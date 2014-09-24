#!/usr/bin/env bats

@test "sudo binary is found in PATH" {
  which sudo
}

@test "rvm binary is found" {
  grep rvm /home/vagrant/.rvm/bin/rvm
}

@test "psql binary is found in PATH" {
  which psql
}

@test "~/.rspec config file exists" {
  grep format /home/vagrant/.rspec
}

@test "config.yml exists" {
  ls /home/vagrant/rails/inaturalist/config/config.yml
}

@test "database.yml exists" {
  ls /home/vagrant/rails/inaturalist/config/database.yml
}

@test "gmaps_api_key.yml exists" {
  ls /home/vagrant/rails/inaturalist/config/gmaps_api_key.yml
}

@test "smtp.yml exists" {
  ls /home/vagrant/rails/inaturalist/config/smtp.yml
}

@test "sphinx.yml exists" {
  ls /home/vagrant/rails/inaturalist/config/sphinx.yml
}
