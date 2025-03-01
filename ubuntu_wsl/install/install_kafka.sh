#!/bin/bash
archiveName="kafka_2.13-3.9.0.tgz"
kafkaUrl="https://dlcdn.apache.org/kafka/3.9.0/$archiveName"
baseFolder="/opt/kafka"

mkdir -p $baseFolder
cd $baseFolder || exit

echo "downloading kafka from: $kafkaUrl"
wget $kafkaUrl

echo "extracting archive.."
tar -xzf $archiveName

echo "dir.."
ls -ltra

echo "configuring kafka to run as a service.."

sudo sh -c echo '
[Unit]
Description=Apache Kafka KRaft Server
After=network.target

[Service]
Type=simple
# Set the working directory where Kafka is installed (adjust as needed)
WorkingDirectory="/opt/kafka/kafka_2.13-3.9.0
# Run as a specific user/group; ensure this user has permissions for the Kafka files and storage
User=kafka
Group=kafka
# Set Kafka to listen on port 9092 for client connections
#Environment="KAFKA_LISTENERS=PLAINTEXT://:9092"
# Advertise the external address (update your.host.name as needed)
#Environment="KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://your.host.name:9092"
# Generate a random cluster ID, format storage, then start Kafka
ExecStartPre=/bin/sh -c 'KAFKA_CLUSTER_ID="$(./bin/kafka-storage.sh random-uuid)" && ./bin/kafka-storage.sh format --standalone -t $KAFKA_CLUSTER_ID -c ./config/kraft/reconfig-server.properties'
ExecStart=./bin/kafka-server-start.sh ./config/kraft/reconfig-server.properties
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
' > /etc/systemd/system/kafka.service

sudo systemctl daemon-reload #reload system services
sudo systemctl enable kafka #enable service to start on boot
sudo systemctl start kafka #start kafka service
echo "kafka service started on port 9092 - run 'systemctl status kafka' to confirm service running"

