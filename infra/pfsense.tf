# Bucket para armazenar a imagem
resource "google_storage_bucket" "pfsense_bucket" {
  name          = "${var.project_id}-pfsense-images"
  location      = var.region
  force_destroy = true
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "pfsense_sa_access" {
  bucket = google_storage_bucket.pfsense_bucket.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${jsondecode(file("${var.credentials_file}")).client_email}"
}

# Firewall para permitir acesso à interface web do pfSense (porta 80 e 443)
resource "google_compute_firewall" "allow_pfsense_web" {
  name    = "allow-pfsense-web"
  network = google_compute_network.vpc_wan.self_link

  allow {
    protocol = "tcp"
    ports    = ["443", "80", "22"]
  }

  # Aqui você pode limitar por IP (ex: só sua máquina)
  source_ranges = ["0.0.0.0/0"] # cuidado: isso abre pro mundo todo
}




# Obs: Ativar abaixo apenas no 2º apply em diante

# Imagem customizada (depois que você fizer o upload do .raw.tar.gz)
resource "google_compute_image" "pfsense_image" {
  name = "pfsense-custom-image"

  raw_disk {
    source = "https://storage.googleapis.com/${google_storage_bucket.pfsense_bucket.name}/pfsense.raw.tar.gz"
  }
}

# Instância pfSense
resource "google_compute_instance" "pfsense" {
  name         = "pfsense-fw"


  machine_type = "e2-medium"
  zone         = "us-central1-a"

  # Permite para a instância para aplicar alterações
  allow_stopping_for_update = true

  # garante que as subnets existem antes da VM
  depends_on = [
    google_compute_subnetwork.subnet_lan,
    google_compute_subnetwork.subnet_wan
  ]

  boot_disk {
    initialize_params {
      image = google_compute_image.pfsense_image.self_link
      size  = 20
    }
  }

  # Interface WAN
  network_interface {
    subnetwork = google_compute_subnetwork.subnet_wan.self_link
    access_config {}
    }

  # Interface LAN
  network_interface {
    subnetwork = google_compute_subnetwork.subnet_lan.self_link
    }

  # Habilite também na console o acesso via console serial
  # gcloud config set project <project_name>
  # 
  # Para acessar a console serial:
  # gcloud compute connect-to-serial-port pfsense-fw --zone us-central1
  #
  # Habilita console serial
  metadata = {
    serial-port-enable = "1"
  }
}


