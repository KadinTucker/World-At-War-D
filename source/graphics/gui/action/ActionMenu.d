module graphics.gui.action.ActionMenu;

import d2d;
import graphics;
import logic;

/**
 * This class contains functions which yield preset action configurations 
 * that will be used by the player in the button menu of the game
 */
class ActionMenu {

        /**
         * Returns an empty button menu configuration
         */
        static Action[6] nullMenu(Display container, ButtonMenu menu) {
                return [null, null, null, null, null, null];
        }

        /**
         * The root actions available when a city is selected
         */
        static Action[6] cityMenu(Display container, ButtonMenu menu) {
                return [new DevelopAction(container, menu),
                new SettleAction(container, menu), 
                        null, 
                        null, 
                        null, 
                        null];
        }

}