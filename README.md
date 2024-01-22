# potime
A simple bash CLI timer that logs tasks to a timeclock file.


# Installation

```
# First ensure ~/bin/ exists and add ~/bin/ to your PATH if necessary..

git clone https://github.com/poism/potime.git
ln -s $(pwd)/potime/potime ~/bin/potime

```

# Usage examples

```
potime 45 POISM:adm 'get frustrated using google calendar'

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
