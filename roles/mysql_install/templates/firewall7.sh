firewall-cmd --zone=public --add-port={{ mysql_port }}/tcp --permanent
firewall-cmd --reload
