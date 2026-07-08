# Linux Docker Monitoring & Alerting System

## Overview

This project is a Linux-based monitoring and alerting system designed to detect Docker container failures and automatically notify administrators when service health changes occur.

The system runs on an AWS EC2 Linux instance and uses a Bash health check script scheduled through cron to continuously monitor an Nginx Docker container.

When the service state changes, the system records the event, updates the current health state, and sends an alert notification using AWS SNS.

This project demonstrates practical experience with:

- Linux system administration
- Bash scripting
- Docker container monitoring
- Cron automation
- AWS IAM security practices
- AWS SNS notifications
- Git and GitHub version control

---

## Architecture

The monitoring workflow:

AWS EC2 Instance

|
├── Cron Scheduler
|
├── Bash Health Check Script
|
├── Docker Container Monitoring
|       |
|       └── Nginx Container
|
├── Health State Tracking
|
├── Log File Management
|
└── AWS SNS Notification
        |
        └── Email Alert


---

## Features

### Automated Health Monitoring

- Runs health checks automatically through cron
- Monitors Docker container availability
- Checks HTTP service response status
- Detects service failures and recoveries

### State Change Detection

The system stores the previous health state and only generates alerts when a change occurs.

Examples:

HEALTHY -> UNHEALTHY

or

UNHEALTHY -> HEALTHY

This prevents unnecessary notifications when the service remains in the same state.

### Logging

All monitoring events are recorded with timestamps.

Example:

[2026-07-07 05:30:51] STATUS CHANGE: HEALTHY -> UNHEALTHY - CONTAINER DOWN (HTTP N/A)

[2026-07-07 05:32:01] STATUS CHANGE: UNHEALTHY - CONTAINER DOWN -> HEALTHY (HTTP 200)


### AWS SNS Alerting

When a health state change occurs, the system publishes an alert through AWS SNS.

The notification contains:

- Time of event
- Previous health state
- Current health state
- HTTP response status
- Failure reason

---

## Technologies Used

### Operating System

- Ubuntu Linux

### Scripting

- Bash

### Containerisation

- Docker
- Nginx container

### AWS Services

- Amazon EC2
- AWS IAM Roles
- Amazon SNS

### Automation

- Cron scheduler

### Version Control

- Git
- GitHub

---

## Security Design

The project uses AWS IAM roles instead of storing AWS access keys on the EC2 instance.

The EC2 instance assumes an IAM role with permission to publish messages to the SNS topic.

This follows the AWS security principle of:

Least Privilege Access

Only the permissions required for monitoring alerts are granted.

---

## Monitoring Workflow

Every minute:

1. Cron executes the health check script.
2. The script checks whether the Docker container is running.
3. The script performs an HTTP health check against the service.
4. The current status is compared against the previous recorded state.
5. If a status change occurs:
   - The event is written to the log file.
   - The state file is updated.
   - An SNS notification is sent.

---

## Testing

The monitoring system was tested by intentionally stopping the Docker container.

Example failure detection:

Container stopped

HEALTHY -> UNHEALTHY - CONTAINER DOWN


After restarting the container:

UNHEALTHY - CONTAINER DOWN -> HEALTHY


Both failure and recovery notifications were successfully delivered through AWS SNS email alerts.

---

## Project Structure

project-2-linux-monitoring/

├── scripts/
│   └── healthcheck.sh
│
├── docs/
│
├── screenshots/
│
├── README.md
│
└── .gitignore


---

## Future Improvements

Potential future enhancements:

- Add AWS CloudWatch monitoring and dashboards
- Add Terraform infrastructure deployment
- Add Docker Compose configuration
- Add CI/CD pipeline integration
- Add more detailed alert formatting
- Add monitoring for multiple containers and services
- Add log rotation improvements

---

## Skills Demonstrated

This project demonstrates practical ability in:

- Linux administration
- Bash automation
- Troubleshooting Linux services
- Docker management
- AWS IAM security
- AWS SNS integration
- Cloud infrastructure concepts
- Git workflow and documentation
