module graphics.activity.MenuActivity;

import d2d;
import graphics;
import logic;

/**
 * The main menu activity
 */
class MenuActivity : Activity {

    Texture drawTexture; ///The temporary draw texture

    /**
     * Initializes the menu
     */
    this(Display container) {
        super(container);
        Font font = new Font("res/Font/Cantarell-Regular.ttf", 15);
        Surface background = loadImage("res/Interface/background.png");
        background.blit(font.renderTextSolid("click anywhere to begin the game", Color(255, 255, 255)), null, 500, 500);
        this.drawTexture = new Texture(background, this.container.renderer);
    }

    /**
     * Draws the menu to the screen
     * Temporary; currently just shows some text
     */
    override void draw() {
        this.container.renderer.copy(this.drawTexture, 0, 0);
    }

    /**
     * If the user clicks, create a game activity and start the game
     */ 
    override void handleEvent(SDL_Event event) {
        if(event.type == SDL_MOUSEBUTTONDOWN) {
            GameActivity newActivity = new GameActivity(this.container);
            this.container.activity = newActivity;
            newActivity.startGame();
        }
    }

}