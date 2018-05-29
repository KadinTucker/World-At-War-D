module graphics.gui.action.Action;

import d2d;
import graphics;
import logic;

/**
 * A class which denotes an action
 */
abstract class Action {

    string name; ///The name of this action
    GameActivity container; ///The activity containing this action

    /**
     * Constructs a new action with the given name
     */
    this(string name, GameActivity container) {
        this.name = name;
    }

    /**
     * Performs the action
     */
    abstract void performWithLocation() {

    }

}