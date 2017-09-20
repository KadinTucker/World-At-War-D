import std.random;
import std.math;

import City;
import Player;
import Unit;

enum Terrain {

    WATER=0,
    LAND=1,

}

enum Direction {
    NORTH=0,
    EAST=1,
    SOUTH=2,
    WEST=3,
}

struct Coordinate {

    int x;
    int y;

    Coordinate getCoordinateFromDirection(Direction direction){
        int[2] change;
        if(direction == Direction.NORTH){
            change[1] = -1;
        }
        else if(direction == Direction.EAST){
            change[0] = 1;
        }
        if(direction == Direction.SOUTH){
            change[1] = 1;
        }
        if(direction == Direction.WEST){
            change[0] = -1;
        }
        return Coordinate(x + change[0], y + change[1]);
    }

}



class Tile {

    Terrain terrain;
    Battalion battalion;
    City city;
    Player owner;

    this(Terrain terrain){
        this.terrain = terrain;
    }

}

class World {

    Tile[][] tiles = [];

    this(int ncontinents, int nrows, int ncols){
        Tile[] blankArray = [];
        for(int x = 0; x < nrows; x++){
            //writeln("iterate outer x",x);
            tiles ~= blankArray.dup;
            //writeln(tiles);
            for(int y = 0; y < ncols; y++){
                tiles[x] ~= new Tile(Terrain.WATER);
            }
        }
        for(int i = 0; i < ncontinents; i++){
            tiles[uniform(0, nrows - 1)][uniform(0, ncols - 1)].terrain = Terrain.LAND;
        }
        int generated = ncontinents;
        double correlation;
        while (generated < (nrows * ncols) / 3){
            for(int x = 0; x < tiles.length; x++){
                for(int y = 0; y < tiles[x].length; y++){
                    if(tiles[x][y].terrain != Terrain.LAND){
                        correlation = 0;
                        if(y < tiles[x].length - 1 && tiles[x][y+1].terrain == Terrain.LAND){
                            correlation += 0.25;
                        }
                        if(y > 0 && tiles[x][y-1].terrain == Terrain.LAND){
                            correlation += 0.25;
                        }
                        if(x < tiles.length - 1 && tiles[x+1][y].terrain == Terrain.LAND){
                            correlation += 0.25;
                        }
                        if(x > 0 && tiles[x-1][y].terrain == Terrain.LAND){
                            correlation += 0.25;
                        }
                        if(uniform(0.0, 1.0) < correlation){
                            tiles[x][y].terrain = Terrain.LAND;
                            generated += 1;
                        }
                    }
                }
            }
        }
    }

    Tile getTileAt(Coordinate location){
        return tiles[location.x][location.y];
    }
}

unittest{

    import std.stdio;

    int number = 89304;
    writeln(getNthDigit(89304, 5));
    writeln(getNthDigit(89304, 4));
    writeln(getNthDigit(89304, 3));
    writeln(getNthDigit(89304, 2));
    writeln(getNthDigit(89304, 1));

    World world = new World(4, 30, 40, '_', '+');
    world.printWorld();

}
