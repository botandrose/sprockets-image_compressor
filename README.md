# Image compressor processor for Sprockets

Sprockets preprocessor to losslessly compress images. Requires [pngcrush](http://pmt.sourceforge.net/pngcrush/) to be installed and in your PATH.

## Integration with Rails 3.1+

Just add this gem to your Gemfile:

```ruby
gem 'sprockets-image_compressor'
````

The gem ships with a Railtie which will automatically register the compressor preprocessor.

## Caveats

For the first release, it only compresses pngs with [pngcrush](http://pmt.sourceforge.net/pngcrush/). But don't worry, support for compressing jpegs via jpegoptim will be added shortly!

It doesn't even bother to make sure you have pngcrush installed.

Also, no tests.

### License

(MIT License) - Copyright (c) 2011 Micah Geisel
