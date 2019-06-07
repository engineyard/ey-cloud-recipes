execute "Update to rubygems 2.7.9" do
  command "gem install -v 2.7.9 rubygems-update && update_rubygems"
end
execute "Remove bundler installed by rubygems" do
  command "rm -rf /usr/lib64/ruby/site_ruby/*/bundler{,.rb} && rm -f /usr/local/lib64/ruby/gems/*/specifications/default/bundler*gemspec"
end
