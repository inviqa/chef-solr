include_attribute "jetty"

if Chef::Config[:solo]
    @node.expand!('disk')
else
    @node.expand!('server')
end

default[:solr][:version]   = "3.6.1"
default[:solr][:link]      = "http://www.mirrorservice.org/sites/ftp.apache.org/lucene/solr/#{solr.version}/apache-solr-#{solr.version}.tgz"
default[:solr][:checksum]  = "1b4552ba95c8456d4fbd596e82028eaa0619b6942786e98e1c4c31258543c708" #sha265
default[:solr][:directory] = "/usr/local/src"
default[:solr][:download]  = "#{solr.directory}/apache-solr-#{solr.version}.tgz"
default[:solr][:extracted] = "#{solr.directory}/apache-solr-#{solr.version}"
default[:solr][:war]       = "#{solr.extracted}/dist/apache-solr-#{solr.version}.war"

default[:solr][:context_path]  = 'solr'
default[:solr][:home]          = "/etc/solr"
set[:solr][:config]            = node.solr.home + "/conf"
set[:solr][:lib]               = node.solr.home + "/lib"
default[:solr][:data]          = "#{node.jetty.home}/webapps/#{node.solr.context_path}/data"
default[:solr][:custom_config] = nil
default[:solr][:custom_lib]    = nil
