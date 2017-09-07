import World;
import Player;

enum Attributes {
    TANK=0,
    BYPASS_TANK=1,
    SUBMERGE=2,
    TARGET_SUBMARINES=3,
}

enum UnitTypes{
    INFANTRY=Unit(2, 1, 1, null, 1, 3, 5, "Infantry"),
    TANK=Unit(30, 10, 10, [Attributes.TANK], 1, 20, 8, "Tank"),
    ARTILLERY=Unit(5, 15, 7, null, 3, 10, 3, "Artillery"),
    DESTROYER=Unit(25, 8, 8, [Attributes.TARGET_SUBMARINES], 2, 15, 10, "Destroyer"),
    BATTLESHIP=Unit(40, 12, 12, null, 3, 20, 8, "Battleship"),
    SUBMARINE=Unit(15, 5, 15, [Attributes.SUBMERGE], 2, 10, 13, "Submarine"),
}

struct Unit {

    int hitpoints;
    int siegeDamage;
    int armyDamage;
    Attributes[] attributes;
    int range;
    int defenseValue;
    int movement;
    string name;

}

abstract class Batallion {

    Coordinate location;
    Player owner;
    int moves;
    int[UnitTypes] units;
    char[] passableTiles;

    this(Coordinate location, Player owner, int moves, UnitTypes[] unitTypes, char[] passableTiles){
        this.location = location;
        this.owner = owner;
        this.moves = moves;
        foreach(unit; unitTypes){
            units[unit] = 0;
        }
        this.passableTiles = passableTiles;
    }

    void add(Batallion other){
        if(this.units.keys == other.units.keys){
            foreach(unit; this.units.keys){
                this.units[unit] += other.units[unit];
            }
        }
    }

    bool hasUnits(){
        foreach(unit; this.units.values){
            if(unit > 0){
                return true;
            }
        }
        return false;
    }

}
