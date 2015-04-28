namespace :postfix do
  desc "Install postfix"
  task :install, :roles => :app do
    run "#{sudo} apt-get install postfix -y"
  end
end
