default_run_options[:pty] = true

set :application, "exp.tapani.net:7826"

set :repository,  "git@github.com:michaelleland/Submarine.git"

set :scm, "git"
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set deploy_via, :remote_cache

set :branch, "master"

set :user, "submarine"
set :password, "Submarine"
set :scm_passphrase, "Submarine"
set :use_sudo, true

set :deploy_to, "/home/submarine/rails/Submarine"

ssh_options[:forward_agent] = true

role :web, "#{application}"                          # Your HTTP server, Apache/etc
role :app, "#{application}"                          # This may be the same as your `Web` server
role :db,  "#{application}", :primary => true         # This is where Rails migrations will run

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
 namespace :deploy do
   task :start do
    run "/etc/init.d/apache2 start"
   end
   
   task :stop do
    run "/etc/init.d/apache2 stop" 
   end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end