module graphics.gui.action.Build;

import d2d;
import graphics;
import logic;

import std.conv;

immutable int buildCost = 30;

/**
 * An action which causes a city to run develop without consuming an action
 */
class BuildAction : Action {

    /**
     * Constructs a develop action in the given container and menu
     */
    this(Display container, ButtonMenu menu) {
        super("Build   ", container, menu);
    }

    /**
     * Runs the city's develop method and consume resources
     */
    override void perform() {
        if(cast(City)this.menu.origin && this.menu.origin.owner.resources >= buildCost) {
            (cast(City)this.menu.origin).develop();
            this.menu.origin.owner.resources -= buildCost;
            this.menu.updateScreen();
            this.menu.setNotification("Built city up to level "~(cast(City)this.menu.origin).level.to!string~" for "~buildCost.to!string~" resources");
            if(!this.menu.origin.isActive) {
                this.menu.configuration = ActionMenu.cityDisabledMenu;
            } else {
                this.menu.configuration = ActionMenu.cityMenu;
            }
        } else {
             this.menu.setNotification("Not enough resources to build, you need "~buildCost.to!string);
        }
    }

}