# Bash Tasks

Bash Tasks is a simple script designed to run any bash scripts organized in a directory structure from a GUI-like interface in the terminal. This is a great tool for automating routine tasks and organizing scripts in a user-friendly way.

## Usage

To start Bash Tasks, open your terminal and run:

```bash
bt
```

This will present you with a list of tasks available to run, for instance:

```bash
Please select a task:
1. demo/
2. backup.sh
b. Go back
Enter your choice:
```

Directories are suffixed with a /. You can navigate into directories by entering the corresponding number. You can execute scripts by entering the corresponding number. If you want to go back to the previous directory, enter b.

## Setup

1. Clone the repository

   ```bash
   git clone https://github.com/lingtalfi/bash-tasks.git
   ```

2. Move to the directory

   ```bash
   cd bash-tasks
   ```

3. Make the script executable

   ```bash
   chmod +x bash-tasks.sh
   ```

4. Create an alias for the script. You can add this line to your .bashrc or .zshrc file

   ```bash
   alias bt='path_to_script/bash-tasks.sh'
   ```

5. Customize the root directory: In the **bash-tasks.sh** script, update the **ROOT_DIR** variable to reflect the actual location where you will store your tasks. By default, it is set to **/tmp/root**, which is a temporary directory and its contents are deleted on every reboot.

   ```bash
   ROOT_DIR="/path/to/your/tasks/directory"
   ```

   Ensure that the path you specify is an absolute path and the directory exists. This directory will be the root directory that houses all your tasks.

6. Place your tasks in the **tasks/** directory. They can be organized into subdirectories.

## Adding Tasks

Tasks are simply bash scripts that you place in the **tasks/** directory. They can be organized into subdirectories. All scripts should have the .sh extension and should be executable. Here is an example of a simple task:

```bash
#!/bin/bash
echo "Hello, world!"
```

Remember to make the task executable:

```bash
chmod +x tasks/hello-world.sh
```

### Tasks with Parameters

Sometimes, you might want your script to prompt for parameters. Here's a simple template for a script that does this:

```bash
#!/bin/bash

# Prompt for name
read -p "Enter your name: " name

# Prompt for age
read -p "Enter your age: " age

# Display name and age
echo "Your name is $name, and your age is $age."
```

### Tasks that Execute Commands Remotely

Occasionally, your script may need to execute commands on a remote server. Here's a basic template for a script that executes commands both locally and remotely (note that `ubu` is a SSH alias defined in the `~/.ssh/config` file):

```bash
#!/bin/bash

# Connect to the remote VPS and execute commands
ssh ubu << EOF
echo executing command 1 remotely
echo executing command 2 remotely
exit
EOF

# Execute commands locally
echo executing command 3 locally
echo executing command 4 locally
```

Here's a more concrete example: a script that backs up a remote database, retrieves the backup, and restores it locally:

```bash
#!/bin/bash

# Connect to the remote VPS and backup the database
ssh ubu << EOF
cd my-backups/project1
docker exec d37e5269e612 /usr/bin/mysqldump -u some_user -psome_pass project1 > backup.sql
exit
EOF

# Copy the backup file from the remote VPS to the local machine
scp ubu:/home/me/my-backups/project1/backup.sql .

# Restore the backup locally
/Applications/MAMP/Library/bin/mysql --host=localhost --port=8889 --user=root -proot project1 < backup.sql
```

Note: This is an example script. Be sure to replace the placeholders like `ubu`, `some_user`, `some_pass`, `project1`, and the paths with your actual values.

Note2:

You might run into an issue with the way the here document (<< ENDSSH) is handled in the script.

If this is the case, the problem could be related to variable expansion.
When you use << ENDSSH in your script, any variables inside ENDSSH will be expanded by your local shell before they're sent over SSH.
To prevent this behavior and allow the variables to be expanded on the remote server, you should quote ENDSSH like this: << 'ENDSSH'.

```bash
#!/bin/bash

# Set your local file path
LOCAL_DUMP_PATH="/path/to/app/backup.sql"

# Set a temporary remote file path
REMOTE_DUMP_PATH="/home/myuser/tmp/mybackup.sql"

# Copy local dump to the remote server
scp -i ~/.ssh/ubu_ed25519 -P 50000 $LOCAL_DUMP_PATH my_user@123.456.789.123:$REMOTE_DUMP_PATH

# SSH into the remote server and run the commands
ssh -i ~/.ssh/ubu_ed25519 my_user@123.456.789.123 -p 50000 << 'ENDSSH'

# Get the running MySQL container ID
CONTAINER_ID=$(docker ps -f name=myapp-db-1 -q)

# remove this line once it works...
echo "CONTAINER_ID: $CONTAINER_ID" > /home/my_user/tmp/cont_id.txt

# Drop the existing database and create a new one
echo "DROP DATABASE IF EXISTS my_database; CREATE DATABASE my_database;" | docker exec -i $CONTAINER_ID mysql -uroot -pXXX

# Import the MySQL dump
docker exec -i $CONTAINER_ID mysql -umy_databaseuser -pxxx my_database < $REMOTE_DUMP_PATH

# Remove the dump file from the remote server
rm $REMOTE_DUMP_PATH

ENDSSH
EOF
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

None, do whatever.

## About this

This tool is a reincarnation of my earlier project, [bash manager](https://github.com/lingtalfi/bashmanager). I found myself needing a tool for executing tasks from a terminal again and remembered, "Oh right, I've already done this with bash manager". However, after revisiting bash manager's documentation, I felt it was a bit too complex for what I needed.

So, I decided to start fresh and create a simplified version. I engaged ChatGPT4 to assist with the coding and, astonishingly, we finished the job in under 10 minutes.

I am quite pleased with this new, streamlined version. It accomplishes exactly what it needs to, no more and no less.
