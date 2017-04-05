sudo apt install apache2
sudo apt install php7.0-pgsql
sudo groupadd webmaster
sudo usermod ksi -a -G webmaster
sudo chgrp webmaster -R /var/www/html/
sudo chmod g+w -R /var/www/html/
sudo apt install php7.0-pgsql
sudo apt install postgresql
sudo apt install libapache2-mod-php7.0 
sudo -u postgres createuser -P -e test
sudo -u postgres psql -c 'grant all on database urls to test;'
sudo -u postgres psql urls -f urls.sql
psql -U test urls -c select db.php deploy.sh firstTasks.php forms.php ftp.sh hello.php Makefile mysqldo people.php phone.php phone.sql post.php setting settings.php style.css table_phones.php tasks.php urls_add.php urls.php urls.sql webinstall.sh from urls -W
sudo -u postgres psql urls -c 'grant all on sequence seq1 to test;'
sudo -u postgres psql urls -c 'grant all on table urls to test;'
