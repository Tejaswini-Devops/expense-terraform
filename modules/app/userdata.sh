#!/bin/bash

LOG_FILE="/opt/userdata.log"

# Install Ansible and Python 3.12 with pip
dnf install -y ansible python3.12 python3.12-pip &>>"$LOG_FILE"

# Install boto3 and botocore for Python 3.12 (NOT 3.11)
# Use absolute path to ensure you're installing to the correct interpreter
/usr/bin/python3.12 -m pip install boto3 botocore &>>"$LOG_FILE"

# Confirm the libraries are installed
/usr/bin/python3.12 -c "import boto3, botocore; print('✅ boto3 and botocore installed')" &>>"$LOG_FILE"

# Run ansible-pull with Python 3.12 explicitly set
ansible-pull -i "localhost ansible_python_interpreter=/usr/bin/python3.12," \
  -U https://github.com/Tejaswini-Devops/expense-ansible \
  expense.yml \
  -e service_name=${service_name} \
  -e env=${env} &>>"$LOG_FILE"
