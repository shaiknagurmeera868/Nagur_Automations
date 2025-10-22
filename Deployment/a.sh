#!/bin/bash

WLST_PATH="/Path/wlst.sh" # Path for wlst.sh
USERNAME="username" # weblogic login user
PASSWORD="Password" # login password
ADMIN_SERVER_URL="url" # Replace with actual Admin Server URL

WAR_FILE_PATH="/Path/NBC.war" # War file path
APP_NAME="Name" # Name of Deployment
MANAGED_SERVERS=("Managed_Server_1", "Managed_Server_2") # depended managed servers
TARGETS=$(IFS=, ; echo "${MANAGED_SERVERS[*]}")

Deploy_SCRIPT="/tmp/deploy_script.py" # Creat a temporary python file

cat <<EOF > $Deploy_SCRIPT
# Connect to the Admin Server
try:
    connect('$USERNAME', '$PASSWORD', '$ADMIN_SERVER_URL')
except:
    print('Failed to connect to the Admin Server.')
    exit()

# Start an edit session
edit()
startEdit()

# Deploy the application
try:
    deploy('$APP_NAME', '$WAR_FILE_PATH', targets='$TARGETS', stageMode='stage', upload='true')
    save()
    activate()
except:
    print('Deployment failed')
    exit()

# Start the target servers
for server in "${MANAGED_SERVERS[@]}"; do
    try:
        start(server, block='false')
        print('Starting server: ' + server)
    except:
        print('Failed to start server: ' + server)
	end
done

# Start the application
try:
    startApplication('$APP_NAME')
except:
    print('Failed to start application: ' + '$APP_NAME')

# Disconnect from Admin Server
disconnect()
EOF

$WLST_PATH $DEPLOY_SCRIPT
rm $DEPLOY_SCRIPT

