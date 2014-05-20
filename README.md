## Introduction

This is a collection scripts and recipes for Vagrant to setup a clustered RabbitMQ
installation.

By default, this configuration will create and provision 3 CentOS 6.3 VMs:

- `rabbit1`: RabbitMQ disc node
- `rabbit2`: RabbitMQ disc node
- `rabbit3`: RabbitMQ ram node

And RabbitMQ setting `cluster_partition_handling` is set to `pause_minority`
(by default), for more information, see [Clustering and Network Partitions](https://www.rabbitmq.com/partitions.html).

## Prerequisites

- [Vagrant](http://vagrantup.com)
- [Vagrant Host Manager](https://github.com/smdahlen/vagrant-hostmanager)
- [CentOS 6.3 box](https://s3.amazonaws.com/itmat-public/centos-6.3-chef-10.14.2.box)

## Use

In order to manage node hostnames automatically, install the vagrant-hostmanager plugin:

``` bash
vagrant plugin install vagrant-hostmanager
```


## Ready up and run

``` bash
vagrant up
```
