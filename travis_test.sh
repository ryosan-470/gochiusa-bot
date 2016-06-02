#!/bin/bash
# TRAVIS LINT TEST
COFFEE_FILES=$(find scripts -type f -name '*.coffee')
JAVASCRIPT_FILES=$(find scripts -type f -name '*.js')
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
        exit 1
    fi
    echo " # √"
done

echo ""
echo "Javascript linter test"
for f in $JAVASCRIPT_FILES; do
    cmd="eslint $f"
    echo -e "$cmd"
    $cmd >/dev/null
    if [ $? -ne 0 ]; then
        echo "Failed to lint $f"
        exit 1
    fi
    echo " # √"
done
exit ${return_val}
