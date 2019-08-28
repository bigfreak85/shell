ffmpeg -f x11grab -video_size 1920x1080 -framerate 30 -i :0+3840,0 \                                                                                                                                                      
       -vcodec libx264 -preset medium -qp 0 -pix_fmt yuv444p \
       video.mkv

oder mit Videocamera vom Laptop unten rechts


        ffmpeg -f x11grab -thread_queue_size 64 -video_size 1920x1200 -framerate 30 -i :0 \                                                                                                                              
       -f v4l2 -thread_queue_size 64 -video_size 320x180 -framerate 30 -i /dev/video0 \
       -filter_complex 'overlay=main_w-overlay_w:main_h-overlay_h:format=yuv444' \
       -vcodec libx264 -preset medium -qp 0 -pix_fmt yuv444p \
       videomitcam.mkv
