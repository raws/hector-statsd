hector-statsd is a [Hector](https://github.com/sstephenson/hector) extension which sends statistics to a [statsd](https://github.com/etsy/statsd) server. You may configure custom statistics to accompany the following:

* `traffic.in` -- All lines received by Hector
* `traffic.out` -- All lines sent by Hector
* `connections` -- The number of active connections
* `ssl_connections` -- The number of active SSL connections (as a subset of `connections`)

hector-statsd works with any statsd client which responds to `increment(stat_name)` and `decrement(stat_name)`, such as [statsd-ruby](https://rubygems.org/gems/statsd-ruby).

### Installation and usage

Install the [hector-statsd gem](https://rubygems.com/gems/hector-statsd) and navigate to your server:

```shell
$ gem install hector-statsd
$ cd myserver.hect
```

Load hector-statsd in `init.rb` and configure it with a statsd client and namespace:

```ruby
require "hector/statsd"
require "statsd"
Hector.statsd.client = Statsd.new("statsd.example.com", 8125)
Hector.statsd.namespace = "com.example.hector"
```

Track any [Hector event](https://github.com/sstephenson/hector/tree/master/lib/hector/commands) with a custom statistic:

```ruby
Hector.statsd.track "messages", :received_privmsg
```

You may also watch for a regex pattern in the response text. To keep track of people addressing Sam:

```ruby
Hector.statsd.track "messages.sam", :received_privmsg, /^sam:/i
```

### License (MIT)

Copyright © 2012 Ross Paffett.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
