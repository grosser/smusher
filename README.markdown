Problem
=======
 - Images are too large because they are not optimized
 - Users & your bandwidth is wasted for useless metadata
 - local image optimization requires tons of programs / libaries / knowledge

Solution
========
 - *LOSSLESS* size reduction (10-97% size reduction) in the cloud
 - optmizes all images(jpg+png+[gif]) from a given folder

Install
=======
    install ruby + rubygems + curl
    sudo gem install grosser-smusher --source http://gems.github.com/

Usage
=====
Optimize a single image or a whole folder in the cloud.

converting gif-s to png-s:

 - called with a folder gif-s will not be converted
 - called on a singe .gif, it will be converted if it is optimizeable

Usage:
    smusher /apps/x/public/images [options]
    smusher /apps/x/public/images/x.png [options]

Options are:
    -q, --quiet                      no output
    -c, --convert-gifs               convert all .gif`s in the given folder


Protection
==========
Any image that returns a failure code, is larger than before,  
or is empty will not be saved.

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

TODO
====
 - only optimize 'new' images -> save time when doing on each deploy
 - use ruby library rather than curl
 - support `smusher images/*.png` ?

Author
======
Michael Grosser  
grosser.michael@gmail.com  
Hereby placed under public domain, do what you want, just do not hold me accountable...  