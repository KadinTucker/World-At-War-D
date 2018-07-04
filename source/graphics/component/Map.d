module graphics.components.Map;

import d2d;
import graphics;
import logic;

/**
 * A component that displays and handles interation with the world
 */
class Map : Component {

    iRectangle _location; ///The location on the screen of the map
    iVector pan; ///The offset of the center of the map
    World world; ///The world to be drawn by the map
    TileElement selectedElement; ///The tile element selected by the player
    Texture mapTexture; ///The compiled texture of all map elements on the screen

    /**
     * Constructs a new map in the given display, bounded by the given rectangle 
     * and displaying the given world
     */
    this(Display container, iRectangle location, World world) {
        super(container);
        this.world = world;
        this.pan = new iVector(0, 0);
        this._location = location;
        this.updateTexture();
    }

    /**
     * Returns the rectangle bounding the map
     */
    override @property iRectangle location() {
        return this._location;
    }

    /**
     * Sets the location of the map
     */
    @property void location(iRectangle newLocation) {
        this._location = newLocation;
    }

    /**
     * Handles incoming events to the map component
     */
    void handleEvent(SDL_Event event) {
        
    }

    /**
     * Updates the base map texture
     * Updates whenever there is a change to the location of units or cities on the map
     */
    void updateTexture() {
        Surface mapSurface = new Surface(this.world.length * 50, this.world[0].length * 50, SDL_PIXELFORMAT_RGBA32);
        Surface waterSurface = loadImage("res/Tile/water.png");
        Surface landSurface = loadImage("res/Tile/land.png");
        for(int x; x < this.world.length; x++) {
            for(int y; y < this.world[x].length; y++) {
                if(world[x][y].terrain == Terrain.WATER) {
                    mapSurface.blit(waterSurface, null, this._location.initialPoint.x + 50 * x, 
                            this._location.initialPoint.y + 50 * y);
                } else if(world[x][y].terrain == Terrain.LAND) {
                    mapSurface.blit(landSurface, null, this._location.initialPoint.x + 50 * x, 
                            this._location.initialPoint.y + 50 * y);
                }
                if(world[x][y].city !is null) {
                    mapSurface.blit(generateCityTexture(world[x][y].city), null,
                            this._location.initialPoint.x + 50 * x, this._location.initialPoint.y + 50 * y);
                }
                if(world[x][y].unit !is null) {
                    if(cast(Army)world[x][y].unit) {
                        mapSurface.blit(generateArmyTexture(cast(Army)world[x][y].unit), null,
                                this._location.initialPoint.x + 50 * x, this._location.initialPoint.y + 50 * y);
                    }
                }
            }
        }
        this.mapTexture = new Texture(mapSurface, this.container.renderer);
    }

    /**
     * Draws the map to the screen
     * Also pans the map 
     */
    override void draw() {
        //Draw the base of the map
        this.container.renderer.copy(this.mapTexture, this.pan.x, this.pan.y);
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
        this.container.renderer.clipRect = this._location;
        this.container.renderer.fill(new iRectangle(this._location.initialPoint.x + this.pan.x + 50 * 
                this.getHoveredTile().x, this._location.initialPoint.y + this.pan.y + 50 * 
                this.getHoveredTile().y, 50, 50), color);
        this.container.renderer.clipRect = null;
    }

    /**
     * Gets the location of the tile over which the user's mouse is located 
     */
    Coordinate getHoveredTile() {
        return new Coordinate((this.container.mouse.location.x - this.pan.x - this._location.initialPoint.x) / 50, 
                (this.container.mouse.location.y - this.pan.y - this._location.initialPoint.y) / 50);
    }

}