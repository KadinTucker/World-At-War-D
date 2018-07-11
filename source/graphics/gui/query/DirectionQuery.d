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
        this.direction = Direction.NO_DIRECTION;
        Surface arrows = new Surface(150, 150, SDL_PIXELFORMAT_RGBA32);
        arrows.blit(loadImage("res/Interface/directionarrowright.png"), null, 100, 50);
        arrows.blit(loadImage("res/Interface/directionarrowup.png"), null, 50, 0);
        arrows.blit(loadImage("res/Interface/directionarrowdown.png"), null, 50, 100);
        arrows.blit(loadImage("res/Interface/directionarrowleft.png"), null, 0, 50);
        this.directionArrows = new Texture(arrows, this.container.renderer);
    }

    /**
     * Checks if the player has chosen a direction
     * Uses the arrow keys to determine direction
     * or the mouse
     */
    override void ask(SDL_Event event) {
        if(this.isFulfilled) {
            return; 
        }
        if(event.type == SDL_KEYDOWN) {
            if(event.key.keysym.sym == SDLK_w) {
                this.direction = Direction.NORTH;
            } else if(event.key.keysym.sym == SDLK_d) {
                this.direction = Direction.EAST;
            } else if(event.key.keysym.sym == SDLK_s) {
                this.direction = Direction.SOUTH;
            } else if(event.key.keysym.sym == SDLK_a) {
                this.direction = Direction.WEST;
            } else if(event.key.keysym.sym == SDLK_ESCAPE) {
                this.cancel();
            }
        } else if(event.type == SDL_MOUSEBUTTONDOWN) {
            if(event.button.button == SDL_BUTTON_LEFT) {
                if(Tile.getManhattanDistance((cast(GameActivity)this.container.activity).map.getHoveredTile, 
                        this.action.menu.origin.location) == 1) {
                    if((cast(GameActivity)this.container.activity).map.getHoveredTile.x > this.action.menu.origin.location.x) {
                        this.direction = Direction.EAST;
                    } else if((cast(GameActivity)this.container.activity).map.getHoveredTile.x < this.action.menu.origin.location.x) {
                        this.direction = Direction.WEST;
                    } else if((cast(GameActivity)this.container.activity).map.getHoveredTile.y > this.action.menu.origin.location.y) {
                        this.direction = Direction.SOUTH;
                    } else if((cast(GameActivity)this.container.activity).map.getHoveredTile.y < this.action.menu.origin.location.y) {
                        this.direction = Direction.NORTH;
                    }
                }
            } else if(event.button.button == SDL_BUTTON_RIGHT) {
                this.cancel();
            }
        }
        if(this.direction != Direction.NO_DIRECTION 
                && (cast(GameActivity)this.container.activity).map.world.getTileAt(
                Tile.moveDirection(this.action.menu.origin.location, this.direction)) !is null) {
            this.isFulfilled = true;
            this.performAction();
        } else {
            this.direction = Direction.NO_DIRECTION;
        }
    }

    /**
     * Indicates that the player should choose a location
     * by drawing arrows around the origin
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