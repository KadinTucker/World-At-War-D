module graphics.gui.query.DirectionQuery;

import d2d;
import graphics.gui.action.Action;
import graphics.gui.query.Query;
import logic.world.Tile;

/**
 * A class which gets the location on the map where the user clicks
 * Stores the location where the player clicked
 */
class DirectionQuery : Query {

    Direction direction;

    /**
     * Constructs a new Query
     */
    this(Action action, Display container) {
        super(action, container);
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
    override void indicate() {

    }

    /**
     * Does the stored action in the collected direction
     */
    override void performAction() {
        this.action.performAfterQuery(moveDirection(this.action.origin, coord));
    }

}