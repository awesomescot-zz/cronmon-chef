include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"
include_recipe "runit"

user "cronmon" do
  comment "cronmon user"
  system true
  shell "/bin/false"
end

directory "/opt/cronmon" do
  user "cronmon"
  group "cronmon"
  recursive true
end

rbenv_ruby "2.0.0-p247" do
    global :true
end

rbenv_gem "bundler" do
    ruby_version "2.0.0-p247"
end

git "/opt/cronmon" do
  repository "https://github.com/awesomescot/cronmon.git"
  reference "master"
  user "cronmon"
  group "cronmon"
  action :sync
  notifies :run, "rbenv_execute[cronmon_exec_bundle]" ,  :immediately
  notifies :run, "execute[copy_cron_wrapper]", :immediately
end

rbenv_execute "cronmon_exec_bundle" do
  ruby_version "2.0.0-p247"
  command "bundle install --no-cache --path vendor/bundler"
  user "cronmon"
  group "cronmon"
  cwd "/opt/cronmon"
#  notifies :run, "execute[chmod_/opt/cronmon/vendor]", :immediately
end

execute "copy_cron_wrapper" do
  command "cp ./cron_wrapper /usr/local/bin/"
  cwd "/opt/cronmon"
  action :nothing
end
#execute "chmod_/opt/cronmon/vendor" do
#  command "chmod -R 755 /opt/cronmon/vendor"
#  action :nothing
#end

package "redis-server"

runit_service "cronmon_runit"

directory "/var/log/cronmon"

