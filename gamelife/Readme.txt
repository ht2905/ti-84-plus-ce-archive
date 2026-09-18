<=============================================================>

GAMELIFE
> First version
> 256 bytes on calc

program written by Zemmargorp
released the 2020/07/19 on ticalc.org


Description
===========

GAMELIFE is an assembly implementation of the Game of Life,
both lightweight and fast, for TI 83+/84+ CE calculators.
It simply runs Conway's Game of Life in full screen.
The initial configuration is generated randomly.


How to use
==========

Send "GAMEL1FE_1x" and "GAMELIFE_2x" to your calculator.

Run "Asm(prgmGAMEL1FE" for the 1-pixel-wide cells version.
Run "Asm(prgmGAMELIFE" for the 2-pixel-wide cells version.

The screen will briefly turn grey during the board generation.
The simulation will start shortly after.

Press [CLEAR] to exit.


Notes
=====

This is a port of my optimized (178 bytes!) "Game of Life"
implementation for TI 83+/84+ calculators, available here:
https://www.ticalc.org/archives/files/fileinfo/474/47411.html

The two CE versions wouldn't have been possible without the
amazing work of the "CE Programming" team: their emulator has
been an invaluable help in debugging, and I've reused their
"graphx" library to set the LCD in a 8bpp palette mode.

Further improvements are possible: it would probably be better
to set the LCD in a 1bpp (monochrome) mode, and to adjust its
refresh rate to fit the simulation speed, but I have no idea
how to do that! If you do, feel free to send me an email.


Acknowledgments
===============

- John Horton Conway (RIP) for the Game of Life
- the https://github.com/CE-Programming/ team for their
  awesome TI CE emulator, dev. toolchain and librairies!
- Axe Parser for its random number generator routine
- Sean McLaughlin for his very good z80 assembly
  tutorial "Learn TI-83 Plus Assembly In 28 Days"
- and thank you for your interest in this program :)


<=============================================================>