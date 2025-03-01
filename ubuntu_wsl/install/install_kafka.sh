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

# Write the service file using a here-document with sudo tee.
sudo tee /etc/systemd/system/kafka.service > /dev/null << 'EOF'
[Unit]
Description=Apache Kafka KRaft Server
After=network.target

[Service]
Type=simple
WorkingDirectory=/opt/kafka/kafka_2.13-3.9.0
User=root
Group=root
# Generate a random cluster ID, format storage, then start Kafka
ExecStartPre=/opt/kafka/kafka_2.13-3.9.0/bin/zookeeper-server-start.sh config/zookeeper.properties
ExecStart=/opt/kafka/kafka_2.13-3.9.0/bin/kafka-server-start.sh config/server.properties
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable and start the Kafka service.
sudo systemctl daemon-reload
sudo systemctl enable kafka
sudo systemctl start kafka

echo "Kafka service started on port 9092 - run 'systemctl status kafka' to confirm service running."
