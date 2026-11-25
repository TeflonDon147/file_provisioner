resource "time_sleep" "wait_for_instance" {
  create_duration = "3m"
  depends_on      = [aws_instance.teflon]
}