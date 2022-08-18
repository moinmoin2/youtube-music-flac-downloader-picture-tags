#!/bin/bash
#download files

echo "Youtube Music Downloader"
echo "Post the Playlist link or link of the song"
read url
short_url=$(echo "$url" | sed s/"&feature=share"//)
youtube-dl -x --audio-format flac --add-metadata --write-thumbnail --id --ignore-errors "$short_url"

#getting full files names
for i in *.flac; do


  #remove only file extension from name
  name=$(echo "$i" | awk '{ print substr( $0, 1, length($0)-5 ) }')
  finale_picture="${name}new.jpg"
  #echo $finale_picture
  #for webp files

    if [[ -f "${name}.webp" ]]; then
        #convert them to diffrent resolution
        convert "${name}.webp" -crop 720x720+280 "$finale_picture"
        rm -v "./${name}.webp"
    fi

  #for jpg files
    if [[ -f "${name}.jpg" ]]; then
        #convert them to diffrent resolution
        convert "${name}.jpg" -crop 720x720+280 "$finale_picture"
        rm -v "./${name}.jpg"
    fi
#check for release year of the song

comment=$(exiftool -q -Description "./$i")

if echo "$comment" | grep 'Released on:'; then
    release_year=$(echo $comment | sed 's/.*Released on: //' | awk '{print substr ($0, 0, 4)}')
fi

#get artist and title for the final filename

artist=$(exiftool -q -s3 -Artist "./${i}" | cut -d',' -f1)
title=$(exiftool -q -s3 -Title "./${i}")
final="${artist} - ${title}"



#merging files
ffmpeg -i "./${i}" -i "${name}new.jpg" -s 720x720 -map 0:0 -map 1:0 -disposition:v:0 attached_pic -c:v:0 mjpeg -ab 320k -map_metadata 0 -metadata date="$release_year" -y -id3v2_version 3 "${final}.flac" 

#deleting not needed files
rm -v "./${i}"
rm -v "./${finale_picture}"


done


echo "Everything is done ......  Finish"


