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
ExecStartPre=nohup /opt/kafka/kafka_2.13-3.9.0/bin/zookeeper-server-start.sh /opt/kafka/kafka_2.13-3.9.0/config/zookeeper.properties > /var/log/zookeeper.log 2>&1 &
ExecStartPre=/bin/sleep 10
ExecStart=nohup /opt/kafka/kafka_2.13-3.9.0/bin/kafka-server-start.sh /opt/kafka/kafka_2.13-3.9.0/config/server.properties > /var/log/kafka-server.log 2>&1 &
ExecStopPost=nohup /opt/kafka/kafka_2.13-3.9.0/bin/kafka-server-stop.sh > /var/log/kafka-server.log 2>&1 &
ExecStopPost=nohup /opt/kafka/kafka_2.13-3.9.0/bin/zookeeper-server-stop.sh > /var/log/zookeeper.log 2>&1 &
ExecStopPost=rm -rf /tmp/kafka-logs /tmp/zookeeper /tmp/kraft-combined-logs

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable and start the Kafka service.
echo "reloading daemon services.."
sudo systemctl daemon-reload
echo "starting kafka service.."
sudo systemctl start kafka.service
echo "enabling kafka service.."
sudo systemctl enable kafka.service

echo "Kafka service started on port 9092 - run 'systemctl status kafka' to confirm service running."
