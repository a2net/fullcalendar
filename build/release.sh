#!/usr/bin/env bash

cd "`dirname $0`/.."

read -p "Enter the new version number with no 'v' (for example '1.0.1'): " version

if [[ ! "$version" ]]
then
	exit
fi

grunt bump --setversion=$version && \
grunt dist && \
npm run-script no-assume-unchanged && \
git add -f dist/*.js dist/*.css dist/lang/*.js && \
git add *.json && \
git commit -e -m "version $version" && \
git tag -a v$version -m "version $version"

status=$?

# regardless of error/success, undo the temporary no-assume-unchanged
git reset
npm run-script assume-unchanged

if [ $status -eq 0 ]
then
	echo
	echo 'DONE. It is now up to you to run `'"git push origin master && git push origin v$version"'`'
	echo
fi