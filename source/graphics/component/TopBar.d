module graphics.components.TopBar;

import d2d;
import graphics;
import logic;

/**
 * The component which displays information at the top of the screen
 * Shows the turn number, amount of resources, and also handles
 * access to the menu
 */
class TopBar : Component {

    iRectangle _location; ///The location of the bar

    /**
     * Constructs a new top bar in the given container
     */
    this(Display container, iRectangle location) {
        super(container);
        this._location = location;
    }

    /**
     * Returns the location of the component
     */
    override @property iRectangle location() {
        return this._location;
    }

    @property void location(iRectangle newLocation) {
        this._location = newLocation;
    }

    /**
     * Draws the top bar to the screen
     * TODO:
     */
    override void draw() {

    }

    /**
     * Handles events
     */
    void handleEvent(SDL_Event event) {

    }

}