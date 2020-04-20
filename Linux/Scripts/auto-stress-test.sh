# Torture test for CPU and RAM

#!/bin/bash

# Check if script is running as root
if [[ $EUID -ne 0 ]]; then
  echo "You must run this script as root..."
  exit -1
fi

# Calculate max CPU core and RAM
CPU="$(nproc)"
STRESS_CPU=$(($CPU * 2))
RAM_KB="$(awk '/MemTotal/ {print $2}' /proc/meminfo)"
RAM_GB=$(($RAM_KB / 1024 / 1024 - 1))
TIME="86400s"

# Launch one day stress test
stress-ng --cpu $STRESS_CPU --vm $RAM_GB --vm-bytes 1G --timeout $TIME --metrics-brief

exit 0

