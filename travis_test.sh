#!/bin/bash
# TRAVIS COFFEELINT TEST
COFFEE_FILES=$(find scripts -type f -name '*.coffee')

return_val=0;

coffeelint $COFFEE_FILES
if [ $? -ne 0 ]; then
    return_val=1;
fi

for f in $COFFEE_FILES ; do
    cmd="coffee -c -p $f"
    echo -en "$cmd"
    $cmd >/dev/null
    if [ $? -ne 0 ]; then
        echo "Failed to compile $f"
        exit ${return_val}
    fi
    echo " # √"
done

exit ${return_val}
