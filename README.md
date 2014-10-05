# SRTMGem

Gem parses SRTM data and for given latitude/longitude returns the elevation for that point, or nearest interpolated. Fetching of SRTM data files will be supported soon.

## Installation

Add this line to your application's Gemfile:

    gem 'SRTMGem'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install SRTMGem

## Usage

    srtm = SRTM.new('/path/to/hgt/file/N46E016.hgt')

    p srtm.get_elevation(16.223, 46.7421)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
