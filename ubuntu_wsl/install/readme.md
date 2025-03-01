# Run in this Order
- java_install.sh
- docker_install.sh
- microk8s_install.sh (requires docker)
- jenkins_install.sh
- kafka_install.sh


For custom Runs ensure to comment out what is not needed from the individual bash scripts

NOTE: for kafka no uninstall script necessary just run "systemctl stop kafka"