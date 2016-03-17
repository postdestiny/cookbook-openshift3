# Openshift 3 Cookbook CHANGELOG
This file is used to list changes made in each version of the Openshift 3 cookbook.

## v1.0.6
### Improvement
- Add delay/retry before installing servcieaccount
- Change xip.io for nip.io (STABLE)

### Bug
- Fix scripts/origin_deploy.sh
- Fix hostname for origin_deploy.sh

## v1.0.5
### Bug
- Fix bug when enabling HTTPD at startup

## v1.0.4
### Improvement
- Detect the CN or SAN from certificates file when using named certificates.
- Move origin_deploy.sh in scripts folder

### Bug
- Enable HTTPD at startup
- Fix some typos

## v1.0.3
### Improvement
- Add possibility to customise docker-storage-setup
- Add possibility for configuring Custom Certificates

## v1.0.2
### Improvement
- Add MIT LICENCE model 
- Add script to auto deploy origin instance
- Add the possibility to exclude packages from updates or installs

### Bug fix
- Fix attributes labelling when using chef in local mode (or solo) 
- Remove specific mentions to OSE

## v0.0.1
- Current public release
