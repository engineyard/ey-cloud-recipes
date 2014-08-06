# Support whyrun
def whyrun_supported?
	true
end

action :run do

	file_path = new_resource.path || new_resource.name

	# Check if the file already contains the line
	unless ::File.exists?(file_path) && ::File.read(file_path) =~ /^#{Regexp.escape(new_resource.line)}$/

		# Append to file
		converge_by("Append #{new_resource}") do
			ruby_block "#{new_resource.name}" do
				block do
					begin
						file = ::File.open(file_path, "a")
						file.puts new_resource.line
					ensure
						file.close
					end
				end
			end
		end

		Chef::Log.info "+ #{new_resource.line}"

		# Notify that a node was updated successfully
		new_resource.updated_by_last_action(true)

	end
end
