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
    
    override void move() {
        
    }

    override void takeDamage(int damage) {
         
    }

    override void attack(Coordinate target) {

    }

    override void garrison(Unit attacker, City toDefend) {

    }

}