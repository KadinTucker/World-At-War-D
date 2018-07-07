module graphics.components.ButtonMenu;

import d2d;
import graphics;
import logic;

/**
 * A component which shows all of the buttons
 * Contains a button configuration
 * TODO:
 */
class ButtonMenu : Component {

    Action[6] _configuration; ///The configuration of actions currently used
    Texture[6] configTexture; ///The textures for each action button
    iRectangle _location; ///The location and dimensions of the menu

    /**
     * Constructs a new button menu in the given display
     */
    this(Display container, iRectangle location) {
        super(container);
        this._location = location;
        this.updateButtonTextures();
        ActionMenu.initializeMenuConfigurations(container, this);
    }

    /**
     * Returns the location of the button menu
     */
    override @property iRectangle location() {
        return this._location;
    }

    /**
     * Sets the location of the panel
     */
    @property void location(iRectangle newLocation) {
        this._location = newLocation;
    }

    /**
     * Returns the selected element on the map
     * For easy access by actions
     */
    @property TileElement origin() {
        return (cast(GameActivity)this.container.activity).map.selectedElement;
    }

    @property void configuration(Action[6] newConfig) {
        this._configuration = newConfig;
        this.updateButtonTextures();
    }

    @property Action[6] configuration() {
        return this._configuration;
    }

    /**
     * Handles events
     * TODO:
     */
    void handleEvent(SDL_Event event) {
        if(event.type == SDL_MOUSEBUTTONDOWN) {
            if(event.button.button == SDL_BUTTON_LEFT) {
                if(this._location.contains(this.container.mouse.location) && 
                        this.configuration[this.container.mouse.location.x / 115] !is null) {
                    this.configuration[this.container.mouse.location.x / 115].perform();
                }
            }
        }
    }
    
    /**
     * Draws the button menu to the screen
     */
    override void draw() {
        for(int i; i < 6; i++) {
            this.container.renderer.copy(this.configTexture[i], this._location.initialPoint.x + i * 115,
                    this._location.initialPoint.y);
        }
    }

    /**
     * Updates the button textures based on the currently stored actions
     * Occurs whenever actions are modified
     */
    void updateButtonTextures() {
        for(int i; i < 6; i++) {
            if(this.configuration[i] is null) {
                this.configTexture[i] = new Texture(loadImage("res/Interface/base.png"), this.container.renderer);
            } else {
            this.configTexture[i] = new Texture(TextPanel.createPanelWithText(loadImage("res/Interface/base.png"), new iRectangle(0, 0, 115, 60), 
                    this.configuration[i].name), this.container.renderer);
            }
        }
    }

    /**
     * Sets the notification bar to display the given message
     * For easy access from actions
     */
    void setNotification(string notification) {
        (cast(GameActivity)this.container.activity).notifications.notification = notification;
    }

    /**
     * Updates the container's components
     * For easy access from actions
     */
    void updateScreen() {
        (cast(GameActivity)this.container.activity).updateComponents();
    }
    
}