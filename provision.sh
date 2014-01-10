#!/usr/bin/env bash
# Onorio Catenacci 3 January 2014

echo "Installing scala and setting it up . . . "

readonly homedir="/home/vagrant"
apt-get update >/dev/null 2>&1
apt-get install -y scala > /dev/null 2>&1

# Thanks to pardigmatic on StackOverflow for this procedure to install
# SBT via apt-get on Ubuntu
# See here: http://stackoverflow.com/questions/13711395/install-sbt-on-ubuntu

echo "Installing SBT . . ."
readonly debfile="repo-deb-build-0002.deb"
wget http://apt.typesafe.com/"$debfile" > /dev/null 2>&1
dpkg -i "$debfile" > /dev/null 2>&1
apt-get update > /dev/null 2>&1
apt-get install -y sbt > /dev/null 2>&1

echo "Installing TypeSafe Stack . . . "
apt-get install -y typesafe-stack > /dev/null 2>&1

echo "Installing TypeSafe Activator . . . "
#Can't assume that unzip is present so we'll install it
apt-get install -y unzip > /dev/null 2>&1
cd "$homedir"
readonly activator_ver=1.0.10
readonly activator_zip="typesafe-activator-$activator_ver.zip"
readonly activator_script="/usr/bin/activator-$activator_ver/activator"

curl -O http://downloads.typesafe.com/typesafe-activator/"$activator_ver"/"$activator_zip" > /dev/null 2>&1
#put the activator files under the /usr/bin tree.
unzip "$activator_zip" -d /usr/bin > /dev/null 2>&1

#make the activator script executable
chmod a+x "$activator_script" > /dev/null

#adjust the amount of memory activator requires (NB: this seems to be specific to Ubuntu 13.10)
sed -i "$activator_script" -e "s#local mem=\${1:-1024}#local mem=\${1:-256}#g"

echo "Installing Postgre SQL . . ."
apt-get install -y postgresql > /dev/null 2>&1

readonly basevim="$homedir/.vim"

echo "Setting up VIM for syntax highlighting"
#Create directories for vim syntax highlighting then fetch the files from github
#Credit where credit's due, one liner is from blog posting by Bruce Snyder
#http://bsnyderblog.blogspot.com/2012/12/vim-syntax-highlighting-for-scala-bash.html

mkdir -p "$basevim"/{ftdetect,indent,syntax} && for d in ftdetect indent syntax ; do wget --no-check-certificate -O "$basevim"/$d/scala.vim https://raw.github.com/scala/scala-dist/master/tool-support/src/vim/$d/scala.vim; done > /dev/null 2>&1

#clean up after ourselves
rm -f "$debfile"
rm -f "$homedir/$activator_zip"

