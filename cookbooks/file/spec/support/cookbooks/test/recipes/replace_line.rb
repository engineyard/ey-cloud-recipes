file_replace_line '/test1' do
  replace 'test'
  with 'tested'
end

file_replace_line 'test2' do
  path '/test2/path.txt'
  replace /test/
  with 'tested'
end

file_replace_line 'test3' do
  action :nothing
end