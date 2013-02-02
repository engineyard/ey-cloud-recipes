require 'chefspec'

describe 'sidekiq::default' do
  # instance roles
  roles = ['solo', 'app_master', 'app', 'db_master', 'db_slave', 'util']
  
  roles.each do |role|
    describe role do
      let(:chef_run) do 
        chef_run = ChefSpec::ChefRunner.new do |node|
          node['instance_role'] = role
          node['applications'] = ['alpha' => {}, 'beta' => {}]
          node['sidekiq_workers'] = 2
          node['sidekiq_utility_name'] = 'sidekiq'
        end
    
        chef_run.converge('sidekiq::default') 
      end
      
      it 'should write the bin script' do
        chef_run.should create_file('/engineyard/bin/sidekiq')
        chef_run.file('/engineyard/bin/sidekiq').should be_owned_by('root', 'root')
      end
      
      it 'should create monit files for each application' do
      end
    end
  end
end