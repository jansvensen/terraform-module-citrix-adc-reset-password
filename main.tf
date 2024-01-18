#####
# Reset password
#####
resource "citrixadc_password_resetter" "pw_password_reset" {
  username     = var.adc-base.username
  password     = "nsroot"
  new_password = var.adc-base.password
}

#####
# Wait a few seconds
#####
resource "time_sleep" "pw_wait_a_few_seconds" {
  create_duration = "15s"

  depends_on = [
    citrixadc_password_resetter.pw_password_reset
  ]
}

#####
# Save config
#####
resource "citrixadc_nsconfig_save" "pw_save" {    
    all       = true
    timestamp = timestamp()
    
    # Will not error when save is already in progress
    concurrent_save_ok = true

    # Set to non zero value to retry the save config operation
    # Will throw error if limit is surpassed
    concurrent_save_retries = 3

    # Time interval between save retries
    concurrent_save_interval = "10s"

    # Total timeout for all retries
    concurrent_save_timeout = "1m"

  depends_on = [
    time_sleep.pw_wait_a_few_seconds
  ]
}

#####
# Wait a few seconds
#####
resource "time_sleep" "pw_wait_a_few_seconds_last" {
  create_duration = "15s"

  depends_on = [
    citrixadc_nsconfig_save.pw_save
  ]
}