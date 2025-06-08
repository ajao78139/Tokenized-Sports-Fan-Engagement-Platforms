# Tokenized Sports Fan Engagement Platform

A comprehensive blockchain-based platform for sports fan engagement, built on the Stacks blockchain using Clarity smart contracts.

## Overview

This platform enables sports teams and fans to interact through a tokenized ecosystem that includes team verification, fan interactions, merchandise sales, event coordination, and loyalty rewards.

## Smart Contracts

### 1. Team Verification Contract (`team-verification.clar`)
- **Purpose**: Validates and manages sports teams and organizations
- **Key Features**:
    - Team registration with name and sport type
    - Verification system for legitimate teams
    - Team ownership and metadata management

### 2. Fan Interaction Contract (`fan-interaction.clar`)
- **Purpose**: Manages fan engagement activities and social features
- **Key Features**:
    - Follow/unfollow teams
    - Create fan posts and content
    - Like and engage with posts
    - Track follower counts

### 3. Merchandise Management Contract (`merchandise.clar`)
- **Purpose**: Handles sports merchandise sales and inventory
- **Key Features**:
    - Add merchandise items with pricing and stock
    - Purchase items with automatic stock management
    - Track purchase history
    - Seller management capabilities

### 4. Event Coordination Contract (`event-coordination.clar`)
- **Purpose**: Coordinates fan events and experiences
- **Key Features**:
    - Create team events with capacity limits
    - Fan registration and check-in system
    - Event cancellation and management
    - Attendance tracking

### 5. Loyalty Rewards Contract (`loyalty-rewards.clar`)
- **Purpose**: Rewards fan loyalty and engagement
- **Key Features**:
    - Point-based reward system
    - Create and manage rewards
    - Claim and redeem rewards
    - Track fan activity and engagement

## Getting Started

### Prerequisites
- Stacks blockchain development environment
- Clarity CLI tools
- Node.js and npm for testing

### Installation

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd sports-fan-platform
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Run tests:
   \`\`\`bash
   npm test
   \`\`\`

### Deployment

Deploy contracts to Stacks testnet:
\`\`\`bash
# Deploy team verification contract
clarinet deploy --testnet contracts/team-verification.clar

# Deploy other contracts in order
clarinet deploy --testnet contracts/fan-interaction.clar
clarinet deploy --testnet contracts/merchandise.clar
clarinet deploy --testnet contracts/event-coordination.clar
clarinet deploy --testnet contracts/loyalty-rewards.clar
\`\`\`

## Usage Examples

### Team Registration
\`\`\`clarity
;; Register a new team
(contract-call? .team-verification register-team "Lakers" "Basketball")
\`\`\`

### Fan Engagement
\`\`\`clarity
;; Follow a team
(contract-call? .fan-interaction follow-team u1)

;; Create a post
(contract-call? .fan-interaction create-post u1 "Go Lakers!")
\`\`\`

### Purchase Merchandise
\`\`\`clarity
;; Buy team merchandise
(contract-call? .merchandise purchase-item u1 u2)
\`\`\`

### Event Registration
\`\`\`clarity
;; Register for a team event
(contract-call? .event-coordination register-for-event u1)
\`\`\`

### Earn and Claim Rewards
\`\`\`clarity
;; Award points to a fan
(contract-call? .loyalty-rewards award-points 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM u100 "Post Creation")

;; Claim a reward
(contract-call? .loyalty-rewards claim-reward u1)
\`\`\`

## Contract Architecture

The platform follows a modular architecture where each contract handles a specific domain:

- **Team Verification**: Foundation layer for legitimate team validation
- **Fan Interaction**: Social engagement and community building
- **Merchandise**: E-commerce functionality for team products
- **Event Coordination**: Real-world event management
- **Loyalty Rewards**: Gamification and fan retention

## Security Features

- Owner-only functions for critical operations
- Input validation and error handling
- Access control for sensitive functions
- Safe arithmetic operations
- Proper state management

## Testing

The platform includes comprehensive tests for all contracts:
- Unit tests for individual functions
- Integration tests for contract interactions
- Edge case testing for error conditions

Run tests with:
\`\`\`bash
npm test
\`\`\`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For questions and support, please open an issue in the GitHub repository.
