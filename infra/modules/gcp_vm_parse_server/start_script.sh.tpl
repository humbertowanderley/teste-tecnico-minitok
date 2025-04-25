#!/bin/bash
docker run -d \
    --name parse-server \
    -p 1337:1337 \
    --restart unless-stopped \
    -e PARSE_SERVER_APPLICATION_ID=${parse_app_id} \
    -e PARSE_SERVER_MASTER_KEY=${parse_master_key} \
    -e PARSE_SERVER_DATABASE_URI=${database_uri} \
    -e PARSE_SERVER_CLIENT_KEY=${parse_client_key} \
    -e PARSE_SERVER_ALLOW_CLIENT_CLASS_CREATION=true \
    parseplatform/parse-server:8.1.0

curl -X GET -H "X-Parse-Application-Id: minitok-app-id" http://localhost:1337/parse/classes/Video/
