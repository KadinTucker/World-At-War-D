module graphics.components.ButtonMenu;

import d2d;
import graphics.gui.query.Query;
import graphics.gui.ActionButton;

/**
 * A component which shows all of the buttons
 * Contains a button configuration
 * TODO:
 */
class ButtonMenu : Component {

    ActionButton[6] configuration; ///The configuration of buttons currently used

    /**
     * Constructs a new button menu in the given display
     */
    this(Display container) {
        super(container);
    }

    /**
     * Returns the location of the button menu
     * TODO:
     */
    override @property iRectangle location() {
        return null;
    }

    /**
     * Handles events
     * TODO:
     */
    void handleEvent(SDL_Event event) {

    }
    
    /**
     * Draws the button menu to the screen
     * TODO:
     */
    override void draw() {

    }
        
}