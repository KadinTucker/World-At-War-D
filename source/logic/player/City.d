module logic.player.City;

import logic;

immutable int resourcesPerLevel = 1; ///The number of resources a city yields per turn per level
immutable int levelsPerAction = 5; ///The number of levels a city must have before it can take an extra action
immutable double percentRepairedPerTurn = 0.15; ///How much of a city's garrison is replenished every turn
immutable int baseCityDefense = 30;
immutable int defensePerLevel = 10;

/**
 * A stationary population and production center on the map
 */
class City : TileElement {

    int level; ///The level of this city, affects production and number of actions
    int defense; ///The current defense value of the city
    Army garrison; ///The army garrisoned in the city

    /**
     * Constructs a new city owned by the given player
     * at the given location in the given world, starting at the given level
     */
    this(Player owner, Coordinate location, World world, int level) {
        super(owner, location, world);
        this.level = level;
        this.garrison = new Army(owner, location, world);
        this.defense = this.maxDefense;
    }

    /**
     * Gets the maximum defense of the city
     */
    @property int maxDefense() {
        return baseCityDefense + this.level * defensePerLevel;
    }

    void refreshGarrison() {
        this.garrison = new Army(this.owner, this.location, this.world);
    }

    /**
     * What happens the city receives damage from the given attacker
     */
    override void takeDamage(int damage, Unit attacker) {
        this.garrison.garrisonAction(damage, attacker, this);
        this.defense -= damage;
        if(this.defense <= 0) {
            this.owner = attacker.owner;
            this.defense = cast(int)(0.1 * cast(double)this.defense);
        }
    }

    /**
     * The actions that are performed when the turn ends.
     * The city repairs itself if damaged, and if not, provides its owner with resources.
     * The city's actions are refreshed.
     */
    void resolveTurn() {
        if(this.defense < this.maxDefense){
            this.defense += cast(int)(this.maxDefense * percentRepairedPerTurn);
            if(this.defense > this.maxDefense){
                this.defense = this.maxDefense;
            }
        } else {
            this.owner.resources += this.level * resourcesPerLevel;
        }
    }

    /**
     * Consumes a city action to increase the city's level by one.
     */
    void develop() {
        this.level += 1;
        this.defense += defensePerLevel;
    }

}
