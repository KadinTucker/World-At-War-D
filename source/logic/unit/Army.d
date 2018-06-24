module logic.unit.Army;

import logic;

//Below are statistics of each unit type
immutable int infantryHP = 5;
immutable int tankHP = 35;
immutable int artilleryHP = 10;

immutable int infantryAttack = 3;
immutable int tankAttack = 12;
immutable int arilleryAttack = 13;

immutable int tankSiege = 9;

immutable int infantryDefense = 5;
immutable int tankDefense = 6;

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
        if(index == 0) {
            target.takeDamage(infantryAttack * this.troops[0], this);
        } else if(index == 1) {
            if(cast(City)target) {
                target.takeDamage(tankSiege * this.troops[1], this);
            } else {
                target.takeDamage(tankAttack * this.troops[1], this);
            }
        } else if(index == 2) {
            target.takeDamage(arilleryAttack * this.troops[2], this);
        }
    }

    /**
     * Armies perform no actions to defend their cities
     */
    override void garrisonAction(int damage, Unit attacker, City toDefend) {
        
    }

    /**
     * Returns the value of each troop to a garrison
     */
    override int garrisonValue() {
        return this.troops[0] * infantryDefense + this.troops[1] * tankDefense;
    }

    /**
     * Adds the armies from another unit to this one
     * The target unit must be an army
     */
    override void add(Unit unit) {
        if(cast(Army)unit) {
            this.troops[0] += unit.troops[0];
            this.troops[1] += unit.troops[1];
            this.troops[2] += unit.troops[2];
        }
    }

}