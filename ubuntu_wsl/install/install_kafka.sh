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

# Correct Kafka home directory
export KAFKA_HOME="/opt/kafka/kafka_2.13-3.9.0"

# Update user profile
echo 'export KAFKA_HOME="/opt/kafka/kafka_2.13-3.9.0/"' >> ~/.bashrc
source ~/.bashrc
echo "Added KAFKA_HOME : $KAFKA_HOME to user profile"

# Ensure log file exists
sudo touch /var/log/kafka.log
sudo chmod 666 /var/log/kafka.log

echo "Configuring Kafka to run as a service..."

# Write the service file using a here-document with sudo tee.
sudo tee /etc/systemd/system/kafka.service > /dev/null << EOF
[Unit]
Description=Apache Kafka KRaft Server
After=network.target

[Service]
User=root
Group=root
Restart=always
ExecStart=$KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/kraft/server.properties
ExecStop=$KAFKA_HOME/bin/kafka-server-stop.sh
StandardOutput=append:/var/log/kafka.log
StandardError=append:/var/log/kafka.log

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable and start the Kafka service.
echo "Reloading daemon services..."
sudo systemctl daemon-reload
echo "Starting Kafka service on port 9092..."
sudo systemctl start kafka.service
echo "Enabling Kafka service..."
sudo systemctl enable kafka.service

echo "Kafka service started on port 9092 - run 'systemctl status kafka' to confirm service running."
