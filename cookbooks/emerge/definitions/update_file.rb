define :update_file, :action => :append do
  require 'tempfile'

  filepath = params[:path] || params[:name]

  file params[:name] do
    backup params[:backup] if params[:backup]
    group params[:group] if params[:group]
    mode params[:mode] if params[:mode]
    owner params[:owner] if params[:owner]
    path filepath
  end

  case params[:action].to_sym
  when :append, :rewrite

    mode = params[:action].to_sym == :append ? 'a' : 'w'

    ruby_block "#{params[:action]}-to-#{filepath}" do
      block do
        File.open(filepath, mode) do |f|
          f.puts params[:body]
        end
        not_if(params[:not_if]) if params[:not_if]
      end
    end

  when :truncate

    execute "truncate-#{filepath}" do
      command "> #{filepath}"
      not_if(params[:not_if]) if params[:not_if]
    end

  end
end
