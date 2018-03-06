module logic.world.World;

import std.random;
import std.math;

import logic.world.Tile;

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
        foreach(x; 0..nrows) {
            tiles ~= blankArray.dup;
            foreach(y; 0..ncols) {
                tiles[x] ~= new Tile(Terrain.WATER);
            }
        }
        foreach(i; 0..ncontinents) {
            tiles[uniform(0, nrows - 1)][uniform(0, ncols - 1)].terrain = Terrain.LAND;
        }
        int generated = ncontinents;
        double correlation;
        while (generated < (nrows * ncols) / 3) {
            foreach(x; 0..tiles.length) {
                foreach(y; 0..tiles[x].length) {
                    if(tiles[x][y].terrain != Terrain.LAND) {
                        correlation = 0;
                        if(y < tiles[x].length - 1 && tiles[x][y+1].terrain == Terrain.LAND) {
                            correlation += 0.20;
                        }
                        if(y > 0 && tiles[x][y-1].terrain == Terrain.LAND) {
                            correlation += 0.20;
                        }
                        if(x < tiles.length - 1 && tiles[x+1][y].terrain == Terrain.LAND) {
                            correlation += 0.20;
                        }
                        if(x > 0 && tiles[x-1][y].terrain == Terrain.LAND) {
                            correlation += 0.20;
                        }
                        if(uniform(0.0, 1.0) < correlation) {
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
    Tile getTileAt(Coordinate location) {
        return tiles[location.x][location.y];
    }
}