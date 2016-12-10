FOR /F "tokens=* USEBACKQ" %%F IN (`command`) DO (
SET var=%%F
)
set FFMPEG_PATH=c:\Users\tikhomirov\Downloads\ffmpeg-20160127-git-9079e99-win64-static\ffmpeg-20160127-git-9079e99-win64-static\bin\
set FILES_PATH=d:\Q\yd\YandexDisk\offline\learnPrg\java\tgProject\net\cam1\

%FFMPEG_PATH%ffmpeg -r 96 -f image2 -i %FILES_PATH%cam.jpg.%d cam1_%var%_video_rate96_07-30--15-30.mpg