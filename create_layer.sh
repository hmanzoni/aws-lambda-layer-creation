#!/bin/bash

PKG="python"
if [ $1 ]
then
    PKG=$1
    # Create python requirements 
    echo $PKG > requirements.txt
fi

# Set the directory where the Dockerfile and requirements.txt are located
DIRECTORY="$(pwd)"

# Change it as per your requirement
LAYER_NAME="$PKG-layer"

# Change it as per your requirement
IMG_NAME="lambda-layer"


# Build the Docker image
docker build -t $IMG_NAME "$DIRECTORY"

# Run the Docker container to create the layer
docker run --name $IMG_NAME-container -v "$DIRECTORY:/app" $IMG_NAME

# create layers directory, if not created.
mkdir -p layers

# Copy file from the app folder to layers
docker cp $IMG_NAME-container:/app/layer.zip ./$LAYER_NAME.zip

# Move the zip file in layers directory.
mv "$DIRECTORY/$LAYER_NAME.zip" "$DIRECTORY/layers/$LAYER_NAME.zip"

# Stop the conainer
docker stop $IMG_NAME-container

# Remove the running conainer
docker rm $IMG_NAME-container

# Cleanup: remove the Docker image
docker rmi --force $IMG_NAME