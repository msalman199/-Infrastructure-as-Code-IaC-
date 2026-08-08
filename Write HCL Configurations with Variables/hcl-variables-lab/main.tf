# main.tf

terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

# The local_file resource writes content to a file on disk
resource "local_file" "student_info" {
  filename = "${path.module}/student_output.txt"

  # TODO: Use string interpolation to combine variables into one string
  # Hint: use join() to convert the list into a comma-separated string
  content = <<-EOT
    Student Name: ${var.student_name}
    Number of Files Requested: ${var.file_count}
    Topics Covered: ${join(", ", var.course_topics)}
  EOT
}
