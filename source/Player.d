import std.stdio;

import Unit;
import World;
import City;

immutable int startingResources = 50;

class Player{

    string name;
    int number;
    int resources;
    int territory;
    City[] cities;
    Batallion[][] military;

    this(string name, int number){
        this.name = name;
        this.number = number;
        this.resources = startingResources;
    }

}
