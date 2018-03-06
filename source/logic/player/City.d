module logic.player.City;

import logic.player.Player;
import logic.player.Unit;
import logic.world.Tile;
import logic.world.World;


immutable int baseCityLevel = 3;
immutable int resourcesPerLevel = 1;
immutable int levelsPerAction = 5;
immutable double percentRepairedPerTurn = 0.1;

class City {

    Coordinate location;            ///The location of this city.
    Player owner;                   ///The player who controls this city.
    int level;                      ///The level of this city, affects production and number of actions.
    int actions;                    ///The number of actions this city can take.
    Battalion[] garrison;           ///The armies/fleets garrisoned in the city.
    int defense;                    ///The current defense value of the city.
    int maxDefense;                 ///The maximum defense value of the city.

    /**
     * Constructs a new city.
     * Params:
     *      location = the location where this city is placed
     *      owner = the one placing the city; to become the owner
     *      level = the starting level of the city; by default the base city level variable. Starting cities start at level 5
     */
    this(Coordinate location, Player owner, int level=baseCityLevel){
        this.location = location;
        this.owner = owner;
        this.level = level;
    }

    /**
     * Gets the maximum defense that this city can have.
     * The city level times 10 is the base defense, plus the defensive strength of all units garrisoned.
     */
    int getDefense(){
        int totalDefense = 0;
        foreach(battalion; garrison){
            foreach(unitType; battalion.units.keys){
                totalDefense += this.level * unitType.defenseValue * battalion.units[unitType];
            }
        }
        return this.level * 10 + (totalDefense / 100);
    }

    /**
     * The actions that are performed when the turn ends.
     * The city repairs itself if damaged, and if not, provides its owner with resources.
     * The city's actions are refreshed.
     */
    void resolveTurn(){
        this.maxDefense = this.getDefense();  //TODO: Make sure that when garrison is mobilized, reduce defense to its proportional value. Make repair method?
        if(this.defense < this.maxDefense){
            this.defense += cast(int)(this.maxDefense * percentRepairedPerTurn);
            if(this.defense > this.maxDefense){
                this.defense = this.maxDefense;
            }
        }else{
            this.owner.resources += this.level * resourcesPerLevel;
        }
        this.actions = this.level / levelsPerAction + 1;
    }

    /**
     * Consumes a city action to increase the city's level by one.
     */
    void develop(){
        this.level += 1;
        this.actions -= 1;
    }

    void produce(){
        // TODO: Add submenu feature for this and other things.
    }

    void mobilize(){
        //TODO: Allow for partial mobilization
    }

    void settle(){
        //TODO: Allow for taking coordinate input on map.
    }

    void draft(){
        //TODO: submenus
    }

}
