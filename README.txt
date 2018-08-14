------------------------------------------
1CFRESH ENVIRONMENT INSTALLATION AND SETUP
------------------------------------------

--------------
PREREQUISITES:
--------------

- Bare-bone Ubuntu 16.04 installed on the local computer
- Access to github.com/KonstantinRupasov/1CFresh repository
- http://61.28.226.190/fresh-install-64.zip, containing all distribs necessary
  -- You can replace it with any other web resource of your choise in setup_int.sh script

-------------
GENERAL USAGE
-------------

To instal and set up 1cfresh environment you need to run the followin command:
. <(curl https://raw.githubusercontent.com/KonstantinRupasov/1CFresh/master/scripts/setup.sh?token=AYe0BQGRL8dUNvQ59G8fl3G5Da-VE5hSks5Z6lsGwA%3D%3D)

This will download and run setup.sh script from the repository.
IMPORTANT! If you changed setup.sh script you will need to use ANOTHER token with the link (see "Raw" GitHub representation).
You will be asked to provide a username and a password for github.com/KonstantinRupasov/1CFresh repository.
Then the script will clone the entire repository to the local computer and run setup_int.sh script.
setup_int.sh script will download all distributives and run other scripts in the following order:
  - env.sh
  - fresh.sh

------------------------------------------------------------
INSTRUCTION FOR 1C VIETNAM (VINADATA HOSTING) for new server
------------------------------------------------------------

- change a password for stackops user: passwd
- switch shell to bash for stackops user: sudo chsh -s /bin/bash stackops
- update hosts with server name (replace "ubuntu" with server name): sudo nano /etc/hosts
- clone repo to '/fresh-install': sudo git clone https://github.com/KonstantinRupasov/1CFresh-International.git /fresh-install
- download distribs: sudo bash /fresh-install/scripts/download.sh
- setup and environment: sudo bash /fresh-install/scripts/env.sh
- add infobases: sudo bash /fresh-install/scripts/fresh.sh -a sm -p acs
- (on WIN) add server IP to host on win-server 
- (on WIN) load CFs for sm and acs
- add server with license functionality to the cluster: sudo bash /fresh-install/scripts/license.sh <lisense_server_ip> <license_server_name>

-------------------
INSTRUCTION FOR SSL
-------------------

- install certbot: sudo bash /fresh-install/scripts/ssl.sh
- install ssl certs (add email and one or more domains): sudo certbot --apache --email <email> --agree-tos --redirect -d <domain>

------------------------
INSTRUCTION FOR WEB-SITE
------------------------

- create web-site folder: sudo mkdir /var/www/acsweb
- clone ACSWEB repo (add server name as a branch-name): sudo git clone -b <branch-name> https://github.com/ildarcheg/acsweb.git /var/www/acsweb
- add web-site path to /etc/apache2/envvars: sudo echo -e "\n# ACS WEB SITE\n\nexport APACHE_WEB_SITE='/var/www/acsweb'" >> /etc/apache2/envvars
- replace "DocumentRoot /var/www/html" to "DocumentRoot /var/www/acsweb" in "/etc/apache2/sites-enabled/000-default-le-ssl.conf": sudo nano /etc/apache2/sites-enabled/000-default-le-ssl.conf
- restart apache: sudo service apache2 restart