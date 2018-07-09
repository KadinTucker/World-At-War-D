module graphics.gui.action.Attack;

import d2d;
import graphics;
import logic;

/**
 * An action which causes a unit to attack
 * Creates a submenu which lays out options to be produced
 */
class AttackAction : Action {

    /**
     * Constructs an attack action in the given container and menu
     */
    this(Display container, ButtonMenu menu) {
        super("Attack  ", container, menu);
    }

    /**
     * Sets a notification and sets the menu to be attack options
     */
    override void perform() {
        if(cast(Army)this.menu.origin) {
            this.menu.setNotification("Attack with what?");
            this.menu.configuration = ActionMenu.attackOptionsLandMenu;
        }
    }
    
}