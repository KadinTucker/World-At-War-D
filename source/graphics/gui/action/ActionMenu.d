module graphics.gui.action.ActionMenu;

import d2d;
import graphics;
import logic;

/**
 * This file contains functions which yield preset action configurations 
 * that will be used by the player in the button menu of the game
 */

/**
 * The root actions available when a city is selected
 */
 Action[6] menuCity(Display container, ButtonMenu menu) {
    return [new DevelopAction(container, menu),
            new SettleAction(container, menu), 
            null, 
            null, 
            null, 
            null];
 }