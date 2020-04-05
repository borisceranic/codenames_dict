#!/bin/sh

set -e

realpath() {
	[[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}
MYDIR=$(dirname $(realpath "$0"))

cd "$MYDIR/.."

echo "Removing existing dictionaries:"
rm -fv priv/*.txt

echo "Regenerating dictionaries from source files:"
for file in dicts/*.txt; do
	newfile="priv/$(basename "${file}")"
	echo '%% coding: utf-8' > "$newfile"
	echo "$file"
	awk '{print "\"" $0 "\"."}' "$file" >> "$newfile"
done
