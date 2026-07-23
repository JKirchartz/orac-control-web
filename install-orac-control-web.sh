#!/bin/bash

REPO_NAME=orac-control-web
REPO_URL=https://github.com/JKirchartz/$REPO_NAME.git
APP_DIR=/usr/local/orac-control-web
WORK_DIR="$HOME/$REPO_NAME"

cd $HOME

pwd

if [ -z `which git` ]; then
	echo "Installing git..."
	sudo apt-get update
	sudo apt-get install -y git
fi

if [ ! -d "$REPO_NAME" ]; then
	echo Cloning repository from $REPO_URL
	git clone $REPO_URL "$WORK_DIR"
	cd $REPO_NAME
else
	echo Updating $REPO_NAME repository with latest stuff
	cd "$WORK_DIR"
	git pull
fi

echo "Setup started..."
sudo apt install add-apt-repository
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.7 python3.7-venv

cd $WORK_DIR/backend
python3.7 -m venv .venv
. .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
deactivate
sudo rm -rf $APP_DIR
sudo mkdir -p $APP_DIR/client $APP_DIR/backend
sudo cp -R "$WORK_DIR/client/." $APP_DIR/client
sudo cp -R "$WORK_DIR/backend/." $APP_DIR/backend
cd $REPO_NAME
sudo install -v -m 644 "$WORK_DIR/orac-control-web.service" /usr/lib/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable orac-control-web.service
sudo systemctl start orac-control-web.service

echo "Done! Thank you!"
