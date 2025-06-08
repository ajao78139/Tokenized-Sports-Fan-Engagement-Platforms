;; Fan Interaction Contract
;; Manages fan engagement activities

(define-constant ERR_UNAUTHORIZED (err u200))
(define-constant ERR_INVALID_TEAM (err u201))
(define-constant ERR_ALREADY_FOLLOWING (err u202))
(define-constant ERR_NOT_FOLLOWING (err u203))

;; Data structures
(define-map fan-teams
  { fan: principal, team-id: uint }
  { following: bool, joined-at: uint }
)

(define-map team-followers
  { team-id: uint }
  { count: uint }
)

(define-map fan-posts
  { post-id: uint }
  {
    fan: principal,
    team-id: uint,
    content: (string-ascii 280),
    likes: uint,
    created-at: uint
  }
)

(define-data-var post-counter uint u0)

;; Follow a team
(define-public (follow-team (team-id uint))
  (let ((existing (map-get? fan-teams { fan: tx-sender, team-id: team-id })))
    (asserts! (is-none existing) ERR_ALREADY_FOLLOWING)
    (map-set fan-teams
      { fan: tx-sender, team-id: team-id }
      { following: true, joined-at: block-height }
    )
    ;; Update follower count
    (let ((current-count (default-to u0 (get count (map-get? team-followers { team-id: team-id })))))
      (map-set team-followers
        { team-id: team-id }
        { count: (+ current-count u1) }
      )
    )
    (ok true)
  )
)

;; Unfollow a team
(define-public (unfollow-team (team-id uint))
  (let ((existing (map-get? fan-teams { fan: tx-sender, team-id: team-id })))
    (asserts! (is-some existing) ERR_NOT_FOLLOWING)
    (map-delete fan-teams { fan: tx-sender, team-id: team-id })
    ;; Update follower count
    (let ((current-count (default-to u0 (get count (map-get? team-followers { team-id: team-id })))))
      (map-set team-followers
        { team-id: team-id }
        { count: (if (> current-count u0) (- current-count u1) u0) }
      )
    )
    (ok true)
  )
)

;; Create a fan post
(define-public (create-post (team-id uint) (content (string-ascii 280)))
  (let ((post-id (+ (var-get post-counter) u1)))
    (asserts! (is-some (map-get? fan-teams { fan: tx-sender, team-id: team-id })) ERR_NOT_FOLLOWING)
    (map-set fan-posts
      { post-id: post-id }
      {
        fan: tx-sender,
        team-id: team-id,
        content: content,
        likes: u0,
        created-at: block-height
      }
    )
    (var-set post-counter post-id)
    (ok post-id)
  )
)

;; Like a post
(define-public (like-post (post-id uint))
  (match (map-get? fan-posts { post-id: post-id })
    post-data (begin
      (map-set fan-posts
        { post-id: post-id }
        (merge post-data { likes: (+ (get likes post-data) u1) })
      )
      (ok true)
    )
    (err u404)
  )
)

;; Get team follower count
(define-read-only (get-follower-count (team-id uint))
  (default-to u0 (get count (map-get? team-followers { team-id: team-id })))
)

;; Check if fan follows team
(define-read-only (is-following (fan principal) (team-id uint))
  (is-some (map-get? fan-teams { fan: fan, team-id: team-id }))
)
