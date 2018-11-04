#!/bin/bash

# visualize repository
# only git is supported by this script at the moment

REPO=${1:?Path to a git repository path is required}

SD=$(readlink -e `dirname $0`)

if ! test -d $REPO/.git; then
    echo "Error: git repository isn't found in $REPO" 2>&1
    exit 10
fi

cd $REPO
git log --name-status --pretty=format:'%n------------------------------------------------------------------------%nr%h | %ae | %ai (%aD) | x lines%nChanged paths:' \
    >$SD/activity.log

cd $SD

python convert_logs/convert_logs.py -s activity.log activity.xml

java -Xmx1000m -classpath dist/code_swarm.jar:lib/core.jar:lib/xml.jar:lib/vecmath.jar:. code_swarm default.config
