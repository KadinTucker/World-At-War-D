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
    bool[] attacked; ///A list of whether or not each troop type has attacked
    bool isDestroyed; ///Whether or not the unit still exists in the world

    /**
     * Constructs a new unit
     * Initializes the unit for the player at the given location in the given world
     */
    this(Player owner, Coordinate location, World world) {
        super(owner, location, world);
    }

    /**
     * Returns whether or not the unit has any troops remaining
     */
    bool isEmpty() {
        foreach(troopType; this.troops) {
            if(troopType > 0) {
                return false;
            }
        }
        return true;
    }

    int numTroops() {
        int total;
        foreach(troopType; this.troops) {
            total += troopType;
        }
        return total;
    }

    /**
     * Mobilizes the unit by adding itself
     * to the owner's military and to the map
     * at its location
     */
    void mobilize() {
        owner.military ~= this;
        world.getTileAt(location).element = this;
        this.isDestroyed = false;
        for(int i = 0; i < this.attacked.length; i++) {
            this.attacked[i] = true;
        }
    }

    /**
     * The unit gets destroyed
     * Any traces are removed
     * Also used when the unit is garrisoned or embarked
     */
    void getDestroyed() {
        this.owner.military.remove(this.owner.military.countUntil(this));
        world.getTileAt(location).element = null;
        this.isDestroyed = true;
    }

    /**
     * What happens when the unit takes a movement action 
     * when given a direction in which to move
     */
    abstract void move(Coordinate target);

    /**
     * Attacks the given target
     * Index references the specific troop that attacks
     * Sets the attacked values of the index to be true
     */
    void attack(TileElement target, int index) {
        this.attacked[index] = true;
    }

    /**
     * How the unit impacts a city while garrisoned
     * and being attacked
     * Returns the defense value given to the city by the garrison
     */
    abstract void garrisonAction(int damage, Unit attacker, City toDefend);

    /**
     * Returns the value this unit adds to a city's defense value
     */
    abstract int garrisonValue();

    /**
     * Adds to another unit from this unit
     */
    abstract void addTo(Unit unit);

    /**
     * Resolves the unit's turn
     * Refreshes all attacks
     */
    void resolveTurn() {
        for(int i; i < this.attacked.length; i++) {
            this.attacked[i] = false;
        }
    }

    /**
     * Disables the unit by setting all of its attacks to true
     */
    void disable() {
        if(this.attacked !is null) {
            for(int i; i < this.attacked.length; i++) {
                this.attacked[i] = true;
            }
        }
    }


}