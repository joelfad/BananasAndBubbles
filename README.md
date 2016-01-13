# Bananas & Bubbles

Bananas & Bubbles is the game "Connect Four", written in [Monkey C](http://developer.garmin.com/connect-iq/monkey-c/) for Garmin wearable devices.

<img src="/resources/screenshot.png" width="640" alt="Screenshot">

## Dependencies
The [Connect IQ](http://developer.garmin.com/connect-iq/overview/) SDK must be installed in order to compile and run Bananas & Bubbles.
* Download [Connect IQ SDK 1.2.2](http://developer.garmin.com/connect-iq/sdk/)

## Building & Running
Read the [Getting Started](http://developer.garmin.com/connect-iq/programmers-guide/getting-started/) guide to learn how to build and run Monkey C apps. The guide also explains how to install an Eclipse plugin which provides syntax highlighting and integrated execution in the Connect IQ simulator. The easiest way to build and run Bananas & Bubbles is to import the project into Eclipse.

Alternatively, to skip building, simply open a command prompt in the SDK bin directory and run:<br>
&gt; connectiq<br>
&gt; monkeydo &lt;path to BananasAndBubbles.prg&gt;

## Notes
Bananas & Bubbles has only been tested on virtual devices. There is no guarantee that it will run on a physical device but you are welcome to try AT YOUR OWN RISK. The game does not have AI or wireless communication at this time.
