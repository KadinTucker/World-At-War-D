module graphics.gui.action.city.Build;

import d2d;
import graphics;
import logic;

import std.conv;

//Define constants used in settling cities
immutable int buildCost = 20;
immutable int initialSize = 1;
immutable int buildLevels = 1;

/**
 * An action which settles a new city
 * or develops an existing city
 */
class BuildAction : Action {

    /**
     * Constructs a new action with the given name
     * given container and action's origin location
     */
    this(Display container, ButtonMenu menu) {
        super("Build   ", container, menu);
    }

    /**
     * Causes a city to be settled or built up
     * Initiates a location query for the settlement
     */
    override void perform() {
        if(cast(City)this.menu.origin && this.menu.origin.owner.resources >= buildCost) {
            this.setQuery(new LocationQuery(this, this.container));
            this.menu.setNotification("Choose a location to build");
        } else {
            this.menu.setNotification("Not enough resources to build! You need "~buildCost.to!string);
        }
    }

    /**
     * If the location obtained from the query is valid,
     * add a city there and consume an action
     */
    override void performAfterQuery(Coordinate target, string str="") {
        if(this.menu.origin.world.getTileAt(target).terrain == Terrain.LAND 
                && this.menu.origin.world.getTileAt(target).owner == this.menu.origin.owner) {
            if(cast(City)this.menu.origin.world.getTileAt(target).element) {
                (cast(City)this.menu.origin).develop();
                this.menu.setNotification("Built city at "~target.toString~" up to level "~(cast(City)this.menu.origin).level.to!string~" for "~buildCost.to!string~" resources");
                if(!this.menu.origin.isActive) {
                    this.menu.configuration = ActionMenu.cityDisabledMenu;
                } else {
                    this.menu.configuration = ActionMenu.cityMenu;
                }
                this.menu.origin.owner.resources -= buildCost;
            } else if(this.menu.origin.isActive) {
                City cityToAdd = new City(this.menu.origin.owner, target, this.menu.origin.world, initialSize);
                cityToAdd.isActive = false;
                if(this.menu.origin.world.getTileAt(target).element !is null && cast(Army)this.menu.origin.world.getTileAt(target).element) {
                    cityToAdd.garrison = (cast(Army)this.menu.origin.world.getTileAt(target).element);
                    (cast(Army)this.menu.origin.world.getTileAt(target).element).getDestroyed();
                }
                this.menu.origin.world.getTileAt(target).element = cityToAdd;
                this.menu.origin.world.getTileAt(target).owner = cityToAdd.owner;
                this.menu.origin.owner.cities ~= cityToAdd;
                this.menu.setNotification("Settled a new city at "~target.toString());
                this.disableOrigin();
                this.menu.configuration = ActionMenu.cityDisabledMenu;
                this.menu.origin.owner.resources -= buildCost;
            } else {
                this.menu.setNotification("Cannot settle a new city without an action");
                this.menu.configuration = ActionMenu.cityDisabledMenu;
            }
            this.menu.updateScreen();
        } else {
            this.menu.setNotification("The destination must be a land tile that you own");
        }
    }

}