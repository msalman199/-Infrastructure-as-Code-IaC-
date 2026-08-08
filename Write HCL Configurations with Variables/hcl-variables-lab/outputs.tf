# outputs.tf

# Displays the path of the created file after apply
output "file_path" {
  description = "Path to the generated file"
  value       = local_file.student_info.filename
}

# Displays the student name used
output "student_name_output" {
  description = "Name of the student used in the configuration"
  value       = var.student_name
}

# TODO: Add one more output that displays the course_topics list
