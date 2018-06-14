module graphics.activity.GameActivity;

import d2d;

import graphics;
import logic;

immutable int numPlayers = 2; ///TODO: Make this a chosen option at start of game

/**
 * The main game activity
 * Contains the major elements of the game
 */
class GameActivity : Activity {

    World world; ///The world present in this game
    Query query; ///The currently active query
    TileElement selected; ///The currently selected object
    Player[] players; ///The players in the game
    Map map; ///The map component; for easy access
    ButtonMenu buttonMenu; ///The button menu for actions; for easy access
    NotificationPanel notifications; ///The notification panel for easy access

    /**
     * Constructs a new GameActivity
     * Generates a world with 6 continents that is 40x30
     * TODO: make world generation based on json configs
     */
    this(Display container) {
        super(container);
        //Generate world and players
        this.world = new World(6, 30, 40);
        foreach(i; 0..numPlayers) {
            this.players ~= new Player("TestPlayer", i);
        }
        //Initialize components
        this.map = new Map(container, new iRectangle(0, 16, 1100, 464), this.world);
        this.components ~= this.map;
        this.buttonMenu = new ButtonMenu(container, new iRectangle(0, 540, 690, 60));
        this.components ~= this.buttonMenu;
        this.buttonMenu.updateButtonTextures();
        this.components ~= new QueryIndicator(container, this);
        this.notifications = new NotificationPanel(container, new iRectangle(0, 480, 690, 60));
        this.components ~= this.notifications;
        this.components ~= new TopBar(container, new iRectangle(0, 0, 1100, 16));
    }

    /**
     * Sets the query to null if it is fulfilled
     */
    override void draw() {
        if(this.query !is null) {
            if(this.query.isFulfilled) {
                this.query = null;
            }
        }
    }

    /** 
     * Asks the contained query for input from the user
     */
    override void handleEvent(SDL_Event event) {
        if(this.query !is null) {
            this.query.ask(event);
        }
    }

    /**
     * Begins the game
     * Players settle their initial cities
     */
    void startGame() {
        Action initSettle = new InitialSettleAction(container, this.buttonMenu);
        TileElement tempElement = new TileElement(null, null, this.world);
        this.map.selectedElement = tempElement;
        initSettle.perform();
    }

}