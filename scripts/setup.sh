# -----------------------------------------------------------------
# Installing 1CFresh environment to bare-bone Ubuntu 16.04 computer
# -----------------------------------------------------------------
# Does the following:
#  - Asks a user to specify the following parameters:
#    -- Scripts/configs GIT repository URI
#    -- Username and password for  repository
#    -- Root catalog for installation files ($root_dir)
#    -- URI of dictributions
#  - Creates a $root_dir directory for all the stuff we need
#  - Clones "https://github.com/KonstantinRupasov/1CFresh" repository to catalog $root_dir or the local computer
#  - Runs $root_dir\scripts\setup_int.sh that does the rest of the installation:
#    -- Downloads distribs
#    -- Runs a sequence of scripts
# ---------------------------------------------
# This script is supposed to NEVER change.
# If it's changed you need to replace the link in ". <(curl link)" with a new one (token has changed)
# ---------------------------------------------
# Script version 0.1.0.1
# --------------------

# Default parameters values
_git_repo="github.com/KonstantinRupasov/1CFresh"                    # Scripts/configs repository URI default value
_root_dir="/fresh_install"                                          # Root installation catalog default value
#_distr_URI="http://61.28.226.190/distribs.zip"                      # Distributions URI default value
_distr_URI="https://www.dropbox.com/s/yil4r64l8gcdy5z/distribs.zip?dl=0"
_fresh_base_name="sm"                                               # Service Manager infobase name
_solution_base_name="asc"                                           # Application infobase name

# Prompt credential for github.com/KonstantinRupasov/1CFresh repository and other settings
echo "-----------------------------------------------------"
echo "--- Please, provide the parameters for the script ---"
echo "-----------------------------------------------------"
read -e -p "GIT repository with scipts/configs: " -i $_git_repo git_repo
read -p "Your GitHub username: " username
#username=${username:=KR}
read -sp "Your GitHub password: " password
echo
read -e -p "Root catalog for installation files: " -i $_root_dir root_dir
read -e -p "Distributions URI: " -i $_distr_URI distr_URI
read -e -p "Service Manager infobase name: " -i $_fresh_base_name fresh_base_name
read -e -p "Application infobase name: " -i $_solution_base_name solution_base_name

# Delete root_dir if it exists
if [ -d $root_dir ]; then
     sudo rm -Rf $root_dir
fi
# Create root_dir
sudo mkdir $root_dir
cd $root_dir

# Clone the repository
sudo git clone https://$username:$password@github.com/KonstantinRupasov/1CFresh.git $root_dir

# Run setup_int.sh script
. $root_dir/scripts/setup_int.sh
