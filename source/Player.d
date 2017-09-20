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
    Battalion[BattalionType] military;

    this(string name, int number){
        this.name = name;
        this.number = number;
        this.resources = startingResources;
    }

    void settleCity(World world, Coordinate location){
        if(world.getTileAt(location).owner == this){
            territory -= 1;
            cities ~= new City(location);
        }
    }

}
