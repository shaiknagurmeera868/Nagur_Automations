cat <<EOF > $WLST_SCRIPT
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
    exit()

# Start the target servers
for server in ${MANAGED_SERVERS[@]}; do
    try:
        start(server, block='false')
        print('Starting server ' + server)
    except:
        print('Failed to start server ' + server)
done

# Start the Application
try:
    startApplication('$APP_NAME')
except:
    print('Failed to start application ' + APP_NAME)

# Disconnect from Admin Server
disconnect()
EOF

