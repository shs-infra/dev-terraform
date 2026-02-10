locals {
  is_zip   = lower(var.package_type) == "zip"
  is_image = lower(var.package_type) == "image"
}