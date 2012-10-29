# Collectd

A chef recipe that allows you to tune Collectd alert levels.

## Example

```ruby
collectd do
  load :warning => 4, :failure => 8
  db_space ['1.3GB', '500MB']
  data_space [3000000000, 1500000000]
  root_space :warning => '1245MB', :failure => '500MB'
  mnt_space :warning => 400000, :failure => 200000
end
```

## Options

Below is a list of all available options that can be passed to the `collectd` block:

| option     | description                                                               |
|------------|---------------------------------------------------------------------------|
| load       | sets the alerting levels for the CPU load                                 |
| db_space   | sets the alerting levels for the disk space remaining on the /db volume   |
| data_space | sets the alerting levels for the disk space remaining on the /data volume |
| root_space | sets the alerting levels for the disk space remaining on the / volume     |
| mnt_space  | sets the alerting levels for the disk space remaining on the /mnt volume  |

## Arguments

Each option can be passed either a `Hash` or an `Array`:

### Hash

If passing in a `Hash`, it must contain a `:warning` and a `:failure` key. eg:

```ruby
collectd do
  load :warning => 4, :failure => 8
end
```

### Array

If passing in an `Array`, it must contain two items. The first item will be used as the warning and the second as the failure level eg:

```ruby
collectd do
  load [4, 8]
end
```

### Values

Values can either be a `Numeric` value or a `String`. When using a `String`, you may use units (KB, MB, GB) eg:

```ruby
collectd do
  db_space ['1.3GB', '500MB']
end
```