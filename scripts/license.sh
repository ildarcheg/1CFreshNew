# Setup 1C licenses

# Accept 2 parameter: IP and name of server with license functionality 

#Suppress interactive questions
export DEBIAN_FRONTEND=noninteractive

#Exit on error
set -e

license_server_ip=$1
license_server_name=$2

source /fresh-install/scripts/util.sh

sudo echo -e $license_server_ip $license_server_name >> /etc/hosts
# create variable for server and console agents
mras='/opt/1C/v8.3/x86_64/ras'
mrac='/opt/1C/v8.3/x86_64/rac'

message "Getting cluster and server ids"

cluster_id=$(echo $($mrac cluster list) | cut -d':' -f 2 | cut -d' ' -f 2)
echo "cluster id:" $cluster_id
server_id=$(echo $($mrac server --cluster=$cluster_id list) | cut -d':' -f 2 | cut -d' ' -f 2)
echo "server id:" $server_id

message "Adding license server"

$mrac server --cluster=$cluster_id insert --agent-host=$license_server_name --agent-port=1540 --port-range=1560-1591 --name=$license_server_name --using=normal
license_server_id=$(echo $($mrac server --cluster=$cluster_id list) | sed -e 's/server :/|/g' | sed -e 's/agent-host :/|/g' | sed -e 's/ //g' | cut -d'|' -f 4)
echo "license server id:" $license_server_id

message "Adding rules for servers"

$mrac rule --cluster=$cluster_id insert --server=$server_id --position=1 --object-type=LicenseService --rule-type=never
$mrac rule --cluster=$cluster_id insert --server=$license_server_id --position=1 --object-type=LicenseService --rule-type=always
$mrac rule --cluster=$cluster_id insert --server=$license_server_id --position=2 --object-type=Connection --rule-type=never
$mrac rule --cluster=$cluster_id apply --full

message "Following rules were applied:"

echo $($mrac rule --cluster=$cluster_id list --server=$server_id)
echo $($mrac rule --cluster=$cluster_id list --server=$license_server_id)

message "ALL DONE"