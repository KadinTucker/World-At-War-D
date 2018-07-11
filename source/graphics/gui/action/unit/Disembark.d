module graphics.gui.action.unit.Disembark;

import d2d;
import graphics;
import logic;

/**
 * An action which causes a fleet to 
 * release its embarked army
 */
class DisembarkAction : Action {

    /**
     * Constructs a disembark action in the given container and menu
     */
    this(Display container, ButtonMenu menu) {
        super("Disembark", container, menu);
    }

    /**
     * Performs the action 
     * Sets a direction query
     */
    override void perform() {
        if(cast(Fleet)this.menu.origin && !(cast(Fleet)this.menu.origin).embarked.isEmpty()) {
            this.menu.setNotification("Choose a direction to disembark");
            this.setQuery(new DirectionQuery(this, this.container));
        } else {
            this.menu.setNotification("No embarked army to release");
        }
    }

    /**
     * Once a direction has been acquired, disembark there if valid
     */
    override void performAfterQuery(Coordinate target, string str="") {
        if(this.menu.origin.world.getTileAt(target).terrain == Terrain.LAND ) {
            if(this.menu.origin.world.getTileAt(target).element is null) {
                (cast(Fleet)this.menu.origin).embarked.location = target;
                (cast(Fleet)this.menu.origin).embarked.mobilize();
                (cast(Fleet)this.menu.origin).embarked.disable();
            } else if(cast(City)this.menu.origin.world.getTileAt(target).element) {
                (cast(Fleet)this.menu.origin).embarked.addTo((cast(City)this.menu.origin.world.getTileAt(target).element).garrison);
            } else if(cast(Army)this.menu.origin.world.getTileAt(target).element) {
                (cast(Fleet)this.menu.origin).embarked.addTo(cast(Army)this.menu.origin.world.getTileAt(target).element);
            } else {
                return;
            }
            (cast(Fleet)this.menu.origin).refreshEmbarked();
            this.menu.setNotification("Disembarked to "~target.toString());
            this.menu.updateScreen();
        } else if(cast(Fleet)this.menu.origin.world.getTileAt(target).element) {
            (cast(Fleet)this.menu.origin).embarked.addTo(cast(Fleet)this.menu.origin.world.getTileAt(target).element);
            (cast(Fleet)this.menu.origin).refreshEmbarked();
            this.menu.setNotification("Moved to another fleet");
            this.menu.updateScreen();
        } else {
            this.menu.setNotification("Needs to be on land or to another fleet");
        }
    }

}