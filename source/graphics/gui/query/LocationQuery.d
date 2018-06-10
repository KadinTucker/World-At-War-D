module graphics.gui.query.LocationQuery;

import d2d;
import graphics;
import logic.world.Tile;

/**
 * A class which gets the location on the map where the user clicks
 * Stores the location where the player clicked
 */
class LocationQuery : Query {

    Coordinate coord;

    /**
     * Constructs a new Query
     */
    this(Action action, Display container) {
        super(action, container);
    }

    /**
     * Checks if the player clicked a valid location
     * If so, sets the query's location to be such
     */
    override void ask(SDL_Event event) {
        if(event.type == SDL_MOUSEBUTTONDOWN) {
            if(event.button.button == SDL_BUTTON_LEFT) {
                if((cast(GameActivity)(this.container.activity)).map.location.contains(this.container.mouse.location)) {
                    this.coord = (cast(GameActivity)this.container.activity).map.getHoveredTile();
                    this.isFulfilled = true;
                    (cast(GameActivity)(this.container.activity)).notifications.notification = "";
                    this.performAction();
                }
            }
        }
    }

    /**
     * Indicates that the player should choose a location
     * Indicates by highlighting 
     */
    override void indicate() {
        this.container.renderer.fill((cast(GameActivity)(this.container.activity)).map.location, Color(255, 0, 0, 50));
        (cast(GameActivity)(this.container.activity)).map.fillHovered(Color(255, 0, 0, 75));
        (cast(GameActivity)(this.container.activity)).notifications.notification = "Select a location on the map on which to settle";
    }

    /**
     * Does the stored action with the collected location
     */
    override void performAction() {
        this.action.performAfterQuery(coord);
    }

}