module graphics.components.EndTurnButton;

import d2d;
import graphics;
import logic;

class EndTurnButton : Component {

    iRectangle _location; ///The location of the button
    Texture button; ///The button texture to be used

    /**
     * Constructs a new end turn button at the given location
     */
    this(Display container, iRectangle location) {
        super(container);
        this._location = location;
        this.button = new Texture(loadImage("res/Interface/endturn.png"), container.renderer);
    }

    /**
     * Returns the location of the component
     */
    override @property iRectangle location() {
        return this._location;
    }

    /**
     * Sets the location of the component
     */
    @property void location(iRectangle newLocation) {
        this._location = newLocation;
    }

    /**
     * Draws the button to the screen
     */
    override void draw() {
        this.container.renderer.copy(this.button, this._location);
    }

    /**
     * Handles events
     * When clicked, ends the turn
     */
    void handleEvent(SDL_Event event) {
        if(event.type == SDL_MOUSEBUTTONDOWN) {
            if(event.button.button == SDL_BUTTON_LEFT) {
                if(this._location.contains(this.container.mouse.location)) {
                    (cast(GameActivity)this.container.activity).endTurn();
                }
            }
        }
    }

}