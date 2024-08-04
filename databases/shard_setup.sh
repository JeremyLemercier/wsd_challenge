#!/bin/bash

# Connect to the MongoDB cluster and execute the sharding commands
mongo <<EOF
// Enable sharding on the database
sh.enableSharding("sanfrancisco")

// Add the shards
sh.addShard("replicaset_1/mongodb1:27017,mongodb2:27017,mongodb3:27017")
sh.addShard("replicaset_2/mongodb4:27017,mongodb5:27017,mongodb6:27017")

// Shard the collection based on the _id field
sh.shardCollection("sanfrancisco.company_name", { "_id": 1 })

// Verify the sharding status
sh.status()
EOF

### To run this script:
# chmod +x shard_setup.sh
# ./shard_setup.sh