// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";

contract GameContract is Ownable {
    // Structs
    struct Game {
        bool isBoosted;
        uint256 gameScore;
        uint256 gameId;
    }

    // State variables
    mapping(address => Game[]) public playerGames;

    // Events
    event GameEntered(
        address indexed player,
        uint256 indexed gameId,
        uint256 timestamp
    );
    event GameOver(
        address indexed player,
        uint256 indexed gameId,
        uint256 score
    );

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
    ) external onlyOwner {
        Game memory newGame = Game({
            isBoosted: _isBoosted,
            gameScore: 0,
            gameId: _gameId
        });

        playerGames[player].push(newGame);

        emit GameEntered(player, _gameId, block.timestamp);
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
    ) external onlyOwner {
        require(gameId < playerGames[player].length, "Game does not exist");

        Game storage game = playerGames[player][gameId];
        game.gameScore = _finalScore;
        game.isBoosted = false;

        emit GameOver(player, gameId, _finalScore);
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
        require(gameId < playerGames[player].length, "Game does not exist");
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
        require(gameId < playerGames[player].length, "Game does not exist");
        return playerGames[player][gameId].gameScore;
    }
}
