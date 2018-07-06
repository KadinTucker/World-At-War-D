module graphics.gui.action.Settle;

import d2d;
import graphics;
import logic;

import std.conv;

//Define constants used in settling cities
immutable int settleCost = 30;
immutable int initialSize = 3;

/**
 * An action which settles a new city
 */
class SettleAction : Action {

    /**
     * Constructs a new action with the given name
     * given container and action's origin location
     */
    this(Display container, ButtonMenu menu) {
        super("Settle  ", container, menu);
    }

    /**
     * Causes a city to be settled
     * Initiates a location query for the settlement
     * TODO:
     */
    override void perform() {
        if(cast(City)this.menu.origin && this.menu.origin.owner.resources >= settleCost) {
            this.setQuery(new LocationQuery(this, this.container));
            this.menu.setNotification("Choose a location to settle the new city");
        } else {
            this.menu.setNotification("Not enough resources to settle a new city! You need "~settleCost.to!string);
        }
    }

    /**
     * If the location obtained from the query is valid,
     * add a city there and consume an action
     */
    override void performAfterQuery(Coordinate target, string str="") {
        if(this.menu.origin.world.getTileAt(target).terrain == Terrain.LAND 
                && this.menu.origin.world.getTileAt(target).city is null) {
            City cityToAdd = new City(this.menu.origin.owner, target, this.menu.origin.world, initialSize);
            cityToAdd.isActive = false;
            this.menu.origin.world.getTileAt(target).city = cityToAdd;
            this.menu.origin.owner.cities ~= cityToAdd;
            this.menu.origin.owner.resources -= settleCost;
            this.menu.updateMap();
            this.menu.setNotification("Settled a new city at ("~target.x.to!string~", "~target.y.to!string~")");
            this.disableOrigin();
        }
    }

}