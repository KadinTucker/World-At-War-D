module graphics.gui.action.Cancel;

import d2d;
import graphics;
import logic;

/**
 * An action which returns an action menu of a
 * tile element to the base action menu
 */
class CancelAction : Action {

    /**
     * Constructs a cancel action in the given container and menu
     */
    this(Display container, ButtonMenu menu) {
        super("Cancel  ", container, menu);
    }

    /**
     * Sets the menu to be the base menu of whatever tile element is selected
     */
    override void perform() {
        if(cast(City)this.menu.origin) {
            this.menu.configuration = ActionMenu.cityMenu;
        } else if(cast(Army)this.menu.origin) {
            //TODO: Make army menu
        }
    }

    /**
     * Does not use queries
     */
    override void performAfterQuery(Coordinate target, string str="") {

    }

}