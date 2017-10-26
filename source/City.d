import World;
import Unit;

immutable int baseCityLevel = 3;

class City{

    Coordinate location;
    int level;
    Battalion[] garrison;
    int defense;
    int maxDefense;

    this(Coordinate location, int level=3){
        this.location = location;
        this.level = level;
    }

    void getDefense(){
        int totalDefense = 0;
        foreach(battalion; garrison){
            foreach(unitType; battalion.units.keys){
                totalDefense += this.level * unitType.defenseValue * battalion.units[unitType];
            }
        }
        this.defense = this.level * 10 + (totalDefense / 100);
    }

    void develop(){
        this.level += 1;
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
