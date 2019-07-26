[buildAPKs](https://github.com/BuildAPKs/buildAPKs)

BuildAPKs has [source code](https://github.com/BuildAPKs) and [scripts](https://github.com/BuildAPKs/buildAPKs/tree/master/scripts/) in order to build APKs (Android Package Kits) on Android handhelds, and similar.  Quick setup instructions can be found here at https://buildapks.github.io/docsBuildAPKs/setup and also https://buildapks.github.io/docsBuildAPKs/reallyEasilyBuildAndroidAPKsOnDevice right here.

You can try building hundreds of exciting, amazing and beautiful APKs by running [shell scripts](https://www.google.com/search?q=shell+scripts) from [this directory](https://github.com/BuildAPKs/buildAPKs/tree/master/scripts/bash/build).  It is simple!  The minimal install size to start building your first apps (6) is about 10MB!  Have fun and enjoy compiling, hacking, modifying and running these select APKs!

**Cloning and updating [submodules](https://gist.github.com/gitaarik/8735255) is automated into the build\*.bash scripts.  If you recieve a history error message from `git pull`, the simplest solution is `mv ~/buildAPKs ~/b0` and then reclone into the $HOME folder.**  The `~/buildAPKs/sources/` directory can be a symbolic link to external storage space to save native space on device.  Prefix the build*.bash scripts with bash to run buildAPKs in external storage, e.g. [`$ bash buildFlashlights.bash`](https://raw.githubusercontent.com/BuildAPKs/buildAPKs/master/scripts/bash/build/buildFlashlights.bash).

Build Android APKs on device (smartphone and tablet).

Build Android APKs on device, on your smartphone and tablet with [Termux](https://github.com/termux/); Make applications for your Android smartphone and tablet! This repository contains source code for various Android applications that have been successfully built in [Termux](https://github.com/termux/).

Have you ever wanted to build your own application? Something that you can distribute over the Internet, and can be used on Android smartphones and tablets worldwide.  Would you dare to try to spend some time learning something new to do so?

[BuildAPKs](https://github.com/BuildAPKs/buildAPKs) is a repository of source code designed just for this purpose.  Source code is the way programs are written in a human understandable language for applications to compile and then to be run on an Android device.  These programs have been tested and were built successfully on device, a smartphone.  First successful builds on Sun May 28 2017 in [Termux](https://github.com/termux/) (Android 6.0.1 aarch64).

See https://buildapks.github.io/docsBuildAPKs/reallyEasilyBuildAndroidAPKsOnDevice for quick setup instructions and https://sdrausty.github.io/docsBuildAPKs for the documentation website for this project.  

This command: `for i in $(cat ~/buildAPKs/conf/UNAMES) ; do ~/buildAPKs/scripts/bash/build/build.github.bash $i ; done`shall attempt to build [UNAMES](https://raw.githubusercontent.com/BuildAPKs/buildAPKs/master/conf/UNAMES), all known GitHub usernames, while: `for i in $(cat ~/buildAPKs/conf/TNAMES) ; do ~/buildAPKs/scripts/bash/build/build.github.bash $i ; done`shall attempt to build [TNAMES](https://raw.githubusercontent.com/BuildAPKs/buildAPKs/master/conf/TNAMES), all known GitHub topics @GitHub.  Please submit a [pull request](https://github.com/BuildAPKs/buildAPKs/pulls) if you want a name added to these listings.

### Really Easily Build an Android APK on an Android Device (Smartphone and Tablet).

Prefix these bash scripts by typing dot slash `./` on your Android smartphone and tablet in Termux, i.e. type `./b` at the prompt ($), press TAB TAB (x2).  The prompt should magically add `uild`; Then add a capitol `A`.  Press TAB TAB (x2) again.  This should build the following command on the command line [`./buildAll.bash`](https://raw.githubusercontent.com/BuildAPKs/buildAPKs/master/scripts/bash/build/buildAll.bash) for you.  Press enter (return) in `~/buildAPKs/`.  Additional CLI information at [The Linux Documentation Project.](https://duckduckgo.com/?q=command+line+beginner+site%3Atldp.org)

The built APKs will be deposited into Download/builtAPKs for installing on smartphone and tablet through browsers, and download and file managers.  The minimal install size to start building your first applications is about 10MB.  Have fun and enjoy compiling, hacking, modifying and running these select APKs on device!

The [`buildAll.bash`](https://raw.githubusercontent.com/BuildAPKs/buildAPKs/master/scripts/bash/build/buildAll.bash) command can build hundreds of APKs on your device.  Maximum space allotment for complete build of everything included (755) is about 850MB for buildAPKs, plus about 74MB for the finished products deposited into /storage/emulated/0/Download/builtAPKs;  More than seven hundred and fifty five (755) Android applications can be made from source code on device today.

Contribute to this project through both [the issues page](https://github.com/BuildAPKs/buildAPKs/issues) and [pull requests](https://github.com/BuildAPKs/buildAPKs/pulls).  Enjoy building these select APKs for Termux [projects,](https://github.com/BuildAPKs/buildAPKs/tree/master/sources) and find the time to post your feelings [here,](https://github.com/BuildAPKs/buildAPKs/issues) and [at this wiki](https://github.com/BuildAPKs/buildAPKs/wiki).

If you're confused by this page try [this link,](http://tldp.org/) and you might want to try [this one.](https://www.debian.org/doc/) Post your what you have found at [the wiki](https://github.com/BuildAPKs/buildAPKs/wiki).

🛳⛴🛥🚢🚤🚣⛵
 
Message to [@Grimler91](https://github.com/Grimler91):  I have stepped on the ancient cobblestones in the capital, north of Stockholm. You enticed me to contribute. Then you with others deleted my hard effort, my work numerous times, before I became aware of your destructive actions towards Termux development. 

Later you banned the [SDRausty GitHub account](https://github.com/SDRausty) from Termux.  You and your team are keeping Termux away from Wikipedia, and guess what, I have a firm idea as to why. You want my latex academic literature, and my smartphone bitcoins Swedish liaison, don't you?  My academic literature is not to be stolen/deleted by you and your Termuxed deb packages!

Message to [@fornwall](https://github.com/fornwall):  DITTO. Do you like being the stooge? Too lazy to merge pull requests? Or is it, no ones rooted, and I cannot get the bitcoins and bounce a Tesla autodrive?

Message to [@Neo-Oli](https://github.com/Neo-Oli):  DITTO without Sweden encouraging me to root my stuff, just you and your team encouraging me to root away my Android citadel from Switzerland!

Message to [@xeffyr](https://github.com/xeffyr):  DITTO without Sweden encouraging me to root my stuff, just you and your group encouraging me to root away my Android castle and to delete my open source GitHub contributions from the Ukraine!

Did you want to root my device to get to my BITCOINS?  To bounce my Tesla autodrive? To read my latexed literature? You know, latex is elastic. Read my work through your Termuxed latex *.deb files? I think not Grimler91. Neo-Oli our Termux Swiss liaison can you please confirm? Or are you and your team camping far away from us in the Alpine Mountains with other people's bitcoins?

You didn't like the timings, did you? I did not like them at all. Why is Termux slower? Degustamos rooted bitcoins?

Listen to [alphaV.webm](https://github.com/sdrausty/sdrausty.github.io/blob/master/audio/alphaV.webm?raw=true) and possibly you shall comprehend. Possibly.

`while true ; do play-audio alphaV.webm ; sleep ${RANDOM::2} ; done`

As you may well know, I have been using Termux software since it arrived. After years of using (coof coof) your open source software (does it compile?) I have a firm opinion about you. If it doesn't compile, what are you feeding me? Why are you wasting my time? To get my autodrive, my bitcoins? Why doesn't it compile from the source code that you publish? 

<!-- EOM -->
