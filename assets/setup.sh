#!/bin/bash

# avoid dpkg frontend dialog / frontend warnings
export DEBIAN_FRONTEND=noninteractive
export ORACLE_HOME=/usr/lib/oracle/xe/app/oracle/product/10.2.0/server
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export PATH=$ORACLE_HOME/bin:$PATH
export ORACLE_SID=XE

echo ----- Install OpenSSH -----
dpkg --add-architecture i386 &&
apt-get update &&
apt-get install -y openssh-server &&
mkdir /var/run/sshd &&
echo 'root:admin' | chpasswd &&
sed -i 's/^PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config &&
sed -i 's/session\s*required\s*pam_loginuid.so/session optional pam_loginuid.so/g' /etc/pam.d/sshd &&
echo 'export VISIBLE=now' >> /etc/profile &&

echo ----- Prepare to install Oracle -----
apt-get install -y bc:i386 libaio1:i386 libc6-i386 net-tools wget &&
apt-get clean &&
ln -s /usr/bin/awk /bin/awk &&
mkdir /var/lock/subsys &&
mv /assets/chkconfig /sbin/chkconfig &&
chmod 755 /sbin/chkconfig &&

echo ----- Install Oracle -----
dpkg -i /assets/oracle-xe-universal_10.2.0.1-1.0_i386.deb &&

mv /assets/init.ora $ORACLE_HOME/config/scripts &&
mv /assets/initXETemp.ora $ORACLE_HOME/config/scripts &&

printf 8080\\n1521\\noracle\\noracle\\ny\\n | /etc/init.d/oracle-xe configure &&

echo "export ORACLE_HOME=$ORACLE_HOME" >> /etc/bash.bashrc &&
echo "export ORACLE_SID=$ORACLE_SID" >> /etc/bash.bashrc &&
echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH" >> /etc/bash.bashrc &&
echo "export NLS_LANG=$NLS_LANG" >> /etc/bash.bashrc &&
echo 'export PATH=$ORACLE_HOME/bin:$PATH' >> /etc/bash.bashrc &&

echo ----- Install startup script for container -----
mv /assets/startup.sh /oracle-startup.sh &&
chmod +x /oracle-startup.sh &&

echo ----- Remove installation files -----
rm -rf /assets/

echo ----- Setup complated -----
exit $?
