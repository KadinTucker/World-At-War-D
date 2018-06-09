module graphics.activity.GameActivity;

import d2d;

import graphics;
import logic;

/**
 * The main game activity
 * Contains the major elements of the game
 */
class GameActivity : Activity {

    World world; ///The world present in this game
    Query query; ///The currently active query
    TileElement selected; ///The currently selected object
    Player[] players; ///The players in the game
    Map map; ///The map component; for easy access
    ButtonMenu buttonMenu; ///The button menu for actions; for easy access

    /**
     * Constructs a new GameActivity
     * Generates a world with 6 continents that is 40x30
     * TODO: make world generation based on json configs
     */
    this(Display container) {
        super(container);
        this.world = new World(6, 30, 40);
        this.map = new Map(container, new iRectangle(0, 0, 1100, 540), this.world);
        this.components ~= this.map;
        this.buttonMenu = new ButtonMenu(container, new iRectangle(0, 540, 690, 60));
        this.components ~= this.buttonMenu;
        this.buttonMenu.configuration[0] = new SettleAction(container, this.buttonMenu);
        this.buttonMenu.updateButtonTextures();
    }

    override void draw() {
        if(this.query !is null) {
            this.query.indicate();
        }
    }

}