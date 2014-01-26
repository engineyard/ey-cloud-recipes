#
# Cookbook Name:: collectd-custom
# Library:: default
#

def collectd_plugin_option_value(option)
  return option if option.instance_of?(Fixnum) || option == true || option == false
  "\"#{option}\""
end

def collectd_plugin_conf(config, level=0)
  conf = []
  config.to_hash.each_pair do |key, value|
    if value.is_a? Array
      value.each do |subvalue|
        conf << "#{key} #{collectd_plugin_option_value(subvalue)}"
      end
    elsif value.is_a? Hash
      value.each_pair do |name, suboptions|
        conf << "<#{key} \"#{name}\">"
        conf << "#{collectd_plugin_conf(suboptions, level+2)}"
        conf << "</#{key}>"
      end
    else
     conf << "#{key} #{collectd_plugin_option_value(value)}"
    end
  end
  conf.join("\n" + (" "*level))
end
