Приложение для извлечения Youtube ID видео из ссылки,
которая отображается в письме.

Используется создание apk файлов из коммандной строки.

Проект базируется на информацииб полученной по ссылке:
http://www.hanshq.net/command-line-android.html


sudo apt install android-sdk
sudo apt install apksigner

Для версии андроид lolipop 5.1 ставит платформу 22:
sudo apt install google-android-platform-22-installer
sudo apt install google-android-build-tools-22-installer

настроит привелегии  для adb
vi /etc/udev/rules.d/51-android.rules
SUBSYSTEM=="usb", ATTR{idVendor}=="1782", MODE="0666", GROUP="plugdev" 

После подключения через adb, на устройстве подтвердить соединение на устройстве.
