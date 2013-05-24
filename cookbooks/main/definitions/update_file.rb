define :update_file, :action => :append do
  # requirements
  require 'tempfile'

  # find filepath
  filepath = params[:path] || params[:name]

  # file
  file params[:name] do
    path filepath
    backup params[:backup] if params[:backup]
    group params[:group] if params[:group]
    mode params[:mode] if params[:mode]
    owner params[:owner] if params[:owner]
    not_if params[:not_if] if params[:not_if]
    only_if params[:only_if] if params[:only_if]
  end

  # check which action we are performing
  case params[:action].to_sym
    
  # append or rewrite
  when :append, :rewrite
    # file mode
    mode = params[:action].to_sym == :append ? 'a' : 'w'

    # carry out the action
    ruby_block "#{params[:action]}-to-#{filepath}" do
      block do
        File.open(filepath, mode) do |f|
          f.puts params[:body]
        end
      end

      # guards
      not_if params[:not_if] if params[:not_if]
      only_if params[:only_if] if params[:only_if]
    end

  # truncate
  when :truncate
    # carry out truncation
    execute "truncate-#{filepath}" do
      command "> #{filepath}"

      # guards
      not_if params[:not_if] if params[:not_if]
      only_if params[:only_if] if params[:only_if]
    end
  end
end
