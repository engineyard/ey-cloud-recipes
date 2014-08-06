require_relative 'spec_helper'

describe 'test::replace' do
  let(:chef_run) do
    File.stub(:read).and_call_original
    File.should_receive(:read).with("/test1").and_return('test')
    File.should_receive(:read).with("/test2/path.txt").and_return('test')
    
    ChefSpec::Runner.new(step_into: ['file_replace']).converge described_recipe
  end

  context '/test1' do
    it 'expect file_replace matcher to run' do
      expect(chef_run).to run_file_replace('/test1')
    end

    it 'expect ruby block to run' do
      expect(chef_run).to run_ruby_block('/test1')
    end
  end

  context 'test2' do
    it 'expect file_replace matcher to run' do
      expect(chef_run).to run_file_replace('test2')
    end

    it 'expect ruby block to run' do
      expect(chef_run).to run_ruby_block('test2')
    end
  end

  context 'test3' do
    it 'expect file_replace matcher to not run' do
      expect(chef_run).not_to run_file_replace('test3')
    end
  end
end