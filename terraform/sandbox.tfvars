aws_account = "sandbox"
system_dns_zone_id = "Z3F01K58AELPO9"
apps_dns_zone_id = "Z2J69DYGGLH268"
cf_db_multi_az = "false"
cf_db_backup_retention_period = "0"
cf_db_skip_final_snapshot = "true"
cf_db_maintenance_window = "Tue:07:00-Tue:08:00"
support_email="hector.rivas@mergermarket.com"

# Enabled/disabled resources
# Disable datadog_monitor.total_routes_drop resource
datadog_monitor_total_routes_drop_enabled = 0

pingdom_contact_ids = [  ]

datadog_notification_24x7 = "@pagerduty-datadog-in-hours"
datadog_notification_in_hours = "@pagerduty-datadog-in-hours"
