import World;
import Unit;

immutable int baseCityLevel = 3;

class City{

    Coordinate location;
    int level;
    Batallion[] garrison;
    int defense;
    int maxDefense;

    this(Coordinate location, int level=3){
        this.location = location;
        this.level = level;

    }

    void getDefense(){
        int totalDefense = 0;
        foreach(batallion; garrison){
            foreach(unitType; batallion.units.keys){
                totalDefense += this.level * unitType.defenseValue * batallion.units[unitType];
            }
        }
        this.defense = this.level * 10 + (totalDefense / 100);
    }

}
