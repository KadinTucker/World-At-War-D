module graphics.gui.action.Attack;

import d2d;
import graphics;
import logic;

/**
 * An action which causes an army to attack
 */
class AttackAction : Action {

    /**
     * Constructs a new action with the given name
     * given container and action's origin location
     */
    this(Display container, ButtonMenu menu) {
        super("Attack  ", container, menu);
    }

    /**
     * Causes an attack to be made
     */
    override void perform() {
        if(cast(Army)this.menu.origin) {
            this.setQuery(new RangeLocationQuery(this, this.container, 9));
            this.menu.setNotification("Choose a target to attack");
        }
    }

    /**
     * If the location obtained from the query is valid,
     * attack it
     * TODO:
     */
    override void performAfterQuery(Coordinate target, string str="") {
        
    }

}