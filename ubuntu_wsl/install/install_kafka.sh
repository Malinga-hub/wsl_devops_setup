#!/bin/bash
archiveName="kafka_2.13-3.9.0.tgz"
kafkaUrl="https://dlcdn.apache.org/kafka/3.9.0/$archiveName"
baseFolder="/opt/kafka"

# Create the base folder and change into it
mkdir -p "$baseFolder"
cd "$baseFolder" || exit

echo "Downloading Kafka from: $kafkaUrl"
wget -nc "$kafkaUrl"

echo "Extracting archive..."
tar -xzf "$archiveName"

echo "Directory listing:"
ls -ltra

echo "Configuring Kafka to run as a service..."

sudo tee ~/.bashrc > /dev/null << 'EOF'
export KAFKA_HOME="/opt/kafka_2.13-3.9.0/"
EOF
source ~/.bashrc
echo "added KAKFA_HOME : $KAFKA_HOME to user profile"

# Write the service file using a here-document with sudo tee.
sudo tee /etc/systemd/system/kafka.service > /dev/null << 'EOF'
[Unit]
Description=Apache Kafka KRaft Server
After=network.target

[Service]
User=root
Group=root

Restart=always
ExecStartPre=$KAFKA_HOME/bin/zookeeper-server-start.sh $KAFKA_HOME/config/zookeeper.properties
ExecStartPre=/bin/sleep 10
ExecStart=$KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties
ExecStopPost=$KAFKA_HOME/bin/kafka-server-start.sh
ExecStopPost=$KAFKA_HOME/bin/zookeeper-server-start.sh
StandardOutput=append:/var/log/kafka.log
StandardError=append:/var/log/kafka.log

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable and start the Kafka service.
echo "reloading daemon services.."
sudo systemctl daemon-reload
echo "starting kafka service on port 9092.."
sudo systemctl start kafka.service
echo "enabling kafka service.."
sudo systemctl enable kafka.service

echo "Kafka service started on port 9092 - run 'systemctl status kafka' to confirm service running."
