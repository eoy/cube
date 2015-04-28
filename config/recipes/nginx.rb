namespace :nginx do
  desc "Install latest stable release of nginx"
  task :install, roles: :web do
    add_apt_repository 'ppa:nginx/stable'
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install nginx"
  end
  after "deploy:install", "nginx:install"

  desc "Setup nginx configuration for this application"
  task :setup, roles: :web do
    template "nginx_unicorn.erb", "/tmp/nginx_conf"
    run "#{sudo} mv /tmp/nginx_conf /etc/nginx/sites-enabled/#{application}"
    run "#{sudo} rm -f /etc/nginx/sites-enabled/default"
    # restart
    # puts "Creating a subdomain for the vhost\n"
    # cmd = "curl  -H 'X-DNSimple-Token: niklas@milkpluschocolate.com:gJv7D2o1TstZ9Jea2lP' \
    #   -H 'Accept: application/json' \
    #   -H 'Content-Type: application/json' \
    #   -X POST \
    #   -d '{\"record\":{\"name\": \"#{application}\",\"record_type\": \"A\",\"content\": \"#{server_ip}\",\"ttl\": 3600,\"prio\": 10}}' \
    #   https://dnsimple.com/domains/mplusc.net/records"
    # system(cmd)
  end
  after "deploy:setup", "nginx:setup"

  task :create_subdomain, roles: :web do
    puts "Creating a subdomain for the vhost\n"
    cmd = "curl  -H 'X-DNSimple-Token: welike@milkpluschocolate.com:#{ENV["DNS_SIMPLE_KEY"]}' \
      -H 'Accept: application/json' \
      -H 'Content-Type: application/json' \
      -X POST \
      -d '{\"record\":{\"name\": \"#{application}\",\"record_type\": \"A\",\"content\": \"#{server_ip}\",\"ttl\": 3600,\"prio\": 10}}' \
      https://dnsimple.com/domains/mplusc.net/records"
    system(cmd)
  end

  # task :dns, roles: :web do
  #   puts "Creating a subdomain for the vhost\n"
  #   cmd = "curl  -H 'X-DNSimple-Token: niklas@milkpluschocolate.com:gJv7D2o1TstZ9Jea2lP' \
  #     -H 'Accept: application/json' \
  #     -H 'Content-Type: application/json' \
  #     -X POST \
  #     -d '{\"record\":{\"name\": \"#{application}\",\"record_type\": \"A\",\"content\": \"#{server_ip}\",\"ttl\": 3600,\"prio\": 10}}' \
  #     https://dnsimple.com/domains/mplusc.net/records"
  #   system(cmd)
  # end

  %w[start stop restart].each do |command|
    desc "#{command} nginx"
    task command, roles: :web do
      run "#{sudo} service nginx #{command}"
    end
  end
end
