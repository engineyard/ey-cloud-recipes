file_replace '/test1' do
  replace 'test'
  with 'tested'
end

file_replace 'test2' do
  path '/test2/path.txt'
  replace /test/
  with 'tested'
end

file_replace 'test3' do
  action :nothing
end