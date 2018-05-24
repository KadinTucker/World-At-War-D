module graphics.gui.query.LocationQuery;

import d2d;
import graphics.gui.query.Query;
import logic.world.Tile;

/**
 * A class which gets the location on the map where the user clicks
 * Stores the location where the player clicked
 */
class DirectionQuery : Query!Direction {

    Direction direction;

    /**
     * Constructs a new Query
     */
    this(void delegate(Direction) action) {
        super(action);
    }

    /**
     * Checks if the player has chosen a direction
     * Uses the arrow keys to determine direction
     * TODO:
     */
    override void ask(SDL_Event event) {
        
    }

    /**
     * Indicates that the player should choose a location
     * by displaying a message 
     * TODO:
     */
    override void indicate(Display display) {

    }

}