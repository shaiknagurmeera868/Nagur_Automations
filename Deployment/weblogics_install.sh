#!/bin/bash

# Define Variables
servers=("1.12.23.21" "1.12.23.22" "1.12.23.23" "1.12.23.24")
login_username="Munna"
login_password="your_password"
script_path="/nagur/meera/shaik.sh"
files=("Bhai.zip" "nmr.zip")
source_path="/path/to/files/"
destination_path="/path/to/destination/"
WLST_PATH="$WL_HOME/common/bin/wlst.sh"
USERNAME="weblogic_user"
PASSWORD="weblogic_password"
ADMIN_SERVER_URL="t3://1.12.23.21:7001"
WAR_FILE_PATH="/path/to/your/application.war"
APP_NAME="nagur"
MANAGED_SERVERS=("managed_server_11" "managed_server_12")
WLST_STOP_SCRIPT="/tmp/deploystop_script.py"
WLST_DEPLOY_SCRIPT="/tmp/deploy_script.py"

# Create the WLST stop script
cat <<EOF > $WLST_STOP_SCRIPT
# Connect to the Admin Server
connect('$USERNAME', '$PASSWORD', '$ADMIN_SERVER_URL')

# Start an edit session
edit()
startEdit()

# Stop the application
stopApplication('$APP_NAME')

# Delete the application
undeploy('$APP_NAME')

# Save and activate changes
save()
activate()

# Stop the managed servers
for server in ${MANAGED_SERVERS[@]}; do
    try:
        shutdown(server, 'Force')
        print('Shutdown command issued to', server)
    except:
        print('Error shutting down', server)
done

# Disconnect from Admin Server
disconnect()
EOF

# Execute the WLST stop script
echo "Stopping application and managed servers..."
$WLST_PATH $WLST_STOP_SCRIPT

# Clean up the temporary WLST stop script
rm $WLST_STOP_SCRIPT

# Function to execute the script and move files
process_server() {
    local source_server=$1
    local target_server=$2

    # Execute the script on the source server
    echo "Executing $script_path on $source_server..."
    sshpass -p "$login_password" ssh $login_username@$source_server "bash $script_path"

    # Move files from the source server to the target server
    echo "Moving files from $source_server to $target_server..."
    for file in "${files[@]}"; do
        sshpass -p "$login_password" ssh $login_username@$source_server "mv $source_path$file $destination_path"
        sshpass -p "$login_password" scp $login_username@$source_server:$destination_path$file $login_username@$target_server:$destination_path
    done

    # Execute the script on the target server
    echo "Executing $script_path on $target_server..."
    sshpass -p "$login_password" ssh $login_username@$target_server "bash $script_path"
}

# Loop through servers in pairs
for ((i = 0; i < ${#servers[@]}-1; i++)); do
    process_server "${servers[$i]}" "${servers[$i+1]}"
done

# Process the last server (if needed)
last_server="${servers[-1]}"
echo "Processing final server $last_server..."
sshpass -p "$login_password" ssh $login_username@$last_server "bash $script_path"

# Create the WLST deployment script
cat <<EOF > $WLST_DEPLOY_SCRIPT
# Connect to the Admin Server
try:
    connect('$USERNAME', '$PASSWORD', '$ADMIN_SERVER_URL')
except:
    print('Failed to connect to the Admin Server')
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
    print('Error:', sys.exc_info()[0])
    exit()

# Start the target servers
for server in ${MANAGED_SERVERS[@]}; do
    try:
        start(server, block='true')
        print('Start command issued to', server)
    except:
        print('Failed to start server ' + server)

# Start the application
try:
    startApplication('$APP_NAME')
    print('Application started successfully')
except:
    print('Failed to start application ' + APP_NAME)

# Disconnect from Admin Server
disconnect()
EOF

# Run the deployment script
echo "Running deployment script..."
$WLST_PATH $WLST_DEPLOY_SCRIPT

# Clean up the temporary WLST deployment script
rm $WLST_DEPLOY_SCRIPT