module graphics.gui.action.ProduceOption;

import d2d;

import graphics;
import logic;

import std.conv;

/**
 * An action which produces a tank
 */
class ProduceOption : Action {

    int cost; ///The resource cost to produce this
    string name; ///The name of what is being produced
    void function(ButtonMenu) production; ///The function which causes the production to occur

    /**
     * Constructs a produce action
     */
    this(Display container, ButtonMenu menu, string name, int cost, void function(ButtonMenu) production) {
        super(name~" ("~cost.to!string~")", container, menu);
        this.name = name;
        this.cost = cost;
        this.production = production;
    }

    /**
     * If the player has sufficient resources, add a tank
     * to the city's garrison
     */
    override void perform() {
        if(this.menu.origin.owner.resources >= this.cost) {
            this.production(this.menu);
            this.menu.origin.owner.resources -= this.cost;
            this.menu.updateScreen();
            this.menu.setNotification("Produced "~this.name~" for "~this.cost.to!string~" resources");
            this.disableOrigin();
        } else {
            this.menu.setNotification("Not enough resources");
        }
    }

    /**
     * Produces a tank unit
     */
    static void produceTank(ButtonMenu menu) {
        if(cast(City)menu.origin) {
            (cast(City)menu.origin).garrison.troops[1] += 1;
        }
    }

    /**
     * Produces an artillery unit
     */
    static void produceArtillery(ButtonMenu menu) {
        if(cast(City)menu.origin) {
            (cast(City)menu.origin).garrison.troops[2] += 1;
        }
    }

}

