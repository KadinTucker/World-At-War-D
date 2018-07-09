module graphics.gui.action.Cancel;

import d2d;
import graphics;
import logic;

/**
 * An action which returns an action menu of a
 * tile element to the base action menu
 */
class CancelAction : Action {

    Action[6] toReturnTo;

    /**
     * Constructs a cancel action in the given container and menu
     * takes in an action config to return to
     */
    this(Display container, ButtonMenu menu, Action[6] toReturnTo) {
        super("Cancel  ", container, menu);
        this.toReturnTo = toReturnTo;
    }

    /**
     * Sets the menu to be the base menu of whatever tile element is selected
     */
    override void perform() {
        if(cast(City)this.menu.origin) {
            this.menu.configuration = this.toReturnTo;
        }
        this.menu.setNotification(" ");
    }

}