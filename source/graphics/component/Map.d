module graphics.components.Map;

import d2d;
import graphics.CityDisplay;
import logic.player.City;
import logic.world.World;
import logic.world.Tile;

/**
 * A component that displays and handles interation with the world
 */
class Map : Component {

    iRectangle _location; ///The location on the screen of the map
    iVector pan; ///The offset of the center of the map
    World world; ///The world to be drawn by the map
    Texture waterTexture; ///The water texture to be drawn
    Texture landTexture; ///The land texture

    /**
     * Constructs a new map in the given display, bounded by the given rectangle 
     * and displaying the given world
     */
    this(Display container, iRectangle location, World world) {
        super(container);
        this.world = world;
        this.pan = new iVector(0, 0);
        this._location = location;
        this.waterTexture = new Texture(loadImage("res/Tile/water.png"), this.container.renderer);
        this.landTexture = new Texture(loadImage("res/Tile/land.png"), this.container.renderer);
        this.world[4][7].city = new City(null, new Coordinate(4, 7), this.world, 8);
        this.world[4][8].city = new City(null, new Coordinate(4, 8), this.world, 8);
        this.world[4][9].city = new City(null, new Coordinate(4, 9), this.world, 8);
        this.world[7][7].city = new City(null, new Coordinate(7, 7), this.world, 3);
        this.world[8][7].city = new City(null, new Coordinate(8, 7), this.world, 4);
        this.world[9][7].city = new City(null, new Coordinate(9, 7), this.world, 7);
        this.world[10][7].city = new City(null, new Coordinate(10, 7), this.world, 14);
        this.world[14][12].city = new City(null, new Coordinate(14, 12), this.world, 13);
    }

    /**
     * Returns the rectangle bounding the map
     */
    override @property iRectangle location() {
        return this._location;
    }

    /**
     * Handles incoming events to the map component
     */
    void handleEvent(SDL_Event event) {
        
    }

    /**
     * Draws the map to the screen
     * Also pans the map 
     */
    override void draw() {
        //Draw tiles, cities, armies
        for(int x; x < this.world.length; x++) {
            for(int y; y < this.world[x].length; y++) {
                if(world[x][y].terrain == Terrain.WATER) {
                    this.container.renderer.copy(this.waterTexture, this._location.initialPoint.x + this.pan.x + 50 * x, 
                            this._location.initialPoint.y + this.pan.y + 50 * y);
                } else if(world[x][y].terrain == Terrain.LAND) {
                    this.container.renderer.copy(this.landTexture, this._location.initialPoint.x + this.pan.x + 50 * x, 
                            this._location.initialPoint.y + this.pan.y + 50 * y);
                }
                if(world[x][y].city !is null) {
                    this.container.renderer.copy(generateCityTexture(world[x][y].city, this.container.renderer), 
                            this._location.initialPoint.x + this.pan.x + 50 * x, this._location.initialPoint.y + this.pan.y + 50 * y);
                }
            }
        }
        //Fill rectangle at hovered tile
        this.fillHovered(Color(255, 255, 255, 100));
        //Pan map with arrow keys
        if(this.container.keyboard.allKeys[SDLK_UP].isPressed) {
            this.pan.y += 14;
        }
        if(this.container.keyboard.allKeys[SDLK_RIGHT].isPressed) {
            this.pan.x -= 14;
        }
        if(this.container.keyboard.allKeys[SDLK_DOWN].isPressed) {
            this.pan.y -= 14;
        }
        if(this.container.keyboard.allKeys[SDLK_LEFT].isPressed) {
            this.pan.x += 14;
        }
    }

    /**
     * Fills in the hovered tile with the given color
     */
    void fillHovered(Color color) {
        this.container.renderer.fill(new iRectangle(this.pan.x + 50 * this.getHoveredTile().x,
                this.pan.y + 50 * this.getHoveredTile().y, 50, 50), color);
    }

    /**
     * Gets the location of the tile over which the user's mouse is located 
     */
    Coordinate getHoveredTile() {
        return new Coordinate((this.container.mouse.location.x - this.pan.x) / 50, 
                (this.container.mouse.location.y - this.pan.y) / 50);
    }

}