#!/bin/bash -e

cd `dirname $0`/..

if [ "$#" -ne 3 ]; then
    echo "Usage: $(basename $0) login_server_release_version login_server_next_dev_version uaa_next_dev_version"
    exit 1
fi

echo Deploying and finishing Login Server release $1

set -x

unset GEM_PATH
git checkout releases/$1
mvn deploy -DskipTests=true
git checkout master
git merge releases/$1 --no-ff
git tag -a $1 -m "$1 release of the Login Server"
git push origin master --tags
git co develop
git merge releases/$1 --no-ff
git branch -d releases/$1
./scripts/set-version.sh $2 $3
git commit -am "Bump next developer version"


set +x

echo Maven deploy made from releases/$1
echo
echo releases/$1 merged into master, tagged and pushed
echo
echo releases/$1 back merged into develop
echo
echo UAA version bumped to $3 on develop
echo Login Server version bumbed to $2 on develop
echo
echo Check the dev versions, ammend if necessary, and push the changes
