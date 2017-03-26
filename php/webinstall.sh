sudo apt install apache2
sudo apt install php7.0-pgsql
sudo groupadd webmaster
sudo usermod ksi -a -G webmaster
sudo chgrp webmaster -R /var/www/html/
sudo chmod g+w -R /var/www/html/
sudo apt install php7.0-pgsql
sudo apt install postgresql
sudo apt install libapache2-mod-php7.0 
