#Echo delimiter
function delimiter() {
	echo -e "---------------------------"
}

# Echo message
function message() {
	delimiter
	echo $1
	delimiter
}