module graphics.activity.MenuActivity;

import d2d;
import graphics;
import logic;

/**
 * The main menu activity
 */
class MenuActivity : Activity {

    Texture drawTexture; ///The temporary draw texture
    GameActivity newActivity; ///The game activity to use to make the game

    /**
     * Initializes the menu
     */
    this(Display container) {
        super(container);
        this.generateDrawTexture();
    }

    private void generateDrawTexture() {
        Surface background = loadImage("res/Interface/background.png");
        Font font = new Font("res/Font/Courier.ttf", 55);
        Font font2 = new Font("res/Font/Courier.ttf", 16);
        Font font3 = new Font("res/Font/Courier.ttf", 21);
        background.blit(loadImage("res/Interface/informationpanel.png"), null, this.container.window.size.x / 2 - 205, 50);
        background.blit(font.renderTextSolid("World at War", Color(75, 75, 75)), null, this.container.window.size.x / 2 - 200, 90);
        background.blit(loadImage("res/Interface/base.png"), null, this.container.window.size.x / 2 - 57, 230);
        background.blit(font2.renderTextSolid("Random Map", Color(30, 30, 30)), null, this.container.window.size.x / 2 - 50, 250);
        background.blit(loadImage("res/Interface/base.png"), null, this.container.window.size.x / 2 - 57, 350);
        background.blit(font3.renderTextSolid("Scenario", Color(30, 30, 30)), null, this.container.window.size.x / 2 - 50, 370);
        this.drawTexture = new Texture(background, this.container.renderer);
    }

    /**
     * Draws the menu to the screen
     */
    override void draw() {
        this.container.renderer.copy(this.drawTexture, 0, 0);
        if(this.newActivity !is null) {
            this.container.activity = this.newActivity;
            this.newActivity.startGame();
        }
    }

    /**
     * If the user clicks a button, create a game activity and start the game
     */ 
    override void handleEvent(SDL_Event event) {
        if(event.type == SDL_MOUSEBUTTONDOWN) {
            if(this.container.mouse.location.x > this.container.window.size.x / 2 - 57 
                    && this.container.mouse.location.x < this.container.window.size.x / 2 + 57) {
                if(this.container.mouse.location.y > 230 && this.container.mouse.location.y < 290) {
                    this.newActivity = new GameActivity(this.container, new World(6, 30, 40));
                } else if(this.container.mouse.location.y > 350 && this.container.mouse.location.y < 410) {
                    this.newActivity = new GameActivity(this.container, new World("res/Scenario/eastasia.json"));
                }
            }
        }
        if(event.type == SDL_WINDOWEVENT) {
            if(event.window.event == SDL_WINDOWEVENT_RESIZED) {
                this.generateDrawTexture();
            }
        }
    }

}