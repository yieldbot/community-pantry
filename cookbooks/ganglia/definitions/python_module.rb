define :gmond_python_module, :module_type => nil, :template_cookbook => "ganglia", variables => {} do
  include_recipe "ganglia::client"
  include_recipe "ganglia::python"
  
  module_name = params[:name]
  module_type = params[:module_type] || module_name
  
  confd_dir = "#{node['ganglia']['conf_dir']}/conf.d"
  python_modules_dir = "#{node['ganglia']['lib_dir']}/python_modules"

  template "#{confd_dir}/#{module_name}.pyconf" do
    source "#{module_type}.pyconf.erb"
    cookbook params[:template_cookbook]
    owner "ganglia"
    group "ganglia"
    mode 0644
    variables params[:variables]
    notifies :restart, resources(:service => "ganglia-monitor")
  end
  
  template "#{python_modules_dir}/#{module_name}.py" do
    source "#{module_type}.py.erb"
    cookbook params[:template_cookbook]
    owner "ganglia"
    group "ganglia"
    mode 0755
    variables params[:variables]
    notifies :restart, resources(:service => "ganglia-monitor")
  end
  
end