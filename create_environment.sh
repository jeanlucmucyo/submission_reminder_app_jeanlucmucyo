#!/bin/bash

#Prompting the user to enter their name and creating the main directory

read -p "Please enter your name: " name
directory=submission_reminder_$name
mkdir $directory && cd $directory
# Creating the subdirectories and and the files that are supposed to be in them

mkdir app && cd app

cat << 'EOF' > reminder.sh
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

submissions_file="./assets/submissions.txt"

echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions "$submissions_file"
EOF


chmod +x reminder.sh
cd ..

mkdir modules && cd modules

cat << 'EOF' > functions.sh
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file")
}
EOF

chmod +x functions.sh
cd ..

mkdir assets && cd assets
echo "student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
" > submissions.txt
cd ..

mkdir config && cd config

cat << EOF > config.env
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF


cd ..

cat << 'EOF' > startup.sh
#!/bin/bash

# Run the reminder script
bash ./app/reminder.sh
EOF

chmod +x startup.sh

