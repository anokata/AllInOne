tmpdir='dotget'
tmppath="/run/$tmpdir"
repo="txthub"
user="anokata"
gitpath="https://github.com"
repopath="$gitpath/$user/$repo.git"
login=`whoami`
dotfilesdir='Linux/dotfiles'

echo '* Check temp dir exist...'
if [ -e $tmppath ] 
then
    echo 'OK exist'
else
    echo 'Not exist.'
    echo '* Create as root'
    sudo mkdir $tmppath
    echo "OK($?)"
    echo 'Need chg owner to '$login
    sudo chown ksi:ksi $tmppath
    echo "OK($?)"
fi

cd $tmppath

if [ -e $repo ] 
then
    echo 'OK Repo exist'
else
    echo "* Cloning $repopath"
    git clone $repopath
fi

echo '* Removing'
#rm -rf "$tmppath/$repo"

