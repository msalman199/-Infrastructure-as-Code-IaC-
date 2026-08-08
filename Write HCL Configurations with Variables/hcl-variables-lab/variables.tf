# A string variable with a default value
variable "student_name" {
  description = "Name of the student"
  type        = string
  default     = "guest"
}

# A number variable with a default value
variable "file_count" {
  description = "Number of lines to write in the file"
  type        = number
  default     = 1
}

# A list variable with default values
variable "course_topics" {
  description = "List of topics covered in this course"
  type        = list(string)
  default     = ["HCL", "Terraform", "Variables"]
}
