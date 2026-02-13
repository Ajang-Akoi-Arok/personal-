#!/bin/bash

# Automated Project Bootstrapping Script
# Handles directory creation, configuration, and signal management

PROJECT_NAME=""
PROJECT_DIR=""

# Trap function to handle SIGINT (Ctrl+C)
cleanup_on_interrupt() {
    echo ""
    echo "⚠️  Setup interrupted! Cleaning up..."
    
    if [ -d "$PROJECT_DIR" ]; then
        # Create archive of incomplete project
        ARCHIVE_NAME="${PROJECT_NAME}_archive.tar.gz"
        tar -czf "$ARCHIVE_NAME" "$PROJECT_DIR" 2>/dev/null
        
        if [ -f "$ARCHIVE_NAME" ]; then
            echo "✓ Archived incomplete project to: $ARCHIVE_NAME"
        fi
        
        # Delete incomplete directory
        rm -rf "$PROJECT_DIR"
        echo "✓ Removed incomplete directory: $PROJECT_DIR"
    fi
    
    echo "Exiting..."
    exit 1
}

# Set trap for SIGINT
trap cleanup_on_interrupt SIGINT

# Prompt for project name
echo "=== Attendance Tracker Project Setup ==="
echo ""
read -p "Enter project name suffix: " user_input

if [ -z "$user_input" ]; then
    echo "Error: Project name cannot be empty!"
    exit 1
fi

PROJECT_NAME="attendance_tracker_${user_input}"
PROJECT_DIR="$PROJECT_NAME"

# Check if directory already exists
if [ -d "$PROJECT_DIR" ]; then
    echo "Error: Directory '$PROJECT_DIR' already exists!"
    exit 1
fi

echo ""
echo "Creating project: $PROJECT_NAME"

# Create directory structure
mkdir -p "$PROJECT_DIR/Helpers"
mkdir -p "$PROJECT_DIR/reports"

echo "✓ Created directory structure"

# Create attendance_checker.py
cat > "$PROJECT_DIR/attendance_checker.py" << 'EOF'
import csv
import json
import os
from datetime import datetime

def run_attendance_check():
    # 1. Load Config
    with open('Helpers/config.json', 'r') as f:
        config = json.load(f)
    
    # 2. Archive old reports.log if it exists
    if os.path.exists('reports/reports.log'):
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        os.rename('reports/reports.log', f'reports/reports_{timestamp}.log.archive')
    
    # 3. Process Data
    with open('Helpers/assets.csv', mode='r') as f, open('reports/reports.log', 'w') as log:
        reader = csv.DictReader(f)
        total_sessions = config['total_sessions']
        log.write(f"--- Attendance Report Run: {datetime.now()} ---\n")
        
        for row in reader:
            name = row['Names']
            email = row['Email']
            attended = int(row['Attendance Count'])
            
            # Simple Math: (Attended / Total) * 100
            attendance_pct = (attended / total_sessions) * 100
            message = ""
            
            if attendance_pct < config['thresholds']['failure']:
                message = f"URGENT: {name}, your attendance is {attendance_pct:.1f}%. You will fail this class."
            elif attendance_pct < config['thresholds']['warning']:
                message = f"WARNING: {name}, your attendance is {attendance_pct:.1f}%. Please be careful."
            
            if message:
                if config['run_mode'] == "live":
                    log.write(f"[{datetime.now()}] ALERT SENT TO {email}: {message}\n")
                    print(f"Logged alert for {name}")
                else:
                    print(f"[DRY RUN] Email to {email}: {message}")

if __name__ == "__main__":
    run_attendance_check()
EOF

echo "✓ Created attendance_checker.py"

# Create assets.csv
cat > "$PROJECT_DIR/Helpers/assets.csv" << 'EOF'
Names,Email,Attendance Count
John Doe,john.doe@example.com,8
Jane Smith,jane.smith@example.com,15
Alice Johnson,alice.johnson@example.com,12
Bob Williams,bob.williams@example.com,18
Charlie Brown,charlie.brown@example.com,5
EOF

echo "✓ Created assets.csv"

# Create config.json with default values
cat > "$PROJECT_DIR/Helpers/config.json" << 'EOF'
{
    "total_sessions": 20,
    "thresholds": {
        "warning": 75,
        "failure": 50
    },
    "run_mode": "dry_run"
}
EOF

echo "✓ Created config.json"

# Create empty reports.log
touch "$PROJECT_DIR/reports/reports.log"
echo "✓ Created reports.log"

echo ""
echo "=== Configuration Setup ==="

# Prompt for threshold updates
read -p "Do you want to update attendance thresholds? (y/n): " update_choice

if [[ "$update_choice" == "y" || "$update_choice" == "Y" ]]; then
    echo ""
    read -p "Enter Warning threshold (default 75%): " warning_threshold
    read -p "Enter Failure threshold (default 50%): " failure_threshold
    
    # Validate input
    if [[ "$warning_threshold" =~ ^[0-9]+$ ]] && [[ "$failure_threshold" =~ ^[0-9]+$ ]]; then
        # Use sed to update config.json
        sed -i.bak "s/\"warning\": [0-9]*/\"warning\": $warning_threshold/" "$PROJECT_DIR/Helpers/config.json"
        sed -i.bak "s/\"failure\": [0-9]*/\"failure\": $failure_threshold/" "$PROJECT_DIR/Helpers/config.json"
        rm -f "$PROJECT_DIR/Helpers/config.json.bak"
        
        echo "✓ Updated thresholds: Warning=$warning_threshold%, Failure=$failure_threshold%"
    else
        echo "⚠️  Invalid input. Using default values."
    fi
fi

echo ""
echo "=== Environment Validation ==="

# Check for Python 3
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1)
    echo "✓ Python 3 is installed: $PYTHON_VERSION"
else
    echo "⚠️  WARNING: Python 3 is not installed!"
    echo "   Please install Python 3 to run the attendance checker."
fi

# Verify directory structure
echo ""
echo "=== Directory Structure Verification ==="

if [ -f "$PROJECT_DIR/attendance_checker.py" ] && \
   [ -f "$PROJECT_DIR/Helpers/assets.csv" ] && \
   [ -f "$PROJECT_DIR/Helpers/config.json" ] && \
   [ -f "$PROJECT_DIR/reports/reports.log" ]; then
    echo "✓ All required files are in place"
else
    echo "⚠️  WARNING: Some files may be missing!"
fi

echo ""
echo "=== Setup Complete ==="
echo "Project created at: $PROJECT_DIR"
echo ""
echo "To run the attendance checker:"
echo "  cd $PROJECT_DIR"
echo "  python3 attendance_checker.py"
echo ""