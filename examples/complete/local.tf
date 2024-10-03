locals {
  region = "us-east-1"
  name   = "ezcl-event-${basename(path.cwd)}"

  tags = {
    Name       = local.name
    Example    = basename(path.cwd)
    Repository = "https://github.com/eazycloudlife/terraform-aws-sns"
  }
}
