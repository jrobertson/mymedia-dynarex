Introducing the MyMedia-Dynarex gem

This gem publishes Dynarex files to jamesrobertson.eu, although it could be configured to publish Dynarex files to any website.

e.g.

    require 'simple-config'
    require 'mymedia-dynarex'

    lib = '/home/james/jamesrobertson.eu'

    h = SimpleConfig.new(File.read(File.join(lib,'mymedia.conf'))).to_h

    mmd = MyMediaDynarex.new(config: h)
    mmd.auto_copy_publish()


file: mymedia.conf

    # config file for mymedia

    home: /home/james/jamesrobertson.eu
    website: http://www.jamesrobertson.eu
    www: www

    # SimplePubSub (SPS) config
    sps:
      address: 192.168.4.171
      default_subscriber: niko

Note: Although I have been publishing Dynarex files on my website for several years now, this gem was only released today, and was previously known as jrdynarex.rb. The documentation for publishing MyMedia files is incomplete and development of the codebase is ongoing.

## Resources

* ?mymedia-dynarex https://rubygems.org/gems/mymedia-dynarex?

dynarex mymedia mymediadynarex gem
