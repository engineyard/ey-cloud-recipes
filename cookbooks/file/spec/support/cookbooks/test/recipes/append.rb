file_append '/test1' do
  line 'test'
end

file_append 'test2' do
  path '/test2/path.txt'
  line /test/
end

file_append 'test3' do
  action :nothing
end