#!/bin/bash
# @author Fred Brooker <git@gscloud.cz>

which ffmpeg >/dev/null 2>&1
if [ $? -eq 1 ]; then
  echo "Installing ffmpeg"
  sudo apt-get install -yqq ffmpeg
fi

which ffmpeg >/dev/null 2>&1
if [ $? -eq 1 ]; then
  echo -e "ERROR: ffmpeg is not installed!\n"
  exit 1
fi

which lame >/dev/null 2>&1
if [ $? -eq 1 ]; then
  echo "Installing lame"
  sudo apt-get install -yqq lame
fi

which lame >/dev/null 2>&1
if [ $? -eq 1 ]; then
  echo -e "ERROR: lame is not installed!\n"
  exit 1
fi

if [ ! -e ".concat" ]; then
  find . -maxdepth 1 -type f -size 0 -delete

  for i in *
  do
    # skip if not a directory
    if [ ! -d "$i" ]; then continue; fi
    echo -en "> $i\n"

    # check if file exists
    if [ -e "$i.mp3" ]; then
      A=`du -sb "$i" | awk '{print $1}' | awk '{print int($1)}'` # folder size, integer
      B=`du -sb "$i.mp3" | awk '{print $1}' | awk '{print int($1)+10485760}'` # file size, integer + 10 MB
      if [ "$B" -gt "$A" ]; then
        echo "🆗 $i"
        continue
      else
        echo "🤯 $i failure"
        rm -f "$i.mp3" >/dev/null 2>&1
        rm -f "$i/.concat" >/dev/null 2>&1
        sleep 2
      fi
    fi

    # check if already processed
    if [ -e "$i/.concat" ]; then continue; fi

    # dive into the album
    cd "$i"
    find . -maxdepth 1 -type f -size 0 -delete

    # check for subfolders
    D=0
    for x in *
    do
      if [ -d "$x" ]; then D=1; continue; fi
    done

    # run recursively
    if [ "$D" -eq "1" ]; then echo "📁 subfolders ..."; . $0; cd ..; continue; fi

    # check for MP3s
    FILES=`ls *.mp3 2>/dev/null`
    if [ -z "$FILES" ]; then echo "😵 missing MP3 in $i"; cd ..; continue; fi

    # create MP3
    echo -en "\n\nProcessing: $i\n\n"
    ls *.mp3 | perl -ne 'print "file $_"' > .files
    ffmpeg -y -f concat -i .files -c copy "../$i.mp3"
    if [ $? -eq 0 ]; then
      touch .concat
    fi
    rm -f .files
    cd ..

    # check filesizes
    if [ -e "$i.mp3" ]; then
      A=`du -sb "$i" | awk '{print $1}' | awk '{print int($1)}'` # folder size, integer
      B=`du -sb "$i.mp3" | awk '{print $1}' | awk '{print int($1)+10485760}'` # file size, integer + 10 MB
      if [ "$B" -gt "$A" ]; then
        echo "🆗 $i"
        continue
      else
        echo "🤯 $i failure"
        rm -f "$i.mp3" >/dev/null 2>&1
        rm -f "$i/.concat" >/dev/null 2>&1
        sleep 2
      fi
    fi
  done

  find . -maxdepth 1 -type f -size 0 -delete
  touch .concat
fi
