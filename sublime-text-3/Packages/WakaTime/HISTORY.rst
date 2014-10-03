
History
-------


2.0.12 (2014-09-30)
++++++++++++++++++

- upgrade external wakatime package to v2.1.1
- fix bug where binary file opened as utf-8


2.0.11 (2014-09-30)
++++++++++++++++++

- upgrade external wakatime package to v2.1.0
- python3 compatibility changes


2.0.10 (2014-08-29)
++++++++++++++++++

- upgrade external wakatime package to v2.0.8
- supress output from svn command


2.0.9 (2014-08-27)
++++++++++++++++++

- upgrade external wakatime package to v2.0.7
- fix support for subversion projects on Mac OS X


2.0.8 (2014-08-07)
++++++++++++++++++

- upgrade external wakatime package to v2.0.6
- fix unicode bug by encoding json POST data


2.0.7 (2014-07-25)
++++++++++++++++++

- upgrade external wakatime package to v2.0.5
- option in .wakatime.cfg to obfuscate file names


2.0.6 (2014-07-25)
++++++++++++++++++

- upgrade external wakatime package to v2.0.4
- use unique logger namespace to prevent collisions in shared plugin environments


2.0.5 (2014-06-18)
++++++++++++++++++

- upgrade external wakatime package to v2.0.3
- use project name from sublime-project file when no revision control project found


2.0.4 (2014-06-09)
++++++++++++++++++

- upgrade external wakatime package to v2.0.2
- disable offline logging when Python not compiled with sqlite3 module


2.0.3 (2014-05-26)
++++++++++++++++++

- upgrade external wakatime package to v2.0.1
- fix bug in queue preventing completed tasks from being purged


2.0.2 (2014-05-26)
++++++++++++++++++

- disable syncing offline time until bug fixed


2.0.1 (2014-05-25)
++++++++++++++++++

- upgrade external wakatime package to v2.0.0
- offline time logging using sqlite3 to queue editor events


1.6.5 (2014-03-05)
++++++++++++++++++

- upgrade external wakatime package to v1.0.1
- use new domain wakatime.com


1.6.4 (2014-02-05)
++++++++++++++++++

- upgrade external wakatime package to v1.0.0
- support for mercurial revision control


1.6.3 (2014-01-15)
++++++++++++++++++

- upgrade common wakatime package to v0.5.3


1.6.2 (2014-01-14)
++++++++++++++++++

- upgrade common wakatime package to v0.5.2


1.6.1 (2013-12-13)
++++++++++++++++++

- upgrade common wakatime package to v0.5.1
- second line in .wakatime-project now sets branch name


1.6.0 (2013-12-13)
++++++++++++++++++

- upgrade common wakatime package to v0.5.0


1.5.2 (2013-12-03)
++++++++++++++++++

- use non-localized datetime in log


1.5.1 (2013-12-02)
++++++++++++++++++

- decode file names with filesystem encoding, then encode as utf-8 for logging


1.5.0 (2013-11-28)
++++++++++++++++++

- increase "ping" frequency from every 5 minutes to every 2 minutes
- prevent sending multiple api requests when saving the same file


1.4.12 (2013-11-21)
+++++++++++++++++++

- handle UnicodeDecodeError exceptions when json encoding log messages


1.4.11 (2013-11-13)
+++++++++++++++++++

- placing .wakatime-project file in a folder will read the project's name from that file


1.4.10 (2013-10-31)
++++++++++++++++++

- recognize jinja2 file extensions as HTML


1.4.9 (2013-10-28)
++++++++++++++++++

- handle case where ignore patterns not defined


1.4.8 (2013-10-27)
++++++++++++++++++

- new setting to ignore files that match a regular expression pattern


1.4.7 (2013-10-26)
++++++++++++++++++

- simplify some language lexer names into more common versions


1.4.6 (2013-10-25)
++++++++++++++++++

- force some file extensions to be recognized as certain language


1.4.5 (2013-10-14)
++++++++++++++++++

- remove support for subversion projects on Windows to prevent cmd window popups
- ignore all errors from pygments library


1.4.4 (2013-10-13)
++++++++++++++++++

- read git branch from .git/HEAD without running command line git client


1.4.3 (2013-09-30)
++++++++++++++++++

- send olson timezone string to api for displaying logged time in user's zone


1.4.2 (2013-09-30)
++++++++++++++++++

- print error code in Sublime's console if api request fails


1.4.1 (2013-09-30)
++++++++++++++++++

- fix SSL support problem for Linux users


1.4.0 (2013-09-22)
++++++++++++++++++

- log source code language type of files
- log total number of lines in files
- better python3 support


1.3.7 (2013-09-07)
++++++++++++++++++

- fix relative import bug


1.3.6 (2013-09-06)
++++++++++++++++++

- switch back to urllib2 instead of requests library in wakatime package


1.3.5 (2013-09-05)
++++++++++++++++++

- send Sublime version with api requests for easier debugging


1.3.4 (2013-09-04)
++++++++++++++++++

- upgraded wakatime package


1.3.3 (2013-09-04)
++++++++++++++++++

- using requests package in wakatime package


1.3.2 (2013-08-25)
++++++++++++++++++

- fix bug causing wrong file name detected
- misc bug fixes


1.3.0 (2013-08-15)
++++++++++++++++++

- detect git branches


1.2.0 (2013-08-12)
++++++++++++++++++

- run wakatime package in new process when no SSL support in Sublime


1.1.0 (2013-08-12)
++++++++++++++++++

- run wakatime package in main Sublime process


1.0.1 (2013-08-09)
++++++++++++++++++

- no longer beta for Package Control versioning requirement


0.4.2 (2013-08-08)
++++++++++++++++++

- remove away prompt popup


0.4.0 (2013-08-08)
++++++++++++++++++

- run wakatime package in background


0.3.3 (2013-08-06)
++++++++++++++++++

- support installing via Sublime Package Control


0.3.2 (2013-08-06)
++++++++++++++++++

- fixes for user sublime-settings file


0.3.1 (2013-08-04)
++++++++++++++++++

- renamed plugin folder


0.3.0 (2013-08-04)
++++++++++++++++++

- use WakaTime.sublime-settings file for configuration settings


0.2.10 (2013-07-29)
+++++++++++++++++++

- Python3 support
- better Windows support by detecting pythonw.exe location


0.2.9 (2013-07-22)
++++++++++++++++++

- upgraded wakatime package
- bug fix when detecting git repos


0.2.8 (2013-07-21)
++++++++++++++++++

- Windows bug fixes


0.2.7 (2013-07-20)
++++++++++++++++++

- prevent cmd window opening in background (Windows users only)


0.2.6 (2013-07-17)
++++++++++++++++++

- log errors from wakatime package to ~/.wakatime.log


0.2.5 (2013-07-17)
++++++++++++++++++

- distinguish between write events and normal events
- prompt user for api key if one does not already exist
- rename ~/.wakatime to ~/.wakatime.conf
- set away prompt to 5 minutes
- fix bug in custom logger


0.2.1 (2013-07-07)
++++++++++++++++++

- Birth

