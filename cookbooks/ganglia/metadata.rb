maintainer       "Chris Howe - Infochimps, Inc"
maintainer_email "coders@infochimps.com"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

description      "Ganglia: a distributed high-performance monitoring system"

depends          "java"
depends 'runit', '~> 0.14.0'
depends          "volumes"
depends          "silverware"

recipe           "ganglia::default",                   "Base configuration for ganglia"
recipe           "ganglia::server",                    "Ganglia server -- contact point for all ganglia_agents"
recipe           "ganglia::agent",                     "Ganglia agent  -- discovers and sends to its ganglia_server"

%w[ debian ubuntu ].each do |os|
  supports os
end

attribute "ganglia/home_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/var/lib/ganglia"

attribute "ganglia/log_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/var/log/ganglia"

attribute "ganglia/conf_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/etc/ganglia"

attribute "ganglia/pid_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/var/run/ganglia"

attribute "ganglia/data_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/var/lib/ganglia/rrds"

attribute "ganglia/user",
  :display_name          => "",
  :description           => "",
  :default               => "ganglia"

attribute "ganglia/send_port",
  :display_name          => "",
  :description           => "",
  :default               => "8649"

attribute "ganglia/rcv_port",
  :display_name          => "",
  :description           => "",
  :default               => "8649"

attribute "ganglia/agent/run_state",
  :display_name          => "",
  :description           => "",
  :default               => "start"

attribute "ganglia/server/run_state",
  :display_name          => "",
  :description           => "",
  :default               => "start"

attribute "users/ganglia/uid",
  :display_name          => "",
  :description           => "",
  :default               => "320"

attribute "groups/ganglia/gid",
  :display_name          => "",
  :description           => "",
  :default               => "320"
