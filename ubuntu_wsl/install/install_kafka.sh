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
User=root
Group=root

Restart=always
ExecStartPre=/opt/kafka/kafka_2.13-3.9.0/bin/zookeeper-server-start.sh /opt/kafka/kafka_2.13-3.9.0/config/zookeeper.properties
ExecStartPre=/bin/sleep 10
ExecStart=/opt/kafka/kafka_2.13-3.9.0/bin/kafka-server-start.sh /opt/kafka/kafka_2.13-3.9.0/config/server.properties
ExecStopPost=rm -rf /tmp/kafka-logs /tmp/zookeeper /tmp/kraft-combined-logs
StandardOutput=append:/var/log/kafka.log
StandardError=append:/var/log/kafka.log

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable and start the Kafka service.
echo "reloading daemon services.."
sudo systemctl daemon-reload
echo "starting kafka service.."
sudo systemctl start kafka
echo "enabling kafka service.."
sudo systemctl enable kafka

echo "Kafka service started on port 9092 - run 'systemctl status kafka' to confirm service running."
