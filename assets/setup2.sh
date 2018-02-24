#!/bin/bash

echo ----- Prepare to install Oracle -----
ln -s /usr/bin/awk /bin/awk
mkdir /var/lock/subsys
mv /assets/chkconfig /sbin/chkconfig
chmod 755 /sbin/chkconfig

echo ----- Install Oracle -----
dpkg -i /assets/oracle-xe-universal_10.2.0.1-1.0_i386.deb

mv /assets/init.ora $ORACLE_HOME/config/scripts
mv /assets/initXETemp.ora $ORACLE_HOME/config/scripts

printf 8080\\n1521\\noracle\\noracle\\ny\\n | /etc/init.d/oracle-xe configure

echo "export ORACLE_HOME=$ORACLE_HOME" >> /etc/bash.bashrc
echo "export ORACLE_SID=$ORACLE_SID" >> /etc/bash.bashrc
echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH" >> /etc/bash.bashrc
echo "export NLS_LANG=\"$NLS_LANG\"" >> /etc/bash.bashrc
echo 'export PATH=$ORACLE_HOME/bin:$PATH' >> /etc/bash.bashrc

echo ----- Install startup script for container -----
mv /assets/startup.sh /oracle-startup.sh
chmod +x /oracle-startup.sh

echo ----- Remove installation files -----
cd /
rm -rf /assets

echo ----- Setup complated -----
exit $?
