umesh.pendhare

#!/bin/bash

# install nginx
sudo yum update -y
sudo amazon-linux-extras install nginx1 -y 

# install data-dog agent
export DD_AGENT_MAJOR_VERSION=7 
export DD_API_KEY=9154fe02fdf0717ab5c42db7b25b3c08 
export DD_SITE="datadoghq.com" 
bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"

# enable logs in datadog agent
# cat /etc/datadog-agent/datadog.yaml | grep "logs_enabled: false" 
sed -i -e 's/# logs_enabled: false/logs_enabled: true/g' /etc/datadog-agent/datadog.yaml

# datadog config files for nginx
# /etc/datadog-agent/conf.d/nginx.d/conf.yaml  # log streams
curl -s https://raw.githubusercontent.com/ChaitanyaChandra/DataDog/main/conf.yaml > /etc/datadog-agent/conf.d/nginx.d/conf.yaml


# nginx config files
# /etc/nginx/conf.d/status.conf             # config file for status of nginx  
curl -s https://raw.githubusercontent.com/ChaitanyaChandra/DataDog/main/status.conf > /etc/nginx/conf.d/status.conf

# /etc/nginx/nginx.conf                     # for log formetting
curl -s https://raw.githubusercontent.com/ChaitanyaChandra/DataDog/main/nginx.conf > /etc/nginx/nginx.conf

# restart and enable nginx, data-dog agent
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl enable datadog-agent
sudo systemctl restart datadog-agent