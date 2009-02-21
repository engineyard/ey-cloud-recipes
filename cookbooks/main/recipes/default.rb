execute "testing" do
  command %Q{
    echo "i ran at #{Time.now}" >> /root/yessir
  }
end