#!/bin/bash -f

# Initialize envroiments.
PWD=`dirname $0`

# Install versions.
SCALA_VERSION=scala-2.11.11
SBT_VERSION=sbt-1.1.6-0

SCALAENV=~/.scalaenv

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
