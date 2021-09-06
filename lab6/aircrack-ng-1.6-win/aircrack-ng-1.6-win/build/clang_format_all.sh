#!/bin/sh
#
# Adapted from:
#   https://github.com/baldurk/renderdoc/raw/v1.x/util/clang_format_all.sh
#

CLANG_MAJOR=3
CLANG_MINOR=8

CLANG_FORMAT_VERSION=$CLANG_MAJOR.$CLANG_MINOR

# Locate the clang-format executable. We try:
#   - the existing value of $CLANG_FORMAT
#   - the first command line argument to the script
#   - in order:
#      clang-format-Maj.Min
#      clang-format-Maj
#      clang-format

# define a function to check the current $CLANG_FORMAT
valid_clang_format() {
	if which $CLANG_FORMAT > /dev/null 2>&1; then
		if $CLANG_FORMAT --version | grep -q $CLANG_FORMAT_VERSION; then
			echo "Located $CLANG_FORMAT";
			return 0;
		fi
	fi

	return 1;
}

if test ! -e configure.ac; then
    echo "Must be at the root of the entire project."
    exit 1;
fi;

if ! valid_clang_format; then
	# if not valid yet, first try the command line parameter
	CLANG_FORMAT=$1
fi;

if ! valid_clang_format; then
	# Next try the full version
	CLANG_FORMAT=clang-format-$CLANG_MAJOR.$CLANG_MINOR
fi;

if ! valid_clang_format; then
	# Then -maj just in case
	CLANG_FORMAT=clang-format-$CLANG_MAJOR
fi;

if ! valid_clang_format; then
	# Then finally with no version suffix
	CLANG_FORMAT=clang-format
fi;

# Check if we have a valid $CLANG_FORMAT
if ! valid_clang_format; then
	# If we didn't find one, bail out
	echo "Couldn't find correct clang-format version, was looking for $CLANG_FORMAT_VERSION"
	echo "Aircrack-ng requires a very specific clang-format version to ensure there isn't"
	echo "any variance between versions that can happen. You can install it as"
	echo "'clang-format-$CLANG_FORMAT_VERSION' so that it doesn't interfere with any other"
	echo "versions you might have installed, and this script will find it there"
	exit 1;
fi;

# Format all source code
find src -iname '*.h' -a \( ! -path "include/aircrack-ng/third-party/*" -a ! -path "lib/radiotap/*" \) | \
    xargs -n1 $CLANG_FORMAT -i -style=file
find src -iname '*.cpp' -a \( ! -path "include/aircrack-ng/third-party/*" -a ! -path "lib/radiotap/*" \) | \
    xargs -n1 $CLANG_FORMAT -i -style=file
find src -iname '*.c' -a \( ! -path "include/aircrack-ng/third-party/*" -a ! -path "lib/radiotap/*" \) | \
    xargs -n1 $CLANG_FORMAT -i -style=file
$CLANG_FORMAT -i -style=file include/aircrack-ng/third-party/eapol.h
$CLANG_FORMAT -i -style=file include/aircrack-ng/third-party/hashcat.h
