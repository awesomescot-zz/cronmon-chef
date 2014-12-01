include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"
include_recipe "runit"

user "cronmon" do
  comment "cronmon user"
  system true
  shell "/bin/false"
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
end

rbenv_execute "cronmon_exec_bundle" do
  ruby_version "2.0.0-p247"
  command "bundle install --no-cache --path vendor/bundler"
  user "cronmon"
  group "cronmon"
  cwd "/opt/cronmon"
end

package "redis-server"

# unpack github repo into /opt/cronmon
# mv wrapper script to /usr/local/bin/
# 
# install correct gems
