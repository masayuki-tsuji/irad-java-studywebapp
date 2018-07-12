#!/bin/bash -f

# Initialize envroiments.
PWD=`dirname $0`

# Install versions.
SCALA_VERSION=scala-2.11.11
SBT_VERSION=sbt-1.1.6-0

# Directory path.
SCALAENV=~/.scalaenv

# MySQL config
DATABASE_CONFIG=/etc/my.cnf
DATABASE_NAME=playapp
MYSQLD_CLIENT="character-set-server=utf8"
CONFIG_CLIENT="default-character-set=utf8"

echo "*========================*"
echo "* Initialize mysql conf."
echo "*========================*"
cat $DATABASE_CONFIG | grep -q $MYSQLD_CLIENT
if [ $? != 0 ]; then
    echo "*** Add character set server start."
    sudo sed -i "/\[mysqld\]/a$MYSQLD_CLIENT" $DATABASE_CONFIG
    echo "*** Add character set server finish."
else
    echo "It is already set up.(@$MYSQLD_CLIENT)"
fi

cat $DATABASE_CONFIG | grep -q $CONFIG_CLIENT
if [ $? != 0 ]; then
    echo "*** Add default character set start."
    cat $DATABASE_CONFIG | grep -q '\[client\]'
    if [ $? != 0 ]; then
        sudo sed -i "\$a[client]" $DATABASE_CONFIG
    fi
    sudo sed -i "/\[client\]/a$CONFIG_CLIENT" $DATABASE_CONFIG
    echo "*** Add default character set finish."
else
    echo "It is already set up.(@$CONFIG_CLIENT)"
fi

echo "*========================*"
echo "* start mysql service."
echo "*========================*"
sudo service mysqld status > /dev/null
if [ $? != 0 ]; then
    sudo service mysqld start
else
    sudo service mysqld restart
fi

echo "*========================*"
echo "* Intiliaze mysql ."
echo "*========================*"
echo "*** create database start."
mysqladmin -uroot create $DATABASE_NAME > /dev/null 2&>1
if [ $? != 0 ]; then
    echo "Database name $DATABASE_NAME is already created."
fi
echo "*** create database finish."

echo "*** create user start."
mysql -uroot $DATABASE_NAME << EFO > /dev/null 2&>1
    create user play_user@localhost identified by 'play2018';
    grant all on ${DATABASE_NAME}.* to play_user@localhost identified by 'play2018';
    exit
EFO
if [ $? != 0 ]; then
    echo "It is already created."
fi
echo "*** create user finish."

echo "*========================*"
echo "* install scala."
echo "*========================*"
if [ ! -d $SCALAENV ]; then
    echo "*** install scalaenv start."
    git clone git://github.com/mazgi/scalaenv.git $SCALAENV
    echo 'export PATH="${HOME}/.scalaenv/bin:${PATH}"' >> ~/.bash_profile
    echo 'eval "$(scalaenv init -)"' >> ~/.bash_profile
    source ~/.bash_profile
    echo "*** install scalaenv finish."
else
    echo "It is already installed."
fi

which scalaenv > /dev/null
if [ $? != 0 ]; then
    echo "scalaenv not found."
    exit 1
fi

scalaenv global $SCALA_VERSION
if [ $? != 0 ]; then
    echo "*** scala install by $SCALA_VERSION start"
    scalaenv install $SCALA_VERSION
    scalaenv global $SCALA_VERSION
    echo "*** scala install by $SCALA_VERSION finish"
fi

echo "*========================*"
echo "* install sbt."
echo "*========================*"
which sbt > /dev/null
    if [ $? != 0 ]; then
    echo "*** sbt check curl start"
    curl https://bintray.com/sbt/rpm/rpm | sudo tee /etc/yum.repos.d/bintray-sbt-rpm.repo
    if [ $? != 0 ]; then
        echo "install sbt curl error."
        exit 1
    fi
    echo "*** sbt check curl finish"

    echo "*** sbt install start"
    sudo yum -y install $SBT_VERSION
    which sbt
    if [ $? != 0 ]; then
        echo "sbt install error."
        exit 1
    fi
    echo "*** sbt install check finish"
else
    echo "It is already installed."
fi

# Normal end.
echo "*** Complete"
exit 0
