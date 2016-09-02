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

## CouchDB

### Access to web gui
```
http://127.0.0.1:15984/_utils
```

### List all databases
```shell
curl -X GET http://127.0.0.1:5984/_all_dbs
```
