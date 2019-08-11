#!/bin/sh

# Helper functions
print_usage() {
	echo "Usage: -t target [-b blocksize -n]";
	echo "	-t	Directory to nuke.";
	echo "	-b	Block size in bytes. Can end in K|M|G|B";
	echo "	-n	Dry run";
}

exit_badly() {
	print_usage
	exit 1
}


DRY=false

# Parse arguments
while getopts 't:b:n' options; do
  case "${options}" in
    b) BS="${OPTARG}" ;;
	t) DIR="${OPTARG}" ;;
	n) DRY=true; echo "Dry run - Printing commands but not executing them" ;;
    *) print_usage
       exit 1 ;;
  esac
done

# Ensure dir is given and valid
if [[ "$DIR" == "" || ! -d "$DIR" ]]; then
	exit_badly
fi

# Default Blocksize
if [[ "$BS" == "" ]]; then
	BS=512
fi

# Convert block size to bytes
echo "Using block size of ${BS}B"

if [[ "$BS" == *K ]]; then
	let BS=(${BS%K}*1024)
elif [[ "$BS" == *M ]]; then
	let BS=(${BS%M}*1024*1024)
elif [[ "$BS" == *G ]]; then
	let BS=(${BS%G}*1024*1024*1024)
fi

# Make sure BS is now a number
if [[ "$BS" -ne "$BS" ]]; then
	exit_badly
fi

echo "Wiping file contents..."
for f in $(find $DIR -type f); do
	echo "  $f"
	SIZE=$(ls -l $f | awk '{ print $5 }')
	let size_blocks=($SIZE+$BS-1)/$BS
	COMMAND="dd if=/dev/urandom of=$f bs=$BS count=$size_blocks"
	if [[ $DRY != "true" ]]; then
		output=`$COMMAND 1> /dev/null 2> /dev/null`
	else
		echo "  $ $COMMAND"
	fi
done

echo "Removing files..."
for f in $(find $DIR -type f); do
	rm $f
	echo "  $f"
done

echo "Removing directory..."
rm -rf $DIR