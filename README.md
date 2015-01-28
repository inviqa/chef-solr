# DESCRIPTION:

[![Build Status](https://secure.travis-ci.org/inviqa/chef-solr.png?branch=master)](http://travis-ci.org/inviqa/chef-solr)

This chef cookbook is designed to install Solr as a Jetty servlet and should be used in conjunction with https://github.com/inviqa/chef-jetty. It has been tested on Ubuntu 8.04 and is used in production.

## REQUIREMENTS:

## ATTRIBUTES:

## USAGE:

### Installation of Solr 4
To install Solr 4.3+ some paths have to be set in different way (files were renamed). On top of this, it is neceesary to put slf4j and commons-logging jars in place. https://wiki.apache.org/solr/SolrLogging 

```
{
  "name": "solr",
  "chef_type": "role",
  "json_class": "Chef::Role",
  "description": "Solr server role",
  "default_attributes":
  {
    "solr" : {
      "version" : "4.10.3",
      "link": "http://archive.apache.org/dist/lucene/solr/4.10.3/solr-4.10.3.tgz",
      "download": "/usr/local/src/solr-4.10.3.tgz",
      "extracted": "/usr/local/src/solr-4.10.3",
      "war": "/usr/local/src/solr-4.10.3/dist/solr-4.10.3.war"
    },
    "java" : {
      "jdk_version": "7"
    }
  },
  "run_list": [
    "recipe[solr]",
    "recipe[solrmulticore]"
  ]
}
```

example default.rb from in-project  solrmulticore recipe
```
#
# Cookbook Name:: solrmulticore
# Recipe:: default
#
include_recipe "jetty"

bash "Cleanup solr home" do
  code <<-EOH
    rm -rf #{node['solr']['home']}/*
  EOH
  notifies     :restart, resources(:service => "jetty")
end

remote_directory node['solr']['home'] do
  source       "solrconfig"
  owner        node['jetty']['user']
  group        node['jetty']['group']
  files_owner  node['jetty']['user']
  files_group  node['jetty']['group']
  files_backup 0
  files_mode   "644"
  purge        true
  notifies     :restart, resources(:service => "jetty")
end

template "/etc/solr/solr.xml" do
  source "solr.xml.erb"
  owner        node['jetty']['user']
  group        node['jetty']['group']
  mode 0644
  notifies     :restart, resources(:service => "jetty"), :immediately
end


# Fetch
remote_file "/tmp/slf4jv.tgz" do
  source "http://www.slf4j.org/dist/slf4j-1.7.10.tar.gz"
  action :create_if_missing
end

remote_file "/tmp/commons-logging.tgz" do
  source "http://mirror.ox.ac.uk/sites/rsync.apache.org//commons/logging/binaries/commons-logging-1.2-bin.tar.gz"
  action :create_if_missing
end


# Extract
execute "cd /tmp && tar -xf /tmp/slf4jv.tgz && rm -rf /tmp/slf4j-1.7.10/slf4j-android* && cp /tmp/slf4j-1.7.10/slf4j-*.jar /usr/share/jetty/lib/ext/" do
  action :run
end

execute "cd /tmp && tar -xf /tmp/commons-logging.tgz && cp /tmp/commons-logging-1.2/*.jar /usr/share/jetty/lib/ext/" do
  action :run
end

```


