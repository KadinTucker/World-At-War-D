module graphics.gui.action.Move;

import d2d;
import graphics;
import logic;

import std.conv;

/**
 * An action which moves an army
 */
class MoveAction : Action {

    /**
     * Constructs a move action in the given container and menu
     */
    this(Display container, ButtonMenu menu) {
        super("Move    ", container, menu);
    }

    /**
     * Performs the action 
     * Performs until the unit runs out of movement points
     * or the query is cancelled
     */
    override void perform() {
        if(cast(Army)this.menu.origin && (cast(Army)this.menu.origin).movementPoints > 0) {
            this.setQuery(new DirectionQuery(this, this.container));
            this.menu.configuration = ActionMenu.nullMenu;
        } else {
            this.menu.setNotification("No movement points left");
        }
    }

    /**
     * Once a direction has been acquired, mobilize in that direction if valid
     * TODO: Make mobilization onto friendly army add to the army and onto city
     * garrison in that city
     */
    override void performAfterQuery(Coordinate target, string str="") {
        (cast(Army)this.menu.origin).move(target);
        this.menu.setNotification((cast(Army)this.menu.origin).movementPoints.to!string~" move(s) remaining");
        this.menu.updateScreen();
        this.menu.updateInformation();
        if((cast(Army)this.menu.origin).movementPoints > 0) {
            this.perform();
        } else {
            this.menu.setNotification(" ");
        }
    }

}