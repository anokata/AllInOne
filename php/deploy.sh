echo '* Mounting ftp...'
curlftpfs ftp.eu.ai /mnt/ftp -o user=euai_19877563:`cat setting`
echo '* mounted ftp. Copy files'
cp * /mnt/ftp/htdocs
echo '* copied. umount.'
umount /mnt/ftp
