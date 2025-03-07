#!/bin/bash

KAFKA_CLUSTER_ID="$("$KAFKA_HOME"/bin/kafka-storage.sh random-uuid)"
echo "KAFKA_CLUSTER_ID set to $KAFKA_CLUSTER_ID"

"$KAFKA_HOME"/bin/kafka-storage.sh format --standalone -t "$KAFKA_CLUSTER_ID" -c "$KAFKA_HOME"/config/kraft/reconfig-server.properties
nohup "$KAFKA_HOME"/bin/kafka-server-start.sh "$KAFKA_HOME"/config/kraft/reconfig-server.properties &