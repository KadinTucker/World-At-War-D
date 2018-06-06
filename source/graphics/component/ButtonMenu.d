module graphics.components.ButtonMenu;

import d2d;
import graphics.gui.query.Query;
import graphics.gui.action;

/**
 * A component which shows all of the buttons
 * Contains a button configuration
 * TODO:
 */
class ButtonMenu : Component {

    Action[6] configuration; ///The configuration of actions currently used
    Texture blankButton; ///The texture to draw when there is no button
    iRectangle _location; ///The location and dimensions of the menu

    /**
     * Constructs a new button menu in the given display
     */
    this(Display container, iRectangle location) {
        super(container);
        this._location = location;
        this.blankButton = new Texture(loadImage("res/Button/base.png"), container.renderer);
    }

    /**
     * Returns the location of the button menu
     */
    override @property iRectangle location() {
        return this._location;
    }

    /**
     * Handles events
     * TODO:
     */
    void handleEvent(SDL_Event event) {

    }
    
    /**
     * Draws the button menu to the screen
     */
    override void draw() {
        for(int i; i < 6; i++) {
            if(this.configuration[i] is null) {
                this.container.renderer.copy(this.blankButton, this._location.initialPoint.x + i * 115,
                        this._location.initialPoint.y);
            }
        }
    }
        
}