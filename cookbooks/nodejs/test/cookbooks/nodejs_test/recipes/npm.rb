include_recipe 'git'

user 'random' do
  supports :manage_home => true
  home '/home/random'
end

# global "express"
nodejs_npm 'express'

nodejs_npm 'async' do
  version '0.6.2'
end

nodejs_npm 'request' do
  url 'github mikeal/request'
end

git '/home/random/grunt' do
  repository 'https://github.com/gruntjs/grunt'
  user 'random'
end

nodejs_npm 'grunt' do
  path '/home/random/grunt'
  json true
  user 'random'
end

nodejs_npm 'mocha' do
  options ['--force', '--production']
end
