module graphics.gui.action.Settle;

import d2d;
import graphics;
import logic;

/**
 * An action which settles a new city
 */
class SettleAction : Action {

    /**
     * Constructs a new action with the given name
     * given container and action's origin location
     */
    this(Display container, ButtonMenu menu) {
        super("Settle", container, menu);
    }

    /**
     * Causes a city to be settled
     * Initiates a location query for the settlement
     * TODO:
     */
    override void perform() {
        import std.stdio;
        writeln("Settling");
    }

    /**
     * If the location obtained from the query is valid,
     * add a city there
     */
    override void performAfterQuery(Coordinate target, string str="") {

    }

}