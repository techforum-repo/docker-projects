set -ex
# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=techforum
# image name
IMAGE=sonarqube-with-custom-plugins-aem
# ensure we're up to date

read -p "Enter Version Number:" TAG
git pull

echo $TAG
# run build
./build.bash
# tag it
git add -A
git commit -m $TAG
git tag $TAG
git push
git push --tags
docker tag $USERNAME/$IMAGE:latest $USERNAME/$IMAGE:$TAG
#push it
docker push $USERNAME/$IMAGE:latest
docker push $USERNAME/$IMAGE:$TAG