module graphics.gui.action.Develop;

import d2d;
import graphics;
import logic;

import std.conv;

/**
 * An action which causes a city to run its develop method
 */
class DevelopAction : Action {

    /**
     * Constructs a develop action in the given container and menu
     */
    this(Display container, ButtonMenu menu) {
        super("Develop ", container, menu);
    }

    /**
     * Runs the city's develop method
     */
    override void perform() {
        if(cast(City)this.menu.origin) {
            (cast(City)this.menu.origin).develop();
            this.menu.updateMap();
            this.menu.setNotification("Developed city to level "~(cast(City)this.menu.origin).level.to!string);
            this.disableOrigin();
        }
    }

    /**
     * Does not use queries
     */
    override void performAfterQuery(Coordinate target, string str="") {

    }

}