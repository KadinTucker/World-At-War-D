module graphics.gui.action.InitialSettle;

import d2d;
import graphics;
import logic;

immutable int startingCityLevel = 5;

/**
 * Settles a city
 * Different from regular settle action, only occurs at the
 * start of the game.
 * Cannot be done with any buttons
 */
class InitialSettleAction : Action {

    GameActivity game; ///The game activity; stored so that turn transition can happen

    /**
     * Constructs a new action with the given name
     * given container and action's origin location
     */
    this(Display container, ButtonMenu menu) {
        super(" ", container, menu);
        this.game = cast(GameActivity)container.activity;
    }

    /**
     * Causes a city to be settled
     * Initiates a location query for the settlement
     */
    override void perform() {
        this.container.activity = this.container.activity = new TurnTransitionActivity(this.container, this.game);
        this.game.notifications.notification = "Player "~this.game.players[this.game.activePlayerIndex].name~", choose a location for your starting city";
        this.game.query = new LocationQuery(this, this.container);
    }

    /**
     * If the location obtained from the query is land and has no city already on it,
     * add a city there starting at level 5
     * If not, restart the action
     * If yes, move on to the next player
     */
    override void performAfterQuery(Coordinate target, string str="") {
        if(this.game.world.getTileAt(target).terrain == Terrain.LAND 
                && this.game.world.getTileAt(target).element is null) {
            City cityToAdd = new City(this.game.players[this.game.activePlayerIndex], target, this.game.world, startingCityLevel);
            this.game.world.getTileAt(target).element = cityToAdd;
            this.game.world.getTileAt(target).owner = cityToAdd.owner;
            this.game.players[this.game.activePlayerIndex].cities ~= cityToAdd;
            this.game.activePlayerIndex += 1;
            if(this.game.activePlayerIndex < this.game.players.length) {
                this.container.activity = new TurnTransitionActivity(this.container, this.game);
                this.perform();
            } else {
                this.game.activePlayerIndex = 0;
                this.game.updateComponents();
                this.game.info.updateTexture(null);
                this.container.activity = new TurnTransitionActivity(this.container, this.game);
            }
        } else {
            this.perform();
        }
    }

}