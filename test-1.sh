#!/bin/sh

set -e

#trigger-ci2
#VAR=$(curl -s -X GET 'https://api.github.com/repos/Rookout/helm-charts/issues/48/labels')
OWNER="rookout"
REPO_NAME="helm-charts"
PR_NUMBER=48
#echo $PR_NUMBER
#echo $OWNER
VAR=$((curl --connect-timeout 5 --max-time 5 --retry 4 --retry-delay 0 --retry-max-time 20 -s 'https://api.github.com/repos/'"${OWNER}"'/'"${REPO_NAME}"'/issues/'"${PR_NUMBER}"'/labels' | grep "name") | sed 's/name//g; s/"//g; s/,//g; s/://g; s/ //g')
#VAR=$(curl --connect-timeout 5 --max-time 5 --retry 4 --retry-delay 0 --retry-max-time 20 -s 'https://api.github.com/repos/'"${OWNER}"'/'"${REPO_NAME}"'/issues/'"${PR_NUMBER}"'/labels' | grep "name")
#VAR=$(curl -s 'https://api.github.com/repos/Rookout/helm-charts/issues/48/labels' | grep "name")
#VAR=$(curl -s 'https://api.github.com/repos/Rookout/docs/issues/472/labels' | grep "name")  # Check do not merge label
echo "accessing: https://api.github.com/repos/"${OWNER}"/"${REPO_NAME}"/issues/"${PR_NUMBER}"/labels "
#echo $(sed -e 's/,/\n/g;s/"//g;s/{//g;s/}//g' $VAR)
#echo $VAR
WORDTOREMOVE='"name":'
WORDTOREMOVE2='"'
WORDTOREMOVE3=','

echo $VAR

#VAR=$(sed -n "s/"name"//g" "$VAR")
#sed 's/"//g' $VAR
#sed 's/,//g' $VAR

#VAR=${VAR//$WORDTOREMOVE/$WORDTOREMOVE2}}
#echo $VAR | sed -e 's/^.*"endTime":"\([^"]*\)".*$/\1/'
#VAR=${sed -e 's/^.*"endTime":"\([^"]*\)".*$/\1/'}

#VAR=${sed 's/name/~~/g; s/"/~~/g; s/,/~~/g' $VAR}
#VAR=${sed '/$WORDTOREMOVE\|$WORDTOREMOVE2\|$WORDTOREMOVE3/d' $VAR}

#VAR=${{VAR//$WORDTOREMOVE/} & {VAR//$WORDTOREMOVE2/} }
#echo sed "s/"name"/"OK"/g" "$VAR"

#VAR=$(sed 's/name/OK/' <<< "$VAR")
#VAR=$(sed 's/name//g; s/"//g; s/,//g; s/://g; s/do not merge/do_not_merge/g' <<< "$VAR")
#VAR=$(sed 's/name//g; s/"//g; s/,//g; s/://g; s/ //g' <<< "$VAR")  # Working version, changes color of the rest after it.
#VAR=$(sed 's/name//g; s/"//g; s/,//g; s/://g; s/ //g' <<< "$VAR")

#VAR=${VAR//$WORDTOREMOVE/}
#VAR=${VAR//$WORDTOREMOVE2/}
#VAR=${VAR//$WORDTOREMOVE3/}
#touch file.txt
#echo $VAR >> file.txt
#cat file.txt
#chmod 775 file.txt
#sed -E -i '' 's/[[:<:]]('name'|"|,)[[:>:]]//g' file.txt
#sed 's/"name"/'"'/","/g;s/""/""/""/g' VAR

echo $VAR

#if [ -z "$VAR" ] || [[ -z $(grep "controller" $VAR) ]  && [-z $(grep "datastore" $VAR)] && [-z $(grep "operator" $VAR)]]; then
#  echo "ERROR: No labels found / didn't find a label named controller/datastore/operator"
#fi

for VARIABLE in $VAR; do
# Check if regular label
if [ $VARIABLE = "DeployEnforcer/MergeOnceApproved" ] || [ $VARIABLE = "donotmerge" ]; then
  echo "Im a enforcer label"
else
  echo "Im a regular label"
fi
if [ $VARIABLE = "controller" ] || [ $VARIABLE = "datastore" ] || [ $VARIABLE = "operator" ]; then
  echo Special label: $VARIABLE
else
  echo skip label: $VARIABLE
fi
done

#for i in $(echo $VAR | tr "," "\n")
#do
  # process #
#done

#CI_PR=(curl -X GET -u {GITHUB_TOKEN}:x-oauth-basic 'https://api.github.com/repos/{CIRCLE_PROJECT_USERNAME}/{CIRCLE_PROJECT_REPONAME}/pulls?head={CIRCLE_PROJECT_USERNAME}:{CIRCLE_BRANCH}’ | jq “.[0].url”)

#echo $CI_PR

#work_dir="$PWD"
#echo $work_dir

#echo "env_pwd=$PWD"
#echo "pwd=$PWD"

# execute the statement which follows only if the preceding statement failed #
#[ "$GITHUB_PAGES_REPO" ] || { 
#  echo "ERROR: Environment variable GITHUB_PAGES_REPO is required"
#  exit 1
#}
