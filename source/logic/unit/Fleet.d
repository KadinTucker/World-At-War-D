module logic.unit.Fleet;

import logic;

import std.math;

//Below are statistics of each unit type
immutable int battleshipHP = 50;
immutable int destroyerHP = 50;
immutable int submarineHP = 30;
immutable int carrierHP = 70;

immutable int battleshipAttack = 12;
immutable int destroyerAttack = 12;
immutable int submarineAttack = 16;

immutable int submarineLandAttack = 5;

immutable int fleetMoves = 8;

/**
 * A fleet of ships at sea
 */
class Fleet : Unit {

    int movementPoints; ///The amount of moves this fleet can take this turn
    Army embarked; ///An army that is embarked on this fleet
    //TODO: Add air unit

    /**
     * Constructs a new fleet
     * Units are in order: battleship, destroyer, submarine, carrier
     */
    this(Player owner, Coordinate location, World world) {
        super(owner, location, world);
        this.troops = [0, 0, 0, 0];
        this.wounds = [0, 0, 0, 0];
        this.attacked = [false, false, false];
        this.movementPoints = fleetMoves;
    }

    /**
     * Runs unit mobilize
     * Ends with no movement
     */
    override void mobilize() {
        super.mobilize();
        this.movementPoints = 0;
    }
    
    /**
     * Moves the unit
     * Can only move onto empty land
     */
    override void move(Coordinate target) {
        if(this.world.getTileAt(target).terrain == Terrain.WATER) {
            if(this.world.getTileAt(target).element is null) {
                this.world.getTileAt(this.location).element = null;
                this.location = target;
                this.world.getTileAt(this.location).element = this;
                this.movementPoints -= 1;
            } else if(cast(Fleet)this.world.getTileAt(target).element) {
                this.addTo(cast(Fleet)this.world.getTileAt(target).element);
                this.getDestroyed();
            } 
        } else if(cast(City)this.world.getTileAt(target).element) {
            this.addTo((cast(City)this.world.getTileAt(target).element).harbor);
            this.getDestroyed();
        }
    }

    /**
     * Takes damage
     * Destroyers and battleships take damage first,
     * then aircraft carriers then submarines
     * TODO: make aircraft carriers take damage from aircraft first
     */
    override void takeDamage(int damage, Unit attacker) {
        while(damage > 0 && !this.isEmpty()) {
            bool frontLineDamaged = false;
            if(this.troops[0] > 0) {
                this.wounds[0] += 1;
                damage -= 1;
                frontLineDamaged = true;
            } 
            if(this.troops[1] > 0 && damage > 0) {
                this.wounds[1] += 1;
                damage -= 1;
                frontLineDamaged = true;
            }
            if(!frontLineDamaged && damage > 0) {
                if(this.troops[3] > 0) {
                    this.wounds[3] += 1;
                    damage -= 1;
                } else if(this.troops[2] > 0) {
                    this.wounds[2] += 1;
                    damage -= 1;
                }
            }
            if(this.wounds[0] >= battleshipHP) {
                this.troops[0] -= 1;
                this.wounds[0] -= infantryHP;
            }
            if(this.wounds[1] >= destroyerHP) {
                this.troops[1] -= 1;
                this.wounds[1] -= destroyerHP;
            }
            if(this.wounds[2] >= submarineHP) {
                this.troops[2] -= 1;
                this.wounds[2] -= submarineHP;
            }
        }
        if(this.isEmpty()) {
            this.getDestroyed();
        }
    }

    /**
     * Attacks the target location
     * Index of zero means tanks and infantry,
     * One means artillery
     */
    override void attack(TileElement target, int index) {
        super.attack(target, index);
        if(index == 0) {
            target.takeDamage(battleshipAttack * this.troops[0], this);
        } else if(index == 1) {
            target.takeDamage(destroyerAttack * this.troops[1], this);
        } else if(index == 2) {
            if(target.world.getTileAt(target.location).terrain == Terrain.LAND) {
                target.takeDamage(submarineLandAttack * this.troops[2], this);
            } else {
                target.takeDamage(submarineAttack * this.troops[2], this);
            }
        }
    }

    /**
     * If defending against a fleet, this fleet will fire back
     */
    override void garrisonAction(int damage, Unit attacker, City toDefend) {
        if(cast(Fleet)attacker && Tile.getManhattanDistance(this.location, attacker.location) <= 3) {
            this.attack(attacker, 0);
            if(Tile.getManhattanDistance(this.location, attacker.location) <= 2) {
                this.attack(attacker, 1);
                this.attack(attacker, 2);
            }
        }
    }

    /**
     * Fleets provide no garrison strength to a city
     */
    override int garrisonValue() {
        return 0;
    }

    /**
     * Adds this unit to another target unit
     * The target unit must be another fleet
     */
    override void addTo(Unit unit) {
        if(cast(Fleet)unit) {
            unit.troops[0] += this.troops[0];
            unit.troops[1] += this.troops[1];
            unit.troops[2] += this.troops[2];
            unit.troops[3] += this.troops[3];
            this.disable();
            unit.disable();
        }
    }

    /**
     * Resolves the turn by refreshing the attacks of the units
     * And the fleet's movement points
     */
    override void resolveTurn() {
        super.resolveTurn();
        this.movementPoints = fleetMoves;
    }

    /**
     * Disables the fleet
     */
    override void disable() {
        super.disable();
        this.movementPoints = 0;
    }

}