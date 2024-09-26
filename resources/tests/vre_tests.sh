# Copyright 2020 CS GROUP - France, http://www.c-s.fr
# All rights reserved

set -e

# Exec Python test files
for file in /opt/vre/tests/*.py
do
    echo "Testing $file..."
    python3 "$file"
done

# Exec Bash test files
for file in /opt/vre/tests/*.sh
do
    if [ "$file" != "/opt/vre/tests/vre_tests.sh" ]; then
        echo "Testing $file..."
        bash "$file"
    fi
done
