#!/bin/sh

WORKING_DIRECTORY="$PWD"
GITHUB_PAGES_REPO=$1
GITHUB_BRANCH=$2
GITHUB_USERNAME=$3
GITHUB_ACTIONS_REPO=$4
GITHUB_ACTIONS_RUN_ID=$5
GH_TOKEN=$6

[ "$1" ] || {
  echo "ERROR: Environment variable GITHUB_PAGES_REPO is required"
  exit 1
}

[ "$2" ] || {
  echo "ERROR: Environment variable GITHUB_BRANCH is required"
  exit 1
}

[ "$3" ] || {
  echo "ERROR: Environment variable GITHUB_USERNAME is required"
  exit 1
}

[ "$4" ] || {
  echo "ERROR: Environment variable GITHUB_ACTIONS_REPO is required"
  exit 1
}

[ "$5" ] || {
  echo "ERROR: Environment variable GITHUB_ACTIONS_RUN_ID is required"
  exit 1
}

[ -z "$GITHUB_PAGES_BRANCH" ] && GITHUB_PAGES_BRANCH=gh-pages
[ -z "$HELM_CHARTS_SOURCE" ] && HELM_CHARTS_SOURCE="$WORKING_DIRECTORY/charts"
[ -d "$HELM_CHARTS_SOURCE" ] || {
  echo "ERROR: Could not find Helm charts in $HELM_CHARTS_SOURCE"
  exit 1
}
[ -z "$HELM_VERSION" ] && HELM_VERSION=2.8.1
[ "$GITHUB_BRANCH" ] || {
  echo "ERROR: Environment variable GITHUB_BRANCH is required"
  exit 1
}

echo "GITHUB_PAGES_REPO=$GITHUB_PAGES_REPO"
echo "GITHUB_PAGES_BRANCH=$GITHUB_PAGES_BRANCH"
echo "HELM_CHARTS_SOURCE=$HELM_CHARTS_SOURCE"
echo "HELM_VERSION=$HELM_VERSION"
echo "GITHUB_BRANCH=$GITHUB_BRANCH"
echo "GITHUB_ACTIONS_REPO=$GITHUB_ACTIONS_REPO"
echo "GITHUB_ACTIONS_RUN_ID=$GITHUB_ACTIONS_RUN_ID"

echo ">> Checking out $GITHUB_PAGES_BRANCH branch from $GITHUB_PAGES_REPO"
cd /tmp/helm/publish
mkdir -p "$HOME/.ssh"
#ls $HOME/.ssh/
cat $HOME/.ssh/known_hosts
sleep 2
#git config user.email "${GITHUB_USERNAME}@users.noreply.github.com"
#git config user.name Github-Actions-CI
git config user.name
git config user.email
ssh -T git@github.com
sleep 2
echo "$GH_TOKEN"
echo "@@@@@@@@"
#ssh-keyscan -H github.com >> "$HOME/.ssh/known_hosts"
ls -al ~/.ssh
echo "@@@@@@@@"
sleep 2
ssh -T git@github.com
# sleep 2
# ls $HOME/.ssh/
# cat $HOME/.ssh/known_hosts
# sleep 3
#cat $HOME/.ssh/known_hosts
echo "@@@@@@@@!"
#git clone -b "${GITHUB_PAGES_BRANCH}" "https://github.com/${GITHUB_PAGES_REPO}.git"
#git clone -b "${GITHUB_PAGES_BRANCH}" "git@github.com:${GITHUB_PAGES_REPO}.git"
#sudo git clone -b "${GITHUB_PAGES_BRANCH}" "git@github.com:Goobensio/test.git"
git clone -b "${GITHUB_PAGES_BRANCH}" "https://github.com/Goobensio/test.git"
echo "@@@@@@@@!"
alias helm="/tmp/helm/bin/linux-amd64/helm"
cd test/
#cd helm-charts/
git config user.email "${GITHUB_USERNAME}@users.noreply.github.com"
git config user.name Github-Actions-CI
git config user.name
git config user.email
sleep 2
ssh -T git@github.com


echo "-------------------------------------"
echo '>> Building charts...'
sudo find "$HELM_CHARTS_SOURCE" -mindepth 1 -maxdepth 1 -type d | while read chart; do
  chart_name="`basename "$chart"`"
  echo ">>> fetching chart $chart_name version"
  chart_version=$(cat $chart/Chart.yaml | grep -oE "version:\s[0-9]+\.[0-9]+\.[0-9]+" | grep -oE "[0-9]+\.[0-9]+\.[0-9]+")
  echo ">>> helm lint $chart"
  helm lint "$chart"
  echo ">>> helm package -d $chart_name $chart"
  mkdir -p "$chart_name"
  helm package -d "$chart_name" "$chart"
done

echo '>>> helm repo index'
helm repo index .
if [ "$GITHUB_BRANCH" != "refs/heads/master" ]; then
  echo "Current branch is not master and do not publish"
  exit 0
fi
echo "-------------------------------------"
echo ">> Publishing to $GITHUB_PAGES_BRANCH branch of $GITHUB_PAGES_REPO"
git config user.email "${GITHUB_USERNAME}@users.noreply.github.com"
git config user.name Github-Actions-CI
git add .
git status
echo "Message to commit: Published by github actions https://github.com/${GITHUB_ACTIONS_REPO}/actions/runs/${GITHUB_ACTIONS_RUN_ID}"
git commit -m "Published by github actions https://github.com/${GITHUB_ACTIONS_REPO}/actions/runs/${GITHUB_ACTIONS_RUN_ID}" #$CIRCLE_BUILD_URL"
git status
git push "git@github.com:Goobensio/test.git" "${GITHUB_PAGES_BRANCH}"
#git push "https://github.com/Goobensio/test.git" "${GITHUB_PAGES_BRANCH}"
#git push origin "$GITHUB_PAGES_BRANCH"
