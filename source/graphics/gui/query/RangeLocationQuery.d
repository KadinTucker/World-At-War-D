module graphics.gui.query.RangeLocationQuery;

import d2d;
import graphics;
import logic.world.Tile;

/**
 * A class which gets the location on the map where the user clicks
 * Stores the location where the player clicked
 * Query is limited to tiles within a certain range of the origin
 * Range is done by manhattan distance
 */
class RangeLocationQuery : Query {

    Coordinate coord; ///The location received from the query
    int range; ///The range bounds of the query
    Texture indicationTexture; ///The texture drawn to indicate the query

    /**
     * Constructs a new Query
     */
    this(Action action, Display container, int range) {
        super(action, container);
        this.range = range;
        this.getIndicationTexture();
    }

    /**
     * Initializes the texture used to indicate the query
     */
    private void getIndicationTexture() {
        Surface base = new Surface(50 * (1 + 2 * this.range), 50 * (1 + 2 * this.range), SDL_PIXELFORMAT_RGBA32);
        for(int i = 0; i <= this.range; i++) {
            base.fill(new iRectangle(50 * (this.range - i), 50 * i, 50 * (1 + 2 * i), 50), Color(255, 0, 0, 70));
        }
        for(int i = this.range + 1; i < 2 * this.range; i++) {
            base.fill(new iRectangle(50 * (i % this.range), 50 * i, 50 * (1 + 2 * this.range - 2 * (i % (this.range))), 50), Color(255, 0, 0, 70));
        }
        base.fill(new iRectangle(50 * this.range, 50 * this.range * 2, 50, 50), Color(255, 0, 0, 70));
        this.indicationTexture = new Texture(base, this.container.renderer);
    }

    /**
     * Checks if the player clicked a valid location
     * If so, sets the query's location to be such
     */
    override void ask(SDL_Event event) {
        if(event.type == SDL_MOUSEBUTTONDOWN) {
            if(event.button.button == SDL_BUTTON_LEFT) {
                if((cast(GameActivity)(this.container.activity)).map.location.contains(this.container.mouse.location)
                        && Tile.getManhattanDistance((cast(GameActivity)(this.container.activity)).map.getHoveredTile(), 
                        this.action.menu.origin.location) <= this.range) {
                    this.coord = (cast(GameActivity)this.container.activity).map.getHoveredTile();
                    this.isFulfilled = true;
                    (cast(GameActivity)(this.container.activity)).notifications.notification = "";
                    this.performAction();
                }
            } else if(event.button.button == SDL_BUTTON_RIGHT) {
                this.isFulfilled = true;
                this.action.menu.setNotification("Cancelled");
            }
        } else if(event.type == SDL_KEYDOWN) {
            if(event.key.keysym.sym == SDLK_ESCAPE) {
                this.isFulfilled = true;
                this.action.menu.setNotification("Cancelled");
            }
        }
    }

    /**
     * Indicates that the player should choose a location
     * Indicates by highlighting 
     */
    override void indicate() {
        Map refMap = (cast(GameActivity)this.container.activity).map;
        this.container.renderer.copy(this.indicationTexture, 
                refMap.location.initialPoint.x + 50 * (this.action.menu.origin.location.x - this.range) + refMap.pan.x,
                refMap.location.initialPoint.y + 50 * (this.action.menu.origin.location.y - this.range) + refMap.pan.y);
    }

    /**
     * Does the stored action with the collected location
     */
    override void performAction() {
        this.action.performAfterQuery(coord);
    }

}