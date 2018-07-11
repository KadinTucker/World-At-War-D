module graphics.gui.action.city.Mobilize;

import d2d;
import graphics;
import logic;

/**
 * An action which releases an army from
 * the garrison of a city
 * TODO: make seperate for army and navy
 */
class MobilizeAction : Action {

    int typeToMobilize; ///Which to mobilize; 0 for army, 1 for fleet

    /**
     * Constructs a mobilize action in the given container and menu
     */
    this(Display container, ButtonMenu menu, string name, int typeToMobilize) {
        super(name, container, menu);
        this.typeToMobilize = typeToMobilize;
    }

    /**
     * Sets a notification and a direction query of where to mobilize
     * if the player has enough resources
     */
    override void perform() {
        if(cast(City)this.menu.origin) {
            this.menu.setNotification("Mobilize to where?");
            this.setQuery(new DirectionQuery(this, this.container));
            if(!this.menu.origin.isActive) {
                this.menu.configuration = ActionMenu.cityDisabledMenu;
            } else {
                this.menu.configuration = ActionMenu.cityMenu;
            }
        } else {
            this.menu.setNotification("No unit of that type");
        }
    }

    /**
     * Once a direction has been acquired, mobilize in that direction if valid
     */
    override void performAfterQuery(Coordinate target, string str="") {
        Unit toMobilize;
        if(this.typeToMobilize == 0 && this.menu.origin.world.getTileAt(target).terrain == Terrain.LAND) {
            toMobilize = (cast(City)this.menu.origin).garrison;
        }
        else if(this.typeToMobilize == 1 && this.menu.origin.world.getTileAt(target).terrain == Terrain.WATER) {
            toMobilize = (cast(City)this.menu.origin).harbor;
        } else {
            this.menu.setNotification("Invalid location for that unit");
            return;
        }
        if(this.menu.origin.world.getTileAt(target).element is null) {
            toMobilize.location = target;
            toMobilize.mobilize();
            (cast(City)this.menu.origin).refreshGarrison();
        } else if(cast(Army)this.menu.origin.world.getTileAt(target).element
                && !cast(Fleet)toMobilize) {
            toMobilize.addTo(cast(Army)this.menu.origin.world.getTileAt(target).element);
        } else if(cast(Fleet)this.menu.origin.world.getTileAt(target).element) {
            toMobilize.addTo(cast(Fleet)this.menu.origin.world.getTileAt(target).element);
        } else if(cast(City)this.menu.origin.world.getTileAt(target).element
                && cast(Army)toMobilize) {
            toMobilize.addTo((cast(City)this.menu.origin.world.getTileAt(target).element).garrison);
        } else if(cast(City)this.menu.origin.world.getTileAt(target).element
                && cast(Fleet)toMobilize) {
            toMobilize.addTo((cast(City)this.menu.origin.world.getTileAt(target).element).harbor);
        } else {
            this.menu.setNotification("Invalid destination for that unit");
            return;
        }
        this.menu.setNotification("Mobilized unit at "~target.toString());
        this.menu.updateScreen();
    }

}