# wsd_challenge

## Configuration management
1) The command to display all ansible_ configuration for a host is : `ansible <host> -m setup`
   where `<host>` is the name or IP address of the host you want to query.

2) To configure a cron job that runs logrotate on all machines every 10 minutes between 2h - 4h. Please:
   1. Download the /configuration_management and install it onto the Ansible Control node.
   2. Run the Playbook `configure_logrotate_cron.yml` in the /configuration_management folder: `ansible-playbook -i hosts.ini configure_logrotate_cron.yml`

3) Run the command: `ansible-playbook -i hosts.ini deploy_ntpd_and_nagios.yml`
   Here we are assuming the IP address of the nagios server `monitoring.fra1.internal` is `192.168.0.5`

## Docker & Kubernetes
1) To start the Nginx server, run the docker-compose.yml file under the /docker_kubernetes folder: `docker-compose up -d`
2) Assuming we don't know the pod's name but we have a label "project=internal" on the related pods. We first have to identify which pod is restarting: `kubectl get pods -n production -l project=internal`. Once we have identified the pod that is restarting, use the describe command: `kubectl describe pod <pod-name> -n production`. In the output, the section "Events" generally contains information about restarts.
3) The pod is consistently close to its memory request. If the application needs more memory, it might hit the limit and restart. Moreover, the Xmx setting leaves little room for non-heap memory, which could lead to memory pressure and potential Out of Memory Killed.
Also, with Xmx set to 1000M and memory usage at 951Mi, the JVM might be performing frequent garbage collections, potentially causing application pauses or failures.

