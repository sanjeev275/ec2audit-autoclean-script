#!/bin/bash

# Set threshold in days
THRESHOLD_DAYS=7
NOW=$(date +%s)

echo "📊 EC2 Instance Audit (Running > $THRESHOLD_DAYS days)"
echo "------------------------------------------------------"

# Get all running instances
instances=$(aws ec2 describe-instances \
    --query 'Reservations[*].Instances[*].[InstanceId,LaunchTime,State.Name,Tags]' \
    --output json)

# Loop through each instance
echo "$instances" | jq -c '.[][]' | while read -r instance; do
    INSTANCE_ID=$(echo "$instance" | jq -r '.[0]')
    LAUNCH_TIME=$(echo "$instance" | jq -r '.[1]')
    STATE=$(echo "$instance" | jq -r '.[2]')
    NAME=$(echo "$instance" | jq -r '.[3][]? | select(.Key=="Name") | .Value')

    # Convert launch time to seconds
    LAUNCH_TS=$(date -d "$LAUNCH_TIME" +%s)
    UPTIME_DAYS=$(( (NOW - LAUNCH_TS) / 86400 ))

    if [[ "$STATE" == "running" && "$UPTIME_DAYS" -gt "$THRESHOLD_DAYS" ]]; then
        echo "⚠️  $NAME ($INSTANCE_ID) - $UPTIME_DAYS days"
        
        # Ask to stop it
        read -p "   ↪ Stop instance $INSTANCE_ID? (y/n): " CHOICE
        if [[ "$CHOICE" == "y" ]]; then
            aws ec2 stop-instances --instance-ids "$INSTANCE_ID"
            echo "   🔴 Stopping $INSTANCE_ID..."
        fi
    fi
done
