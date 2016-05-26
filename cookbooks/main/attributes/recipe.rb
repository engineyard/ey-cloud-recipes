# This causes the chef run to fail on Chef 12
# So far, my testing shows that it can be safely commented out on Chef 10
# Is this being used in Chef 0.6? If not we can just remove it altogether
unless Chef::VERSION[/^12/]
  recipes('main')
end
