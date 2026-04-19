#!/bin/bash

while true; do
    php /var/www/html/cron_copy_hitcount.php
    php /var/www/html/cron_metadata_field_check.php
    php /var/www/html/cron_resource_log.php
    sleep 300
done
