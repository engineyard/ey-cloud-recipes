directory "/mnt/src" do
	action :create
	owner "root"
	group "root"
	mode 0755
end

remote_file "/mnt/src/setuptools-0.6c11.tar.gz" do
  not_if { FileTest.exists?("/mnt/src/setuptools-0.6c11.tar.gz") }
  source "http://pypi.python.org/packages/source/s/setuptools/setuptools-0.6c11.tar.gz#md5=7df2a529a074f613b509fb44feefe74e"
end

execute "un-tar setuptools" do
  command "cd /mnt/src;tar zxfv setuptools-0.6c11.tar.gz"
  not_if { FileTest.directory?("/mnt/src/setuptools-0.6c11") }
end

execute "install setuptools" do
  command "cd /mnt/src/setuptools-0.6c11;python setup.py install"
  action :run
  not_if { FileTest.exists?("/usr/lib/python2.5/site-packages/setuptools-0.6c11-py2.5.egg") }
end
