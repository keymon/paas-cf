output "cf1_subnet_id" {
  value = "${aws_subnet.cf.0.id}"
}

output "cf2_subnet_id" {
  value = "${aws_subnet.cf.1.id}"
}

output "cf3_subnet_id" {
  value = "${aws_subnet.cf.2.id}"
}

output "cell1_subnet_id" {
  value = "${aws_subnet.cell.0.id}"
}

output "cell2_subnet_id" {
  value = "${aws_subnet.cell.1.id}"
}

output "router1_subnet_id" {
  value = "${aws_subnet.router.0.id}"
}

output "router2_subnet_id" {
  value = "${aws_subnet.router.1.id}"
}

output "cf_root_domain" {
  value = "${var.system_dns_zone_name}"
}

output "cf_apps_domain" {
  value = "${var.apps_dns_zone_name}"
}

output "cf_rds_client_security_group" {
  value = "${aws_security_group.cf_rds_client.name}"
}

output "cf_db_address" {
  value = "${aws_db_instance.cf.address}"
}

output "elb_name" {
  value = "${aws_elb.router.name}"
}

output "cf_cc_elb_name" {
  value = "${aws_elb.cf_cc.name}"
}

output "cf_uaa_elb_name" {
  value = "${aws_elb.cf_uaa.name}"
}

output "cf_ssh_proxy_elb_name" {
  value = "${aws_elb.ssh_proxy.name}"
}

output "logsearch_ingestor_elb_name" {
  value = "${aws_elb.logsearch_ingestor.name}"
}

output "logsearch_ingestor_elb_dns_name" {
  value = "${aws_elb.logsearch_ingestor.dns_name}"
}

output "logsearch_elastic_master_elb_name" {
  value = "${aws_elb.logsearch_es_master.name}"
}

output "logsearch_elastic_master_elb_dns_name" {
  value = "${aws_elb.logsearch_es_master.dns_name}"
}

output "logsearch_elb_name" {
  value = "${aws_elb.logsearch_kibana.name}"
}

output "metrics_elb_name" {
  value = "${aws_elb.metrics.name}"
}
