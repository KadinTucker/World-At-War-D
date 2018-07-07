module logic.player.City;

import logic.player.Player;
import logic.unit.Unit;
import logic.world.Tile;
import logic.world.TileElement;
import logic.world.World;

immutable int baseCityLevel = 3; ///The normal level at which cities begin
immutable int resourcesPerLevel = 1; ///The number of resources a city yields per turn per level
immutable int levelsPerAction = 5; ///The number of levels a city must have before it can take an extra action
immutable double percentRepairedPerTurn = 0.15; ///How much of a city's garrison is replenished every turn

/**
 * A stationary population and production center on the map
 */
class City : TileElement {

    int level; ///The level of this city, affects production and number of actions
    int actions; ///The number of actions this city can take
    int defense; ///The current defense value of the city
    Unit[] garrison; ///The units garrisoned in the city

    /**
     * Constructs a new city owned by the given player
     * at the given location in the given world, starting at the given level
     */
    this(Player owner, Coordinate location, World world, int level=baseCityLevel) {
        super(owner, location, world);
        this.level = level;
        this.defense = this.maxDefense;
    }

    /**
     * Gets the maximum defense of the city
     */
    @property int maxDefense() {
        int garrisonDefense;
        foreach(unit; this.garrison) {
            garrisonDefense += unit.garrisonValue();
        }
        return 30 + this.level * 10;
    }

    /**
     * What happens the city receives damage from the given attacker
     */
    override void takeDamage(int damage, Unit attacker) {
        foreach(unit; garrison) {
            unit.garrisonAction(damage, attacker, this);
        }
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
        this.actions = this.level / levelsPerAction + 1;
    }

    /**
     * Consumes a city action to increase the city's level by one.
     */
    void develop() {
        this.level += 1;
        this.actions -= 1;
    }

}
