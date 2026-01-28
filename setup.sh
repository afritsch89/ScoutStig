#!/usr/bin/env bash
set -e
source ./stigctl.conf
mariadb -e "CREATE DATABASE IF NOT EXISTS $database;"
mariadb $database < schema.sql
echo "ScoutStig DB setup complete."
