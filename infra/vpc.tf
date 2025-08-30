# VPC WAN
resource "google_compute_network" "vpc_wan" {
  name                    = "${var.vpc_name}-wan"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet_wan" {
  name          = "${var.vpc_name}-subnet-wan"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc_wan.self_link
}

# VPC LAN
resource "google_compute_network" "vpc_lan" {
  name                    = "${var.vpc_name}-lan"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet_lan" {
  name          = "${var.vpc_name}-subnet-lan"
  ip_cidr_range = "10.0.2.0/24"
  region        = var.region
  network       = google_compute_network.vpc_lan.self_link
}