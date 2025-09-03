
module "network" {
  source   = "../infra"
  
  project_id = "745945782978"
  region     = "us-central1"
  vpc_name   = "minha-vpc"
  credentials_file = "/home/fernandogalvao/GIP/GCP/credentials/boxwood-chalice-470513-e3-396a65bc6ecc.json"
  pfsense_image_name = "pfsense-272-image"
}
