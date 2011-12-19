define :sysctl, :action => :add do
  case params[:action]
  when :add
    params[:variables].each do |name, value|
      search  = "^#{Regexp.escape(name)}\\s*=.*$"

      execute "remove-#{name}-in-sysctl" do
        command "sed -i '/#{search}/d' /etc/sysctl.conf"
      end

      update_file "add-#{name}-to-sysctl" do
        action :append
        path '/etc/sysctl.conf'
        body "#{name} = #{value}"
      end
    end

    execute "reload-sysctl" do
      command "sysctl -p"
    end
  end
end
