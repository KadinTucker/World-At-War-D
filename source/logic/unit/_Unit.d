module logic.unit.Unit;

import logic.player.Player;
import logic.world.Tile;
import logic.world.World;

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

    void takeDamage(int damage); ///What happens when the unit takes a certain amount of damage
    void move(); ///What happens when the unit moves
    void attack(Coordinate target); ///What happens when the unit attacks
    int garrison(); ///What strength the unit provides for a city while garrisoned

}