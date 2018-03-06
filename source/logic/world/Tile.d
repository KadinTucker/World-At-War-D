module logic.world.Tile;

import logic.player.City;
import logic.player.Player;
import logic.unit.Unit;

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
Coordinate moveDirection(Coordinate coord, Direction direction) {
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
        return Coordinate(coord.x + change[0], coord.y + change[1]);
    }

/**
 * A tile to be found in the world
 * Has a terrain; may also house a battalion, city, and may be owned by a player as territory
 */
class Tile {

    Terrain terrain;
    Unit unit;
    City city;
    Player owner;

    this(Terrain terrain) {
        this.terrain = terrain;
    }

}
