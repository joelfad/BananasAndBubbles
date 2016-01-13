/*
Project: Bananas & Bubbles
File: BananasAndBubblesGrid.mc
Author: Joel McFadden
Created: January 9, 2016

Description:
    The game "Connect Four", written in Monkey C for Garmin wearable devices.

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

// Handles user input during game
class BananasAndBubblesDelegate extends Ui.BehaviorDelegate {
    var game;
    var confirmQuit;

    function initialize(game_) {
        game = game_;
        confirmQuit = Ui.loadResource(Rez.Strings.ConfirmQuit);
        BehaviorDelegate.initialize();
    }

    // Responds to menu, up, down, and enter keys
    function onKey(evt) {
        if (!game.isRunning()) {
            return false;
        }

        var key = evt.getKey();

        if (key == KEY_MENU || key == KEY_UP) {
            game.selectNext();
            Ui.requestUpdate();
        }
        else if (key == KEY_DOWN) {
            game.selectPrev();
            Ui.requestUpdate();
        }
        else if (evt.getKey() == KEY_ENTER) {
            if (game.drop()) {
                Ui.requestUpdate();
            }
        }
        return true;
    }

    // Responds to user selecting back
    function onBack() {
        if (!game.isRunning()) {
            System.exit();  // if game is over, skip confirmation dialog
        }

        // launch confirmation dialog
        var cd = new Ui.Confirmation(confirmQuit);
        Ui.pushView(cd, new ConfirmQuitDelegate(), Ui.SLIDE_IMMEDIATE);
        return true;
    }
}

// Handles confirmation dialog input
class ConfirmQuitDelegate extends Ui.ConfirmationDelegate {
    // Quits the application if user selects "yes"
    function onResponse(value) {
        if(value == Ui.CONFIRM_YES) {
            System.exit();
        }
    }
}
