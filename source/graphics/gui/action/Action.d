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
    ButtonMenu menu; ///The menu containing this action

    /**
     * Constructs a new action with the given name
     * given display container and the buttonmenu 
     * in which the action is stored 
     */
    this(string name, Display container, ButtonMenu menu) {
        this.name = name;
        this.container = container;
        this.menu = menu;
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