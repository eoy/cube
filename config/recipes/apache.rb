set_default(:apache_document_root) { "/home/#{user}/public_html" }
set_default(:apache_server_name) { Capistrano::CLI.ui.ask "Apache Sever Name: " }

namespace :apache do
  desc "Install latest stable release of apache"
  task :install, roles: :web do
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install apache2"
  end
  after "deploy:install", "apache:install"

  desc "Setup apache configuration and virtual hosts"
  task :setup, roles: :web do
    #template "nginx_unicorn.erb", "/tmp/nginx_conf"
    run "#{sudo} mkdir -p ~/public_html"
    run "#{sudo} chown -R $USER:sudo ~/public_html; #{sudo} sudo chmod -R 755 ~/public_html"
    run "#{sudo} echo \"<h1>Virtual Host for #{user}</h1>\" >> ~/public_html/index.html"
    template "vhost.erb", "/tmp/apache_vhost_#{application}"
    run "#{sudo} mv /tmp/apache_vhost_#{application} /etc/apache2/sites-available/#{application}"
    run "#{sudo} a2ensite #{application}"
    restart
    puts "Creating a subdomain for the vhost\n"
    cmd = "curl  -H 'X-DNSimple-Token: niklas@milkpluschocolate.com:gJv7D2o1TstZ9Jea2lP' \
      -H 'Accept: application/json' \
      -H 'Content-Type: application/json' \
      -X POST \
      -d '{\"record\":{\"name\": \"#{application}\",\"record_type\": \"A\",\"content\": \"#{server_ip}\",\"ttl\": 3600,\"prio\": 10}}' \
      https://dnsimple.com/domains/mplusc.net/records"
    system(cmd)
  end
  after "apache:install", "apache:setup"

  %w[start stop restart].each do |command|
    desc "#{command} apache"
    task command, roles: :web do
      run "#{sudo} service apache2 #{command}"
    end
  end
end
