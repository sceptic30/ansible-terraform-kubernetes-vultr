#!/bin/sh
export ANSIBLE_HOST_KEY_CHECKING=False
export command_warnings=False
export deprecation_warnings=False
terraform init
terraform apply
echo "Installation completed"
