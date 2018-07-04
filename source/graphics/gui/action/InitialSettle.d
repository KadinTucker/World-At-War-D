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

    int playerIndex = 0; ///The currently reached index of the initial settlements

    /**
     * Constructs a new action with the given name
     * given container and action's origin location
     */
    this(Display container, ButtonMenu menu) {
        super(" ", container, menu);
    }

    /**
     * Causes a city to be settled
     * Initiates a location query for the settlement
     */
    override void perform() {
        this.menu.origin.owner = (cast(GameActivity)this.container.activity).players[this.playerIndex];
        (cast(GameActivity)this.container.activity).notifications.notification = "Player "~this.menu.origin.owner.name~
                ", choose a location for your starting city";
        this.setQuery(new LocationQuery(this, this.container));
    }

    /**
     * If the location obtained from the query is land and has no city already on it,
     * add a city there starting at level 5
     * If not, restart the action
     * If yes, move on to the next player
     */
    override void performAfterQuery(Coordinate target, string str="") {
        if(this.menu.origin.world.getTileAt(target).terrain == Terrain.LAND 
                && this.menu.origin.world.getTileAt(target).city is null) {
            this.menu.origin.world.getTileAt(target).city = new City(this.menu.origin.owner, 
                    target, this.menu.origin.world, 3);
            (cast(GameActivity)this.container.activity).map.updateTexture();
            this.playerIndex++;
            if(this.playerIndex < (cast(GameActivity)this.container.activity).players.length) {
                this.perform();
            }
        } else {
            this.perform();
        }
    }

}