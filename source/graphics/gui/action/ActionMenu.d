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
    static Action[6] produceOptionsLandMenu; ///The configuration active when a city is producing units 
    static Action[6] armyMenu; ///The menu active when there is an army selected
    static Action[6] attackOptionsLandMenu; ///The menu for choosing an army's attack

    /**
     * Initializes every menu configuration for the game
     */
    static void initializeMenuConfigurations(Display container, ButtonMenu menu) {
        this.nullMenu = [null, null, null, null, null, null];
        this.cityMenu = [
            new DevelopAction(container, menu),
            new SettleAction(container, menu), 
            new ProduceAction(container, menu), 
            new MobilizeAction(container, menu), 
            null, 
            null
        ];
        this.produceOptionsLandMenu = [
            new ProduceInfantryAction(container, menu),
            new ProduceOption(container, menu, "Tank", 20, &ProduceOption.produceTank),
            new ProduceOption(container, menu, "Artillery", 15, &ProduceOption.produceArtillery),
            null,
            null,
            new CancelAction(container, menu, this.cityMenu)
        ];
        this.armyMenu = [
            new MoveAction(container, menu),
            new AttackAction(container, menu),
            null,
            null,
            null,
            null
        ];
        this.attackOptionsLandMenu = [
            new AttackOption(container, menu, "Front Line", [0, 1], 1),
            new AttackOption(container, menu, "Artillery", [2], 3),
            null,
            null,
            null,
            new CancelAction(container, menu, this.armyMenu)
        ];
    }

}