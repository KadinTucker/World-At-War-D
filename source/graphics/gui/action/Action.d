module graphics.gui.action.Action;

import d2d;
import graphics;
import logic;

/**
 * A class which denotes an action
 */
abstract class Action {

    string name; ///The name of this action
    Display container; ///The display containing this action
    Coordinate origin; ///The origin of this action

    /**
     * Constructs a new action with the given name
     * given container and action's origin location
     */
    this(string name, Display container, Coordinate origin) {
        this.name = name;
        this.container = container;
        this.origin = origin;
    }

    /**
     * Performs the action
     */
    abstract void perform();

    /**
     * Performs the action from a query
     * Uses whatever the query resulted in, 
     * either a coordinate or a string
     */
    abstract void performAfterQuery(Coordinate target, string str="");

}