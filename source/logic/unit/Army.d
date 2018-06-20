module logic.unit.Army;

import logic;

//Below are statistics of each unit type
immutable int infantryHP = 5;
immutable int tankHP = 35;
immutable int artilleryHP = 10;

immutable int infantryAttack = 3;
immutable int tankAttack = 12;
immutable int arilleryAttack = 13;

immutable int infantrySiege = 3;
immutable int tankSiege = 9;
immutable int arillerySiege = 15;

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
        this.wounds = [0, 0, 0];
    }
    
    /**
     * Moves the unit
     * Can only move onto empty land
     */
    override void move(Coordinate target) {
        if(this.world.getTileAt(target).terrain == Terrain.LAND
                && this.world.getTileAt(target).unit is null) {
            this.world.getTileAt(this.location).unit = null;
            this.location = target;
            this.world.getTileAt(this.location).unit = this;
        }
    }

    /**
     * Takes damage
     * Tanks take damage before other units, then infantry,
     * then last artillery
     */
    override void takeDamage(int damage, Unit attacker) {
         while(damage > 0 && this.troops[0] + this.troops[1] + this.troops[2] > 0) {
            if(this.troops[1] > 0) {
                this.wounds[1] += 1;
            } else if(this.troops[0] > 0) {
                this.wounds[0] += 1;
            } else {
                this.wounds[2] += 1;
            }
            if(this.wounds[0] >= infantryHP) {
                this.troops[0] -= 1;
                this.wounds[0] -= infantryHP;
            }
            if(this.wounds[1] >= tankHP) {
                this.troops[1] -= 1;
                this.wounds[1] -= tankHP;
            }
            if(this.wounds[2] >= artilleryHP) {
                this.troops[2] -= 1;
                this.wounds[2] -= artilleryHP;
            }
            damage -= 1;
         }
    }

    /**
     * Attacks the target location
     * TODO:
     */
    override void attack(TileElement target, int index) {

    }

    /**
     * Provides extra defense to the city defending
     * TODO:
     */
    override void garrison(Unit attacker, City toDefend) {

    }

    /**
     * Combines two armies
     * The target unit must be an army
     */
    override void add(Unit unit) {

    }

}