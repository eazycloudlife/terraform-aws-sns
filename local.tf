locals {
  name = try(trimsuffix(var.name, ".fifo"), "")
}
