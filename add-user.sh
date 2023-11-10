#!/bin/bash

dnf install -y sudo passwd

useradd user
usermod -aG wheel user
echo 'user' | passwd user --stdin
