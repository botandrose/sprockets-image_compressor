0.2.4 (05/18/2014)
-------------------------
* Bugfix: jpgs weren't being opened in binary mode. Thanks, @JakeTheSnake3p0!

0.2.3 (04/10/2014)
-------------------------
* Bugfix: Return original file and warn if compression fails. Thanks, @tomchentw!

0.2.2 (09/20/2013)
-------------------------

* Bugfix: Work on Rails 4. Thanks, @dkubb!

0.2.1 (07/20/2012)
-------------------------

* Bugfix: Work with Sprockets::Rails. Thanks, @florentmorin!
* Bugfix: Include license in gemspec. Thanks, @sunny!

0.2.0 (01/28/2012)
-------------------------

* Feature: Fallback to vendored binaries if pngcrush and/or jpegoptim aren't installed on the system. Works on Heroku, now!

0.1.2 (01/26/2012)
-------------------------

* Bugfix: Works on Rails 3.1 and 3.2 on Ruby 1.9

0.1.1 (12/26/2011)
-------------------------

* Bugfix: Make sure we're using binary encoding when dealing with the image files
* Bugfix: Add basic sprockets integration tests

0.1.0 (09/21/2011)
-------------------------

* Initial public release!
