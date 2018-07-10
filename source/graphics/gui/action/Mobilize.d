module graphics.gui.action.Mobilize;

import d2d;
import graphics;
import logic;

/**
 * An action which releases an army from
 * the garrison of a city
 * TODO: make seperate for army and navy
 */
class MobilizeAction : Action {

    /**
     * Constructs a mobilize action in the given container and menu
     */
    this(Display container, ButtonMenu menu) {
        super("Mobilize", container, menu);
    }

    /**
     * Sets a notification and a direction query of where to mobilize
     * if the player has enough resources
     */
    override void perform() {
        if(cast(City)this.menu.origin && !(cast(City)this.menu.origin).garrison.isEmpty()) {
            this.menu.setNotification("Choose a direction in which to mobilize");
            this.setQuery(new DirectionQuery(this, this.container));
            if(!this.menu.origin.isActive) {
                this.menu.configuration = ActionMenu.cityDisabledMenu;
            } else {
                this.menu.configuration = ActionMenu.cityMenu;
            }
        } else {
            this.menu.setNotification("There is no army to mobilize");
        }
    }

    /**
     * Once a direction has been acquired, mobilize in that direction if valid
     * TODO: Make mobilization onto friendly army add to the army and onto city
     * garrison in that city
     */
    override void performAfterQuery(Coordinate target, string str="") {
        if(this.menu.origin.world.getTileAt(target).terrain == Terrain.LAND) {
            if(this.menu.origin.world.getTileAt(target).element is null) {
                (cast(City)this.menu.origin).garrison.location = target;
                (cast(City)this.menu.origin).garrison.mobilize();
                (cast(City)this.menu.origin).refreshGarrison();
                this.menu.setNotification("Mobilized army at "~target.toString());
                this.menu.updateScreen();
            } else if(cast(Army)this.menu.origin.world.getTileAt(target).element) {
                (cast(City)this.menu.origin).garrison.addTo(cast(Army)this.menu.origin.world.getTileAt(target).element);
                this.menu.setNotification("Mobilized army at "~target.toString());
                this.menu.updateScreen();
            } else if(cast(City)this.menu.origin.world.getTileAt(target).element) {
                (cast(City)this.menu.origin).garrison.addTo((cast(City)this.menu.origin.world.getTileAt(target).element).garrison);
                this.menu.setNotification("Mobilized army at "~target.toString());
                this.menu.updateScreen();
            }
        } else {
            this.menu.setNotification("Invalid location: it must be a land tile");
        }
    }

}