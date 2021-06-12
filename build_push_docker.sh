#!/bin/bash

# build, tag, and push to AWS ECR

if [ $# -ge 1 ]
then
    echo "tag specified $1"
    tag_read=$1
else
    echo "no tag specified. defaulting to latest"
fi

# prerequisites: docker (obviously), awscli configured, and a repo on ECR set up called 'awsgpu'

docker_exec="docker"
# docker_exec="sudo docker"  # depending on your setup you may want this

tag="aws_gpu:${tag_read}"

$docker_exec build --tag $tag .

echo "build over at `date`"

while true; do
    read -p "continue with push?" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "continuing to push..."

iam_role="YOUR_IAM_ROLE"  # fill in
region="us-west-1"  # for example

amazon_url="${iam_role}.dkr.ecr.${region}.amazonaws.com"

echo "logging into AWS for docker..."

aws ecr get-login-password --region ${region} | $docker_exec login --username AWS --password-stdin $amazon_url

$docker_exec tag $tag "$amazon_url/$tag"
echo "pushing..."
$docker_exec push "$amazon_url/$tag"
echo "done at `date`"


