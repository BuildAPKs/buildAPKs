Should you find a username with APKs that build in the NUNAMES file, start a pull request in https://github.com/BuildAPKs/buildAPKs/pulls by adding to ONAMES, UNAMES, and possibly to an appropriate ma.bash file with the desired APK source code commit reference.  This means that two very simple pull requests can be submitted.  One in buildAPKs, by adding a name to the corresponding ONAMES and UNAMES file, just one word.  And the second pull in an appropriate module repository by adding an `_AT_` line in a ma.bash file. 

1) To see the available ma.bash files you can use: 
```
find ~/buildAPKs/sources/ -type f -name ma.bash -exec cat {} \;
```

2) The line of interest in ma.bash is: 
```
find ~/buildAPKs/sources/ -type f -name ma.bash -exec cat {} \; | grep _AT_
```

	Usage: `_AT_ org/repo commit`

	Usage: `_AT_ user/repo commit`


Adding information to ONAMES, UNAMES and the corresponding ma.bash file will enhance this progect and its' user experience.  The file ~/buildAPKs/.gitmodules has information about the repository associated with any particular ma.bash file.  For the curious, the `_AT_` function is located in `grep -r _AT_ ~/buildAPKs/scripts/` after the first APKs have been built, and the corresponding submodules have been cloned.


The only file that contains duplicate names is ENAMES in the following file list.  See do.sum.bash for more info:  These files are located in ~/buildAPKs/conf/:

| File Name   | Purpose   |
| ----------- | --------- |
| rm.dups.bash | parses [OU]NAMES for duplicate names in UNAMES |
| CNAMES      | checked names |
| ENAMES      | names with exceptional APK projects |
| GAUTH       | OATH token file |
| NUNAMES     | names with possible new APKs that might migrate to ONAMES, UNAMES and ma.bash |
| ONAMES      | organization names whose APKs build in buildAPKs on device |
| PNAMES      | pending names that might transition to ONAMES, UNAMES and ma.bash |
| README.md   | this file |
| TNAMES      | topics that build with buildAPKs on device |
| UNAMES      | user names whose APKs build in buildAPKs on device |
| VERSIONID   | current buildAPKs Version |

##### Some source pages:
   * [https://github.com/amitshekhariitbhu/awesome-android-complete-reference](https://github.com/amitshekhariitbhu/awesome-android-complete-reference)
   * [https://github.com/wasabeef/awesome-android-ui](https://github.com/wasabeef/awesome-android-ui)
   * [https://github.com/JStumpp/awesome-android](https://github.com/JStumpp/awesome-android)
   * [https://github.com/Trinea/android-open-project](https://github.com/Trinea/android-open-project)

##### Information about shells:
   * [https://developer.ibm.com/tutorials/l-linux-shells/](https://developer.ibm.com/tutorials/l-linux-shells/)
   * [http://tldp.org/guides.html](http://tldp.org/guides.html)
<!-- README.md EOF -->
