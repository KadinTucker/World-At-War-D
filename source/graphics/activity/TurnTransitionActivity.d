module graphics.activity.TurnTransitionActivity;

import d2d;
import graphics;
import logic;

class TurnTransitionActivity : Activity {

    GameActivity game; ///The game whose turn this screen is transitioning
    Texture drawTexture; ///The texture to draw to the screen

    /**
     * Initializes a new turn transition screen
     * that transitions the turn of the given game
     */
    this(Display container, GameActivity game) {
        super(container);
        this.game = game;
        Font drawFont = new Font("res/Font/Courier.ttf", 20);
        this.drawTexture = new Texture(drawFont.renderTextSolid("Player "~game.players[game.activePlayerIndex].name~", take your turn",
                Color(255, 255, 255)), container.renderer);
    }

    /**
     * Draws the draw texture to the screen
     */
    override void draw() {
        this.container.renderer.copy(this.drawTexture, this.container.window.size.x / 2 - 100, 250);
    }

    /**
     * If the user clicks the mouse, set the container activity 
     * to be the game activity stored
     */
    override void handleEvent(SDL_Event event) {
        if(event.type == SDL_MOUSEBUTTONDOWN) {
            if(this.container.mouse.location.y < this.container.window.size.y - 100) {
                this.container.activity = this.game;
                this.game.map.updateTexture();
            }
        }
    }

}