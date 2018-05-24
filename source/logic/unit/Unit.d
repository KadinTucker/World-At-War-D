module logic.unit.Unit;

import logic.player.City;
import logic.player.Player;
import logic.world.Tile;
import logic.world.World;

import std.algorithm;

/**
 * A unit to be found on the map
 * Units have varying properties which should be implemented in subclasses
 */
abstract class Unit {

    int[] troops; ///A list of all of the troop types in the unit
    Coordinate location; ///The location of the unit on the map
    Player owner; ///The owner of the unit
    World world; ///The world of which this unit is a part

    /**
     * Constructs a new unit
     * Initializes the unit for the player at the given location in the given world
     */
    this(Player owner, Coordinate location, World world) {
        this.owner = owner;
        this.location = location;
        this.world = world;
        owner.military ~= this;
        world.getTileAt(location).unit = this;
    }

    /**
     * The unit gets destroyed
     * Any traces are removed
     */
    void getDestroyed() {
        this.owner.military.remove(this.owner.military.countUntil(this));
        world.getTileAt(location).unit = null;
    }

    /**
     * What happens when the unit is attacked
     * with the given amount of damage
     */
    void takeDamage(int damage); 

    /**
     * What happens when the unit takes a movement action
     */
    void move();

    /**
     * Attacks the given target
     * Index references the specific troop that attacks
     */
    void attack(Coordinate target, int index);

    /**
     * How the unit impacts a city while garrisoned
     * and being attacked
     */
    void garrison(Unit attacker, City toDefend);

}