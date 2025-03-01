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

sudo tee /opt/kafka/kafka_2.13-3.9.0/kafka-service-start-script.sh > /dev/null << 'EOF'
#!/bin/bash
nohup ./bin/zookeeper-server-start.sh ./config/zookeeper.properties >> /var/log/zookeeper.log 2>&1
sleep 10
nohup ./bin/kafka-server-start.sh ./config/server.properties >> /var/log/kafka-server.log 2>&1
EOF

sudo tee /opt/kafka/kafka_2.13-3.9.0/kafka-service-stop-script.sh > /dev/null << 'EOF'
#!/bin/bash
nohup ./bin/kafka-server-stop.sh >> /var/log/zookeeper.log 2>&1
sleep 10
nohup ./bin/zookeeper-server-stop.sh >> /var/log/kafka-server.log 2>&1
rm -rf /tmp/kafka-logs /tmp/zookeeper /tmp/kraft-combined-logs
EOF

#make executable
sudo chmod +x /opt/kafka/kafka_2.13-3.9.0/*.sh

# Write the service file using a here-document with sudo tee.
sudo tee /etc/systemd/system/kafka.service > /dev/null << 'EOF'
[Unit]
Description=Apache Kafka KRaft Server
After=network.target

[Service]
User=root
Group=root

Restart=always
ExecStart=/opt/kafka/kafka_2.13-3.9.0/kafka-service-start-script.sh
ExecStopPost=/opt/kafka/kafka_2.13-3.9.0/kafka-service-stop-script.sh

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
