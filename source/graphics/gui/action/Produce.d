module graphics.gui.action.Produce;

import d2d;
import graphics;
import logic;

/**
 * An action which causes a city to produce a unit
 * Creates a submenu which lays out options to be produced
 */
class ProduceAction : Action {

    /**
     * Constructs a produce action in the given container and menu
     */
    this(Display container, ButtonMenu menu) {
        super("Produce ", container, menu);
    }

    /**
     * Sets a notification and sets the menu to be production options
     */
    override void perform() {
        if(cast(City)this.menu.origin) {
            this.menu.setNotification("Choose a unit to produce");
            this.menu.configuration = ActionMenu.produceOptionsLandMenu;
        }
    }

    /**
     * Does not use queries
     */
    override void performAfterQuery(Coordinate target, string str="") {

    }

}