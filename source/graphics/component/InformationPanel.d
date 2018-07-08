module graphics.components.InformationPanel;

import d2d;
import graphics;
import logic;

import std.conv;

/**
 * The component which displays information about the
 * currently selected tile element
 */
class InformationPanel : Component {

    iRectangle _location; ///The location of the bar
    Texture panelTexture; ///The texture to be drawn
    Font renderingFont; ///The font used to render numbers and text for the display

    /**
     * Constructs a new information panel in the given container
     */
    this(Display container, iRectangle location) {
        super(container);
        this._location = location;
        this.panelTexture = new Texture(loadImage("res/Interface/informationpanel.png"), container.renderer);
        this.renderingFont = new Font("res/Font/Courier.ttf", 14);
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
     * Draws the panel to the screen
     */
    override void draw() {
        this.container.renderer.copy(this.panelTexture, this._location);
    }

    /**
     * Handles events
     */
    void handleEvent(SDL_Event event) {

    }

    /**
     * Updates the information displayed on the panel
     * of the given tile element
     * TODO: More information to be displayed
     */
    void updateTexture(Tile tile) {
        if(tile.element is null) {
            Surface base = loadImage("res/Interface/informationpanel.png");
            Surface titleLabel = this.renderingFont.renderTextSolid("Tile "~tile.location.toString());
            if(tile.owner !is null) {
                Surface ownerLabel = this.renderingFont.renderTextSolid("Owner: "~tile.owner.name);
                base.blit(ownerLabel, null, 6, 26);
            } 
            base.blit(titleLabel, null, 6, 8);
            this.panelTexture = new Texture(base, this.container.renderer);
        } else if(cast(City)tile.element) {
            City refCity = cast(City)tile.element;
            Surface base = loadImage("res/Interface/informationpanel.png");
            Surface titleLabel = this.renderingFont.renderTextSolid("City at "~refCity.location.toString());
            Surface ownerLabel = this.renderingFont.renderTextSolid("Owner: "~refCity.owner.name);
            base.blit(titleLabel, null, 6, 8);
            base.blit(ownerLabel, null, 6, 26);
            this.panelTexture = new Texture(base, this.container.renderer);
        } else {
            this.panelTexture = new Texture(loadImage("res/Interface/informationpanel.png"), this.container.renderer);
        }
    }

}