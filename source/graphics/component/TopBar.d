module graphics.components.TopBar;

import d2d;
import graphics;
import logic;

/**
 * The component which displays information at the top of the screen
 * Shows the territory amount, amount of resources, and also handles
 * access to the menu
 */
class TopBar : Component {

    iRectangle _location; ///The location of the bar
    Texture barBase; ///The base of the bar
    Texture resourceBox; ///The box which displays resources
    Texture territoryBox; ///The box which displays territory

    /**
     * Constructs a new top bar in the given container
     */
    this(Display container, iRectangle location) {
        super(container);
        this._location = location;
        this.barBase = new Texture(loadImage("res/Interface/topbar.png"), container.renderer);
    }

    /**
     * Returns the location of the component
     */
    override @property iRectangle location() {
        return this._location;
    }

    /**
     * Sets the location of the top bar
     */
    @property void location(iRectangle newLocation) {
        this._location = newLocation;
    }

    /**
     * Draws the top bar to the screen
     * TODO:
     */
    override void draw() {
        this.container.renderer.copy(this.barBase, this._location);
    }

    /**
     * Handles events
     */
    void handleEvent(SDL_Event event) {

    }

    /**
     * Updates the information displayed on the bar
     * of the given player
     * TODO:
     */
    void updateBoxes(Player activePlayer) {

    }

}