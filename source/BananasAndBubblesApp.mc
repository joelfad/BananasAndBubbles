/*
Project: Bananas & Bubbles
File: BananasAndBubblesApp.mc
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

using Toybox.Application as App;

// Constants used throughout game
enum {empty, banana, bubble, bananaGray, bubbleGray}
enum {bananaTurn, bubbleTurn, bananaWin, bubbleWin, draw}

// Entry point for application
class BananasAndBubblesApp extends App.AppBase {
    var game;

    function initialize() {
        game = new BananasAndBubblesGame();
        AppBase.initialize();
    }

    //! onStart() is called on application start up
    function onStart() {
    }

    //! onStop() is called when the application is exiting
    function onStop() {
    }

    // Returns the initial view of the application
    function getInitialView() {
        return [ new BananasAndBubblesView(game), new BananasAndBubblesDelegate(game) ];
    }
}
