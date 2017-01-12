namespace :env do
  task :production do
    set :branch,       'production'              # branch to deploy
    set :rails_env,    'production'              # rails environment to use
    set :domain,       'digilin-03.bath.ac.uk'   # machine
    set :user,         'cms-editor'              # user to deploy as
    set :deploy_to,    '/home/cms-editor'        # home directory of user
    set :app_port,     3085                      # port to run on

    # Set symlink so that app can serve attachments from network drive
    set :symlink_paths, [['/store/cms/attachments', 'public/attachments']]

    # uncomment and add to this if you wish to change defaults
    # set :shared_paths, ['tmp', 'log', 'config/unicorn.rb']

    # this needs to be here in every environment
    invoke :defaults
  end
end
