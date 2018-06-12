module graphics.components.NotificationPanel;

import d2d;
import graphics;
import logic;

/**
 * A component which displays various notifications to the user
 */
class NotificationPanel : Component {

    iRectangle _location; ///The location of the panel
    string _notification; ///The notification to display on the panel
    Texture drawTexture; ///The texture to draw for the panel

    /**
     * Constructs a new notification panel in the given display
     */
    this(Display container, iRectangle location) {
        super(container);
        this.drawTexture = new Texture(loadImage("res/Interface/notificationpanel.png"), container.renderer);
        this._location = location;
    }

    /**
     * Returns the location of the panel
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
     * Sets the notification to be a different notification
     * TODO:
     */
    @property void notification(string newNotification) {
        this._notification = newNotification;
        if(newNotification.length > 0) {
            this.drawTexture = new Texture(createPanelWithText(loadImage("res/Interface/notificationpanel.png"), this._location, 
                    newNotification, 4, Color(25, 150, 25)), this.container.renderer);
        } else {
            this.drawTexture = new Texture(loadImage("res/Interface/notificationpanel.png"), container.renderer);
        }
    }

    /**
     * Returns the notification
     */
    @property string notification() {
        return this._notification;
    }

    /**
     * Draws the notification panel
     */
    override void draw() {
        this.container.renderer.copy(this.drawTexture, this._location);
    }

    /**
     * Handles events on the notification panel
     */
    void handleEvent(SDL_Event event) {

    }

}