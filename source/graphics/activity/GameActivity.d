module graphics.activity.GameActivity;

import d2d;

import logic.world.World;

/**
 * The main game activity
 * TODO: basically everything
 */
class GameActivity : Activity {

    World world; ///The world present in this game

    /**
     * Constructs a new GameActivity
     * Generates a world with 6 continents that is 40x30
     * TODO: make world generation based on json configs
     */
    this(Display container) {
        super(container);
        this.world = new World(6, 30, 40);
    }

    override void draw() {

    }

}