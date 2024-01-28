# potime
A simple bash CLI task timer that helps keep you focused, on task, and on time.
Your time logs are saved to plaintext timeclock.el file for processing with hledger and can optionally be pushed to google calendar.

This tool is designed to work along with other plaintext cli productivity tools.


## Installation

Tested on:
- Linux (Ubuntu 22.04.3 LTS with i3wm)


*MACOS COMPATIBILITY IS BROKEN ON MAIN*

The `macos` branch contains last working version for mac.
- MacOS (Intel, MacOS 13.2 Ventura)

Basically the `date` command on macos cannot do the calculations that we are using for gcalcli and retroactive features..


```
# First ensure ~/bin/ exists and add ~/bin/ to your PATH if necessary..

git clone https://github.com/poism/potime.git
ln -s $(pwd)/potime/potime ~/bin/potime

```

## Optional Dependencies

This tool can function without any of the following, but they certainly make it better.

*ffmpeg* or *pplay* - for linux sound playback

*hledger* - plaintext accounting and timekeeping
[hledger](https://hledger.org/) is used to display timelog output.
If you do not have hledger, you will be given the option to download it within this directory during usage.

*gcalcli* - plaintext google calendar
[gcalcli](https://github.com/insanum/gcalcli) is used to add items to google calendar.
Gcalcli requires Google API keys scoped to Google Calendar so that setup can be complicated and totally unnecessary.

If you do wish to use `gcalcli`, your events will be added to the default calendar of gcalcli or you can specify via env var.
For instance if you make a Google Calendar named "TimeClocker", simply add `export GCALENDARNAME="TimeClocker"` to your `~/.bash_rc` file.
All future shells in which you run this app will add events to your TimeClocker calendar.



## Usage

1. Run the script with how many minutes you wish to devote to whichever account, and optional task description.
2. It displays a progress bar timer and at completion displays a system notification and plays your music or a bell.
3. Press CTRL+c to stop the music and end the timer.
4. It will allow you to extend the timer if you wish to continue working on the same task.
5. You will be given a chance to provide additional comments or tags"
6. If you have [gcalcli](https://github.com/insanum/gcalcli) installed, you will be asked if you wish to add the event to your google calendar.
7. It writes to your `~/$USER.timeclock` file.


*Special Characters*
Avoid using special characters for descriptions and comments, they will be removed.
For accounts use colon `:` to define account hierarchies. Do not use spaces in account names.


## Viewing data

For convenience you can use this script as a wrapper for hledger.
It simply passes all args to hledger using the same timeclock file as is configured for time tracking.
Basically `potime view bal -D` becomes a shortcut for `hledger -f ~/username.timeclock bal -D`




```
potime --help
         USAGE:  potime [minutes] [account:optionalsubaccount] [optional description]
      EXAMPLES:  potime 25 POISM:DEV potime app
    VIEW_USAGE:  potime view [any hledger args]
 VIEW_EXAMPLES:  potime view balance --daily
   ENVIRONMENT:  export TIMECLOCKFILE=~/yourusername.timeclock; export GCALENDARNAME="UNSPECIFIED"
CURRENT CONFIG:
                 TIMECLOCKFILE: /home/sangpo/sangpo.timeclock
                 TIMECLOCKSOUND: /datapool/projects/POISM/repos/potime/alarm.ogg
                 GCALENDARNAME: UNSPECIFIED
```

## Usage Examples


### One example with outputs:

Adding a 1 minute timer on task...

```
sangpo@ubu-po:~$ potime 1 POISM:dev potimer
______________________________________________________________ 
 
FILE: /home/sangpo/sangpo.timeclock
TIME: 1 minutes, starting at 10:02:21 AM 
TASK: POISM:dev  potimer 
[########################################] 100% (1:0)
 
Press CTRL+c to stop timer 
 
 
DONE: 1 minutes for POISM:dev!^C 
 
______________________________________________________________ 
 
TASK: POISM:dev  potimer 
TIMER: 1 minutes 7 seconds (originally 1 minutes). 
______________________________________________________________ 
 
Do you wish to extend the current task timer?
Enter additional integer minutes to extend, or anything else to exit.
-->
Enter any additional alphanumeric comments or press Enter
-->update readme
______________________________________________________________ 
 
CLOCKED TASK: POISM:dev  potimer (0h1m7s) ; update readme 
CLOCKED TIME: 1 minutes 7 seconds (originally 1 minutes) 
______________________________________________________________ 
 
i 2024/01/28 10:02:20 POISM:dev  potimer (0h1m7s) ; update readme 
o 2024/01/28 10:03:27
______________________________________________________________ 
 
Add to TimeClockPo google calendar?
Confirm? [y/n] y 
OK: Added to google calendar TimeClockPo 
______________________________________________________________ 
 
BALANCE for this POISM:dev account:
 8.16h  POISM:dev
-------------------- 
 8.16h 
______________________________________________________________ 


```

### Example adding a retroactive task:

Forgot to start the timer? No problem, when you finish just use a negative time to retroactively add a task.


```
sangpo@ubu-po:~$ potime -60 POISM:dev potimer
RETROACTIVE: Adding an event that just ended.
______________________________________________________________ 
 
TASK: POISM:dev potimer 
TIMER: 60 minutes 0 seconds.
______________________________________________________________ 
 
Enter any additional alphanumeric comments or press Enter
-->retroactive and view mode
______________________________________________________________

CLOCKED TASK: POISM:dev  potimer (1h0m0s) ; retroactive and view mode
CLOCKED TIME: 60 minutes 0 seconds (originally  minutes)
______________________________________________________________

i 2024/01/28 08:53:27 POISM:dev  potimer (1h0m0s) ; retroactive and view mode
o 2024/01/28 09:53:27
______________________________________________________________

Add to TimeClockPo google calendar?
Confirm? [y/n] y
OK: Added to google calendar TimeClockPo
______________________________________________________________

BALANCE for this POISM:dev account:
               8.14h  POISM:dev
--------------------
               8.14h
______________________________________________________________


```


### More examples output ommitted

```

potime 90 POISM:dev 'potime app ; make a bash app as an act of pocrastination, tag:dev,docs,potime'

potime 30 PERS:lunch 

potime 15 POISM:dev 'potime app ; wrote readme and upload to github, tag:dev,docs,potime'

```

## Analyzing your timeclock examples

```
#Note the full command is: hledger -f ~/sangpo.timeclock bal -W
$ potime view bal -W
Balance changes in 2024-01-15W03:

            || 2024-01-15W03 
============++===============
 PERS:lunch ||         0.50h 
 POISM:adm  ||         0.75h 
 POISM:dev  ||         1.75h 
------------++---------------
            ||         3.00h 

```

```
$ potime view print -W
2024-01-21 * get fustrated using google calendar
    (POISM:adm)           0.75h

2024-01-21 * potime app ; make a bash app as an act of pocrastination, tag:dev,docs,potime
    (POISM:dev)           1.50h

2024-01-21 * 14:31-15:01
    (PERS:lunch)           0.50h

2024-01-21 * potime app ; wrote readme and upload to github, tag:dev,docs,potime
    (POISM:dev)           0.25h

```

```
$ potime view bal -p 2024/1
               0.50h  PERS:lunch
               0.75h  POISM:adm
               1.75h  POISM:dev
--------------------
               3.00h

```

```
$ potime view bal -p 2024/1 --depth 1
               0.50h  PERS
               2.50h  POISM
--------------------
               3.00h

```

```
$ potime view bal -D POISM
Balance changes in 2024-01-21..2024-01-22:

           || 2024-01-21  2024-01-22 
===========++========================
 POISM:adm ||      0.77h           0 
 POISM:dev ||      1.77h       0.37h 
-----------++------------------------
           ||      2.54h       0.37h 
```

```
$ potime view bal -D --depth 1
Balance changes in 2024-01-21..2024-01-22:

       || 2024-01-21  2024-01-22 
=======++========================
 PERS  ||      0.50h       1.41h 
 POISM ||      2.54h       0.37h 
-------++------------------------
       ||      3.04h       1.78h 
```

## Custom alarm and audio caveats

You can add an `alarm.mp3` file and it will automatically be used if possible.

On Linux, `paplay` is assumed to not support mp3 in which case we fall back to the `alarm.ogg`, but if you have`ffplay` (hopefully included with `ffmpeg`) then the mp3 will be used.

On MacOS `afplay` does not support `.ogg` so we use a default bell sound, played once and then repeated for however many minutes of overage. If an mp3 is found that will be played instead.



## Further reading

- [hledger time budgets](https://hledger.org/time-planning.html#how-to-set-up-a-time-budget)
- [hledger for processing timeclock files](https://hledger.org/1.32/hledger.html#timeclock)

## Author
Sangpo Dorje
