import std.random;
import std.math;

import City;
import Player;
import Unit;

/**
 * An enumeration of all terrain types
 */
enum Terrain {

    WATER=0,
    LAND=1,

}

/**
 * An enumeration of all directions
 */
enum Direction {
    NORTH=0,
    EAST=1,
    SOUTH=2,
    WEST=3,
}

/**
 * A coordinate, with x and y values
 */
struct Coordinate {

    int x;
    int y;

}

/**
 * Given a coordinate, returns the coordinate that results from moving in the given direction
 */
Coordinate moveDirection(Coordinate coord, Direction direction){
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
        return Coordinate(coord.x + change[0], coord.y + change[1]);
    }

/**
 * A tile to be found in the world
 * Has a terrain; may also house a battalion, city, and may be owned by a player as territory
 */
class Tile {

    Terrain terrain;
    Battalion battalion;
    City city;
    Player owner;

    this(Terrain terrain){
        this.terrain = terrain;
    }

}

/**
 * The world, mostly as a two-dimensional array of tiles
 */
class World {

    Tile[][] tiles; ///The tiles of the world

    /**
     * Constructs a new world, using the given world parameters
     * TODO: Add config file to determine worldgen parameters
     */
    this(int ncontinents, int nrows, int ncols){
        Tile[] blankArray;
        foreach(x; 0..nrows){
            tiles ~= blankArray.dup;
            foreach(y; 0..ncols){
                tiles[x] ~= new Tile(Terrain.WATER);
            }
        }
        foreach(i; 0..ncontinents){
            tiles[uniform(0, nrows - 1)][uniform(0, ncols - 1)].terrain = Terrain.LAND;
        }
        int generated = ncontinents;
        double correlation;
        while (generated < (nrows * ncols) / 3){
            foreach(x; 0..tiles.length){
                foreach(y; 0..tiles[x].length){
                    if(tiles[x][y].terrain != Terrain.LAND){
                        correlation = 0;
                        if(y < tiles[x].length - 1 && tiles[x][y+1].terrain == Terrain.LAND){
                            correlation += 0.20;
                        }
                        if(y > 0 && tiles[x][y-1].terrain == Terrain.LAND){
                            correlation += 0.20;
                        }
                        if(x < tiles.length - 1 && tiles[x+1][y].terrain == Terrain.LAND){
                            correlation += 0.20;
                        }
                        if(x > 0 && tiles[x-1][y].terrain == Terrain.LAND){
                            correlation += 0.20;
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

    /**
     * Returns the tile in the world at the given coordinate
     */
    Tile getTileAt(Coordinate location){
        return tiles[location.x][location.y];
    }
}