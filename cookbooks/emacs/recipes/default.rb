#
# Cookbook Name:: emacs
# Recipe:: default
#

remote_file "/engineyard/portage/distfiles/eselect-emacs-1.14.tar.bz2" do
  source "http://distfiles.gentoo.org/distfiles/eselect-emacs-1.14.tar.bz2"
  owner "root"
  group "root"
  mode "0655"
  backup 0
  not_if { FileTest.exists?("/engineyard/portage/distfiles/eselect-emacs-1.14.tar.bz2") }
end

execute "install_emacs" do
  command "emerge app-editors/emacs"
  not_if { FileTest.exists?("/usr/bin/emacs-22") }
end
