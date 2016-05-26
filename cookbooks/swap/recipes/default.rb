# Configuration options
mount_device = '/dev/xvdb'
swapfile_path = '/mnt/swapfile'
swapfile_size = 8 * 1024 # 8GB
builtin_swap = '/dev/xvdc1'
# for c1.medium and m1.small use /dev/xvda3 instead
#builtin_swap = '/dev/xvda3'

blockdev = Mixlib::ShellOut.new "blockdev --getsize64 #{mount_device}"
blockdev.run_command

bash "move swap to #{swapfile_path}" do
  code <<-EOH
    dd of=#{swapfile_path} if=/dev/zero bs=#{swapfile_size} count=1048576
    mkswap #{swapfile_path}
    swapon #{swapfile_path}
    swapoff #{builtin_swap}
    sed -i 's|^#{builtin_swap}|#{swapfile_path}|' /etc/fstab
  EOH
  only_if { File.exists?(mount_device) && blockdev.stdout.chomp.to_i > 35433480192 }
  not_if { File.exists?(swapfile_path)}
end