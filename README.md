# wsd_challenge

## Configuration management
1) The command to display all ansible_ configuration for a host is : `ansible <host> -m setup`
   where `<host>` is the name or IP address of the host you want to query.

2) To configure a cron job that runs logrotate on all machines every 10 minutes between 2h - 4h. Please:
   1. Download the /configuration_management and install it onto the Ansible Control node.
   2. Run the Playbook `configure_logrotate_cron.yml` in the /configuration_management folder: `ansible-playbook -i hosts.ini configure_logrotate_cron.yml`
   
   3. Run the playbook `configure_ntpd.yml`
   ### Some recommandations about the /etc/ntp.conf
   Based on my researchs below some additional recommandations:
   - Prefer Keyword: Added the prefer keyword to the primary server to ensure it is preferred over others.
   - Logging: Added configurations for logging and statistics to help with debugging and monitoring. And ensure that the log directory exists and is writable.

   I have write an other playbook that fits these recommandations: `configure_ntpd_recommandations.yml`
   
