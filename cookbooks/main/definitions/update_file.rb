define :update_file, :action => :append do
  require 'tempfile'

  # variables
  filepath = params[:path] || params[:name]
  params[:action] = params[:action].to_sym

  # the file
  file params[:name] do
    path filepath
    %w[backup group mode owner only_if not_if].each do |attr|
      send(attr, params[attr.to_sym]) if params[attr.to_sym]
    end
  end

  # perform action
  case params[:action]
  # append
  when :append
    ruby_block "append-to-#{filepath}" do
      block do
        File.open(filepath, 'a') do |f|
          f.puts params[:body]
        end
      end

      not_if params[:not_if] if params[:not_if]
      only_if params[:only_if] if params[:only_if]
    end
  # truncate
  when :truncate
    execute "truncate-#{filepath}" do
      command "> #{filepath}"

      not_if params[:not_if] if params[:not_if]
      only_if params[:only_if] if params[:only_if]
    end
  end
end
