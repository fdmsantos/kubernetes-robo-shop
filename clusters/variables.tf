# ========================== APP ============================
variable "name_prefix" {
  type    = string
  default = "robotshop"
}

variable "domain" {
  type    = string
  default = "meraki-mv-rekognition.aws.outscope.com"
}
# ===========================================================

# ========================== GIT ============================
variable "github_user" {
  description = "GitHub owner"
  type        = string
}

variable "github_token" {
  description = "GitHub token"
  type        = string
  sensitive   = true
}

variable "git_repository_name" {
  description = "Git main repository to use for installation"
  type        = string
}

variable "git_repository_branch" {
  description = "Branch name to use on the Git repository"
  type        = string
  default     = "main"
}

variable "git_repository_sync_path" {
  description = "Git repository directory path to use for Flux CD sync"
  type        = string
}

variable "github_ssh_pub_key" {
  description = "GitHub SSH public key"
  type        = string
  default     = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg="
}

# ===========================================================

# ======================== Versions =========================
variable "istio_verion" {
  description = "Istio Version"
  type        = string
  default     = "1.14.1"
}

variable "kiali_verion" {
  description = "Kiali Version"
  type        = string
  default     = "1.52.0"
}
# ===========================================================

# ======================== Addons =========================
variable "enable_elasticsearch" {
  type    = bool
  default = true
}
# ===========================================================