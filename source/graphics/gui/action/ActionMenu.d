module graphics.gui.action.ActionMenu;

import d2d;
import graphics;
import logic;

immutable int tankCost = 40;
immutable int artilleryCost = 30;

immutable int battleshipCost = 60;
immutable int destroyerCost = 50;
immutable int submarineCost = 50;
immutable int carrierCost = 70;

/**
 * This class contains functions which yield preset action configurations 
 * that will be used by the player in the button menu of the game
 */
class ActionMenu {

    static Action[6] nullMenu; ///An empty configuration
    static Action[6] cityMenu; ///The configuration active when a city is selected
    static Action[6] produceOptionsLandMenu; ///The configuration active when a city is producing units 
    static Action[6] produceOptionsWaterMenu; ///The configuration active when a city is producing units 
    static Action[6] mobilizeMenu; ///The configuration for when choosing what to mobilize
    static Action[6] armyMenu; ///The menu active when there is an army selected
    static Action[6] attackLandMenu; ///The menu for choosing an army's attack
    static Action[6] fleetMenu; ///The menu active when there is a fleet selected
    static Action[6] attackWaterMenu; ///The menu for choosing a fleet's attack
    static Action[6] cityDisabledMenu; ///The menu when a city is disabled 

    /**
     * Initializes every menu configuration for the game
     * TODO: Make property methods for some configurations
     */
    static void initializeMenuConfigurations(Display container, ButtonMenu menu) {
        this.nullMenu = [null, null, null, null, null, null];
        this.mobilizeMenu = [
            new MobilizeAction(container, menu, "Army ", 0),
            new MobilizeAction(container, menu, "Fleet", 1),
            null,
            null,
            null,
            new SwitchMenuAction(container, menu, "Cancel  ", "", this.cityMenu)
        ];
        this.cityMenu = [
            new SwitchMenuAction(container, menu, "Mobilize", "Mobilize army or fleet?", this.mobilizeMenu), 
            new BuildAction(container, menu),
            new DevelopAction(container, menu),
            new ProduceAction(container, menu), 
            null,
            null
        ];
        this.cityDisabledMenu = [
            new SwitchMenuAction(container, menu, "Mobilize", "Mobilize army or fleet?", this.mobilizeMenu), 
            new BuildAction(container, menu),
            null,
            null, 
            null,
            null
        ];
        this.produceOptionsLandMenu = [
            new ProduceInfantryAction(container, menu),
            new ProduceOption(container, menu, "Tank", tankCost, &ProduceOption.produceTank),
            new ProduceOption(container, menu, "Artillery", artilleryCost, &ProduceOption.produceArtillery),
            null,
            new SwitchMenuAction(container, menu, "Water   ", "Choose a unit to produce", this.produceOptionsWaterMenu),
            new SwitchMenuAction(container, menu, "Cancel  ", "", this.cityMenu)
        ];
        this.produceOptionsWaterMenu = [
            new ProduceOption(container, menu, "Battleship", battleshipCost, &ProduceOption.produceBattleship),
            new ProduceOption(container, menu, "Destroyer", destroyerCost, &ProduceOption.produceDestroyer),
            new ProduceOption(container, menu, "Submarine", submarineCost, &ProduceOption.produceSubmarine),
            new ProduceOption(container, menu, "Aircraft Carrier", carrierCost, &ProduceOption.produceCarrier),
            new SwitchMenuAction(container, menu, "Land    ", "Choose a unit to produce", this.produceOptionsLandMenu),
            new SwitchMenuAction(container, menu, "Cancel  ", "", this.cityMenu)
        ];
        (cast(SwitchMenuAction)this.produceOptionsLandMenu[4]).toSwitchTo = this.produceOptionsWaterMenu;
        this.attackLandMenu = [
            new AttackAction(container, menu, "Front Line", 0, 1),
            new AttackAction(container, menu, "Artillery", 1, 3),
            null,
            null,
            null,
            new SwitchMenuAction(container, menu, "Cancel  ", "", this.armyMenu)
        ];
        this.armyMenu = [
            new MoveAction(container, menu),
            new SwitchMenuAction(container, menu, "Attack  ", "Attack with what?", this.attackLandMenu),
            null,
            null,
            null,
            null
        ];
        (cast(SwitchMenuAction)this.attackLandMenu[5]).toSwitchTo = this.armyMenu;
        this.attackWaterMenu = [
            new AttackAction(container, menu, "Battleship", 0, 3),
            new AttackAction(container, menu, "Destroyer", 1, 2),
            new AttackAction(container, menu, "Submarine", 2, 2),
            null,
            null,
            new SwitchMenuAction(container, menu, "Cancel  ", "", this.fleetMenu)
        ];
        this.fleetMenu = [
            new MoveAction(container, menu),
            new SwitchMenuAction(container, menu, "Attack  ", "Attack with what?", this.attackWaterMenu),
            new DisembarkAction(container, menu),
            null,
            null,
            null
        ];
        (cast(SwitchMenuAction)this.attackWaterMenu[5]).toSwitchTo = this.fleetMenu;
    }

}