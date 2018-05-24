module graphics.gui.query.LocationQuery;

import d2d;
import graphics.gui.query.Query;

/**
 * A class which gets input from the user's keyboard
 * Can be numbers or a long string
 */
class KeyboardQuery : Query!string {

    string currentText;

    /**
     * Constructs a new Query
     */
    this(void delegate(string) action) {
        super(action);
    }

    /**
     * Checks for keyboard inputs
     * checks for keyboard events and adds the appropriate
     * text to the current text. If the return key is pressed,
     * the query is satisfied
     * TODO:
     */
    override void ask(SDL_Event event) {
        
    }

    /**
     * Displays the text box and the text the player
     * is typing
     * TODO:
     */
    override void indicate(Display display) {

    }

}