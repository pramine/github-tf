provider "github" {
  organization = "runatlantis"
}

# The runatlantis/github-tf repository. This is actually
# where this file lives. This repo holds the Terraform
# for managing the rest of the GitHub organization.
resource "github_repository" "github_tf" {
  name        = "github-tf"
  description = "Manages the GitHub users for the runatlantis organizatio"
}

# The team that has permissions to manage the runatlantis/github-tf.
resource "github_team" "github_tf_writers" {
  name        = "github-tf-writers"
  description = "github-tf-writers"
  privacy     = "closed"
}

# Team the newhire should be on.
resource "github_team" "newhire_team" {
  name        = "newhire_team"
  description = "newhire_team"
  privacy     = "closed"
}

# Give the github-tf-writers team permissions to write to the runatlantis/github-tf
# repo.
resource "github_team_repository" "github_tf_writers" {
  team_id    = "${github_team.github_tf_writers.id}"
  repository = "${github_repository.github_tf.name}"
  permission = "push"
}

variable newhire_username {
  default = "lkysow"
}

# Operator adds the newhire to the organization so they
# can create their own pull request.
resource "github_membership" "newhire_org_membership" {
  username = "${var.newhire_username}"
  role     = "admin"                   # todo: change to member
}

# Operator adds the new hire to the team with write permissions
# to the github organization repo.
resource "github_team_membership" "newhire_tf_writers" {
  team_id  = "${github_team.github_tf_writers.id}"
  username = "${var.newhire_username}"
  role     = "maintainer"                          # todo: change to member
}

# New hire creates their own pull request to add themselves
# to their team's github team.
resource "github_team_membership" "newhire_team_membership" {
  team_id  = "${github_team.newhire_team.id}"
  username = "${var.newhire_username}"
  role     = "member"
}
