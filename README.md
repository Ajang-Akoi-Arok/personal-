# Automated Project Bootstrapping & Process Management

## Overview
This project automates the deployment of a Student Attendance Tracker application using shell scripting. It demonstrates Infrastructure as Code (IaC) principles by automating directory creation, file generation, configuration management, and graceful error handling.

## Features
- **Automated Directory Structure**: Creates complete project hierarchy with one command
- **Dynamic Configuration**: Allows customization of attendance thresholds via command-line prompts
- **Signal Handling**: Gracefully handles interruptions (Ctrl+C) with automatic cleanup
- **Environment Validation**: Checks for Python 3 installation before completion
- **Error Handling**: Validates inputs and handles edge cases

## Prerequisites
- Bash shell (Linux/macOS)
- Python 3 (for running the attendance checker)
- tar (for archiving)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/YOUR_USERNAME/deploy_agent_YOUR_USERNAME.git
cd deploy_agent_YOUR_USERNAME
```

2. Make the script executable:
```bash
chmod +x setup_project.sh
```

## Usage

### Basic Setup

Run the setup script:
```bash
./setup_project.sh
```

**You will be prompted for:**

1. **Project name suffix**: Enter a unique identifier (e.g., "spring2024")
   ```
   Enter project name suffix: spring2024
   ```
   This creates: `attendance_tracker_spring2024/`

2. **Threshold configuration**: Choose whether to update default thresholds
   ```
   Do you want to update attendance thresholds? (y/n): y
   Enter Warning threshold (default 75%): 80
   Enter Failure threshold (default 50%): 60
   ```

### Expected Output

```
=== Attendance Tracker Project Setup ===

Enter project name suffix: spring2024

Creating project: attendance_tracker_spring2024
✓ Created directory structure
✓ Created attendance_checker.py
✓ Created assets.csv
✓ Created config.json
✓ Created reports.log

=== Configuration Setup ===
Do you want to update attendance thresholds? (y/n): y

Enter Warning threshold (default 75%): 80
Enter Failure threshold (default 50%): 60
✓ Updated thresholds: Warning=80%, Failure=60%

=== Environment Validation ===
✓ Python 3 is installed: Python 3.11.5

=== Directory Structure Verification ===
✓ All required files are in place

=== Setup Complete ===
Project created at: attendance_tracker_spring2024

To run the attendance checker:
  cd attendance_tracker_spring2024
  python3 attendance_checker.py
```

### Running the Attendance Checker

After setup completes:
```bash
cd attendance_tracker_spring2024
python3 attendance_checker.py
```

**Sample Output:**
```
[DRY RUN] Email to john.doe@example.com: URGENT: John Doe, your attendance is 40.0%. You will fail this class.
[DRY RUN] Email to alice.johnson@example.com: WARNING: Alice Johnson, your attendance is 60.0%. Please be careful.
[DRY RUN] Email to charlie.brown@example.com: URGENT: Charlie Brown, your attendance is 25.0%. You will fail this class.
```

## Triggering the Archive Feature

### What is the Archive Feature?

The script includes a **Signal Trap** that handles interruptions gracefully. If you press `Ctrl+C` during setup, the script will:
1. Create a compressed archive of the incomplete project
2. Delete the incomplete directory to keep workspace clean
3. Exit gracefully

### How to Trigger It

**Method 1: Manual Interrupt**
1. Start the setup script:
   ```bash
   ./setup_project.sh
   ```
2. When prompted for input, press `Ctrl+C`

**Expected Output:**
```
=== Attendance Tracker Project Setup ===

Enter project name suffix: test_project
^C
⚠️  Setup interrupted! Cleaning up...
✓ Archived incomplete project to: attendance_tracker_test_project_archive.tar.gz
✓ Removed incomplete directory: attendance_tracker_test_project
Exiting...
```

**Method 2: Interrupt During Configuration**
1. Run the script and provide a project name
2. When asked about threshold updates, press `Ctrl+C`

**Result:**
- Archive file created: `attendance_tracker_{name}_archive.tar.gz`
- Incomplete directory removed
- Clean workspace maintained

### Extracting the Archive

If you need to recover the archived project:
```bash
tar -xzf attendance_tracker_test_project_archive.tar.gz
```

## Project Structure

After successful setup:
```
attendance_tracker_{input}/
├── attendance_checker.py    # Main application logic
├── Helpers/
│   ├── assets.csv           # Student attendance data
│   └── config.json          # Configuration settings
└── reports/
    └── reports.log          # Generated reports
```

## Configuration File (config.json)

```json
{
    "total_sessions": 20,
    "thresholds": {
        "warning": 75,
        "failure": 50
    },
    "run_mode": "dry_run"
}
```

- **total_sessions**: Total number of class sessions
- **warning**: Percentage below which a warning is issued
- **failure**: Percentage below which a failure alert is issued
- **run_mode**: "dry_run" (test mode) or "live" (sends actual alerts)

## Student Data (assets.csv)

```csv
Names,Email,Attendance Count
John Doe,john.doe@example.com,8
Jane Smith,jane.smith@example.com,15
Alice Johnson,alice.johnson@example.com,12
Bob Williams,bob.williams@example.com,18
Charlie Brown,charlie.brown@example.com,5
```

## Technical Details

### Shell Script Components

1. **Trap Function**: Catches SIGINT signal
   ```bash
   trap cleanup_on_interrupt SIGINT
   ```

2. **Directory Creation**: Uses `mkdir -p` for safe creation
   ```bash
   mkdir -p "$PROJECT_DIR/Helpers"
   mkdir -p "$PROJECT_DIR/reports"
   ```

3. **HereDocs**: Generates file content inline
   ```bash
   cat > "$PROJECT_DIR/file.py" << 'EOF'
   # content here
   EOF
   ```

4. **Stream Editing**: Uses `sed` for in-place config updates
   ```bash
   sed -i.bak "s/\"warning\": [0-9]*/\"warning\": $value/" config.json
   ```

5. **Input Validation**: Regex pattern matching
   ```bash
   if [[ "$input" =~ ^[0-9]+$ ]]; then
   ```

### Error Handling

- Checks for empty project names
- Validates numeric input for thresholds
- Verifies directory doesn't already exist
- Confirms Python 3 installation
- Validates file creation

## Troubleshooting

### Issue: "Permission denied"
**Solution:** Make script executable
```bash
chmod +x setup_project.sh
```

### Issue: "Directory already exists"
**Solution:** Choose a different project name or remove existing directory
```bash
rm -rf attendance_tracker_existing_name
```

### Issue: "Python 3 not found"
**Solution:** Install Python 3
```bash
# macOS
brew install python3

# Ubuntu/Debian
sudo apt-get install python3
```

### Issue: Archive not created on interrupt
**Solution:** Ensure you have write permissions in the current directory

## Video Walkthrough

[Link to video demonstration will be added here]

The video covers:
- Script execution from start to finish
- Explanation of trap function logic
- Demonstration of archive feature
- Configuration update process
- Error handling scenarios

## Learning Outcomes

This project demonstrates:
- Shell scripting proficiency (variables, functions, control flow)
- File operations (creation, manipulation, archiving)
- Signal handling and process management
- Input validation and error handling
- Infrastructure as Code principles
- Version control best practices

## Author

Created as part of the Individual Summative Lab for Introduction to Linux and IT Tools course.

## License

Educational project - ALU 2024