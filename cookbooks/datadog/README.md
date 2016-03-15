# Cookbook to setup LogEntries for EY Cloud

This is an EY Cloud Cookbook to install and setup DataDog when it is enabled as a Service.  Many thanks to [Alex Morrale](https://github.com/AlexMorreale) for contributing it.

It has only been tested on EY's v4 stack.  If you make it work or face issues when using other versions of the stack feel free to open a case.

#### Usage

Add the API key provided by DataDog on `datadog\attributes/default.rb`
Enable the recipe by adding the following to `main\recipes\default.rb`

```
include_recipe "datadog"
```


