Elasticsearch Cookbook for AppCloud
---------------

You know, for Search

So, we build a web site or an application and want to add search to it, and then it hits us: getting search working is hard. We want our search solution to be fast, we want a painless setup and a completely free search schema, we want to be able to index data simply using JSON over HTTP, we want our search server to be always available, we want to be able to start with one machine and scale to hundreds, we want real-time search, we want simple multi-tenancy, and we want a solution that is built for the cloud.

"This should be easier", we declared, "and cool, bonsai cool".

[elasticsearch][2] aims to solve all these problems and more. It is an Open Source (Apache 2), Distributed, RESTful, Search Engine built on top of [Lucene][1].

NOTE: This recipe installs Elasticsearch 1.4.4 and requires Java 7 or later. It will only work on the Gentoo 12.11 stack; the Java 7 ebuild is not available on Gentoo 2009. We do not recommend running older versions of Elasticsearch - versions prior to 1.2 have a remote code execution vulnerability, see http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2014-3120

Known Issues
--------
- A prior version of this recipe would create duplicate bind mounts under `/proc/mounts`. These weren't known to create any specific problems so this was added as a cleanup rather than a bugfix. In order to remove the extra mounts you need to run `sudo umount /usr/lib64/elasticsearch-#{version}/data` for each extra mount.

Dependencies
--------

  * Your application should use gems(s) such as [tire][4],[rubberband][3],[elastic_searchable][5].

Using it
--------

There are several ways to use this recipe, depending on your environment.

  1. On a solo environment

``include_recipe "elasticsearch::non_util"``

  2. On a small cluster: run Elasticsearch on app_master

  ``include_recipe "elasticsearch::non_util"``

  3. On a cluster with dedicated util instances for Elasticsearch

  ``include_recipe "elasticsearch"``

  Name the Elasticsearch instances elasticsearch_0, elasticsearch_1, etc.

In all cases, make sure you create `/data/#{appname}/shared/config/elasticsearch.yml` on all application and utility instances so that the application knows how to connect to your elasticsearch server(s).


Verify
-------

On your instance, run: 

    curl localhost:9200

Results should be simlar to:

```
{
  "status" : 200,
  "name" : "Man-Thing",
  "cluster_name" : "YourEnvironmentName",
  "version" : {
    "number" : "1.4.0",
    "build_hash" : "bc94bd81298f81c656893ab1ddddd30a99356066",
    "build_timestamp" : "2014-11-05T14:26:12Z",
    "build_snapshot" : false,
    "lucene_version" : "4.10.2"
  },
  "tagline" : "You Know, for Search"
}
```

Plugins
--------

Rudamentary plugin support is there in a definition.  You will need to update the template for configuration options for said plugin; if you wish to improve this functionality please submit a pull request.  

Examples: 

``es_plugin "cloud-aws" do``
``action :install``
``end``

``es_plugin "transport-memcached" do``
``action :remove``
``end``


Caveats
--------

plugin support is still not complete/automated.  CouchDB and Memcached plugins may be worth investigating, pull requests to improve this.

Backups
--------

None automated, regular snapshot should work.  If you have a large cluster this may complicate things, please consult the [elasticsearch][2] documentation regarding that.

Warranty
--------

This cookbook is provided as is, there is no offer of support for this
recipe by Engine Yard in any capacity.  If you find bugs, please open an
issue and submit a pull request.

[1]: http://lucene.apache.org/
[2]: http://www.elasticsearch.org/
[3]: https://github.com/grantr/rubberband
[4]: https://github.com/karmi/tire
[5]: https://github.com/wireframe/elastic_searchable/
