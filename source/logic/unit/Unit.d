module logic.unit.Unit;

import logic;

import std.algorithm;

/**
 * A unit to be found on the map
 * Units have varying properties which should be implemented in subclasses
 */
abstract class Unit : TileElement {

    int[] troops; ///A list of all of the troop types in the unit
    int[] wounds; ///A list of wounds of each troop type

    /**
     * Constructs a new unit
     * Initializes the unit for the player at the given location in the given world
     */
    this(Player owner, Coordinate location, World world) {
        super(owner, location, world);
        owner.military ~= this;
        world.getTileAt(location).unit = this;
    }

    /**
     * The unit gets destroyed
     * Any traces are removed
     */
    abstract void getDestroyed() {
        this.owner.military.remove(this.owner.military.countUntil(this));
        world.getTileAt(location).unit = null;
    }

    /**
     * What happens when the unit is attacked
     * with the given amount of damage
     */
    abstract void takeDamage(int damage); 

    /**
     * What happens when the unit takes a movement action 
     * when given a direction in which to move
     */
    abstract void move(Coordinate target);

    /**
     * Attacks the given target
     * Index references the specific troop that attacks
     */
    abstract void attack(TileElement target, int index);

    /**
     * How the unit impacts a city while garrisoned
     * and being attacked
     */
    abstract void garrison(Unit attacker, City toDefend);

    /**
     * Adds to this unit another unit
     */
    abstract void add(Unit unit);

}