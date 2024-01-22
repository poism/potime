# potime
A simple bash CLI task timer that notifies, plays sounds and logs tasks to a timeclock file for processing with tools such as hledger.


## Installation

```
# First ensure ~/bin/ exists and add ~/bin/ to your PATH if necessary..

git clone https://github.com/poism/potime.git
ln -s $(pwd)/potime/potime ~/bin/potime

```

## Usage

1. Call the script with how many minutes you wish to spend on whichever account.  You can also specify optional optional description, comments and tags initially or after the timer stops.
2. It displays a progress bar timer and at completion displays a notification and plays music.
3. Press CTRL+c to stop the music and end the timer.
4. It will allow you to extend the timer if you wish to continue working on the same task.
5. You will be given a last chance to provide description, comments or tags if you didn't previously.
6. It writes to your ~/potime.timeclock file.


```
potime --help


         USAGE:  potime [minutes] [account:optionalsubaccount] '[optional description ; comments, tag:tag1,tag2]'
      EXAMPLES:  potime 25 POISM:DEV 'timeclocker ; added help messages, tags:dev,poism,timeclocker'
   ENVIRONMENT:  export TIMECLOCKFILE=~/timeclocker.timeclock
CURRENT CONFIG:
                 TIMECLOCKFILE: /home/sangpo/potime.timeclock
                 TIMECLOCKSOUND: /datapool/projects/POISM/repos/potime/alarm.ogg
```

## Usage Examples


### One example with outputs:
```

potime 45 POISM:adm 'get frustrated using google calendar'
______________________________________________________________

FILE: /home/sangpo/potime.timeclock
TIME: 45 minutes, starting at 12:00:00 PM
TASK: POISM:adm  get frustrated using google calendar
[########################################] 100% (1:0)^C

FINISHED: POISM:adm duration was 45 minutes and 0 seconds.

Do you wish to extend the current task timer? Enter additional integer minutes to extend, or [0/n/nothing] to end timer.
--> n


______________________________________________________________

i 2024/01/21 12:00:00 POISM:adm  get frustrated using google calendar
o 2024/01/21 12:45:00
______________________________________________________________

Balance for this POISM:adm account:

               0.75h  POISM:adm
--------------------
               0.75h

```

### More examples output ommitted

```

potime 90 POISM:dev 'potimer app ; make a bash app as an act of pocrastination, tag:dev,docs,potimer'

potime 30 PERS:lunch 

potime 15 POISM:dev 'potimer app ; wrote readme and upload to github, tag:dev,docs,potimer'

```

## Analyzing your timeclock examples

```
$ hledger -f ~/potime.timeclock bal -W
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
$ hledger -f ~/potime.timeclock print -W
2024-01-21 * get fustrated using google calendar
    (POISM:adm)           0.75h

2024-01-21 * potimer app ; make a bash app as an act of pocrastination, tag:dev,docs,potimer
    (POISM:dev)           1.50h

2024-01-21 * 14:31-15:01
    (PERS:lunch)           0.50h

2024-01-21 * potimer app ; wrote readme and upload to github, tag:dev,docs,potimer
    (POISM:dev)           0.25h

```

```
$ hledger -f ~/potime.timeclock bal -p 2024/1
               0.50h  PERS:lunch
               0.75h  POISM:adm
               1.75h  POISM:dev
--------------------
               3.00h

```

```
$ hledger -f ~/potime.timeclock bal -p 2024/1 --depth 1
               0.50h  PERS
               2.50h  POISM
--------------------
               3.00h

```

```
$ hledger -f ~/potime.timeclock register -p 2024/1 --depth 2 
2024-01-21 get fustrated using google calendar                                              (POISM:adm)    0.75h    0.75h
2024-01-21 potimer app ; make a bash app as an act of pocrastination, tag:dev,docs,potimer  (POISM:dev)    1.50h    2.25h
2024-01-21 14:31-15:01                                                                      (PERS:lunch)   0.50h    2.75h
2024-01-21 potimer app ; wrote readme and upload to github, tag:dev,docs,potimer            (POISM:dev)    0.25h    3.00h

```






# Requirements

 - `ffmpeg` or `pplay`
 - `hledger` (optional)


# Further reading

- [hledger time budgets](https://hledger.org/time-planning.html#how-to-set-up-a-time-budget)
- [hledger for processing timeclock files](https://hledger.org/1.32/hledger.html#timeclock)

# Author
Sangpo Dorje
