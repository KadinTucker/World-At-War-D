module graphics.gui.TextPanel;

import d2d;

/**
 * Creates an panel image with given text to fit to the panel's dimensions
 */
Surface createPanelWithText(Surface panelSurface, iRectangle panel, string text, int borderSize = 3, Color color = Color(0, 0, 0)) {
    int fontsize = cast(int)((panel.extent.x) / (text.length / 2));
    if(fontsize * 1.5 > panel.extent.y){
        fontsize = cast(int)(panel.extent.y * 0.67);
    }
    Font font = new Font("res/Font/Cantarell-Regular.ttf", fontsize);
    panelSurface.blit(font.renderTextSolid(text, color), null, borderSize, borderSize);
    return panelSurface;
}