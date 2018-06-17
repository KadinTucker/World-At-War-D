module graphics.gui.action.Develop;

import d2d;
import graphics;
import logic;

/**
 * An action which causes a city to run its develop method
 */
class DevelopAction : Action {

    /**
     * Constructs a develop action in the given container and menu
     */
    this(Display container, ButtonMenu menu) {
        super("Develop", container, menu);
    }

    /**
     * Runs the city's develop method
     */
    override void perform() {
        (cast(City)this.menu.origin).develop();
    }

    /**
     * Does not use queries
     */
    override void performAfterQuery(Coordinate target, string str="") {

    }

}