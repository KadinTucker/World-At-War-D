module graphics.gui.action.city.ProduceInfantry;

import d2d;
import graphics;
import logic;

import std.conv;

immutable int infantryCost = 10;

/**
 * An action which produces infantry units
 * Unique action, as infantry are produced differently from
 * other troop types
 */
class ProduceInfantryAction : Action {

    /**
     * Constructs an action in the given container and menu
     */
    this(Display container, ButtonMenu menu) {
        super("Infantry", container, menu);
    }

    /**
     * Sets a notification and a numeric input to determine
     * how many to produce
     */
    override void perform() {
        if(cast(City)this.menu.origin && this.menu.origin.owner.resources >= infantryCost) {
            this.setQuery(new NumericQuery(this, this.container));
            this.menu.setNotification("Produce how many infantry?");
        } else {
            this.menu.setNotification("Not enough resources to produce any infantry");
        }
    }

    /**
     * Once a number has been acquired, try to produce that many,
     * or cancel if there are not enough resources to do so
     */
    override void performAfterQuery(Coordinate target, string str="") {
        int numToMake = str.to!int;
        if(this.menu.origin.owner.resources >= infantryCost * numToMake) {
            (cast(City)this.menu.origin).garrison.troops[0] += numToMake;
            this.menu.setNotification("Produced "~numToMake.to!string~" infantry");
            this.menu.origin.owner.resources -= infantryCost * numToMake;
            this.disableOrigin();
            this.menu.updateScreen();
            this.menu.updateInformation();
        } else {
            this.menu.setNotification("Not enough resources");
            this.menu.configuration = ActionMenu.cityMenu;
        }
    }

}