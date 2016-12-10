ffmpeg -r 24 -f image2 -i "cam%0d..jpg" output.mpg
pause
ffmpeg -f image2 -i cam%d.jpg video.mpg