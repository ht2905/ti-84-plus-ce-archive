What is this program?
This is a very simple program written in C that estimates your battery status.

You can easily send the program to your calculator using TiLP or TI-connect CE.
Once you've sent it to your calculator there are two possible options to run the program:
-If the OS of your calculator is 5.5 or higher, then you should run the program via Cesium, or use asmhook.
-If the OS of your calculator is 5.4 or below, you can just run the program via the [prgm] menu.

How do I use this program?
Once you've run the program, you'll see an estimation of the current battery level.
To quit the program, just press [clear].

How does the program estimate the battery status?
The program makes use of a CCall, that returns the current battery level as a number from 0 till 4.
This number stands for the battery level of your calculator.
The options are:
-you've less than 5% left.
-you've between 5% and 25% left.
-you've between 25% and 50% left.
-you've between 50% and 75% left.
-you've more than 75% left.

If you find any bugs, feel free to contact me via: privacy_dragon@tutanota.com
