#!/bin/bash
mv /tmp/my.cnf {{ mysql_datadir }}/my.cnf
chown -R {{ mysql_user }}:{{ mysql_user }} {{ mysql_datadir }} {{ mysql_basedir }}
###init mysql db###"
# {{ mysql_basedir }}/scripts/mysql_install_db --defaults-file={{ mysql_datadir }}/my.cnf --basedir={{ mysql_basedir }} --datadir={{ mysql_datadir }} --user={{ mysql_user }} >> {{ mysql_datadir }}/mysql_install_db-`date +%Y%m%d-%H%M%S`.log 2>&1 
if test -f {{ mysql_basedir }}/scripts/mysql_install_db ; then
  echo MySQL5.6
  {{ mysql_basedir }}/scripts/mysql_install_db --defaults-file={{ mysql_datadir }}/my.cnf --basedir={{ mysql_basedir }} --datadir={{ mysql_datadir }} --user={{ mysql_user }} >> {{ mysql_datadir }}/mysql_install_db-`date +%Y%m%d-%H%M%S`.log 2>&1 
else
  echo MySQL5.7.14
  touch /etc/my.cnf
  mv /etc/my.cnf /etc/my.cnf.`date +%Y%m%d-%H%M%S`
  mv {{ mysql_datadir }}/my.cnf /etc/my.cnf
  {{ mysql_basedir }}/bin/mysqld --initialize-insecure --basedir={{ mysql_basedir }} --datadir={{ mysql_datadir }} --user={{ mysql_user }} >> {{ mysql_basedir }}/mysqld_initialize_insecure-`date +%Y%m%d-%H%M%S`.log 2>&1 
  {{ mysql_basedir }}/bin/mysql_ssl_rsa_setup
  mv /etc/my.cnf  {{ mysql_datadir }}/my.cnf
  chmod 0644 {{ mysql_datadir }}/*.pem
fi


# sleep 10  
touch /etc/my.cnf
mv /etc/my.cnf /etc/my.cnf.`date +%Y%m%d-%H%M%S`

touch {{ mysql_basedir }}/my.cnf 
mv {{ mysql_basedir }}/my.cnf {{ mysql_basedir }}/my.cnf.`date +%Y%m%d-%H%M%S`
 
/etc/init.d/mysqld start 

# sleep 5 
ln -s -f {{ mysql_basedir }}/bin/mysql /usr/bin/mysql
ln -s -f {{ mysql_sock }} /tmp/mysql.sock
chkconfig --add mysqld
check_mysql=$(ps aux|grep mysql|grep -v grep|grep -v ansible|wc -l)
rm -rf /tmp/$(basename $0)
