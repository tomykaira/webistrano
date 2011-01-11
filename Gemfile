source 'http://rubygems.org'

gem 'rails', '3.0.3'

# TODO: what are the direct dependencies? -- fd
gem 'net-ssh',         '2.0.15', :require => 'net/ssh'
gem 'net-scp',         '1.0.2',  :require => 'net/scp'
gem 'net-sftp',        '2.0.2',  :require => 'net/sftp'
gem 'net-ssh-gateway', '1.0.1',  :require => 'net/ssh/gateway'
gem 'capistrano',      '2.5.9'
gem 'highline',        '1.5.1'
gem 'open4',           '0.9.3'
gem 'syntax',          '1.0.0'

group :development do
  gem 'sqlite3-ruby', :require => 'sqlite3'
end

group :test do
  gem 'sqlite3-ruby', :require => 'sqlite3'
  gem 'test-unit', '2.0.9', :require => 'test/unit'
  gem 'mocha'
end

group :production do
  gem 'mysql'
end
