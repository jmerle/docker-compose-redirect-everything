#!/bin/bash

# Check if .env file exists
if [ -e .env ]; then
  source .env
else
  echo "Please copy the .env.example file to .env and fill it with correct values."
  exit 1
fi

# Generate the configuration
file=nginx.conf

if [ ! -e "$file" ]; then
  touch "$file"
else
  > "$file"
fi

echo "http {" >> "$file"

for i in ${!FROM_DOMAINS[@]}; do
  domain="${FROM_DOMAINS[$i]}"
  from="${domain//./\\.}"

  if [ ! "$i" -eq "0" ]; then
    echo "" >> "$file"
  fi

  hosts="{subdomain:.+}.$domain,$domain"
  if [ "$i" -eq "0" ]; then
    export TRAEFIK_HOSTS="$hosts"
  else
    export TRAEFIK_HOSTS="$TRAEFIK_HOSTS,$hosts"
  fi

  echo "  server {
    listen 80;
    server_name ~^(([\w\-\_]+\.?)+)$from$;
    return $REDIRECT_CODE \$scheme://\$1$TARGET_DOMAIN\$request_uri;
  }" >> "$file"
done

echo "}

events {}" >> "$file"

# Create the Traefik network if it does not exist yet
docker network inspect $TRAEFIK_NETWORK &>/dev/null || docker network create $TRAEFIK_NETWORK

# Start the container
docker-compose up -d
