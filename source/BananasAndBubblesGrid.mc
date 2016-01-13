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

// Stores game pieces and detects winning combinations
class BananasAndBubblesGrid {
    hidden var numRows;
    hidden var numCols;
    hidden var gridArray;  // gridArray[0][0] is lower-left corner of visible grid

    // Set up an empty grid
    // @param rows number of rows in grid
    // @param cols number of columns in grid
    function initialize(rows, cols) {
        numRows = rows;
        numCols = cols;
        gridArray = new [numRows];                  // create rows
        for (var i = 0; i < numRows; i += 1) {
            gridArray[i] = new [numCols];           // create squares for each row
            for (var j = 0; j < numCols; j += 1) {
                gridArray[i][j] = empty;            // set each square to empty
            }
        }
    }

    // Gets the value of chosen grid square
    // @return contents of square: banana, bubble, or empty
    function getSquare(row, col) {
        return gridArray[row][col];
    }

    // Sets the value of chosen grid square
    // @param val new value of square: banana, bubble, or empty
    function setSquare(row, col, val) {
        gridArray[row][col] = val;
    }

    // Check if column is full
    // @param col column to check
    // @return true if full, false otherwise
    function isColFull(col) {
        for (var i = 0; i < numRows; i += 1) {
            if (gridArray[i][col] == empty) {
                return false;   // at least one square is empty
            }
        }
        return true;            // all squares in column are occupied
    }

    // Check if entire grid is full
    // @return true if full, false otherwise
    function isFull() {
        for (var j = 0; j < numCols; j += 1) {
            if (!isColFull(j)) {
                return false;   // at least one column is not full
            }
        }
        return true;            // all columns are full
    }

    // Check a row for four adjacent bananas or bubbles
    // @param row row to check
    // @param col column of most recently dropped item
    // @param type type of most recently dropped item
    // @param color colors any adjacent items if true (usually false)
    // @return true if at least four adjacent items are found, false otherwise
    hidden function checkRow(row, col, type, color) {
        var count = 1;  // number of adjacent items found

        // check left of drop
        for (var c = col - 1; c >= 0; c -= 1) {
            var t = gridArray[row][c];
            if (t == empty || t % 2 != type % 2) { // %2 for grayscale
                c = -1; // break
            }
            else {
                count += 1;
                if (color) {
                    gridArray[row][c] = type; // recolor
                }
            }
        }

        // check right of drop
        for (var c = col + 1; c < numCols; c += 1) {
            var t = gridArray[row][c];
            if (t == empty || t % 2 != type % 2) { // %2 for grayscale
                c = numCols; // break
            }
            else {
                count += 1;
                if (color) {
                    gridArray[row][c] = type; // recolor
                }
            }
        }

        // color adjacent items
        if (count < 4) {
            return false;
        }
        else if (!color) {
            checkRow(row, col, type, true);
        }

        return true;
    }

    // Check a column for four adjacent bananas or bubbles
    // @param row row of most recently dropped item
    // @param col column to check
    // @param type type of most recently dropped item
    // @param color colors any adjacent items if true (usually false)
    // @return true if at least four adjacent items are found, false otherwise
    hidden function checkCol(row, col, type, color) {
        if (row < 3) {
            return false;
        }
        for (var i = 1; i < 4; i += 1) {
            if (gridArray[row - i][col] % 2 != type % 2) { // %2 for grayscale
                return false;
            }
            else if (color) {
                gridArray[row - i][col] = type; // recolor
            }
        }

        // color adjacent items
        if (!color) {
            checkCol(row, col, type, true);
        }

        return true;
    }

    // Check an ascending diagonal for four adjacent bananas or bubbles
    // @param row row of most recently dropped item
    // @param col column of most recently dropped item
    // @param type type of most recently dropped item
    // @param color colors any adjacent items if true (usually false)
    // @return true if at least four adjacent items are found, false otherwise
    hidden function checkAscending(row, col, type, color) {
        var count = 1;  // number of adjacent items found

        // check lower-left of drop
        var r = row - 1;
        for (var c = col - 1; c >= 0 && r >= 0; c -= 1) {
            var t = gridArray[r][c];
            if (t == empty || t % 2 != type % 2) { // %2 for grayscale
                c = -1; // break
            }
            else {
                count += 1;
                if (color) {
                    gridArray[r][c] = type; // recolor
                }
            }
            r -= 1;
        }

        // check above-right of drop
        r = row + 1;
        for (var c = col + 1; c < numCols && r < numRows; c += 1) {
            var t = gridArray[r][c];
            if (t == empty || t % 2 != type % 2) { // %2 for grayscale
                c = numCols; // break
            }
            else {
                count += 1;
                if (color) {
                    gridArray[r][c] = type; // recolor
                }
            }
            r += 1;
        }

        // color adjacent items
        if (count < 4) {
            return false;
        }
        else if (!color) {
            checkAscending(row, col, type, true);
        }

        return true;
    }

    // Check a descending diagonal for four adjacent bananas or bubbles
    // @param row row of most recently dropped item
    // @param col column of most recently dropped item
    // @param type type of most recently dropped item
    // @param color colors any adjacent items if true (usually false)
    // @return true if at least four adjacent items are found, false otherwise
    hidden function checkDescending(row, col, type, color) {
        var count = 1;  // number of adjacent items found

        // check above-left of drop
        var r = row + 1;
        for (var c = col - 1; c >= 0 && r < numRows; c -= 1) {
            var t = gridArray[r][c];
            if (t == empty || t % 2 != type % 2) { // %2 for grayscale
                c = -1; // break
            }
            else {
                count += 1;
                if (color) {
                    gridArray[r][c] = type; // recolor
                }
            }
            r += 1;
        }

        // check lower-right of drop
        r = row - 1;
        for (var c = col + 1; c < numCols && r >= 0; c += 1) {
            var t = gridArray[r][c];
            if (t == empty || t % 2 != type % 2) { // %2 for grayscale
                c = numCols; // break
            }
            else {
                count += 1;
                if (color) {
                    gridArray[r][c] = type; // recolor
                }
            }
            r -= 1;
        }

        // color adjacent items
        if (count < 4) {
            return false;
        }
        else if (!color) {
            checkDescending(row, col, type, true);
        }

        return true;
    }

    // Check entire grid for four adjacent bananas or bubbles
    // @param lastDrop coordinates of most recently dropped item
    // @return type of item found or empty if not found
    function checkAll(lastDrop) {
        var row = lastDrop[0];
        var col = lastDrop[1];
        var type = gridArray[row][col];
        var found = false;

        // check row
        if (checkRow(row, col, type, false)) {
            found = true;
        }

        // check column
        if (checkCol(row, col, type, false)) {
            found = true;
        }

        // check ascending diagonal
        if (checkAscending(row, col, type, false)) {
            found = true;
        }

        // check descending diagonal
        if (checkDescending(row, col, type, false)) {
            found = true;
        }

        return found ? type : empty;
    }

    // Desaturate all items held in grid except for four adjacent
    // @param lastDrop coordinates of most recently dropped item
    // @param color if true, colors matching items adjacent to last dropped
    function desaturate(lastDrop, color) {
	    for (var j = 0; j < numCols; j += 1) {
	        for (var i = 0; i < numRows; i += 1) {
	            if (gridArray[i][j] != empty) {
	                gridArray[i][j] += 2;
	            }
	        }
	    }
	    // color adjacent items
        if (color) {
	       gridArray[lastDrop[0]][lastDrop[1]] -= 2;
	       checkAll(lastDrop);
	    }
    }
}
