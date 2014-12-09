#!/usr/bin/env bats

@test "git binary is found in PATH" {
  which git
}

@test "vim binary is found in PATH" {
  which vim
}

@test "curl binary is found in PATH" {
  which curl
}
