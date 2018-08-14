# -----------------------------------------------------------------
# Installing 1CFresh environment to bare-bone Ubuntu 16.04 computer
# -----------------------------------------------------------------
# Main script that does the following:
#   - Downloads distribs from $distribs. 
#   - Runs a sequence of scripts
# -----------------------------------------------------------------

# Exit on error
set -e

# Declare util functions
. $root_dir/scripts/util.sh

# Installing unzip
message "Installing unzip..."
sudo apt-get --yes --force-yes install unzip

# Download distributions
message "Unzip is installed. Downloading distibutions..."
sudo mkdir $root_dir/distribs
sudo curl -# -o  $root_dir/distribs.zip -L $distr_URI
message "Download complete. Unzipping the distributions..."
sudo unzip $root_dir/distribs.zip
sudo rm $root_dir/distribs.zip

# Run environment setup
. $root_dir/scripts/env.sh

# Run fresh setup
. $root_dir/scripts/fresh.sh
