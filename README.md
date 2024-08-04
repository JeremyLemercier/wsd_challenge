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


## Metrics
1) Prometheus is an open-source monitoring and alerting toolkit designed for reliability and scalability in dynamic environments. It scrapes metrics from instrumented applications and systems, stores them in a time-series database, and allows querying with PromQL. Exporters expose metrics from third-party systems, while the Alertmanager handles alerts and notifications. Prometheus integrates with visualization tools like Grafana for creating dashboards.

2) Firstly, we create a YAML file to define our alerting rules. This file will contain the conditions under which alerts should be triggered. Secondly, we update the Prometheus configuration to include the alerting rules file. Thirdly, we apply the configuration changes to our Prometheus instance running in Kubernetes.(Example alert rule and its configuration in the /metrics folder)

3) In Grafana, to properly show the usage trend of an application metric that is a counter, we should use the rate() or irate() functions in Prometheus Query Language (PromQL). These functions calculate the per-second average rate of increase of the counter over a specified time window, which helps in visualizing the trend accurately. (Example usage: rate(http_requests_total[5m] or irate(http_requests_total[5m]))


## Databases
1) The behavior you are experiencing with Cassandra is likely due to its eventual consistency model. Here are the main reasons:
- Eventual Consistency: Updates propagate to all nodes eventually, but there can be a delay, causing queries to return stale data if executed before full propagation.
- Stale Reads: Occur when queries read from replicas that haven't received the latest updates, often due to low consistency levels.
- Tombstones: Deleted data is marked with tombstones, which are cleared during compaction. Until then, they can cause read issues if not all nodes have processed them.
- Consistency Level: The specified consistency level for read and write operations affects data visibility. Lower consistency levels increase the chance of reading stale data.

*How to avoid?*
By properly configuring consistency levels, regularly performing maintenance tasks, and maintaining a healthy cluster, you can reduce the probability to get stale reads and achieve more consistent query results in Cassandra.

2) Below all the steps required to shard the collection sanfrancisco.company_name based on _id:
   1. Connect to the MongoDB cluster
      mongo
   
   2. Enable sharding on the database
      sh.enableSharding("sanfrancisco")
      
   3. Add the shards
      sh.addShard("replicaset_1/mongodb1:27017,mongodb2:27017,mongodb3:27017")
      sh.addShard("replicaset_2/mongodb4:27017,mongodb5:27017,mongodb6:27017")

   4. Shard the collection based on the _id field
      sh.shardCollection("sanfrancisco.company_name", { "_id": 1 })

   5. Verify the sharding status
      sh.status()

MongoDB will automatically balance the data across the shards.