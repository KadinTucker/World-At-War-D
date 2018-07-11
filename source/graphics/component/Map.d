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
    Texture[3] selectionTextures; ///The textures used in drawing selections

    /**
     * Constructs a new map in the given display, bounded by the given rectangle 
     * and displaying the given world
     */
    this(Display container, iRectangle location, World world) {
        super(container);
        this.world = world;
        this.pan = new iVector(0, 0);
        this._location = location;
        this.selectionTextures = [new Texture(loadImage("res/Tile/selection.png"), this.container.renderer),
                new Texture(loadImage("res/Tile/selectionCompleted.png"), this.container.renderer),
                new Texture(loadImage("res/Tile/selectionInactive.png"), this.container.renderer)];
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
     * Gets the active player in the game
     */
    @property Player activePlayer() {
        return (cast(GameActivity)this.container.activity).players[(cast(GameActivity)this.container.activity).activePlayerIndex];
    }

    /**
     * Returns the button menu contained in the activity 
     */
    @property ButtonMenu menu() {
        return (cast(GameActivity)this.container.activity).buttonMenu;
    }

    /**
     * Handles incoming events to the map component
     * Handles selection of tiles on the map
     */
    void handleEvent(SDL_Event event) {
        if(event.type == SDL_MOUSEBUTTONDOWN) {
            if(event.button.button == SDL_BUTTON_LEFT) {
                if(this._location.contains(this.container.mouse.location)
                        && (cast(GameActivity)this.container.activity).query is null) {
                    Tile hovered = this.world.getTileAt(this.getHoveredTile());
                    if(hovered !is null && hovered.element !is null) {
                        if(cast(City)hovered.element) {
                            this.selectCity(cast(City)hovered.element);
                        } else if(cast(Unit)hovered.element) {
                            this.selectUnit(cast(Unit)hovered.element);
                        } 
                    } else {
                        this.menu.configuration = ActionMenu.nullMenu;
                        this.menu.setNotification("");
                        this.selectedElement = null;
                    }
                    (cast(GameActivity)this.container.activity).info.updateTexture(hovered);
                }
            }
        }
    }

    /**
     * Runs when a city on the map is selected
     * If the city is active, set the action configuration
     * to be the city actions
     */
    void selectCity(City city) {
        this.selectedElement = city;
        if(this.selectedElement.owner == this.activePlayer) {
            if(this.selectedElement.isActive) {
                this.menu.configuration = ActionMenu.cityMenu;
            } else {
                this.menu.configuration = ActionMenu.cityDisabledMenu;
            }
        } else {
            this.menu.configuration = ActionMenu.nullMenu;
        }
        this.menu.setNotification(" ");
    }

    /**
     * Runs when a unit is selected
     * Handles both armies and fleets
     * TODO: Make action configurations for
     * units to be set
     */
    void selectUnit(Unit unit) {
        this.selectedElement = unit;
        this.menu.configuration = ActionMenu.armyMenu;
        this.menu.setNotification(" ");
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
                    if(world[x][y].owner !is null) {
                        mapSurface.blit(TileDisplay.flags[world[x][y].owner.number], null, this._location.initialPoint.x + 50 * x, 
                                this._location.initialPoint.y + 50 * y);
                    }
                }
                if(world[x][y].element !is null) {
                    if(cast(City)world[x][y].element) {
                        mapSurface.blit(TileDisplay.generateCityTexture(cast(City)world[x][y].element), null,
                                this._location.initialPoint.x + 50 * x, this._location.initialPoint.y + 50 * y);
                    } else if(cast(Army)world[x][y].element) {
                        mapSurface.blit(TileDisplay.generateArmyTexture(cast(Army)world[x][y].element), null,
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
        //Fill rectangle at hovered tile and selected tile
        this.fillHovered(Color(255, 255, 255, 100));
        this.drawSelectedTile();
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
     * Indicates the selected element on the map
     */
    void drawSelectedTile() {
        if(this.selectedElement !is null && this.selectedElement.location !is null) {
            if(this.selectedElement.owner != this.activePlayer) {
                this.container.renderer.copy(this.selectionTextures[2], new iRectangle(this._location.initialPoint.x + this.pan.x + 50 * 
                        this.selectedElement.location.x, this._location.initialPoint.y + this.pan.y + 50 * this.selectedElement.location.y, 
                        50, 50));
            } else if(!this.selectedElement.isActive) {
                this.container.renderer.copy(this.selectionTextures[1], new iRectangle(this._location.initialPoint.x + this.pan.x + 50 * 
                        this.selectedElement.location.x, this._location.initialPoint.y + this.pan.y + 50 * this.selectedElement.location.y, 
                        50, 50));
            } else {
                this.container.renderer.copy(this.selectionTextures[0], new iRectangle(this._location.initialPoint.x + this.pan.x + 50 * 
                        this.selectedElement.location.x, this._location.initialPoint.y + this.pan.y + 50 * this.selectedElement.location.y, 
                        50, 50));
            }
        }
    }

    /**
     * Gets the location of the tile over which the user's mouse is located 
     */
    Coordinate getHoveredTile() {
        return new Coordinate((this.container.mouse.location.x - this.pan.x - this._location.initialPoint.x) / 50, 
                (this.container.mouse.location.y - this.pan.y - this._location.initialPoint.y) / 50);
    }

}