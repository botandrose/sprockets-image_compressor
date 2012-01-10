# Image compressor processor for Sprockets

Sprockets preprocessor to losslessly compress .png and .jpg images. Requires [pngcrush](http://pmt.sourceforge.net/pngcrush/) and [jpegoptim](http://www.kokkonen.net/tjko/projects.html) to be installed and in your PATH.

## Ruby compatibility

Ruby 1.8 requires sprockets >= 2.0.0.

Ruby 1.9 requires sprockets >= 2.2.0, due to encoding issues with binary assets in earlier versions.

## Integration with Rails 3.1+

Just add this gem to your Gemfile:

```ruby
gem 'sprockets-image_compressor'
````

The gem ships with a Railtie which will automatically register the compressor preprocessors.

## TODO

* Detect missing pngcrush or jpegoptim installations
* Provide configuration hooks
* Test Railtie

## License

(MIT License) - Copyright (c) 2011 Micah Geisel
