#####
# Reset password
#####
resource "citrixadc_password_resetter" "pw_password_reset" {
  username     = var.adc-base.username
  password     = var.adc-base.oldpassword
  new_password = var.adc-base.password
}