include_recipe 'apache2::mod_python'

if node[:graphite][:dashboard][:enable_ssl]
  include_recipe 'apache2::mod_ssl'

  devops_secrets node[:graphite][:dashboard][:ssl_certificate] do
    data_bag      node[:graphite][:dashboard][:ssl_data_bag]
    item          node[:graphite][:dashboard][:ssl_data_bag_item]
    key           'key'
    owner         'root'
    group         'root'
    mode          0644
  end

  devops_secrets node[:graphite][:dashboard][:ssl_key] do
    data_bag      node[:graphite][:dashboard][:ssl_data_bag]
    item          node[:graphite][:dashboard][:ssl_data_bag_item]
    key           'key'
    owner         'root'
    group         'root'
    mode          0644
  end

  devops_secrets node[:graphite][:dashboard][:ssl_ca] do
    data_bag      node[:graphite][:dashboard][:ssl_data_bag]
    item          node[:graphite][:dashboard][:ssl_data_bag_item]
    key           'ca'
    owner         'root'
    group         'root'
    mode          0644
  end

  template "#{node[:apache][:dir]}/sites-available/graphite-ssl.conf" do
    mode          0644
    variables(    
      :web_dir          => node[:graphite][:home_dir],
      :log_dir          => node[:graphite][:dashboard][:log_dir],
      :enable_ssl       => node[:graphite][:dashboard][:enable_ssl],
      :ssl_certificate  => node[:graphite][:dashboard][:ssl_certificate],
      :ssl_key          => node[:graphite][:dashboard][:ssl_key],
      :ssl_ca           => node[:graphite][:dashboard][:ssl_ca]
    )
    source        "graphite-vhost-ssl.conf.erb"
  end

  apache_site "graphite-ssl.conf"
end

template "#{node[:apache][:dir]}/sites-available/graphite.conf" do
  mode          0644
  variables(    
    :web_dir          => node[:graphite][:home_dir],
    :log_dir          => node[:graphite][:dashboard][:log_dir]
  )
  source        "graphite-vhost.conf.erb"
end

apache_site "000-default" do
  enable        false
end

apache_site "graphite.conf"
