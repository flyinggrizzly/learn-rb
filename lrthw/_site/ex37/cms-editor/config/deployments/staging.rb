namespace :env do
  task :staging do
    set :branch,       'staging'                 # branch to deploy
    set :rails_env,    'staging'                 # rails environment to use
    set :domain,       'digilin-02.bath.ac.uk'   # machine
    set :user,         'cms-editor'              # user to deploy as
    set :deploy_to,    '/home/cms-editor'        # home directory of user
    set :app_port,     3085                      # port to run on
    set :unicorn_worker_processes, 20            # override default of 5

    # Set symlink so that app can serve attachments from network drive
    set :symlink_paths, [['/store/cmsdev/staging/attachments', 'public/attachments']]

    # uncomment and add to this if you wish to change defaults
    # set :shared_paths, ['tmp', 'log', 'config/unicorn.rb']

    # this needs to be here in every environment
    invoke :defaults
  end
end
