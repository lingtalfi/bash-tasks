#!/bin/bash

ROOT_DIR="/Users/pierrelafitte/scripts/bash-tasks-my"
TASK_DIR="${ROOT_DIR}/tasks"

OPTIONS=()

function drawMenu() {
    echo "Please select a task:"
    for i in "${!OPTIONS[@]}"; do
        printf "%d. %s\n" $((i+1)) "${OPTIONS[$i]}"
    done
    echo "b. Go back"
}

function selectTask() {
    local path="$1"
    local REPLY
    OPTIONS=()  # Clear options

    while IFS= read -r line; do
        line+="/"
        OPTIONS+=("$line")
    done < <(find "$path" -maxdepth 1 -mindepth 1 -type d -exec basename {} \;)

    while IFS= read -r line; do
        OPTIONS+=("$line")
    done < <(find "$path" -maxdepth 1 -mindepth 1 -type f -name "*.sh" -exec basename {} \;)

    if [[ ${#OPTIONS[@]} -eq 0 ]]; then
        echo "No tasks available."
        exit 1
    fi

    while true; do
        clear
        drawMenu
        read -p "Enter your choice: " 

        if [[ $REPLY = b ]]; then
            # If the path is not the root task directory, go back
            if [[ "$path" != "$TASK_DIR/" ]]; then
                path="${path%/*}"
                path="${path%/*}"
                selectTask "$path/"
            fi
            return
        elif [[ $REPLY -ge 1 && $REPLY -le ${#OPTIONS[@]} ]]; then
            local selection="${OPTIONS[$((REPLY-1))]}"
            local newPath="${path}${selection}"
            # Remove trailing slash from directories before checking if they exist
            newPath="${newPath%/}"
            if [[ -d $newPath ]]; then
                selectTask "$newPath/"
            elif [[ -f $newPath ]]; then
                bash "$newPath"
                read -n1 -r -p "Press any key to continue..."
            fi
        else
            echo "Invalid choice. Please try again."
            read -n1 -r -p "Press any key to continue..."
        fi
    done
}

selectTask "$TASK_DIR/"
