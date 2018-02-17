Docker Nashville / Grafana Monitoring Workshop
---

Instructions:

- Install Docker 17.12+
- (optional) Enable experiemental mode with Telemetry [see below]
- Enable Swarm Mode
  - `docker swarm init`
- Deploy all the things
  - `./run.sh`


## Docker Telemetry Plugin

This will enable Prometheus to collect information about healthchecks, network/service allocations, etc.

/etc/docker/daemon.json
```
{
    "experimental": true,
    "metrics-addr": "0.0.0.0:9323"
}
```