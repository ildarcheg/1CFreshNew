#!/bin/bash
sudo apt-get  --yes --force-yes install curl
sudo apt-get  --yes --force-yes install unzip

sudo rm -fr fresh-install-64.zip
sudo rm -fr /fresh-install

sudo curl -O https://transfer.sh/1qf63/fresh-install-64.zip

sudo unzip fresh-install-64.zip
sudo mkdir /fresh-install
sudo cp -a fresh-install-64/* /fresh-install/
sudo rm -fr fresh-install-64
sudo rm fresh-install-64.zip

set -e

sudo apt-get update -y
sudo apt-get --yes --force-yes install gdebi-core
sudo apt-get --yes --force-yes install ntp ntpdate
sudo apt-get --yes --force-yes install apache2
sudo service apache2 restart

sudo locale-gen en_US ru_RU ru_RU.UTF-8 
export LANG="ru_RU.UTF-8"

root_dir=/fresh-install
yes | sudo gdebi $root_dir/postgresql-9.3.4_1.1C_amd64_deb/libicu48_4.8.1.1-3_amd64.deb
yes | sudo gdebi $root_dir/postgresql-9.3.4_1.1C_amd64_deb/libossp-uuid16_1.6.2-1.3ubuntu1_amd64.deb
yes | sudo gdebi $root_dir/postgresql-9.3.4_1.1C_amd64_deb/libpq5_9.3.4-1.1C_amd64.deb
yes | sudo gdebi $root_dir/postgresql-9.3.4_1.1C_amd64_deb/postgresql-client-common_154.1.1C_all.deb
yes | sudo gdebi $root_dir/postgresql-9.3.4_1.1C_amd64_deb/postgresql-client-9.3_9.3.4-1.1C_amd64.deb
yes | sudo gdebi $root_dir/postgresql-9.3.4_1.1C_amd64_deb/postgresql-common_154.1.1C_all.deb
yes | sudo gdebi $root_dir/postgresql-9.3.4_1.1C_amd64_deb/postgresql-9.3_9.3.4-1.1C_amd64.deb
yes | sudo gdebi $root_dir/postgresql-9.3.4_1.1C_amd64_deb/postgresql-contrib-9.3_9.3.4-1.1C_amd64.deb

sudo mkdir -p /1c/db
sudo chown postgres:postgres /1c/db
if sudo [ ! -f /1c/db/pg_hba.conf ]; then
	sudo su - postgres -c "/usr/lib/postgresql/9.3/bin/initdb -D /1c/db --locale=ru_RU.UTF-8"
fi

sudo sed -i 's/local   all             postgres                                peer/local   all             postgres                                trust/' /etc/postgresql/9.3/main/pg_hba.conf
sudo service postgresql restart
sudo psql -U postgres -c "alter user postgres with password '12345Qwerty';" 
sudo sed -i 's/^\([^#]\)/# \1/g' /etc/postgresql/9.3/main/pg_hba.conf
sudo sed -i 's/# local   all             postgres                                trust/local   all             postgres                                peer\nlocal   all             all                                     md5\nhost    all             postgres              127.0.0.1\/32      md5/' /etc/postgresql/9.3/main/pg_hba.conf
sudo service postgresql restart

#!/bin/bash
root_dir=/fresh-install
yes | sudo gdebi $root_dir/deb-client-server-64/1c-enterprise83-common_8.3.12-1616_amd64.deb
yes | sudo gdebi $root_dir/deb-client-server-64/1c-enterprise83-common-nls_8.3.12-1616_amd64.deb
yes | sudo gdebi $root_dir/deb-client-server-64/1c-enterprise83-server_8.3.12-1616_amd64.deb
yes | sudo gdebi $root_dir/deb-client-server-64/1c-enterprise83-server-nls_8.3.12-1616_amd64.deb
yes | sudo gdebi $root_dir/deb-client-server-64/1c-enterprise83-ws_8.3.12-1616_amd64.deb
yes | sudo gdebi $root_dir/deb-client-server-64/1c-enterprise83-ws-nls_8.3.12-1616_amd64.deb

sudo chown -R usr1cv8 /opt/1C
sudo service srv1cv83 start

#!/bin/bash
root_dir=/fresh-install
sudo mkdir -p /opt/1C/v8.3/x86_64/conf
sudo chmod o+w /opt/1C/v8.3/x86_64/conf

echo '<?xml version="1.0"?>
<config xmlns="http://v8.1c.ru/v8/tech-log">
  <log location="/var/log/1c/logs/excp" history="24">
    <event>
      <eq property="name" value="excp"/>
    </event>
    <property name="all"/>
  </log>
  <log location="/var/log/1c/logs/vrs" history="24">
    <event>
      <eq property="name" value="vrsrequest"/>
    </event>
    <event>
      <eq property="name" value="vrsresponse"/>
    </event>
    <property name="all"/>
  </log>
  <dump location="/var/log/1c/dumps" create="1" type="3"/> 
</config>' >> /opt/1C/v8.3/x86_64/conf/logcfg.xml
sudo chmod o-w /opt/1C/v8.3/x86_64/conf/logcfg.xml

sudo mkdir -p /var/log/1c/logs/excp 
sudo mkdir -p /var/log/1c/logs/vrs 
sudo mkdir -p /var/log/1c/dumps

sudo getent group grp1clogs 2>&1 > /dev/null || sudo groupadd grp1clogs
sudo usermod -a -G grp1clogs www-data
sudo usermod -a -G grp1clogs usr1cv8

sudo chown -R usr1cv8:grp1clogs /var/log/1c 
sudo chmod g+rw /var/log/1c

ps aux | grep /opt/1C/v8.3/x86_64/ | grep -v grep | cut -c 1-65 
ps aux | grep apache2 | grep -v grep | cut -c 1-65

sudo apt-get -y install imagemagick
sudo find / -xdev -name "*libMagickWand*"

if [ ! -e /usr/lib/libMagickWand.so ]; then
	sudo ln -s /usr/lib/x86_64-linux-gnu/libMagickWand-6.Q16.so.2.0.0 /usr/lib/libMagickWand.so
fi

sudo apt-get -y install ttf-mscorefonts-installer
sudo fc-cache -fv
if [ ! -e /etc/fonts/conf.d/10-autohint.conf ]; then
	sudo ln -s /etc/fonts/conf.avail/10-autohint.conf /etc/fonts/conf.d/10-autohint.conf
fi

sudo apt-get -y install libc6-i386
yes | sudo gdebi $root_dir/hasp/haspd_7.40-eter10ubuntu_amd64.deb
sudo service haspd start

sudo chmod o+w /etc/apache2/mods-enabled
sudo rm /etc/apache2/mods-enabled/wsap24.load
echo "LoadModule _1cws_module /opt/1C/v8.3/x86_64/wsap24.so" >> /etc/apache2/mods-enabled/wsap24.load
sudo chmod o-w /etc/apache2/mods-enabled/wsap24.load

sudo service srv1cv83 stop
sudo sed -i 's/#SRV1CV8_DEBUG=/SRV1CV8_DEBUG=1/' /etc/init.d/srv1cv83
sudo service srv1cv83 start
sudo systemctl daemon-reload
sudo netstat -peant | grep :15

yes | sudo gdebi $root_dir/deb-client-server-64/1c-enterprise83-client_8.3.12-1616_amd64.deb
yes | sudo gdebi $root_dir/deb-client-server-64/1c-enterprise83-client-nls_8.3.12-1616_amd64.deb

base_name=mymoney
mras='/opt/1C/v8.3/x86_64/ras'
mrac='/opt/1C/v8.3/x86_64/rac'

$mras cluster --daemon
cluster=$(echo $($mrac cluster list) | cut -d':' -f 2 | cut -d' ' -f 2)
echo $cluster
# get server name
server=$(echo $($mrac cluster list) | cut -d':' -f 3 | cut -d' ' -f 2)
echo $server
# create infobase for fresh
$mrac infobase create --create-database --name=$base_name --dbms=PostgreSQL --db-server=$server --db-name=$base_name --locale=en_US --db-user=postgres --db-pwd=12345Qwerty --descr='1C Fresh Manager Service Infobase' --license-distribution=allow --cluster=$cluster >> infobase
# retrieving fresh infobase id
infobase1=$(cat infobase | cut -d':' -f 2 | cut -d' ' -f 2)
echo $infobase1
rm infobase
# getting sumary 
$mrac infobase summary list --cluster=$cluster
$mrac infobase info --infobase=$infobase1 --cluster=$cluster


mkdir -p /var/www/pub/mymoney
echo '<?xml version="1.0" encoding="UTF-8"?>
<point 
    xmlns="http://v8.1c.ru/8.2/virtual-resource-system" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    base="/mymoney" 
    ib="Srvr=&quot;mymoney&quot;;Ref=&quot;mymoney&quot;;">
  <ws />
</point>' >> /var/www/pub/mymoney/default.vrd

mkdir /etc/apache2/1cpub
echo '# Application External Publication (/a/<--ibname-->) 
Alias "/mymoney" "/var/www/pub/mymoney"
<Directory "/var/www/pub/mymoney/">
    AllowOverride All
    Options None
    Order allow,deny
    Allow from all
    SetHandler 1c-application
    ManagedApplicationDescriptor "/var/www/pub/mymoney/default.vrd"
</Directory>' >> /etc/apache2/1cpub/app.conf

echo 'Include 1cpub/*.conf' >> /etc/apache2/ports.conf


/opt/1C/v8.3/x86_64/./webinst -apache24 -wsdir mymoney -dir /var/www/pub/mymoney -connstr "File=/pub/money;" -confPath /etc/apache2/1cpub/app.conf


export JAVA_HOME=/usr/lib/jvm/java-8-oracle/
/opt/1C/1CE/x86_64/ring/ring license activate --first-name "Ildar" --last-name "Gabdrakhmanov" --email "ildarcheg@gmail.com" --country "RU" --zip-code "000" --region "Moscow" --town "Moscow" --street "Lenina" --house 10 --serial "20009305688" --pin "9793-5524-1177-3203" --validate


root@mymoney:~# /opt/1C/1CE/x86_64/ring/ring license activate --first-name "Ildar" --last-name "Gabdrakhmanov" --email "ildarcheg@gmail.com" --country "RU" --zip-code "000" --region "Moscow" --town "Moscow" --street "Lenina" --house 10 --serial "20009305688" --pin "9793-5524-1177-3203" --validate

[WARN  ] com._1c.license.activator.internal.hard.SystemFiles - Cannot read disk info. File "/sys/block/vda/device/model" not found.
[WARN  ] com._1c.license.activator.internal.hard.SystemFiles - Cannot read disk info. File "/sys/block/vda/device/rev" not found.
License activation error.
Reason: PIN code input error. The PIN code is incomplete.

export JAVA_HOME=/usr/lib/jvm/java-8-oracle/

export PATH=$JAVA_HOME/bin:$PATH

#install java
sudo apt-get update -y
sudo apt-get --yes --force-yes install default-jre
sudo apt-get --yes --force-yes install default-jdk
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update -y
sudo apt-get --yes --force-yes install oracle-java8-installer
sudo update-alternatives --config java
sudo nano /etc/environment #JAVA_HOME="/usr/lib/jvm/java-8-oracle"
source /etc/environment
echo $JAVA_HOME

sudo mkdir /pub
unzip Money.zip
sudo mv Money /pub/money
sudo chmod -R 777 /pub
sudo mkdir /etc/apache2/1cpub
sudo touch /etc/apache2/1cpub/app.conf
sudo chmod -R 777 /etc/apache2/1cpub
sudo /opt/1C/v8.3/x86_64/./webinst -apache24 -wsdir mym -dir /var/www/pub/money -connstr "File=/pub/money;" -confPath /etc/apache2/1cpub/app.conf
echo 'Include 1cpub/*.conf' >> /etc/apache2/ports.conf
sudo service apache2 restart







