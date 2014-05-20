#!/usr/bin/env bash

# Use identical RabbitMQ cookie for each node
ERLANG_COOKIE=PXANOXMISGPVHJZPWGKD
echo ${ERLANG_COOKIE} > /var/lib/rabbitmq/.erlang.cookie
chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie
chmod 600 /var/lib/rabbitmq/.erlang.cookie

service rabbitmq-server stop

# Enable management ui
/usr/lib/rabbitmq/bin/rabbitmq-plugins enable rabbitmq_management

# Backup old rabbitmq config
if [[ ! -f /etc/rabbitmq/rabbitmq.config.backup ]]; then
    cp /etc/rabbitmq/rabbitmq.config /etc/rabbitmq/rabbitmq.config.backup 2>/dev/null || :
fi
