module graphics.gui.query.NumericQuery;

import d2d;
import graphics;

import std.algorithm;

//A list of all of the key codes that are accepted as numeric input
immutable numericKeyCodes = [
    SDLK_0, SDLK_1, SDLK_2, SDLK_3, SDLK_4, SDLK_5, SDLK_6, SDLK_7, SDLK_8, SDLK_9, 
    SDLK_KP_0, SDLK_KP_1, SDLK_KP_2, SDLK_KP_3, SDLK_KP_4, SDLK_KP_5, SDLK_KP_6, 
    SDLK_KP_7, SDLK_KP_8, SDLK_KP_9 
];

/**
 * A class which gets input from the user's keyboard
 * Can be numbers or a long string
 */
class NumericQuery : Query {

    string[] currentText; ///The text currently inputted
    Texture textLabel; ///The texture to be displayed on the screen
    Font renderingFont; ///The font used to render everything

    /**
     * Constructs a new Query
     */
    this(Action action, Display container) {
        super(action, container);
        this.renderingFont = new Font("res/Font/Courier.ttf", 14);
        this.setTextLabel();
    }

    /**
     * Initializes the texture to be drawn to the screen
     */
    private void setTextLabel() {
        Surface base = loadImage("res/Interface/inputpanel.png");
        if(this.currentText.length > 0) {
            base.blit(this.renderingFont.renderTextSolid(this.unifyStringArray(), Color(25, 150, 25)), null, 3, 3);
        }
        this.textLabel = new Texture(base, this.container.renderer);
    }

    /**
     * Turns the keycode from the given event 
     * into a string
     */
    string keycodeToString(SDL_Event event) {
        if(event.key.keysym.sym == SDLK_0 || event.key.keysym.sym == SDLK_KP_0) {
            return "0";
        } else if(event.key.keysym.sym == SDLK_1 || event.key.keysym.sym == SDLK_KP_1) {
            return "1";
        } else if(event.key.keysym.sym == SDLK_2 || event.key.keysym.sym == SDLK_KP_2) {
            return "2";
        } else if(event.key.keysym.sym == SDLK_3 || event.key.keysym.sym == SDLK_KP_3) {
            return "3";
        } else if(event.key.keysym.sym == SDLK_4 || event.key.keysym.sym == SDLK_KP_4) {
            return "4";
        } else if(event.key.keysym.sym == SDLK_5 || event.key.keysym.sym == SDLK_KP_5) {
            return "5";
        } else if(event.key.keysym.sym == SDLK_6 || event.key.keysym.sym == SDLK_KP_6) {
            return "6";
        } else if(event.key.keysym.sym == SDLK_7 || event.key.keysym.sym == SDLK_KP_7) {
            return "7";
        } else if(event.key.keysym.sym == SDLK_8 || event.key.keysym.sym == SDLK_KP_8) {
            return "8";
        } else if(event.key.keysym.sym == SDLK_9 || event.key.keysym.sym == SDLK_KP_9) {
            return "9";
        } else if(event.key.keysym.sym == SDLK_BACKSPACE) {
            if(this.currentText.length > 0) {
                import std.algorithm.mutation;
                this.currentText = this.currentText.remove(this.currentText.length - 1);
            }
            return "";
        } else if(event.key.keysym.sym == SDLK_RETURN) {
            this.isFulfilled = true;
            this.performAction();
        } else if(event.key.keysym.sym == SDLK_ESCAPE) {
            this.cancel();
        }
        return "";
    }

    /**
     * Combines the elements of the string array
     * into one single string
     */
    private string unifyStringArray() {
        string unifiedString = "";
        foreach(str; this.currentText) {
            unifiedString = unifiedString~str;
        }
        return unifiedString;
    }

    /**
     * Checks for keyboard inputs
     * checks for keyboard events and adds the appropriate
     * text to the current text. If the return key is pressed,
     * the query is satisfied
     */
    override void ask(SDL_Event event) {
        if(event.type == SDL_KEYDOWN) {
            string charTyped = this.keycodeToString(event);
            if(charTyped != "") {
                this.currentText ~= this.keycodeToString(event);
            }
            this.setTextLabel();
        } else if(event.type == SDL_KEYDOWN) {
            if(event.button.button == SDL_BUTTON_RIGHT) {
                this.cancel();
            }
        }
    }

    /**
     * Displays the text box and the text the player
     * is typing
     * TODO:
     */
    override void indicate() {
        this.container.renderer.copy(this.textLabel, 500, 240);
    }

    /**
     * Does the stored action with the collected string
     */
    override void performAction() {
        this.action.performAfterQuery(null, this.unifyStringArray());
    }

}