# Block

A custom chef recipe that allows you to block IP addresses from accessing your servers, via iptables.

## Usage

Add the IPs that you wish to block to the `recipes/default.rb` file, using the following syntax:

```ruby
block do
  ip "111.111.111.111"
  ip "222.222.222.222", :ports => [22, 80, 443]
end
```