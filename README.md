# Upclid

## Description
Upclid is the client, which reports pending updates, wanted reboots, locked packages to [Upman](https://github.com/flat235/upman).

## Build / Installation
 - `mix deps.get`
 - `MIX_ENV=prod mix release`
 - extract `_build/prod/rel/upclid/releases/${VERSION}/upclid.tar.gz` to `/opt/upclid`
 - copy `upclid.toml` to `/etc` and customize the url
 - copy `upclid.service` to `/etc/systemd/system/`
 - enable and start the service

## Working features
 - sending information about pending updates
 - sending information about pending reboot
 - sending information about locked packages
 - sending log of last update
 - debian-based-distros supported
 - centos / RHEL(probably...) supported
 - executing updates
 - executing reboot

## Features in development
 - (un)locking packages

## Planned features
 - more facts
 - more distributions

## Contributions very welcome!
Issues, pull requests, documentation, questions, feature request, whatever your method - your contributions are very welcome!

## Minimal Doc for adding distributions
 - look at implementations under [lib/upclid/os/](lib/upclid/os/)
 - optionally implement your distribution (if you want a debian-based distro just proceed to next step)
 - add it to the implementation list in [lib/upclid/os.ex](upclid/lib/upclid/os.ex)

## License
[Apache 2.0](LICENSE)
