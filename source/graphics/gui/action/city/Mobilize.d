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
        import std.stdio;
        Unit toMobilize;
        if(this.typeToMobilize == 0 && !(cast(City)this.menu.origin).garrison.isEmpty()) {
            toMobilize = (cast(City)this.menu.origin).garrison;
            if(this.menu.origin.world.getTileAt(target).terrain == Terrain.LAND
                    && this.menu.origin.world.getTileAt(target).element is null) {
                toMobilize.location = target;
                toMobilize.mobilize();
                writeln("Army to empty");
                (cast(City)this.menu.origin).refreshGarrison();
                this.menu.setNotification("Mobilized unit at "~target.toString());
                this.menu.updateScreen();
                return;
            }
        } else if(this.typeToMobilize == 1 && !(cast(City)this.menu.origin).harbor.isEmpty()) {
            toMobilize = (cast(City)this.menu.origin).harbor;
            if(this.menu.origin.world.getTileAt(target).terrain == Terrain.WATER
                    && this.menu.origin.world.getTileAt(target).element is null) {
                toMobilize.location = target;
                toMobilize.mobilize();
                writeln("Fleet to empty");
                (cast(City)this.menu.origin).refreshHarbor();
                this.menu.setNotification("Mobilized unit at "~target.toString());
                this.menu.updateScreen();
                return;
            }
        }
        if(toMobilize is null) {
            this.menu.setNotification("Failed to mobilize");
            return;
        //Army to army
        } else if(cast(Army)this.menu.origin.world.getTileAt(target).element
                && !cast(Fleet)toMobilize) {
            writeln("Army to army");
            toMobilize.addTo(cast(Army)this.menu.origin.world.getTileAt(target).element);
            (cast(City)this.menu.origin).refreshGarrison();
        //Unit to fleet
        } else if(cast(Fleet)this.menu.origin.world.getTileAt(target).element) {
            toMobilize.addTo(cast(Fleet)this.menu.origin.world.getTileAt(target).element);
            if(cast(Army)toMobilize) {
                writeln("Army to fleet");
                (cast(City)this.menu.origin).refreshGarrison();
            } else {
                writeln("Fleet to fleet");
                (cast(City)this.menu.origin).refreshHarbor();
            }
        //Army to city
        } else if(cast(City)this.menu.origin.world.getTileAt(target).element
                && cast(Army)toMobilize) {
            writeln("Army to city");
            toMobilize.addTo((cast(City)this.menu.origin.world.getTileAt(target).element).garrison);
            (cast(City)this.menu.origin).refreshGarrison();
        //Fleet to city
        } else if(cast(City)this.menu.origin.world.getTileAt(target).element
                && cast(Fleet)toMobilize) {
            writeln("Fleet to city");
            toMobilize.addTo((cast(City)this.menu.origin.world.getTileAt(target).element).harbor);
            (cast(City)this.menu.origin).refreshHarbor();
        } else {
            this.menu.setNotification("Invalid destination for that unit");
            return;
        }
        this.menu.setNotification("Mobilized unit at "~target.toString());
        this.menu.updateScreen();
    }

}