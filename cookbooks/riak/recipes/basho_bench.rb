# AppCloud's GCC does not include Fortran by default, so let's install GCC binaries with fortran.

if File.exists?("/usr/bin/gfortran")
  # noop
else
  execute "emerge =sys-devel/gcc-4.1.2" do
    action :run
  end
end

directory "/mnt/src" do
  owner "root"
  group "root"
  action :create
  mode 0755
end
remote_file "/mnt/src/R-2.13.0.tar.gz" do
  source "http://cran.opensourceresources.org/src/base/R-2/R-2.13.0.tar.gz"
  backup 0
  owner "root"
  group "root"
  not_if { File.exists?("/mnt/src/R-2.13.0.tar.gz") }
end

package "x11-libs/libXt" do
  version "1.0.5"
  action :install
end

package "x11-libs/libICE" do
  version "1.0.4"
  action :install
end

execute "un-archive R" do
  cwd "/mnt/src"
  command "tar zxfv R-2.13.0.tar.gz"
  not_if { File.exists?("/usr/bin/Rscript") }
end

execute "configure R" do
  cwd "/mnt/src/R-2.13.0"
  command "./configure --prefix=/usr"
  not_if { File.exists?("/usr/bin/Rscript") }
end

execute "make R" do
  cwd "/mnt/src/R-2.13.0"
  command "make -j2"
  not_if { File.exists?("/usr/bin/Rscript") }
end

execute "make install R" do
  cwd "/mnt/src/R-2.13.0"
  command "make install"
  not_if { File.exists?("/usr/bin/Rscript") }
end
