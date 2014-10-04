# Dump and Restore for InfluxDB

> influxdb-backup.sh is a simple bash script which uses [curl](http://curl.haxx.se/) and
> [jq](http://stedolan.github.io/jq/) to dump and restore all the points in an influxdb
> database.

* `./influxdb-backup.sh dump` fetches all points from a database and outputs them as [line-delimited JSON](http://en.wikipedia.org/wiki/Line_Delimited_JSON) to stdout.
* `./influxdb-backup.sh restore` reads a dump from stdin and writes all points to a database one by one.

## Installation

Download `influxdb-backup.sh` to your computer and make it executable:

```
$ curl https://raw.githubusercontent.com/eckardt/influxdb-backup.sh/master/influxdb-backup.sh -o influxdb-backup.sh && chmod +x ./influxdb-backup.sh && ./influxdb-backup.sh -?
```

## Usage

To copy all datapoints (all series) from one database to another do:

```
$ ./influxdb-backup.sh dump oldDB | ./influxdb-backup.sh restore newDB
```

See `./influxdb-backup.sh dump -?` for more usage information:

```
Usage: ./influxdb-backup.sh dump DATABASE [options...]
	-u USERNAME	(default: root)
	-p PASSWORD	(default: root)
	-h HOST		(default: localhost:8086)
	-s		(use HTTPS)
```
