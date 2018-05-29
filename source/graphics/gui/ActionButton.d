module graphics.gui.ActionButton;

import d2d;

/**
 * A class which denotes an action button
 */
class ActionButton {

    Texture texture; ///The texture denoting this button
    string name; ///The name of this action
    void delegate(Display container) action; ///The action this button performs

    this(Texture texture, string name, void delegate(Display) action) {
        this.texture = texture;
        this.name = name;
        this.action = action;
    }

}