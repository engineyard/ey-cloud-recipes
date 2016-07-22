ImageMagick Cookbook
=========

There were two recent ImageMagick-related vulnerabilities:

* CVE-2016-5118
* CVE-2016-3714

This cookbook installs ImageMagick 6.9.0.3-r1 (available on the latest Gentoo 12.11 stack) and a policy.xml file. 

The 6.9.0.3-r1 ebuild includes backported patches to address the popen vulnerability in CVE-2016-5118.

The policy.xml file is the policy recommended in https://www.imagemagick.org/discourse-server/viewtopic.php?f=4&p=132726&sid=6b961f8b680a0c18189de528bd53504a#p132726 to address CVE-2016-3714.

To use this recipe, add the line

```
include_recipe 'imagemagick'
```

to `cookbooks/main/recipes/default.rb`.