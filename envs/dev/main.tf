module "shipment-backend" {
  source = "../../modules/services/shipment-backend"

  stage = var.stage
# custom_domain = var.custom_domain
}