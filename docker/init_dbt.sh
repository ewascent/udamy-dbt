#!/bin/bash

echo "We are running OS"
cat /etc/os-release | grep PRETTY_NAME
which dbt
dbt --version
dbt debug

tail -f /dev/null