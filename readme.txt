readme.txt

Game: Whack-A-Mole
Author: Daniel Takyi
File: 352LabProject.s
Microcontroller: STM32F100RB Discovery + associated designed carrier board


1. This project simulates a whack-a-mole game in which the LEDs on the discovery board carrier 
are the moles and the pushbuttons on the discovery board carrier are what you use to whack the 
moles.


2. The game is played by first pressing the reset button to boot the program up. After that 
pressing any of the pushbuttons will start the normal game mode. After a brief wait period, a random
LED will flash. Pushing the corresponding button will light up all the LEDS on the carrier for a 
moment. After this moment another random LED will flash. If you keep pushing the corresponding button 
you will reach 16 stages and win the game. A celebratory signal will then be displayed for a couple 
of seconds before returning to the WaitingToPlay state. If the wrong button is pushed or no button 
is pushed for a certain amount of time, the player loses the game and the score received is flashed 
in binary for a couple of seconds before returning to the WaitingToPlay state. As the player racks 
up more points, the time they have to react gets shorter and shorter.


3. One problem I had was getting a random number to show. I tried to use a PRNG that used modulus to 
get somewhat random results. However the randomness was not really random. I then tried to change the certain
components of the PRNG equation based on the time they took to hit a pushbutton, but then the code broke, and 
I had to spend alot of time fixing it. However I now think that I know what needs to be done in order to get 
somewhat random results without breaking the code. I just don't have the time to do it.


4. a)PrelimWait can be adjusted by changing the value of R5 right before the PrelimWait tag

   b)ReactTime can be adjusted by changing the value of R5 after the PrelimWait loop

   c)NumCycles can be changed by changing the comparison value R11 is being compared to. This line is right 
     after the loop tag

   d)WinningSignalTime and LosingSignalTime can be changed in UC4 and UC5 respectively