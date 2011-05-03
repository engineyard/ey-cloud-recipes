mongo_version("1.8.1")
mongo_name("mongodb-linux-#{@attribute["kernel"]["machine"]}-static-legacy-#{@attribute["mongo_version"]}")
mongo_path("/opt/mongodb-linux-#{@attribute["kernel"]["machine"]}-static-legacy-#{@attribute["mongo_version"]}")
mongo_base("/data/mongodb")
mongo_port("27017")
if @attribute["utility_instances"].empty?
  # We have detected no utility instances, so we are skipping the logic for this portion of the recipe.
  else
    mongo_utility_instances( @attribute["utility_instances"].select { |ui| ui["name"].match(/mongodb/) } )
    if mongo_utility_instances[0]["name"].match(/repl/)
      mongo_replset ( mongo_utility_instances[1]["name"].sub("mongodb_","").sub("repl","").split("_")[0] )
    else
      mongo_replset( false )
    end
  end
mongo_journaling ( true )
