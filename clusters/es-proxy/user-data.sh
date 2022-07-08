#! /bin/bash
sudo sed -i 's/$domain-endpoint/${DOMAIN_ENDPOINT}/' /etc/nginx/conf.d/nginx.conf
sudo systemctl restart nginx.service
