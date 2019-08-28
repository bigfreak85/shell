#!/bin/sh

pkill -INT ffmpeg
sleep 10
NOW=$(date +"%m-%d")
cd /daten/Videoueberwachung/Tagekomplett/

/usr/bin/ffmpeg -v verbose \
  -rtsp_transport tcp -stimeout 50000000 -i rtsp://viewer:online@192.168.0.11/axis-media/media.amp \
  -vcodec copy -movflags faststart \
  -map 0 $NOW-CAM1.mkv \
  -rtsp_transport tcp -stimeout 50000000 -i rtsp://viewer:online@192.168.0.12/axis-media/media.amp \
  -vcodec copy -movflags faststart \
  -map 1 $NOW-CAM2.mkv \
  -rtsp_transport tcp -stimeout 50000000 -i rtsp://viewer:online@192.168.0.13/axis-media/media.amp \
  -vcodec copy -movflags faststart \
  -map 2 $NOW-CAM3.mkv \
  -rtsp_transport tcp -stimeout 50000000 -i rtsp://viewer:online@192.168.0.14/axis-media/media.amp \
  -vcodec copy -movflags faststart \
  -map 3 $NOW-CAM4.mkv


#streamprofile=Quality
#-rtsp_transport tcp -i rtsp://192.168.0.9/live3.sdp -vcodec copy -movflags faststart -map 2 $NOW-CAM1.h264 

