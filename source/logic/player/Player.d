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
     * Constructs a new Player.
     * Params:
     *      name = the name of the player
     *      number = the player number of the player
     */
    this(string name, int number) {
        this.name = name;
        this.number = number;
        this.resources = startingResources;
    }

    /**
     * Settles a city for this player.
     * Returns whether or not the settling was successful.
     * Params:
     *      world = the world being settled in
     *      location = the location being settled at
     */
    bool settleCity(World world, Coordinate location){
        if(world.getTileAt(location).owner == this){
            territory -= 1;
            cities ~= new City(location, this);
            return true;
        }
        return false;
    }

}
