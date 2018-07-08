module graphics.components.TopBar;

import d2d;
import graphics;
import logic;

import std.conv;

/**
 * The component which displays information at the top of the screen
 * Shows the territory amount, amount of resources, and also handles
 * access to the menu
 * TODO: Add more information to be displayed:
 * - Turn number
 * - Active player
 * - Resource Income
 */
class TopBar : Component {

    iRectangle _location; ///The location of the bar
    Texture barTexture; ///The texture to be drawn
    Font renderingFont; ///The font used to render numbers for the display

    /**
     * Constructs a new top bar in the given container
     */
    this(Display container, iRectangle location) {
        super(container);
        this._location = location;
        this.barTexture = new Texture(loadImage("res/Interface/topbar.png"), container.renderer);
        this.renderingFont = new Font("res/Font/Courier.ttf", 14);
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
     */
    override void draw() {
        this.container.renderer.copy(this.barTexture, this._location);
    }

    /**
     * Handles events
     */
    void handleEvent(SDL_Event event) {

    }

    /**
     * Updates the information displayed on the bar
     * of the given player
     * TODO: Add more information to be displayed
     */
    void updateTexture(Player activePlayer) {
        if(activePlayer is null) {
            this.barTexture = new Texture(loadImage("res/Interface/topbar.png"), this.container.renderer);
            return;
        }
        Surface barBase = loadImage("res/Interface/topbar.png");
        Surface resource = loadImage("res/Interface/resourceLabel.png");
        resource.blit(this.renderingFont.renderTextSolid(activePlayer.resources.to!string, Color(60, 180, 60)), null, 70, 2);
        Surface territory = loadImage("res/Interface/territoryLabel.png");
        territory.blit(this.renderingFont.renderTextSolid(activePlayer.territory.to!string, Color(60, 180, 60)), null, 55, 2);
        barBase.blit(resource, null, 10, 0);
        barBase.blit(territory, null, 130, 0);
        this.barTexture = new Texture(barBase, this.container.renderer);
    }

}