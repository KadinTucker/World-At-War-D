module logic.player.Player;

import logic.player.City;
import logic.unit.Unit;
import logic.world.Tile;
import logic.world.World;

immutable int startingResources = 50;

/**
 * An object representing a player of the game
 */ 
class Player {

    string name; ///The name of the player.
    int number; ///The player number: for use in save files.
    int resources; ///The number of resources this player has.
    int territory; ///The number of tiles this player owns.
    City[] cities; ///The cities under this player's control.
    Unit[] military;  ///The units this player controls.

    /**
     * Constructs a new Player with the given name
     * and given player id
     */
    this(string name, int number) {
        this.name = name;
        this.number = number;
        this.resources = startingResources;
    }

    /**
     * Resolves the end of a player's turn by getting their income
     * Runs all contained cities' turn end methods
     */
    void resolveTurnEnd() {
        this.resources += this.territory;
        foreach(city; this.cities) {
            city.resolveTurn();
        }
    }

}
