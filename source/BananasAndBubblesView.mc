/*
Project: Bananas & Bubbles
File: BananasAndBubblesView.mc
Author: Joel McFadden
Created: January 9, 2016

Description:
    A remake of Connect Four written in Monkey C for Garmin wearable devices.

Copyright (C) 2016 Joel McFadden

Usage Agreement:
    This file is part of Bananas & Bubbles.
    Bananas & Bubbles is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    Bananas & Bubbles is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with Bananas & Bubbles.  If not, see <http://www.gnu.org/licenses/>.
*/

using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

// Main game view
class BananasAndBubblesView extends Ui.View {
    hidden var game;
    hidden var item;   // dictionary of item images
    hidden var bars;   // dictionary of side bars
    hidden var text;   // dictionary of strings
    hidden var color;  // dictionary of colors

    function initialize(game_) {
        View.initialize();
        game = game_;
    }

    // Load resources
    function onLayout(dc) {
        setLayout(Rez.Layouts.GridLayout(dc));

        item = {banana => Ui.loadResource(Rez.Drawables.Banana),
                bubble => Ui.loadResource(Rez.Drawables.Bubble),
                bananaGray => Ui.loadResource(Rez.Drawables.BananaGray),
                bubbleGray => Ui.loadResource(Rez.Drawables.BubbleGray)};
                
        bars = {empty => new Rez.Drawables.GameOverBars(),
                banana => new Rez.Drawables.BananaBars(),
                bubble => new Rez.Drawables.BubbleBars()};
                
        text = {bananaWin => Ui.loadResource(Rez.Strings.BananaWin),
                bubbleWin => Ui.loadResource(Rez.Strings.BubbleWin),
                draw => Ui.loadResource(Rez.Strings.Draw)};
        
        color = {bananaWin => Gfx.COLOR_YELLOW,
                 bubbleWin => Gfx.COLOR_BLUE,
                 draw => Gfx.COLOR_WHITE};
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        // call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        
        // draw game
        drawSelectionArea(dc);
        drawGridItems(dc);
    }
    
    // Draws the selection area located above the grid
    hidden function drawSelectionArea(dc) {
        var turn = game.getTurn();
        // if game is running, draw next item to be dropped
        if (turn != empty) {
            dc.drawBitmap(game.selectedColOffset(), 0, item[turn]);
        }
        // otherwise, draw message corresponding to game state
        else {
            dc.setColor(color[game.getState()], Gfx.COLOR_TRANSPARENT);
            dc.drawText(game.CENTER, 0, Gfx.FONT_SMALL, text[game.getState()], Gfx.TEXT_JUSTIFY_CENTER);
        }
        // draw side bars
        bars[turn].draw(dc);
    }
    
    // Populates the grid with game items
    hidden function drawGridItems(dc) {
        var grid = game.getGrid();
        // for each column
        for (var j = 0; j < game.NUM_COLS; j += 1) {
            // for each row
            for (var i = 0; i < game.NUM_ROWS; i += 1) {
                var square = grid.getSquare(i, j);
                if (square != empty) {
                    dc.drawBitmap(game.colOffset(j), game.rowOffset(i), item[square]);
                }
                else {
                    i = game.NUM_ROWS; // skip to next column
                }
            }
        } 
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }
}
