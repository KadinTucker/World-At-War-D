module graphics.gui.query.LocationQuery;

import d2d;
import graphics.gui.action.Action;
import graphics.gui.query.Query;
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
    this(Action action) {
        super(action);
    }

    /**
     * Checks if the player clicked a valid location
     * If so, sets the query's location to be such
     *  and returns true
     * TODO:
     */
    override void ask(SDL_Event event) {
        
    }

    /**
     * Indicates that the player should choose a location
     * Indicates by highlighting 
     * TODO:
     */
    override void indicate(Display display) {

    }

}