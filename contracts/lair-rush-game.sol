// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract GameContract is Ownable, ReentrancyGuard {
    enum CoinAction {
        BUY,
        EXCHANGE,
        NFT
    }

    // Structs
    struct Game {
        bool isBoosted;
        uint256 gameScore;
        uint256 gameId;
        bool exists;
    }

    struct Coin {
        CoinAction coinAction;
        string to;
        uint256 amount;
    }

    // State variables
    mapping(address => mapping(uint256 => Game)) public playerGames;
    mapping(address => Coin) playerCoins;

    // Events
    event GameEntered(
        address indexed player,
        uint256 indexed gameId,
        bool isBoosted,
        uint256 timestamp
    );

    event GameOver(
        address indexed player,
        uint256 indexed gameId,
        uint256 score,
        bool wasBoosted
    );

    event CoinExchange(
        address indexed player,
        CoinAction indexed actionType,
        string to,
        uint256 amount,
        uint256 timestamp
    );

    // Errors
    error ZeroAddressNotAllowed();
    error GameAlreadyExists();
    error GameDoesNotExist();

    /**
     * @dev Allows owner to enter a new game
     * @param player The address of the player
     * @param _isBoosted Whether the game starts with boost
     * @param _gameId game Id from the database
     */
    function enterGame(
        address player,
        bool _isBoosted,
        uint256 _gameId
    ) external onlyOwner nonReentrant {
        if (player == address(0)) revert ZeroAddressNotAllowed();
        if (playerGames[player][_gameId].exists) revert GameAlreadyExists();

        Game memory newGame = Game({
            isBoosted: _isBoosted,
            gameScore: 0,
            gameId: _gameId,
            exists: true
        });

        playerGames[player][_gameId] = newGame;

        emit GameEntered(player, _gameId, _isBoosted, block.timestamp);
    }

    /**
     * @dev Ends the game and records the score
     * @param player The address of the player
     * @param gameId The ID of the game for this player
     * @param _finalScore The final score for the game
     */
    function gameOver(
        address player,
        uint256 gameId,
        uint256 _finalScore
    ) external onlyOwner nonReentrant {
        if (player == address(0)) revert ZeroAddressNotAllowed();
        if (!playerGames[player][gameId].exists) revert GameDoesNotExist();

        Game storage game = playerGames[player][gameId];
        bool wasBoosted = game.isBoosted;

        game.gameScore = _finalScore;
        game.isBoosted = false;

        emit GameOver(player, gameId, _finalScore, wasBoosted);
    }

    /**
     * @dev Check if a specific game is boosted
     * @param player The address of the player
     * @param gameId The ID of the game for this player
     */
    function isGameBoosted(
        address player,
        uint256 gameId
    ) external view returns (bool) {
        if (!playerGames[player][gameId].exists) revert GameDoesNotExist();
        return playerGames[player][gameId].isBoosted;
    }

    /**
     * @dev Get the game score
     * @param player The address of the player
     * @param gameId The ID of the game for this player
     */
    function getGameScore(
        address player,
        uint256 gameId
    ) external view returns (uint256) {
        if (!playerGames[player][gameId].exists) revert GameDoesNotExist();
        return playerGames[player][gameId].gameScore;
    }

    /**
     * @dev Records a coin exchange transaction
     * @param _player The address of the player exchanging coins
     * @param _actionType The type of coin action
     * @param _to The destination/purpose of the exchange
     * @param _amount The amount of coins being exchanged
     */
    function recordCoinExchange(
        address _player,
        CoinAction _actionType,
        string calldata _to,
        uint256 _amount
    ) external onlyOwner nonReentrant {
        require(_player != address(0), "Zero address not allowed");
        require(bytes(_to).length > 0, "Invalid destination");
        require(_amount > 0, "Amount must be greater than 0");

        // Record the exchange in playerCoins mapping
        playerCoins[_player] = Coin({
            coinAction: _actionType,
            to: _to,
            amount: _amount
        });

        // Emit the exchange event
        emit CoinExchange(_player, _actionType, _to, _amount, block.timestamp);
    }

    /**
     * @dev Retrieves the coin exchange details for a player
     * @param _player The address of the player
     */
    function getCoinExchangeDetails(
        address _player
    ) external view returns (CoinAction, string memory, uint256) {
        require(_player != address(0), "Zero address not allowed");
        Coin memory playerCoin = playerCoins[_player];
        return (playerCoin.coinAction, playerCoin.to, playerCoin.amount);
    }
}
