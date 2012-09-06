#
# Cookbook Name:: mysql_administration
# Recipe:: default
#

# ***************************************************************************************
# NOTE: using the features in this recipe may limit your applications compatibility with
# platform functionality. Additional details about each recipe can be found in the
# README. If in doubt please consult our Support team before proceeding.
# ***************************************************************************************


# skip_slave_binlog - Disables binary logging on slave databases. The underlying recipe
# disables binary logging on all slaves but could be modified to disable this only on
# specific named slaves. To disable binary logging for slave databases uncomment the
# following line.
#  require_recipe "mysql_administration::skip_slave_binlog"