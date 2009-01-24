Problem
=======
 - Images are too large because they are not optimized
 - Users & your bandwidth is wasted for useless metadata
 - local image optimization requires tons of programs / libaries / knowledge

Solution
========
 - *LOSSLESS* size reduction (10-97% size reduction) in the cloud
 - optmizes all images(jpg+png) from a given folder

Install
=======
    install ruby + rubygems
    sudo gem install grosser-smusher --source http://gems.github.com/

Usage
=====
    # your pictures MUST be online in order to be optimized
    smusher /apps/x/public/images www.x.com/images
    smusher LOCAL_FOLDER REMOTE_FOLDER

Protection
==========
Smusher makes .backup copies of any image before optimizing.  
Any image that returns a failure code, is larger than before,  
or is empty will be reverted.

Example
======

  smusher /apps/ts/public/images xx.com/images
  sushing http://xx.com/images/social/facebook_icon.png -> /apps/rs/public/images/social/facebook_icon.png
  2887 -> 132                              = 4%

  sushing http://xx.com/images/social/myspace_icon.png -> /apps/rs/public/images/social/myspace_icon.png
  3136 -> 282                              = 8%

  sushing http://xx.com/images/dvd/dvd_1.png -> /apps/rs/public/images/dvd/dvd_1.png
  5045 -> 9677                             = 191%
  reverted!
  ...

TODO
====
 - no need for files to be online (direct upload)
 - windows support?

Author
======
Michael Grosser  
grosser.michael@gmail.com  
Hereby placed under public domain, do what you want, just do not hold me accountable...  