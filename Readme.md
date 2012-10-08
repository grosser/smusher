*LOSSLESS* image size reduction for jpg, png and gif in the cloud

 - no image libraries needed, everything done in the interwebs
 - less size (up to a 97% saving) = faster downloads = less bandwidth + happy users

Install
=======
    install ruby + rubygems
    sudo gem install smusher

Usage
=====
Optimize a single image or a whole folder:

    smusher /apps/x/public/images [options]
    smusher /apps/x/public/images/x.png [options]
    smusher /apps/x/public/images/*.png [options]

Options:
    -q, --quiet                      no output
    -c, --convert-gifs               convert gifs to PNGs
    --service PunyPng                use PunyPng for image optimizing, instead of SmushIt
    -v, --version                    display current version

Example
======
    smusher /apps/ts/public/images
      smushing /apps/rs/public/images/social/facebook_icon.png
      2887 -> 132                              = 4%

      smushing /apps/rs/public/images/social/myspace_icon.png
      3136 -> 282                              = 8%

      smushing /apps/rs/public/images/dvd/dvd_1.png
      5045 -> 4                                = 0%
      reverted!
      ...

### PunyPng - usage limit
The default `Smusher::PunyPng.api_key` is used by all users and
could already be full when you try to smush some images.

Create a .puny_png_api_key in your home directory with your own
api key from [PunyPng](http://www.gracepointafterfive.com/punypng).

Protection
==========
Any image that returns a failure code, is larger than before,
or is empty will not be saved.

TODO
====
 - only optimize 'new' images -> save time when doing on already optimized folder

JS + CSS
============
reduce images and minify css + js -> try [reduce](http://github.com/grosser/reduce).

Authors
======
### [Contributors](http://github.com/grosser/smusher/contributors)
 - [ahaller](http://ahax.de/)
 - [retr0h](http://geminstallthat.wordpress.com/)
 - [Nate Pickens](http://github.com/npickens)

[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
Hereby placed under public domain, do what you want, just do not hold me accountable...
