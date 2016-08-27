# path to the lua script
script="/home/someone/GitHub/MpdScripts/GetPlayInfoFromMpd.lua"

echo "MPD: idle"

# point this to your i3status config file
i3status -c /home/someone/.config/i3status/config | while :
     do
         read line
         mpd_status=$(lua $script status)
         if [ "$mpd_status" == "active" ]
             then
                 album=$(lua $script album)
                 artist=$(lua $script artist)
                 song=$(lua $script song)
                 echo "MPD:" $artist "|" $album "|" $song "|" $line || exit 1
             else
                 echo "MPD: idle" "|" $line || exit 1
          fi
          sleep 5
     done
