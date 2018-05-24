module logic.unit.Army;

import logic.player.City;
import logic.player.Player;
import logic.unit.Unit;
import logic.world.Tile;
import logic.world.World;

/**
 * A land army unit
 * TODO:
 */
class Army : Unit {

    /**
     * Constructs a new land army
     * Units are in order: infantry, tanks, artillery
     */
    this(Player owner, Coordinate location, World world) {
        super(owner, location, world);
        this.troops = [0, 0, 0];
    }
    
    /**
     * Moves the unit
     * Can only move on land
     */
    override void move() {
        
    }

    /**
     * Takes damage
     * Tanks take damage before other units, then infantry
     */
    override void takeDamage(int damage) {
         
    }

    /**
     * Attacks the target location
     */
    override void attack(Coordinate target) {

    }

    /**
     * Provides extra defense to the city defending
     */
    override void garrison(Unit attacker, City toDefend) {

    }

}