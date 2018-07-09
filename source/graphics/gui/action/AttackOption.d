module graphics.gui.action.AttackOption;

import d2d;
import graphics;
import logic;

/**
 * An action which causes an army to attack
 */
class AttackOption : Action {

    int[] indices; //The index of the unit to be attacking
    int range; ///The range of the attack

    /**
     * Constructs a new action with the given name
     * given container and action's origin location
     */
    this(Display container, ButtonMenu menu, string name, int[] indices, int range) {
        super(name, container, menu);
        this.indices = indices;
        this.range = range;
    }

    /**
     * Causes an attack to be made
     */
    override void perform() {
        if(cast(Army)this.menu.origin) {
            this.setQuery(new RangeLocationQuery(this, this.container, this.range));
            this.menu.setNotification("Choose a target to attack");
        }
    }

    /**
     * If the location obtained from the query is valid,
     * attack it
     */
    override void performAfterQuery(Coordinate target, string str="") {
        if(this.menu.origin.world.getTileAt(target).element !is null) {
            foreach(index; this.indices) {
                (cast(Unit)this.menu.origin).attack(this.menu.origin.world.getTileAt(target).element, index);
            }
            this.menu.updateScreen();
            this.menu.updateInformation();
            if(this.menu.origin.world.getTileAt(target).element is null) {
                this.menu.setNotification("Destroyed enemy unit");
            }
            this.menu.setNotification("Damaged enemy unit");
            if(cast(Army)this.menu.origin) {
                this.menu.configuration = ActionMenu.armyMenu;
            }
        } else {
            this.menu.setNotification("There is no target there");
            this.perform();
        }
    }

}