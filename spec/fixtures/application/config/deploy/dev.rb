set :deploy_to, '/var/www/dkdeploy'
server 'dkdeploy-php.dev', roles: %w(web app backend), primary: true

# no ssh compression on the dev stage
set :ssh_options, {
  compression: 'none'
}

ssh_key_files = Dir.glob(File.join(Dir.getwd, '..', '..', '.vagrant', 'machines', '**', 'virtualbox', 'private_key'))
unless ssh_key_files.empty?
  # Define generated ssh key files
  set :ssh_options, fetch(:ssh_options).merge(
    {
      user: 'vagrant',
      keys: ssh_key_files
    }
  )
end

set :copy_source, 'htdocs'
set :copy_exclude, %w(
  Gemfile*
  .hidden
  **/.hidden
)

# Set http open timeout to 1 second
set :http_open_timeout, 60

# custom file access properties
set :custom_file_access, {
  app: {
    catalog: {
      owner: 'test-user',
      group: 'test-group',
      mode: 'a+rwx,o-wx',
      recursive: true
    }
  }
}
