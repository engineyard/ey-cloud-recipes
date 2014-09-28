default[:firefox]["28"] = {
  :url => "http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/28.0/linux-x86_64/en-US/firefox-28.0.tar.bz2",
  :filename => "firefox-28.0.tar.bz2",
  :sha => "c032902b548a6e22a5ec74fda376ca76",
  :firefox_dir => 'firefox'
}

default[:firefox]["32"] = {
  :url => "http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/32.0/linux-x86_64/en-US/firefox-32.0.tar.bz2",
  :filename => "firefox-32.0.tar.bz2",
  :sha => "53410cf0944d4d7136130e03cf1b58b7dc181007",
  :firefox_dir => 'firefox'
}

default[:firefox][:default_version] = "28"
default[:firefox][:other_versions] = ["32"]
