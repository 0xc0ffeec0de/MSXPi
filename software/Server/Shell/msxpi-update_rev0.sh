#|===========================================================================|
#|                                                                           |
#| MSXPi Interface                                                           |
#|                                                                           |
#| Version : 0.8.1                                                           |
#|                                                                           |
#| Copyright (c) 2015-2017 Ronivon Candido Costa (ronivon@outlook.com)       |
#|                                                                           |
#| All rights reserved                                                       |
#|                                                                           |
#| Redistribution and use in source and compiled forms, with or without      |
#| modification, are permitted under GPL license.                            |
#|                                                                           |
#|===========================================================================|
#|                                                                           |
#| This file is part of MSXPi Interface project.                             |
#|                                                                           |
#| MSX PI Interface is free software: you can redistribute it and/or modify  |
#| it under the terms of the GNU General Public License as published by      |
#| the Free Software Foundation, either version 3 of the License, or         |
#| (at your option) any later version.                                       |
#|                                                                           |
#| MSX PI Interface is distributed in the hope that it will be useful,       |
#| but WITHOUT ANY WARRANTY; without even the implied warranty of            |
#| MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             |
#| GNU General Public License for more details.                              |
#|                                                                           |
#| You should have received a copy of the GNU General Public License         |
#| along with MSX PI Interface.  If not, see <http://www.gnu.org/licenses/>. |
#|===========================================================================|
#
# File history :
# 0.1    : Initial version.
#!/bin/sh

MSXPIHOME=/home/pi/msxpi
FILESERVER=http://retro-cpu.run/MSXPI/rev0
GETCMD="/usr/bin/wget --user=msxpi@retro-cpu.run --password=retro-cpu.run"
GETCMD="/usr/bin/wget"
TMPDIR=/tmp

cd $TMPDIR
rm msxpitools 2>/dev/null

# Download msxpi-server
$GETCMD --append-output=/tmp/msxpi_error.log $FILESERVER/msxpi-server
$GETCMD --append-output=/tmp/msxpi_error.log $FILESERVER/msxpi-client.bin
$GETCMD --append-output=/tmp/msxpi_error.log $FILESERVER/msxpiext.bin
/bin/mv msxpi-server     $MSXPIHOME/
/bin/mv msxpi-client.bin $MSXPIHOME/
/bin/chmod 755 $MSXPIHOME/*.sh
/bin/chmod 755 $MSXPIHOME/msxpi-server

# Create the update .bat to run from MSX-DOS
echo "pcd $FILESERVER" > MSXPIUP1.BAT.0
$GETCMD -o /tmp/msxpi_error.log $FILESERVER/
FILELIST=$(/bin/cat index.html |/bin/grep "a href="| /usr/bin/cut -f6 -d">"|/usr/bin/cut -f1 -d"<" | /bin/grep -v "DS_Store" | grep -v "Name" | grep -v "Parent")
for FILE in $FILELIST
do
    echo "pcopy $FILE $FILE" >> MSXPIUP1.BAT.0
done

/bin/cat MSXPIUP1.BAT.0 | /usr/bin/awk 'sub("$", "\r")' > MSXPIUP1.BAT
/bin/mv MSXPIUP1.BAT $MSXPIHOME/
/bin/rm MSXPIUP1.BAT.0
/bin/rm index.html*
/bin/chown -R pi.pi $MSXPIHOME


