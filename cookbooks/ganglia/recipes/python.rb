# Setup common directories
directory "#{node['ganglia']['conf_dir']}/conf.d" do
  owner node['ganglia']['user']
  group node['ganglia']['group']
  mode 0755
  action :create
end

directory "#{node['ganglia']['lib_dir']}/python_modules" do
  owner node['ganglia']['user']
  group node['ganglia']['group']
  mode 0755
  action :create
end

template "#{node['ganglia']['conf_dir']}/conf.d/modpython.conf" do
  source "modpython.conf.erb"
  backup false
  owner node['ganglia']['user']
  group node['ganglia']['group']
  mode 0644
end