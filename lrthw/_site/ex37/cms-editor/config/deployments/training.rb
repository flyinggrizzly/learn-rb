namespace :env do
  task :training do
    set :branch,       'production'                  # branch to deploy
    set :rails_env,    'training'                    # rails environment to use
    set :domain,       'digilin-02.bath.ac.uk'       # machine
    set :user,         'cms-training-editor'         # user to deploy as
    set :deploy_to,    '/home/cms-training-editor'   # home directory of user
    set :app_port,     3086                          # port to run on

    # Set symlink so that app can serve attachments from network drive
    set :symlink_paths, [['/store/cmsdev/training/attachments', 'public/attachments']]

    # uncomment and add to this if you wish to change defaults
    # set :shared_paths, ['tmp', 'log', 'config/unicorn.rb']

    # this needs to be here in every environment
    invoke :defaults
  end
end
