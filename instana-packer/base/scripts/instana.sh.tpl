#!/bin/bash
# This script enables 'set -e' to ensure that the script exits immediately if any command returns a non-zero status.
# This helps prevent the script from continuing execution in case of errors, improving reliability and safety.
set -e

# Variables
AGENT_KEY=${instana_agent_key}

curl -o setup_agent.sh https://setup.instana.io/agent && chmod 700 ./setup_agent.sh && sudo ./setup_agent.sh -a $AGENT_KEY -d $AGENT_KEY -t dynamic -e ingress-blue-saas.instana.io:443  -y -s