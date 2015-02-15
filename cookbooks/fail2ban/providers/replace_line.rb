# Support whyrun
def whyrun_supported?
	true
end

action :run do

	file_path = new_resource.path || new_resource.name
	match_regex = Regexp.new(new_resource.replace)

	# Check if file matches the regex
	if ::File.read(file_path) =~ match_regex

		# Replace the line
		converge_by("Replace line #{new_resource}") do
			ruby_block "#{new_resource.name}" do
				block do
					file = Chef::Util::FileEdit.new(file_path)
					file.search_file_replace_line(match_regex, (new_resource.with or ''))
					file.write_file
				end
			end
		end

		Chef::Log.info "- #{new_resource.replace}"
		Chef::Log.info "+ #{new_resource.with}"

		# Notify that a node was updated successfully
		new_resource.updated_by_last_action(true)

	end
end
