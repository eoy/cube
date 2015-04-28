namespace :jetty do
  desc "Install latest stable release of java and jetty"
  task :install, roles: :web do
    # remove_apt_repository 'ppa:ferramroberto/java'
    # remove_apt_repository 'ppa:openjdk/ppa'
    # run "#{sudo} apt-get -y update"
    # run "#{sudo} apt-get -y install openjdk-7-jdk"
    # run "#{sudo} apt-get install python-software-properties"
    # run "#{sudo} mkdir /usr/java"
    # run "#{sudo} ln -s /usr/lib/jvm/java-7-openjdk-amd64 /usr/java/default"
    run "cd /opt"
    run "wget \"http://eclipse.org/downloads/download.php?file=/jetty/stable-9/dist/jetty-distribution-9.0.7.v20131107.tar.gz&r=1\""
    run "#{sudo} mv download.php\?file\=%2Fjetty%2Fstable-9%2Fdist%2Fjetty-distribution-9.0.7.v20131107.tar.gz\&r\=1 jetty-distribution-9.0.0.M3.tar.gz"
    run "#{sudo} tar -xvf jetty-distribution-9.0.7.v20131107.tar.gz"
    run "#{sudo} mv jetty-distribution-9.0.7.v20131107 jetty"
    run "#{sudo} useradd jetty -U -s /bin/false"
    run "#{sudo} chown -R jetty:jetty /opt/jetty"
    run "#{sudo} cp /opt/jetty/bin/jetty.sh /etc/init.d/jetty"
  end
  after "deploy:install", "jetty:install"
end
