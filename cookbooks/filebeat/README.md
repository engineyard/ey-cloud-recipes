# Cookbook to setup Filebeat for EY Cloud

This is an EY Cloud Cookbook to install and setup Filebeat when it is enabled as a Service.  

It has only been tested on EY's v4 stack.  If you make it work or face issues when using other versions of the stack feel free to open a case.

#### Usage

Add the host information for logstash on `filebeat\attributes/default.rb`
Enable the recipe by adding the following to `main\recipes\default.rb`

```
include_recipe "filebeat"
```
