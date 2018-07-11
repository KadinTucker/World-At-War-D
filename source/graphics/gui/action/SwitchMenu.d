module graphics.gui.action.SwitchMenu;

import d2d;
import graphics;
import logic;

/**
 * An action which switches the menu to another menu
 */
class SwitchMenuAction : Action {

    Action[6] toSwitchTo; ///The menu configuration to switch to
    string message; ///The message to display when switching menus

    /**
     * Constructs a cancel action in the given container and menu
     * takes in an action config to return to
     */
    this(Display container, ButtonMenu menu, string name, string message, Action[6] toSwitchTo) {
        super(name, container, menu);
        this.toSwitchTo = toSwitchTo;
        this.message = message;
    }

    /**
     * Sets the menu to be the base menu of whatever tile element is selected
     */
    override void perform() {
        this.menu.configuration = this.toSwitchTo;
        this.menu.setNotification(message);
    }

}