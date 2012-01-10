#!/bin/bash
#
# License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
#
# Filip Oscadal <filip@mxd.cz> http://mxd.cz/
# No Rights Reserved 2012, feel free to modify, use and distribute.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY. YOU USE AT YOUR OWN RISK. THE AUTHOR
# WILL NOT BE LIABLE FOR DATA LOSS, DAMAGES, LOSS OF PROFITS OR ANY
# OTHER  KIND OF LOSS WHILE USING OR MISUSING THIS SOFTWARE.
# See the GNU General Public License for more details.


# check syntax
if [ $# -eq 0 ]
then
  echo -e "\nRecompress flac files to MP3 format recursively.\n\nSyntax: $(basename $0) <folder>\n"
  exit 1
fi
if [ -n "$1" ]
then
  if [ -d "$1" ]
  then
    cd "$1"
  else
    echo -e "Invalid folder: $1\n"
    exit 1
  fi
fi

# check for installed app
which flac >/dev/null 2>&1
if [ $? -eq 1 ]
then
  echo -e "Installing flac package...\n"
  sudo apt-get install flac
fi
which flac >/dev/null 2>&1
if [ $? -eq 1 ]
then
  echo -e "flac CLI tool is not installed!\n"
  exit 1
fi
which lame >/dev/null 2>&1
if [ $? -eq 1 ]
then
  echo -e "lame encoder is not installed!\n"
  exit 1
fi

# recurse any directories first
for i in *
do
  if [ -d "$i" ]
  then
    echo "Recursing into directory: $i"
    $0 "$i"
  fi
done

# decompress .flac files and then compress .wav to .mp3 (or recurse .pdf directories)
for i in *.flac
do
  if [ -d "$i" ]
  then
    echo "Recursing into directory: $i"
    $0 "$i"
  fi
  if [ -f "$i" ]
  then
    /usr/bin/flac -df "$i"
    /usr/bin/lame "${i%.flac}.wav" "${i%.flac}.mp3"
    rm "${i%.flac}.wav"
  fi
done

sync

echo -e "\nDone.\n"
exit 0
