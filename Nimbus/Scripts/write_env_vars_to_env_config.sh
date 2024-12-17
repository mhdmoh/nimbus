#!/bin/sh

#  write_env_vars_to_env_config.sh.sh
#  Nimbus
#
#  Created by Mohamad Mohamad on 17/12/2024.
#

# This script should be run on CI from project dir as a step before building the project
# First, Make sure that all env vars from .env-example.xcconfig are set on CI
#
# The script:
# 1. Reads all env vars defined in env-example.xcconfig
# 2. Writes env var values to env.xcconfig

config_path="./YourFancyProject/Configuration/EnvironmentVars"


# Path to the env.xcconfig file
xcconfig_file="${config_path}/env.xcconfig"

# Path to the env.xcconfig file
example_xcconfig_file="${config_path}/env-example.xcconfig"

# Open the source and destination files for reading and writing
exec 3<$example_xcconfig_file
exec 4>$xcconfig_file

echo "Writing env vars to '$xcconfig_file'..."

# Read the source file line by line and write to the destination file
while read -u 3 line; do
  # Extract the variable name and value from the line
  var_name="$(echo "$line" | cut -d'=' -f1 | sed 's/ //g')"
  default_var_value="$(echo "$line" | cut -d'=' -f2- | sed 's/^ *//;s/ *$//')"
  
  # Extract the variable value from env vars
  var_value="${!var_name}"
  
  if [[ -n "$var_value" ]]; then
    echo "$var_name = $var_value" >&4
    echo "Wrote '$var_name' from env vars."
  else
    echo "$var_name = $default_var_value" >&4
    echo "Wrote default value for '$var_name'."
  fi
done

# Close the files
exec 3<&-
exec 4>&-

echo "Wrote env vars to '$xcconfig_file' successfully."
