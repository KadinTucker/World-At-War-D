module graphics.gui.action.production.Tank;

import d2d;

import graphics;
import logic;

import std.conv;

immutable int tankCost = 20;

/**
 * An action which produces a tank
 */
class ProduceTankAction : Action {

    /**
     * Constructs a produce action
     */
    this(Display container, ButtonMenu menu) {
        super("Tank ("~tankCost.to!string~")", container, menu);
    }

    /**
     * If the player has sufficient resources, add a tank
     * to the city's garrison
     */
    override void perform() {
        if(this.menu.origin.owner.resources >= 20) {
            (cast(City)this.menu.origin).garrison.troops[1] += 1;
        }
    }

}