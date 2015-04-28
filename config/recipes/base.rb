def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

def close_sessions  # method is needed when changing user from root to deployer. Sessions need to close
  sessions.values.each { |session| session.close }
  sessions.clear
end

def add_apt_repository(repo)
  run "#{sudo} add-apt-repository #{repo}", :pty => true do |ch, stream, data|
    if data =~ /Press.\[ENTER\].to.continue/
      ch.send_data("\n")
    else
      Capistrano::Configuration.default_io_proc.call(ch, stream, data)
    end
  end
end

def remove_apt_repository(repo)
  run "#{sudo} add-apt-repository --remove #{repo}", :pty => true do |ch, stream, data|
    if data =~ /Press.\[ENTER\].to.continue/
      ch.send_data("\n")
    else
      Capistrano::Configuration.default_io_proc.call(ch, stream, data)
    end
  end
end

namespace :deploy do
  desc "Install everything onto the server"
  task :install do
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install python-software-properties fail2ban libxslt-dev libxml2-dev sqlite3 libsqlite3-dev"
  end
end
