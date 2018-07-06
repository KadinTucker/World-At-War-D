module graphics.gui.action.ActionMenu;

import d2d;
import graphics;
import logic;

/**
 * This class contains functions which yield preset action configurations 
 * that will be used by the player in the button menu of the game
 */
class ActionMenu {

    static Action[6] nullMenu; ///An empty configuration
    static Action[6] cityMenu; ///The configuration active when a city is selected

    /**
     * Initializes every menu configuration for the game
     */
    static void initializeMenuConfigurations(Display container, ButtonMenu menu) {
        this.nullMenu = [null, null, null, null, null, null];
        this.cityMenu = [
                new DevelopAction(container, menu),
                new SettleAction(container, menu), 
                null, 
                null, 
                null, 
                null
            ];
    }

}