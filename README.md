# Upclid

## Description
Upclid is the client, which reports pending updates, wanted reboots, locked packages to [Upman](https://github/flat235/upman).

## Build / Installation
 - `mix deps.get`
 - `MIX_ENV=prod mix release`
 - extract `_build/prod/rel/upman/releases/0.0.1/upman.tar.gz` to `/opt/upclid`
 - copy `upclid.conf` to `/etc` and customize the url
 - copy `upclid.service` to `/etc/systemd/system/`
 - enable and start the service

## Working features
 - sending information about pending updates
 - sending information about pending reboot
 - sending information about locked packages
 - debian-based-distros supported
 - centos / RHEL(probably...) supported
 
## Planned features
 - (un)locking packages
 - executing updates
 - executing reboot
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
