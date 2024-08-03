# wsd_challenge

## Configuration management
1) The command to display all ansible_ configuration for a host is : `ansible <host> -m setup`
   where `<host>` is the name or IP address of the host you want to query.

2) To configure a cron job that runs logrotate on all machines every 10 minutes between 2h - 4h. Please:
   1. Download the /configuration_management and install it onto the Ansible Control node.
   2. Run the Playbook `configure_logrotate_cron.yml` in the /configuration_management folder: `ansible-playbook -i hosts.ini configure_logrotate_cron.yml`
   3. Run the command: `ansible-playbook -i hosts.ini deploy_ntpd_and_nagios.yml`
   Here we are assuming the IP address of the nagios server `monitoring.fra1.internal` is `192.168.0.5`
   
   
