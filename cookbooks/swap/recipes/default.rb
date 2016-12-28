# Configuration options
mount_device = '/dev/xvdb'          # for ephemeral use /dev/xvdd
swapfile_path = '/mnt/swapfile'     # for ephemeral use /tmp/eph1/swapfile
builtin_swap = '/dev/xvdc1'         # for c1.medium and m1.small use /dev/xvda3 instead
swapfile_size = 8 * 1024 # 8GB


blockdev = Mixlib::ShellOut.new "blockdev --getsize64 #{mount_device}"
blockdev.run_command

bash "move swap to #{swapfile_path}" do
  code <<-EOH
    dd of=#{swapfile_path} if=/dev/zero bs=1048576 count=#{swapfile_size}
    mkswap #{swapfile_path}
    swapon #{swapfile_path}
    swapoff #{builtin_swap}
    sed -i 's|^#{builtin_swap}|#{swapfile_path}|' /etc/fstab
  EOH
  only_if { File.exists?(mount_device) && blockdev.stdout.chomp.to_i > 35433480192 }
  not_if { File.exists?(swapfile_path)}
end