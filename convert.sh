#!/bin/bash
#download files

echo "Youtube Music Downloader"
echo "Post the Playlist link or link of the song"
read url
short_url=$(echo "$url" | sed s/"&feature=share"//)
youtube-dl --ignore-errors -x --audio-format flac --add-metadata --write-thumbnail "$short_url"

#getting full files names
for i in *.flac;
  

  #getting file names
  #var name without file extension and everything after -
  do name=`echo "$i" | cut -d'-' -f1`
  echo $name
	#remove only file extension from name
 	picture=$(echo "$i" | awk '{ print substr( $0, 1, length($0)-5 ) }')

  #for webp files

	if [[ -f "${picture}.webp" ]]; then
		webp="${picture}.webp"
                #original name without file extension and with removed spaces
		new_webp=$(echo "${picture// /}")
                echo $new_webp
                mv "$webp" "${new_webp}.webp"
		square_image=$(echo "${name// /}")
		#convert them to diffrent resolution
		convert "${new_webp}.webp" -crop 720x720+280 "${square_image}.jpg"
		rm "${new_webp}.webp"
	fi
  
  #for jpg files
	if [[ -f "${picture}.jpg" ]]; then
		jpg="${picture}.jpg"
		new_jpg=$(echo "${picture// /}")
		#original name without file extension and with removed spaces
		echo $new
		mv "$jpg" "${new_jpg}.jpg"
		square_image=$(echo "${name// /}")
		#convert them to diffrent resolution
		convert "${new_jpg}.jpg" -crop 720x720+280 "${square_image}.jpg"
		rm "${new_jpg}.jpg"
	fi

echo "$i"
new_file_name=$(echo "${i// /}")
mv "$i" "$new_file_name"
#merging files
ffmpeg -i "$new_file_name" -i "${square_image}.jpg" -s 720x720 -map 0:0 -map 1:0 -disposition:v:0 attached_pic -c:v:0 mjpeg -ab 320k -map_metadata 0 -id3v2_version 3 "${name}.flac" 

#deleting not needed files
rm "$new_file_name"
rm "${square_image}.jpg"


echo "Finish"

done


echo "Everything is done"
