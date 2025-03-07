#!/bin/bash
nohup "$KAFKA_HOME"/bin/kafka-server-stop.sh &
rm -rf /tmp/kafka-logs /tmp/zookeeper /tmp/kraft-combined-logs