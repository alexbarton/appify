#!/bin/bash

#
# appify -- convert your non-interactive shell script into a Mac OS X application
# Copyright (C) 2010  Adam Backstrom
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#

args=$(getopt h $*)

function usage {
    echo "Usage: $0 [-h] script.sh target.app"
    exit 2
}

if [ $? != 0 ]; then
    usage
fi

set -- $args
for i ; do
    case "$i"
    in
        -h) usage ; shift ;;
        --) shift ; break ;;
    esac
done

if [ $# != 2 ]; then
    usage
fi

SCRIPT=$1
TARGET=$2

if [ -d "$TARGET" ]; then
    echo "$TARGET exists, exiting" 1>&2
    exit 3
fi

SCRIPTSIZE=$(ls -l "$SCRIPT" | awk '{print $5}')

if [ $SCRIPTSIZE -lt 28 ]; then
    echo -e "Script smaller than size allowed by OS. Please pad to 28 characters." 1>&2
    exit 4
fi

#
# done checking args; create the app
#

mkdir -p "$TARGET/Contents/MacOS"
mkdir -p "$TARGET/Contents/Resources"

cat <<EOF >"$TARGET/Contents/Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>run.sh</string>
    <key>CFBundleIconFile</key>
    <string></string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>1.0</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleSignature</key>
    <string>????</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
</dict>
</plist>
EOF

cp "$SCRIPT" "$TARGET/Contents/MacOS/run.sh"
chmod 755 "$TARGET/Contents/MacOS/run.sh"
