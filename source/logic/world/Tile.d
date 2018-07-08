module logic.world.Tile;

import logic;

import std.conv;
import std.math;

/**
 * An enumeration of all terrain types
 */
enum Terrain {

    WATER=0,
    LAND=1

}

/**
 * An enumeration of all directions one can travel
 */
enum Direction {

    NO_DIRECTION=-1,
    NORTH=0,
    EAST=1,
    SOUTH=2,
    WEST=3

}

/**
 * A coordinate, with x and y value
 */
class Coordinate {

    int x; ///The x value of the coordinate
    int y; ///The y value of the coordinate

    /**
     * Constructs a new coordinate
     */
    this(int x, int y) {
        this.x = x;
        this.y = y;
    }

    /**
     * Converts the coordinate into a string
     * (x, y)
     */
    override string toString() {
        return "("~this.x.to!string~", "~this.y.to!string~")";
    }

}

/**
 * A tile to be found in the world
 * Has a terrain; may also house a battalion, city, 
 * and may be owned by a player as territory
 */
class Tile {

    Terrain terrain; ///The terrain type of the tile
    TileElement element; ///The tile element present on this tile
    Player owner; ///The owner of this tile
    Coordinate location; ///The coordinates of the tile

    /**
     * Constructs a new tile with the given terrain
     */
    this(Terrain terrain, Coordinate location) {
        this.terrain = terrain;
        this.location = location;
    }

    /**
     * Given a coordinate, returns the coordinate that 
     * results from moving in the given direction
     */
    static Coordinate moveDirection(Coordinate coord, Direction direction) {
        int[2] change;
        if(direction == Direction.NORTH) {
            change[1] = -1;
        }
        else if(direction == Direction.EAST) {
            change[0] = 1;
        }
        if(direction == Direction.SOUTH) {
            change[1] = 1;
        }
        if(direction == Direction.WEST) {
            change[0] = -1;
        }
        return new Coordinate(coord.x + change[0], coord.y + change[1]);
    }

    /**
     * Return the manhattan distance (distance along edges)
     * between two coordinates
     */
    static int getManhattanDistance(Coordinate coord1, Coordinate coord2) {
        return abs(coord1.x - coord2.x) + abs(coord1.y - coord2.y);
    }

}
