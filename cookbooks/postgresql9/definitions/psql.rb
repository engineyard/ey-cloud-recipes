define :psql do
  sql = params[:sql].gsub("'", %{\'})
  sql_not_if = params[:sql_not_if]
  sql_only_if = params[:sql_only_if]

  statement = %{su - postgres -c "psql -h localhost -c \\"%s\\""}

  execute "psql-#{params[:name]}" do
    action :run
    command sprintf(statement, sql)

    not_if "#{sprintf(statement, sql_not_if[:sql].gsub("'", %{\'}))} | #{sql_not_if[:assert]}" if sql_not_if
    only_if "#{sprintf(statement, sql_only_if[:sql].gsub("'", %{\'}))} | #{sql_only_if[:assert]}" if sql_only_if
  end
end
