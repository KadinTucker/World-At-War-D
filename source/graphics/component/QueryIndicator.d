module graphics.components.QueryIndicator;

import d2d;
import graphics;
import logic;

/**
 * A component which indicates an active query
 * In order to display the query after other components
 */
class QueryIndicator : Component {

    GameActivity activity; ///The activity whose query to indicate

    /**
     * Constructs a new query indicator
     */
    this(Display container, GameActivity activity) {
        super(container);
        this.activity = activity;
    }

    /**
     * Returns null; query indicator uses whole display 
     */ 
    override @property iRectangle location() {
        return null;
    }

    /**
     * Indicates the query if it exists
     */
    override void draw() {
        if(this.activity.query !is null) {
            this.activity.query.indicate;
        }
    }

    /**
     * Does not handle events
     */
    void handleEvent(SDL_Event event) {

    }

}