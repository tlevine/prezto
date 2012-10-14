scp
=======
This reduces confusion when you forget to type a colon.

Function
-------
This wraps the `scp` command and warns you when you try running it without a
colon. An example:

    $ scp README.md tlevine@chainsaw.thomaslevine.com
    usage: scp [-12346BCpqrv] [-c cipher] [-F ssh_config] [-i identity_file]
               [-l limit] [-o ssh_option] [-P port] [-S program]
               [[user@]host1:]file1 ... [[user@]host2:]file2
     
    warning: The scp command that you ran has no colon, so you probably don't
           want to run it. Use "env scp" if you really meant to do that.

Authors
-------

*The authors of this module should be contacted via the [issue tracker][2].*

  - [Thomas Levine](https://github.com/tlevine)

[1]: https://github.com/sorin-ionescu/prezto/issues

 
