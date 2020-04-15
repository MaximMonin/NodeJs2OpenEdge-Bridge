#!/bin/bash

set -e

source env.conf

docker-compose down --timeout 60
