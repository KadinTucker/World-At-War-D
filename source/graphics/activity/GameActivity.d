module graphics.activity.GameActivity;

import d2d;

import graphics;
import logic;

import std.conv;

immutable int numPlayers = 12; ///TODO: Make this a chosen option at start of game

/**
 * The main game activity
 * Contains the major elements of the game
 */
class GameActivity : Activity {

    World world; ///The world present in this game
    Query query; ///The currently active query
    TileElement selected; ///The currently selected object
    Player[] players; ///The players in the game
    int activePlayerIndex; ///The index of the active player
    Map map; ///The map component; for easy access
    ButtonMenu buttonMenu; ///The button menu for actions; for easy access
    TopBar topBar; ///the bar at the top which displays global player statistics
    NotificationPanel notifications; ///The notification panel for easy access
    InformationPanel info; ///The information panel for easy access

    /**
     * Constructs a new GameActivity
     * Generates a world with 6 continents that is 40x30
     * TODO: make world generation based on json configs
     */
    this(Display container) {
        super(container);
        //Generate world and players
        this.world = new World(6, 30, 40);
        for(int i = 0; i < numPlayers; i++) {
            this.players ~= new Player("Player "~i.to!string, i);
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
        this.topBar = new TopBar(container, new iRectangle(0, 0, 1100, 16));
        this.components ~= this.topBar;
        this.info = new InformationPanel(container, new iRectangle(690, 480, 410, 120));
        this.components ~= this.info;
        this.components ~= new EndTurnButton(container, new iRectangle(1010, 570, 90, 30));
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
     * Updates each of the components of the activity
     */
    void updateComponents() {
        this.map.updateTexture();
        this.topBar.updateTexture(this.players[this.activePlayerIndex]);
    }

    /**
     * Updates the information panel component
     */
    void updateInformation() {
        this.info.updateTexture(this.world.getTileAt(this.map.getHoveredTile()));
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

    /**
     * Ends the turn and resolves resource income and city repair
     */
    void endTurn() {
        foreach(city; this.players[this.activePlayerIndex].cities) {
            city.isActive = true;
        } 
        foreach(military; this.players[this.activePlayerIndex].military) {
            military.isActive = true;
            military.resolveTurn();
        }
        this.players[this.activePlayerIndex].resolveTurnEnd();
        this.activePlayerIndex += 1;
        this.activePlayerIndex %= this.players.length;
        this.map.selectedElement = null; //TODO: make selected element, if owned by now active player, have proper menu
        this.updateComponents();
        this.notifications.notification = "Player "~this.players[this.activePlayerIndex].name~", take your turn";
    }

}