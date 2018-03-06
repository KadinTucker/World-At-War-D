module logic.unit.Unit;

import logic.player.Player;
import logic.world.Tile;
import logic.world.World;

/**
 * A struct containing statistics for each individual unit type in a unit
 */
struct UnitType {

    int[2] health; ///The amount of health the unit has: [current, maximum]
    int amount; ///The number of soldiers of this type

}

/**
 * A unit to be found on the map
 * Units have varying properties which should be implemented in subclasses
 */
abstract class Unit {

    UnitType[] troops; ///A list of all of the troop types in the unit
    Coordinate location; ///The location of the unit on the map
    Player owner; ///The owner of the unit
    World world; ///The world this unit is a part of

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
     * Ensures that each troop in the unit dies as necessary if damage is sustained
     */
    private void resolveUnitDamage() {
        foreach(troop; this.troops) {
            if(troop.amount > 0 && troop.health[0] <= 0) {
                troop.amount -= 1;
                if(troop.amount > 0) {
                    troop.health[0] = troop.health[1] - troop.health[0];
                } else {
                    troop.health[0] = troop.health[1];
                }
            }
        }
    }

    void takeDamage(int damage); ///What happens when the unit takes a certain amount of damage
    void move(); ///What happens when the unit moves
    void attack(Coordinate target); ///What happens when the unit attacks

}