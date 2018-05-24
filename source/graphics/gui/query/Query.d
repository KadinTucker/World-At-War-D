module graphics.gui.query.Query;

import d2d;

/**
 * A class which tries to take an input from the user
 * Template is that which the query will yield
 */
abstract class Query(T) {

    void delegate(T) action; ///The action performed once the query is fulfilled
    bool isFulfilled; ///Whether or not this query is fulfilled

    this(void delegate(T) action) {
        this.action = action;
    }

    /**
     * Tries to get input from the user
     */
    abstract void ask(SDL_Event event);

    /**
     * Indicates that the query is being made on the display
     */
    abstract void indicate(Display display);

}