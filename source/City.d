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

}
