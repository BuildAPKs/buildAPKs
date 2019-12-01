[buildAPKs](https://github.com/BuildAPKs/buildAPKs)

BuildAPKs has [source code](https://github.com/BuildAPKs) and [scripts](https://github.com/BuildAPKs/buildAPKs/tree/master/scripts/) in order to build APKs (Android Package Kits) on Android handhelds, and similar.  Quick setup instructions can be [found here](https://buildapks.github.io/docsBuildAPKs/setup) and [also right here.](https://buildapks.github.io/docsBuildAPKs/reallyEasilyBuildAndroidAPKsOnDevice)

You can try building hundreds of exciting, amazing and beautiful APKs by running [shell scripts](https://www.google.com/search?q=shell+scripts) from [this directory](https://github.com/BuildAPKs/buildAPKs/tree/master/scripts/bash/build).  It is simple!  The minimal install size to start building your first apps is about 10MB!  Have fun and enjoy compiling, hacking, modifying and running these select APKs!

Build Android APKs on device, on your smartphone and tablet with [Termux](https://github.com/termux/); Make applications for your Android smartphone and tablet! This repository contains source code for various Android applications that have been successfully built in [Termux](https://github.com/termux/).

Have you ever wanted to build your own application? Something that you can distribute over the Internet, and can be used on Android smartphones and tablets worldwide.  Would you dare to try to spend some time learning something new to do so?

[BuildAPKs](https://github.com/BuildAPKs/) is a project containing repositories of source code designed just for this purpose.  Source code is the way programs are written in a human understandable language for applications to compile and then to be run on an Android device.  These programs have been successfully built on device, a smartphone.  First successful builds on Sun May 28 2017 in [Termux](https://github.com/termux/) (Android 6.0.1 aarch64).

__Cloning and updating [submodules](https://gist.github.com/gitaarik/8735255) is automated into the ` build\*.bash ` scripts.  To manually update this project to the newest version, use ` update.buildAPKs.sh `.  See [`up.sh`](https://github.com/shlibs/shlibs.sh/blob/master/buildAPKs/maintenance/up.sh) for more information.__  If you recieve a history error message from ` git pull `, the simplest solution is ` mv ~/buildAPKs ~/b0 ` and then reclone into the $HOME folder.  See [CHANGE.log](https://raw.githubusercontent.com/BuildAPKs/buildAPKs/master/CHANGE.log) for this git repository change history. 

The ` ~/buildAPKs/sources/github ` and ` ~/buildAPKs/var ` directories can be symbolic links to external storage space to save native space on device.  For example, a ` github/var ` directory can be created and each can be symlinked with ` ln -s `.  Prefix the ` build\*.bash ` scripts with bash to run buildAPKs in external storage, e.g. [`$ bash buildFlashlights.bash`](https://raw.githubusercontent.com/BuildAPKs/buildAPKs/master/scripts/bash/build/buildFlashlights.bash). Build Android APKs on device (smartphone and tablet).

This command: ` for i in $(cat ~/buildAPKs/var/db/UNAMES) ; do ~/buildAPKs/scripts/bash/build/build.github.bash $i ; done ` shall attempt to build [UNAMES](https://raw.githubusercontent.com/BuildAPKs/buildAPKs/master/var/db/UNAMES), all known GitHub usernames. 

While this command: ` for i in $(cat ~/buildAPKs/var/db/TNAMES) ; do ~/buildAPKs/scripts/bash/build/build.github.bash $i ; done ` shall attempt to build [TNAMES](https://raw.githubusercontent.com/BuildAPKs/buildAPKs/master/var/db/TNAMES), all known GitHub topics @GitHub.  

Please submit a [pull request](https://github.com/BuildAPKs/buildAPKs/pulls) if you would like names added to these listings.  See [https://github.com/BuildAPKs/buildAPKs/tree/master/var/db/](https://github.com/BuildAPKs/buildAPKs/tree/master/var/db/)[README.md](https://raw.githubusercontent.com/BuildAPKs/buildAPKs/master/var/db/README.md) for more information about buildAPKs' database.

### Really Easily Build an Android APK on an Android Device (Smartphone and Tablet).

Prefix these bash scripts by typing dot slash ` ./ ` on your Android smartphone and tablet in Termux, i.e. type ` ./b ` at the prompt ($), press TAB TAB (x2).  The prompt should magically add ` uild `; Then add a capitol  ` A `.  Press TAB TAB (x2) again.  This should build the following command on the command line [`./buildAll.bash`](https://raw.githubusercontent.com/BuildAPKs/buildAPKs/master/scripts/bash/build/buildAll.bash) for you.  Press enter (return) in ` ~/buildAPKs/ `.  Additional CLI information at [The Linux Documentation Project.](https://duckduckgo.com/?q=command+line+beginner+site%3Atldp.org)

The built APKs will be deposited into Download/builtAPKs for installing on smartphone and tablet through browsers, and download and file managers.  The minimal install size to start building your first applications is about 10MB.  Have fun and enjoy compiling, hacking, modifying and running these select APKs on device!

The [`buildAll.bash`](https://raw.githubusercontent.com/BuildAPKs/buildAPKs/master/scripts/bash/build/buildAll.bash) command can build hundreds of APKs on your device.  Maximum space allotment for complete build of everything included (755) is about 850MB for buildAPKs, plus about 74MB for the finished products deposited into Download/builtAPKs;  More than seven hundred and fifty five (755) Android applications can be made from source code on device today.

Contribute to this project through both [the issues page](https://github.com/BuildAPKs/buildAPKs/issues) and [pull requests](https://github.com/BuildAPKs/buildAPKs/pulls).  Enjoy building these select APKs for Termux [projects,](https://github.com/BuildAPKs/buildAPKs/tree/master/sources) and find the time to post your feelings [here,](https://github.com/BuildAPKs/buildAPKs/issues) and [at this wiki](https://github.com/BuildAPKs/buildAPKs/wiki).

If you are confused by this page try [this link,](http://tldp.org/) and you might want to try [this one.](https://www.debian.org/doc/) Post your what you have found at [the wiki](https://github.com/BuildAPKs/buildAPKs/wiki).

🚢🚤🚣⛵

<!-- README.md EOF -->
