module logic.unit.AirUnit;

import logic;

import std.algorithm;
import std.math;

//Below are statistics of each unit type
immutable int bomberAttack = 8;
immutable int fighterAttack = 1;

immutable int bomberHP = 4;
immutable int fighterHP = 3;

//The range of an air unit moving between cities
immutable int moveRange = 12;

//The range of a patrolling fighter
immutable int fighterPatrolRange = 3;

/**
 * An air unit
 */
class AirUnit : Unit {

    static AirUnit[] airPatrol; ///The list of units patrolling the air this turn
    Coordinate patrolLocation; ///The location of this unit if it is on air patrol

    /**
     * Constructs a new air unit
     * Units are in order: bombers, fighters
     */
    this(Player owner, Coordinate location, World world) {
        super(owner, location, world);
        this.troops = [0, 0];
        this.wounds = [0, 0];
        this.attacked = [false, false];
        this.patrolLocation = location;
    }

    /**
     * Moves the air unit to the target
     * if the target is a city
     */
    override void move(Coordinate target) {
        if(cast(City)this.world.getTileAt(target).element) {
            this.addTo((cast(City)this.world.getTileAt(target).element).airUnit);
        } else if(cast(Fleet)this.world.getTileAt(target).element) {
            this.addTo((cast(Fleet)this.world.getTileAt(target).element).airUnit);
        }
    }

    /**
     * Takes damage
     * Bombers take damage before fighters
     */
    override void takeDamage(int damage, Unit attacker) {
        while(damage > 0 && !this.isEmpty()) {
            if(this.troops[1] > 0) {
                this.wounds[1] += 1;
            } else if(this.troops[0] > 0) {
                this.wounds[0] += 1;
            }
            if(this.wounds[0] >= bomberHP) {
                this.troops[0] -= 1;
                this.wounds[0] -= bomberHP;
            }
            if(this.wounds[1] >= fighterHP) {
                this.troops[1] -= 1;
                this.wounds[1] -= fighterHP;
            }
            damage -= 1;
        }
        if(this.isEmpty()) {
            this.getDestroyed();
        }
    }

    /**
     * Attacks the target location
     * Index of zero fighters,
     * One means bombers
     * Using fighters stations them on the map as patrolling fighters
     * which attack bombers in a range when bombers attack
     */
    override void attack(TileElement target, int index) {
        super.attack(target, index);
        if(index == 1) {
            this.checkForInterceptor(target.location);
            if(!this.isDestroyed) {
                target.takeDamage(this.troops[0] * bomberAttack, this);
            }
        }
    }

    /**
     * Sets the unit to air patrol at
     * the target location
     */
    void setAirPatrol(Coordinate target) {
        this.checkForInterceptor(target);
        if(!this.isDestroyed) {
            this.attacked[1] = true;
            AirUnit.airPatrol ~= this;
            this.patrolLocation = target;
        }
    }

    /**
     * Checks for interceptors
     * and takes damage from them if they are found
     */
    private void checkForInterceptor(Coordinate target) {
        foreach(air; AirUnit.airPatrol) {
            if(Tile.getManhattanDistance(target, air.location) <= fighterPatrolRange) {
                this.takeDamage(air.troops[1] * fighterAttack, air);
            }
        }
    }

    /**
     * Stationed fighters defend their cities
     */
    override void garrisonAction(int damage, Unit attacker, City toDefend) {
        if(cast(AirUnit)attacker) {
            attacker.takeDamage(this.troops[1] * fighterAttack, this);
        }
    }

    /**
     * Doesn't give defense to cities
     */
    override int garrisonValue() {
        return 0;
    }

    /**
     * Adds this unit to another target unit
     * The target unit must be an army
     */
    override void addTo(Unit unit) {
        if(cast(AirUnit)unit) {
            unit.troops[0] += this.troops[0];
            unit.troops[1] += this.troops[1];
            this.disable();
            unit.disable();
        } else if(cast(Fleet)unit) {
            if((cast(Fleet)unit).numTroops + this.numTroops <= unit.troops[3] * aircraftPerCarrier) {
                this.addTo((cast(Fleet)unit).airUnit);
            }
        }
    }

    /**
     * Disables the unit
     * Disables in the normal way and also removes it from
     * the air patrol
     */
    override void disable() {
        super.disable();
        this.resolveTurn();
    }

    /**
     * Resolves the unit's turn
     * Refreshes all attacks,
     * and removes the unit from air patrol if it is in air patrol
     */
    override void resolveTurn() {
        super.resolveTurn();
        if(AirUnit.airPatrol.canFind(this)) {
            AirUnit.airPatrol.remove(AirUnit.airPatrol.countUntil(this));
            this.patrolLocation = this.location;
        }
    }

}