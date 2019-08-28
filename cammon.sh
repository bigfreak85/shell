#Cammon by R.Willems

echo "Verbinde zu Server bitte warten..."

#ssh -f -L 10554:192.168.0.11:554 -L 11554:192.168.0.12:554 -L 12554:192.168.0.13:554 -L 13554:192.168.0.14:554 user@host sleep 10; echo "starte VLC für Videoplayback..." &

#vlc -I dummy --autoscale --width=948 --height=567 --video-x=3846 --video-y=27 --no-video-deco --no-embedded-video 
mpv rtsp://@192.168.0.11/axis-media/media.amp& 
#vlc -I dummy --autoscale --width=948 --height=567 --video-x=4806 --video-y=27 --no-video-deco --no-embedded-video
mpv rtsp://@192.168.0.12/axis-media/media.amp&
#vlc -I dummy --autoscale --width=948 --height=567 --video-x=3846 --video-y=27 --no-video-deco --no-embedded-video 
mpv rtsp://@192.168.0.13/axis-media/media.amp& 
#vlc -I dummy --autoscale --width=948 --height=567 --video-x=3846 --video-y=27 --no-video-deco --no-embedded-video 
mpv rtsp://@192.168.0.14/axis-media/media.amp& 
