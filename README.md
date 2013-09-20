# Image compressor processor for Sprockets

Sprockets preprocessor to losslessly compress .png and .jpg images using [pngcrush](http://pmt.sourceforge.net/pngcrush/) and [jpegoptim](http://www.kokkonen.net/tjko/projects.html).

## Integration with Rails 3.1+

Just add this gem to your Gemfile:

```ruby
gem 'sprockets-image_compressor'
````

The gem ships with a Railtie which will automatically register the compressor preprocessors.

## Now with vendored binary fallbacks / Heroku support!

If the environment doesn't have pngcrush and/or jpegoptim installed, the gem will fall back on binaries packaged with the gem. Currently, only 32bit and 64bit linux binaries are included. Pull requests welcome for other architectures!

## TODO

* Provide configuration hooks
* Test Railtie

## Credits

* @nhogle for help with compiling and packaging the jpegoptim and pngcrush binaries
* @florentmorin for compatibility with sprockets-rails
* @dkubb for compatibility with Rails 4

## License

(MIT License) - Copyright (c) 2012 Micah Geisel
