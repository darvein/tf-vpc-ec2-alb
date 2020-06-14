#!/bin/bash

sudo apt update
sudo apt -y install nginx

sudo systemctl start nginx
sudo systemctl enable nginx

echo "Check OK" | sudo tee /var/www/html/status.html
