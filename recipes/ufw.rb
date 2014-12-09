if node.attribute?('rackspace')
  firewall "ufw" do
    action :enable
  end

  firewall_rule "cronmon-firewall" do
    port 4555
    action :allow
    source "38.104.129.98"
    protocol :tcp
    notifies :enable, "firewall[ufw]"
  end
end
