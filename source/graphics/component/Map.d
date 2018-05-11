module graphics.components.Map;

import d2d;
import logic.world.World;
import logic.world.Tile;

/**
 * A component that displays and handles interation with the world
 */
class Map : Component {

    iRectangle _location;
    World world;
    Texture waterTexture;
    Texture landTexture;

    this(Display container, iRectangle location, World world) {
        super(container);
        this.world = world;
        this._location = location;
        this.waterTexture = new Texture(loadImage("res/Tile/water.png"), this.container.renderer);
        this.landTexture = new Texture(loadImage("res/Tile/land.png"), this.container.renderer);
    }

    override @property iRectangle location() {
        return this._location;
    }

    void handleEvent(SDL_Event event) {

    }

    override void draw() {
        for(int x; x < this.world.length; x++) {
            for(int y; y < this.world[x].length; y++) {
                if(world[x][y].terrain == Terrain.WATER) {
                    this.container.renderer.copy(this.waterTexture, this._location.initialPoint.x + 50 * x, 
                            this._location.initialPoint.y + 50 * y);
                } else if(world[x][y].terrain == Terrain.LAND) {
                    this.container.renderer.copy(this.landTexture, this._location.initialPoint.x + 50 * x, 
                            this._location.initialPoint.y + 50 * y);
                }
            }
        }
    }

}