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

    /**
     * Constructs a new notification panel in the given display
     */
    this(Display container) {
        super(container);
    }

    /**
     * Returns the location of the panel
     */
    override @property iRectangle location() {
        return this._location;
    }

    /**
     * Sets the notification to be a different notification
     * TODO:
     */
    @property void notification(string newNotification) {

    }

    /**
     * Draws the notification panel
     * TODO:
     */
    override void draw() {

    }

    /**
     * Handles events on the notification panel
     */
    void handleEvent(SDL_Event event) {

    }

}