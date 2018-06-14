module graphics.gui.action.InitialSettle;

import d2d;
import graphics;
import logic;

/**
 * Settles a city
 * Different from regular settle action, only occurs at the
 * start of the game.
 * Cannot be done with any buttons
 */
class InitialSettleAction : Action {

    /**
     * Constructs a new action with the given name
     * given container and action's origin location
     */
    this(Display container, ButtonMenu menu) {
        super("InitSettle", container, menu);
    }

    /**
     * Causes a city to be settled
     * Initiates a location query for the settlement
     */
    override void perform() {
        this.setQuery(new LocationQuery(this, this.container));
    }

    /**
     * If the location obtained from the query is land and has no city already on it,
     * add a city there starting at level 5
     * If not, restart the action
     */
    override void performAfterQuery(Coordinate target, string str="") {
        if(this.menu.origin.world.getTileAt(target).terrain == Terrain.LAND 
                && this.menu.origin.world.getTileAt(target).city is null) {
            this.menu.origin.world.getTileAt(target).city = new City(this.menu.origin.owner, 
                    target, this.menu.origin.world, 5);
        } else {
            this.perform();
        }
    }

}