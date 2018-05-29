module graphics.components.PanelText;

import d2d;

/**
 * A button consisting of an image
 * Has no default action; must be manually accessed
 */
class TextButton : Button {

    Texture image; ///The image of the button to display

    /**
     * Creates a new text button
     */
    this(Display container, iRectangle location, Surface image) {
        super(container, location);
        this.image = new Texture(image, this.container.renderer);
    }

    override void action() {

    }

    override void draw() {
        this.container.renderer.copy(this.image, this.location);
    }

}

/**
 * Creates an panel image with given text to fit to the panel's dimensions
 */
Surface createPanelWithText(Surface panelSurface, iRectangle panel, string text, int borderSize = 3, Color color = Color(0, 0, 0)) {
    int fontsize = cast(int)((panel.extent.x) / (text.length / 2));
    if(fontsize * 1.5 > panel.extent.y){
        fontsize = cast(int)(panel.extent.y * 0.67);
    }
    Font font = new Font("res/Cantarell-Regular.ttf", fontsize);
    panelSurface.blit(font.renderTextSolid(text, color), null, borderSize, borderSize);
    return panelSurface;
}

/**
 * Does two in one; creates a text button using the createPanelWithText function
 */
Button createTextButton(Display display, string baseFilename, iRectangle location, string text, int borderSize = 3, Color color = Color(0, 0, 0)){
    return new TextButton(display, location, createPanelWithText(loadImage(baseFilename), location, text, borderSize, color));
}