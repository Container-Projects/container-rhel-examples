!/bin/bash

# Update ZK hosts in case they were linked to this container
if [[ `env | grep _PORT_2181_TCP_ADDR` ]]; then
    MIDO_ZOOKEEPER_HOSTS="$(env | grep _PORT_2181_TCP_ADDR | sed -e 's/.*_PORT_2181_TCP_ADDR=//g' -e 's/^.*/&:2181/g' | sort -u)"
    MIDO_ZOOKEEPER_HOSTS="$(echo $MIDO_ZOOKEEPER_HOSTS | sed 's/ /,/g')"
fi

if [ -z "$MIDO_ZOOKEEPER_HOSTS" ]; then
    echo "No Zookeeper hosts specified neither by ENV VAR nor by linked containers"
    exit 1
fi

sed -i -e 's/zookeeper_hosts = .*$/zookeeper_hosts = '"$MIDO_ZOOKEEPER_HOSTS"'/' /etc/midolman/midolman.conf
sed -i -e 's/root_key = .*$/root_key = '"$(echo $MIDO_ZOOKEEPER_ROOT_KEY|sed 's/\//\\\//g')"'/' /etc/midolman/midolman.conf

mn-conf set -t default <<EOF
zookeeper.zookeeper_hosts="$MIDO_ZOOKEEPER_HOSTS"
EOF

exec /sbin/init
