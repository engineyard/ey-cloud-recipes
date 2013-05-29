cookbook_path [ File.expand_path("../cookbooks", File.dirname(__FILE__)) ]
cache_type 'BasicFile'
cache_options({ 
	:path => "#{ENV['HOME']}/.chef/checksums",
	:skip_expires => true
})
