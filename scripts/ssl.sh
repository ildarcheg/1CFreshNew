# Install SSL

#Suppress interactive questions
export DEBIAN_FRONTEND=noninteractive

#Exit on error
set -e

source /fresh-install/scripts/util.sh

# Istall certbot
message "install certbot"

sudo apt-get update
sudo apt-get --yes --force-yes install software-properties-common
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get --yes --force-yes install python-certbot-apache

message "Certbot installed. Run: sudo certbot --apache --email <email> --agree-tos --redirect -d <domain>"