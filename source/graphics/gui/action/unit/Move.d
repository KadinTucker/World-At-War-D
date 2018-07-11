module graphics.gui.action.unit.Move;

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
     * Checks if the element is one that can move
     * and has movement points
     */
    private bool hasMovementPoints(TileElement element) {
        return (cast(Army)this.menu.origin && (cast(Army)this.menu.origin).movementPoints > 0)
                || (cast(Fleet)this.menu.origin && (cast(Fleet)this.menu.origin).movementPoints > 0);
    }

    /**
     * Returns the number of movement points the unit has with proper casting
     */
    private int getMovementPoints(TileElement element) {
        if(cast(Army)this.menu.origin) {
            return (cast(Army)this.menu.origin).movementPoints;
        } else if(cast(Fleet)this.menu.origin) {
            return (cast(Fleet)this.menu.origin).movementPoints;
        }
        return 0;
    }

    /**
     * Performs the action 
     * Performs until the unit runs out of movement points
     * or the query is cancelled
     */
    override void perform() {
        if(this.menu.origin is null) {
            import std.stdio;
            writeln("Selected element null. Sadness.");
            return;
        }
        if(this.hasMovementPoints(this.menu.origin)) {
            this.menu.setNotification(this.getMovementPoints(this.menu.origin).to!string~" move(s) remaining");
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
        (cast(Unit)this.menu.origin).move(target);
        this.menu.updateScreen();
        this.menu.updateInformation();
        if(this.hasMovementPoints(this.menu.origin)) {
            this.perform();
        } else {
            this.menu.setNotification("Out of moves");
            if((cast(Unit)this.menu.origin).isDestroyed) {
                this.menu.setNotification("Merged with another element");
                (cast(GameActivity)this.container.activity).map.selectedElement = null;
                this.menu.updateScreen();
            }
        }
    }

}