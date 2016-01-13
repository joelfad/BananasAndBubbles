/*
Project: Bananas & Bubbles
File: BananasAndBubblesGame.mc
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

// Game state and player actions
class BananasAndBubblesGame {
    // Constants
    const NUM_ROWS = 6;
    const NUM_COLS = 9;
    const V_OFFSET = 21;        // vertical offset for first row (px)
    const H_OFFSET = 8;         // horizontal offset for first column (px)
    const CENTER = 102;         // center of display (px)
    const SQUARE_SIZE = 20;     // dimensions of each square (px)

    hidden var state;           // for state machine
    hidden var grid;            // array to keep track of player moves
    hidden var selectedCol;     // which column is currently selected
    hidden var running;         // true if game is not over
    hidden var lastDrop;        // coordinates of last dropped item

    function initialize() {
        grid = new BananasAndBubblesGrid(NUM_ROWS, NUM_COLS);
        running = true;         // start game
        state = bananaTurn;     // bananas go first
        selectedCol = NUM_COLS / 2;
    }

    // Calculates the upper y-coordinate of given row
    function rowOffset(row) {
        return V_OFFSET + (NUM_ROWS - 1 - row) * 21;
    }

    // Calculates the leftmost x-coordiate of given column
    function colOffset(col) {
        return H_OFFSET + col * 21;
    }

    // Calculates the leftmost x-coordinate of currently selected column
    function selectedColOffset() {
        return colOffset(selectedCol);
    }

    // Selects next valid column to drop item in (right)
    function selectNext() {
        var nextCol = (selectedCol + 1) % NUM_COLS;
        while (grid.isColFull(nextCol)) {
            nextCol = (nextCol + 1) % NUM_COLS;
        }
        selectedCol = nextCol;
    }

    // Selects previous valid column to drop item in (left)
    function selectPrev() {
        var prevCol = (selectedCol - 1 + NUM_COLS) % NUM_COLS;
        while (grid.isColFull(prevCol)) {
            prevCol = (prevCol - 1 + NUM_COLS) % NUM_COLS;
        }
        selectedCol = prevCol;
    }

    // Drops item in selected column
    // @return true if successful, false otherwise
    function drop() {
        if (grid.isColFull(selectedCol)) {
            return false;
        }
        var row = 0;
        while (grid.getSquare(row, selectedCol) != empty) {
            row += 1;
        }
        grid.setSquare(row, selectedCol, getTurn());
        lastDrop = [row, selectedCol];
        switchTurn();
        return true;
    }

    // Maps state to item
    // @return item corresponding to current state
    function getTurn() {
        if (state == bananaTurn) {
            return banana;
        }
        else if (state == bubbleTurn) {
            return bubble;
        }
        return empty;
    }

    // Switch state after turn
    function switchTurn() {
        var result = grid.checkAll(lastDrop);
        if (result == banana) {
            running = false;
            state = bananaWin;
        }
        else if (result == bubble) {
            running = false;
            state = bubbleWin;
        }
        else if (grid.isFull()) {
            running = false;
            state = draw;
        }
        else if (state == bananaTurn) {
            state = bubbleTurn;
        }
        else if (state == bubbleTurn) {
            state = bananaTurn;
        }

        if (!running) {
            grid.desaturate(lastDrop, (state != draw));
        }
    }

    // Getters

    function getGrid() {
        return grid;
    }

    function getState() {
        return state;
    }

    function isRunning() {
        return running;
    }
}
