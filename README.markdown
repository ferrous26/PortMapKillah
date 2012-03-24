# PortMapKillah

A daemonizable (via launchd) script that monitors UPnP mappings on the
local network and kills any mappings that match against a list of given
patterns.

## Setup

You will need to install the TCMPortMapper framework. You can do this
using the provided Rakefile:

```shell
rake tcmportmapper
```

Which will download and install the TCMPortMapper framework into your
personal frameworks directory (`~/Library/Frameworks`).

## Usage

```shell
./port_map_killah.rb [PATTERN [PATTERN2 [...]]]
```

Simply run the script and pass in as many strings as you want. The
strings will be turned into regular expressions that are matched against
the descriptions of port mappings. I usually use the script like so:

```shell
./port_map_killah.rb uTorrent
```

Which will kill any mappings created by uTorrent. If you do no include
any strings, the port map killah will simply monitor the network.

Output will be printed to standard out as well as the system logger. You
can view system logged output using Console.app (`/Applications/Utilities/Console.app`).

## Why

Because some people just don't listen. Using a script like this instead
of the router's management tools has the added benefit of not being
easily discoverable: they will have a hell of a time figuring out why
things aren't working properly.

## TODO

- Rake task to generate a launchd plist
- Allow the polling period to be configurable (currently every minute)

## License

Copyright (c) 2012 Mark Rada

PortMapKillah is available under the MIT License. 

You can view the details of the license at www.opensource.org/licenses/MIT

