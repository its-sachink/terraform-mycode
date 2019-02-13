#!/bin/sh

# user-data.sh
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
/etc/init.d/httpd start
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www/html
chmod 2775 /var/www/html
cat > /var/www/html/index.html << EOF
<h1>Hello, World</h1>
<p>DB Address: ${db_address} </p>
<p>DB port: ${db_port}</p>
EOF
/etc/init.d/httpd restart
# nohup busybox httpd -f -p "${server_port}" &