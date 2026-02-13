# Script Demonstration Guide

## Test 1: Normal Execution with Default Configuration

### Command:
```bash
./setup_project.sh
```

### User Input:
```
Enter project name suffix: spring2024
Do you want to update attendance thresholds? (y/n): n
```

### Expected Output:
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
Do you want to update attendance thresholds? (y/n): n

=== Environment Validation ===
✓ Python 3 is installed: Python 3.9.6

=== Directory Structure Verification ===
✓ All required files are in place

=== Setup Complete ===
Project created at: attendance_tracker_spring2024

To run the attendance checker:
  cd attendance_tracker_spring2024
  python3 attendance_checker.py
```

### Verification:
```bash
ls -R attendance_tracker_spring2024/
```

**Output:**
```
attendance_tracker_spring2024/:
Helpers  attendance_checker.py  reports

attendance_tracker_spring2024/Helpers:
assets.csv  config.json

attendance_tracker_spring2024/reports:
reports.log
```

---

## Test 2: Execution with Custom Thresholds

### Command:
```bash
./setup_project.sh
```

### User Input:
```
Enter project name suffix: fall2024
Do you want to update attendance thresholds? (y/n): y
Enter Warning threshold (default 75%): 80
Enter Failure threshold (default 50%): 60
```

### Expected Output:
```
=== Attendance Tracker Project Setup ===

Enter project name suffix: fall2024

Creating project: attendance_tracker_fall2024
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
✓ Python 3 is installed: Python 3.9.6

=== Directory Structure Verification ===
✓ All required files are in place

=== Setup Complete ===
Project created at: attendance_tracker_fall2024
```

### Verify Configuration Update:
```bash
cat attendance_tracker_fall2024/Helpers/config.json
```

**Output:**
```json
{
    "total_sessions": 20,
    "thresholds": {
        "warning": 80,
        "failure": 60
    },
    "run_mode": "dry_run"
}
```

---

## Test 3: Running the Attendance Checker

### Command:
```bash
cd attendance_tracker_spring2024
python3 attendance_checker.py
```

### Expected Output:
```
[DRY RUN] Email to john.doe@example.com: URGENT: John Doe, your attendance is 40.0%. You will fail this class.
[DRY RUN] Email to alice.johnson@example.com: WARNING: Alice Johnson, your attendance is 60.0%. Please be careful.
[DRY RUN] Email to charlie.brown@example.com: URGENT: Charlie Brown, your attendance is 25.0%. You will fail this class.
```

### Check Generated Report:
```bash
cat reports/reports.log
```

**Output:**
```
--- Attendance Report Run: 2024-02-13 15:30:45.123456 ---
```

---

## Test 4: Archive Feature (Interrupt Handling)

### Command:
```bash
./setup_project.sh
```

### User Action:
1. Enter project name: `test_interrupt`
2. Press `Ctrl+C` when prompted for threshold update

### Expected Output:
```
=== Attendance Tracker Project Setup ===

Enter project name suffix: test_interrupt

Creating project: attendance_tracker_test_interrupt
✓ Created directory structure
✓ Created attendance_checker.py
✓ Created assets.csv
✓ Created config.json
✓ Created reports.log

=== Configuration Setup ===
Do you want to update attendance thresholds? (y/n): ^C
⚠️  Setup interrupted! Cleaning up...
✓ Archived incomplete project to: attendance_tracker_test_interrupt_archive.tar.gz
✓ Removed incomplete directory: attendance_tracker_test_interrupt
Exiting...
```

### Verify Archive Creation:
```bash
ls -lh *.tar.gz
```

**Output:**
```
-rw-r--r--  1 user  staff   2.1K Feb 13 15:35 attendance_tracker_test_interrupt_archive.tar.gz
```

### Extract and Inspect Archive:
```bash
tar -tzf attendance_tracker_test_interrupt_archive.tar.gz
```

**Output:**
```
attendance_tracker_test_interrupt/
attendance_tracker_test_interrupt/attendance_checker.py
attendance_tracker_test_interrupt/Helpers/
attendance_tracker_test_interrupt/Helpers/assets.csv
attendance_tracker_test_interrupt/Helpers/config.json
attendance_tracker_test_interrupt/reports/
attendance_tracker_test_interrupt/reports/reports.log
```

---

## Test 5: Error Handling - Empty Project Name

### Command:
```bash
./setup_project.sh
```

### User Input:
```
Enter project name suffix: [Press Enter without typing]
```

### Expected Output:
```
=== Attendance Tracker Project Setup ===

Enter project name suffix: 
Error: Project name cannot be empty!
```

---

## Test 6: Error Handling - Directory Already Exists

### Command:
```bash
./setup_project.sh
```

### User Input:
```
Enter project name suffix: spring2024
```

### Expected Output (if directory exists):
```
=== Attendance Tracker Project Setup ===

Enter project name suffix: spring2024
Error: Directory 'attendance_tracker_spring2024' already exists!
```

---

## Test 7: Invalid Threshold Input

### Command:
```bash
./setup_project.sh
```

### User Input:
```
Enter project name suffix: test_invalid
Do you want to update attendance thresholds? (y/n): y
Enter Warning threshold (default 75%): abc
Enter Failure threshold (default 50%): xyz
```

### Expected Output:
```
=== Configuration Setup ===
Do you want to update attendance thresholds? (y/n): y

Enter Warning threshold (default 75%): abc
Enter Failure threshold (default 50%): xyz
⚠️  Invalid input. Using default values.

=== Environment Validation ===
✓ Python 3 is installed: Python 3.9.6
```

---

## Complete Workflow Example

```bash
# 1. Run setup script
./setup_project.sh

# 2. Provide inputs
# Project name: demo_project
# Update thresholds: y
# Warning: 85
# Failure: 55

# 3. Navigate to project
cd attendance_tracker_demo_project

# 4. Run attendance checker
python3 attendance_checker.py

# 5. View results
cat reports/reports.log

# 6. Check configuration
cat Helpers/config.json

# 7. View student data
cat Helpers/assets.csv
```

---

## Key Features Demonstrated

1. **Automated Directory Creation**: Complete project structure created with one command
2. **Dynamic Configuration**: sed command updates JSON values based on user input
3. **Signal Handling**: Trap catches Ctrl+C and performs cleanup
4. **Input Validation**: Checks for empty names, numeric values, existing directories
5. **Environment Validation**: Verifies Python 3 installation
6. **Error Messages**: Clear feedback for all error conditions
7. **Archive Creation**: Incomplete projects are bundled and saved
8. **Clean Workspace**: Failed setups don't leave clutter