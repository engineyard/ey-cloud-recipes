Firefox versions
=========

####Compatible with Linux Gentoo.
Downloads firefox zip files in home directory, extracts them and sym links files.

Attributes
----
In attributes/default.rb file add the firefox versions you want to extract from [firefox ftp url]. Add the sha1 checksum in the file.

Recipes
----
Default recipe downloads the default firefox version and other firefox versions mentioned in the default attributes file, them symlinks them with /usr/bin/firefox#{version}. The default version is also symlinked with /usr/bin/firefox.

[firefox ftp url]:http://ftp.mozilla.org/pub/mozilla.org/firefox/releases
