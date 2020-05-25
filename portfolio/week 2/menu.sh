#! /bin/bash

./passwordCheck.sh
if [[ $? -ne 0 ]]; then
    exit 1
fi

echo "Enter an option:"
echo "1. Create a folder"
echo "2. Copy a folder"
echo "3. Set a password"

read -p "Enter your choice: " choice
case "$choice" in
1)  ./foldermaker.sh
    ;;
2)  ./foldercopier.sh
    ;;
3)  ./setPassword.sh
    ;;
*)  echo "Invalid choice ($choice)" >&2
    exit 2
    ;;
esac
