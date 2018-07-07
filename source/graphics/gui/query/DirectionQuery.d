module graphics.gui.query.DirectionQuery;

import d2d;
import graphics;
import logic;

/**
 * A class which gets the location on the map where the user clicks
 * Stores the location where the player clicked
 */
class DirectionQuery : Query {

    Direction direction; ///The stored direction to pass on
    Texture directionArrows; ///The arrow texture indicating four directions

    /**
     * Constructs a new Query
     */
    this(Action action, Display container) {
        super(action, container);
        Surface arrows = new Surface(150, 150, SDL_PIXELFORMAT_RGBA32);
        arrows.blit(loadImage("res/Interface/directionarrowright"), null, 100, 50);
        arrows.blit(loadImage("res/Interface/directionarrowup"), null, 50, 0);
        arrows.blit(loadImage("res/Interface/directionarrowdown"), null, 50, 100);
        arrows.blit(loadImage("res/Interface/directionarrowrleft"), null, 0, 50);
        this.directionArrows = new Texture(arrows, this.container.renderer);
    }

    /**
     * Checks if the player has chosen a direction
     * Uses the arrow keys to determine direction
     * or the mouse
     * TODO:
     */
    override void ask(SDL_Event event) {
        
    }

    /**
     * Indicates that the player should choose a location
     * by drawing arrows around the origin
     * TODO:
     */
    override void indicate() {
        Map refMap = (cast(GameActivity)this.container.activity).map;
        this.container.renderer.copy(this.directionArrows,
                refMap.location.initialPoint.x + 50 * (this.action.menu.origin.location.x - 1) + refMap.pan.x,
                refMap.location.initialPoint.y + 50 * (this.action.menu.origin.location.y - 1) + refMap.pan.y);
    }

    /**
     * Does the stored action in the collected direction
     */
    override void performAction() {
        this.action.performAfterQuery(Tile.moveDirection(this.action.menu.origin.location, this.direction));
    }

}