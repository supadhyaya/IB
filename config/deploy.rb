############################
      ## voycerBI##
############################



set :shared_children, shared_children + %w{/credentials/}
set :application, "voycerBI" # Set the name of your application
set :scm, "git" # Set the version control type (I use GIT, SVN + others are also available)
set :repository, "git@bitbucket.org:voycerag/socialvoycedatabasetransformer.git" # Set the path to your version control repository
set :branch, "master" # Set the branch of the version control repository to deploy from
set :deploy_to, "/opt/database-migration/" # The remote path to deploy to (not the web root - you will need to edit this in your web server config later)
set :user, "idp" # Remote user to connect via SSH as
set :runner, "idp" # Remote user to run commands as
set :port, 22 # The port number to use for SSH
set :ssh_options, { :forward_agent => true } # Use SSH agent forwarding (use your personal SSH key for authenticating with your version control repository from your server)
set :copy_exclude, %w[.DS_Store .git .gitignore Capfile deploy.rb sftp-config.json] # List of files that shouldn't be deployed
set :keep_releases, 10 # Number of releases to keep on the server (allows you to roll back your application to a previous version)
set :use_sudo, false # Disable the use of sudo
set :normalize_asset_timestamps, false
# Deployment servers
role :server1, "46.16.77.31" # The domain or IP address of your web server

# After we've deployed, cleanup the old releases
#after "deploy:update", "deploy:cleanup

