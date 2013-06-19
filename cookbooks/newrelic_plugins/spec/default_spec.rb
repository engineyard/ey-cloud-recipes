require_relative 'spec_helper'

describe 'newrelic_plugins' do
  before do
    Fauxhai.mock :path => 'cookbooks/newrelic_plugins/spec/fauxhai.json' do |node|

    end
  end
  let(:chef_run) { ChefSpec::ChefRunner.new.converge 'newrelic_plugins::default' }

  it "should install the newrelic-plugin-agent with pip" do
    expect(chef_run).to execute_bash_script 'install newrelic-plugin-agent'
  end

  it "should create the newrelic_plugin_agent.yml template" do
    expect(chef_run).to create_file '/etc/newrelic_plugin_agent.yml'
    file = chef_run.template '/etc/newrelic_plugin_agent.yml'
    expect(file).to be_owned_by 'root', 'root'
  end

  it "should create the monit file" do
    expect(chef_run).to create_cookbook_file '/etc/monit.d/newrelic_plugin_agent.monitrc'
    file = chef_run.cookbook_file '/etc/monit.d/newrelic_plugin_agent.monitrc'
    expect(file).to be_owned_by 'root', 'root'
  end

  it "should create the init.d script" do
    expect(chef_run).to create_cookbook_file '/etc/init.d/newrelic_plugin_agent'
    file = chef_run.cookbook_file '/etc/init.d/newrelic_plugin_agent'
    expect(file).to be_owned_by 'root', 'root'
  end

  it "should add newrelic_plugin_agent to the default run level" do
    expect(chef_run).to execute_bash_script 'add to run level'
  end

  it "should reload monit" do
    expect(chef_run).to execute_command 'monit reload'
  end
end
