module graphics.gui.action.Action;

import d2d;
import graphics;
import logic;

/**
 * A class which denotes an action
 */
class Action {

    string name; ///The name of this action

    /**
     * Constructs a new action with the given name
     */
    this(string name) {
        this.name = name;
    }

}