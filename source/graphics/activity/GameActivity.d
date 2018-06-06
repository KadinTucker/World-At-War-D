module graphics.activity.GameActivity;

import d2d;

import graphics;
import logic;

/**
 * The main game activity
 */
class GameActivity : Activity {

    World world; ///The world present in this game
    Query query; ///The currently active query
    TileElement selected; ///The currently selected object

    /**
     * Constructs a new GameActivity
     * Generates a world with 6 continents that is 40x30
     * TODO: make world generation based on json configs
     */
    this(Display container) {
        super(container);
        this.world = new World(6, 30, 40);
        this.components ~= new Map(container, new iRectangle(0, 0, 1100, 540), this.world);
        this.components ~= new ButtonMenu(container, new iRectangle(0, 540, 690, 60));
    }

    override void draw() {
        if(this.query !is null) {
            this.query.indicate();
        }
    }

}