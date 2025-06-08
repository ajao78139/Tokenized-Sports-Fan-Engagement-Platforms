;; Event Coordination Contract
;; Coordinates fan events and experiences

(define-constant ERR_UNAUTHORIZED (err u400))
(define-constant ERR_EVENT_NOT_FOUND (err u401))
(define-constant ERR_EVENT_FULL (err u402))
(define-constant ERR_ALREADY_REGISTERED (err u403))
(define-constant ERR_NOT_REGISTERED (err u404))

;; Data structures
(define-map events
  { event-id: uint }
  {
    team-id: uint,
    name: (string-ascii 100),
    description: (string-ascii 300),
    max-attendees: uint,
    current-attendees: uint,
    event-date: uint,
    organizer: principal,
    active: bool
  }
)

(define-map event-registrations
  { event-id: uint, attendee: principal }
  { registered-at: uint, checked-in: bool }
)

(define-data-var event-counter uint u0)

;; Create an event
(define-public (create-event (team-id uint) (name (string-ascii 100)) (description (string-ascii 300)) (max-attendees uint) (event-date uint))
  (let ((event-id (+ (var-get event-counter) u1)))
    (map-set events
      { event-id: event-id }
      {
        team-id: team-id,
        name: name,
        description: description,
        max-attendees: max-attendees,
        current-attendees: u0,
        event-date: event-date,
        organizer: tx-sender,
        active: true
      }
    )
    (var-set event-counter event-id)
    (ok event-id)
  )
)

;; Register for an event
(define-public (register-for-event (event-id uint))
  (match (map-get? events { event-id: event-id })
    event-data (let ((existing-registration (map-get? event-registrations { event-id: event-id, attendee: tx-sender })))
      (asserts! (get active event-data) ERR_EVENT_NOT_FOUND)
      (asserts! (is-none existing-registration) ERR_ALREADY_REGISTERED)
      (asserts! (< (get current-attendees event-data) (get max-attendees event-data)) ERR_EVENT_FULL)

      ;; Register attendee
      (map-set event-registrations
        { event-id: event-id, attendee: tx-sender }
        { registered-at: block-height, checked-in: false }
      )

      ;; Update attendee count
      (map-set events
        { event-id: event-id }
        (merge event-data { current-attendees: (+ (get current-attendees event-data) u1) })
      )

      (ok true)
    )
    ERR_EVENT_NOT_FOUND
  )
)

;; Check in to event
(define-public (check-in (event-id uint))
  (let ((registration (map-get? event-registrations { event-id: event-id, attendee: tx-sender })))
    (asserts! (is-some registration) ERR_NOT_REGISTERED)
    (map-set event-registrations
      { event-id: event-id, attendee: tx-sender }
      (merge (unwrap-panic registration) { checked-in: true })
    )
    (ok true)
  )
)

;; Cancel event registration
(define-public (cancel-registration (event-id uint))
  (match (map-get? events { event-id: event-id })
    event-data (let ((registration (map-get? event-registrations { event-id: event-id, attendee: tx-sender })))
      (asserts! (is-some registration) ERR_NOT_REGISTERED)

      ;; Remove registration
      (map-delete event-registrations { event-id: event-id, attendee: tx-sender })

      ;; Update attendee count
      (map-set events
        { event-id: event-id }
        (merge event-data { current-attendees: (- (get current-attendees event-data) u1) })
      )

      (ok true)
    )
    ERR_EVENT_NOT_FOUND
  )
)

;; Get event details
(define-read-only (get-event (event-id uint))
  (map-get? events { event-id: event-id })
)

;; Check if user is registered for event
(define-read-only (is-registered (event-id uint) (attendee principal))
  (is-some (map-get? event-registrations { event-id: event-id, attendee: attendee }))
)
