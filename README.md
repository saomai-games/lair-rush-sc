# Lair Rush

## Overview

Lair Rush is a blockchain-based game powered by two core smart contracts:

1. **NFT Contract** (LairRush720) - ERC721 token for game ownership
2. **Game Contract** - Handles gameplay mechanics and scoring

## Smart Contracts

### LairRush720 (NFT)

ERC721-compliant contract managing game collectibles.

**Features:**

- ✨ Sequential token ID minting
- 🔒 Owner-controlled minting process
- 📜 Full ERC721 standard compliance
- 💫 Metadata support

### GameContract

Core gameplay and mechanics manager.

**Features:**

- 🎮 Session management
- 🚀 Boost system
- 📊 Score verification
- 🛡️ Anti-exploit protection
- 📝 Event logging

#### Game Mechanics

1. **Session Flow**
   - Start game (boosted/normal)
   - Play session
   - Submit & verify score
   - Record results

2. **Tracking System**
   - Unique game IDs
   - On-chain score verification
   - Player history tracking
   - Boost status validation

## Events

| Event | Description |
|-------|-------------|
| `GameEntered(address player, uint256 gameId, bool boosted)` | Triggered when game starts |
| `GameOver(address player, uint256 gameId, uint256 score)` | Triggered when game ends |

## Security

🔐 **Built-in Protections:**

- OpenZeppelin's `Ownable` for access control
- `ReentrancyGuard` for transaction safety
- Comprehensive address validation
- Session state verification

## Development

### Prerequisites

- Solidity ^0.8.0
- OpenZeppelin Contracts
- Hardhat/Truffle (recommended)

## License

MIT License - See [LICENSE](./LICENSE) for details.
