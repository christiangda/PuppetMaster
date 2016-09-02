# PuppetMaster

## Hiera

### Access to web gui
```
http://127.0.0.1:15984/_utils
```

### Access through the command
Example: hiera "key"
```shell
hiera profile::common::timezone
```

### Query as specific client (based on facters)
```
hiera -a profile::common::packages::debian_family ::node_group=vagrant ::node_location=vagrant ::node_environment=vagrant ::osfamily=Ubuntu ::clientcert="agent-02.puppet.local" --debug
```

## CouchDB

### Access to web gui
```
http://127.0.0.1:15984/_utils
```

### List all databases
```shell
curl -X GET http://127.0.0.1:5984/_all_dbs
```
