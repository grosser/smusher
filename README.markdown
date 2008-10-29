Syntax
======

    #Smush a single image
    rake URL=url_of_image FILE=file
    rake URL=www.x.com/logo.png FILE=public/logo.png

    #Smush all images in a folder
    rake URL=url_of_image_root FOLDER=folder
    rake URL=www.x.com/images FOLDER=public/images


Protection
==========

smush makes .backup copies of any image before smushing.
Any image that returns a failure code, or is larger than before
will be reverted.