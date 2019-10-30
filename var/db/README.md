GitHub `*NAMES` README.md

The build.github*.bash commands use this directory.  The [build.github.bash](https://raw.githubusercontent.com/BuildAPKs/buildAPKs/master/scripts/bash/build/build.github.bash) command can build all the APK projects in a GitHub account on device today!  When you find a GitHub username that builds with buildAPKs, consider adding to this project by submitting a [pull request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request) at https://github.com/BuildAPKs/buildAPKs/pulls by adding to one or more of the `*NAMES` files, and possibly to appropriate ma.bash files with the desired APK project(s) source code GitHub commit reference(s). 

This means that two very simple pull requests can be submitted:  One in buildAPKs, by adding a name to the corresponding `*NAMES` file or files, just one login name in each corresponding file per GitHub login.  The second pull request can be added in an appropriate https://github.com/BuildAPKs module repository by adding an `_AT_` line in the suitable ma.bash file, one per project.  This means that if a GitHub login has many interesting projects, multiple buildAPKs module repositories can recieve pull requests regarding the same user's projects.    

1) To see the available ma.bash files you can use: 
` find ~/buildAPKs/sources/ -type f -name ma.bash -exec cat {} \; `

2) The line of interest in ma.bash is: 
` find ~/buildAPKs/sources/ -type f -name ma.bash -exec grep -H _AT_ {} \; `
Usage: `_AT_ login/repo commit`

The file ~/buildAPKs/.gitmodules has information about each submodule repository.  The submodules located in ~/buildAPKs/sources/ contain each particular ma.bash file.  Running ~/buildAPKs/build.buildAPKs.modules.bash will populate the `.gitmodules` file and the submodules.  The `_AT_` function itself is located in ` grep -r _AT_ ~/buildAPKs/scripts/ ` after the corresponding submodules have been cloned into the ~/buildAPKs/ directory.

These files may contain duplicate names: CNAMES, ENAMES, ONAMES, UNAMES and ZNAMES.  File rm.dups.bash has more information.  The following files are located in ~/buildAPKs/var/db/ and their purpose is outlined below:

| File Name   | Purpose   |
| ----------- | --------- |
| CNAMES      | checked names |
| ENAMES      | names with exceptional APK projects |
| NUNAMES     | names with possible new APKs that might migrate to ONAMES, UNAMES and ma.bash |
| ONAMES      | organization names whose APKs build in buildAPKs on device |
| PNAMES      | pending names that might transition to ONAMES, UNAMES and ma.bash |
| QNAMES  ∆   | pending names that might transition to PNAMES, ONAMES, UNAMES and ma.bash |
| README.md   | this file |
| TNAMES      | GitHub topics that build with buildAPKs on device |
| UNAMES      | user names whose APKs build in buildAPKs on device |
| ZNAMES      | user names who have zero APK projects |
| rm.dups.bash | parses files for duplicate names |

∆ *system created file* 

NOTE:  Add a token username pair to ~/buildAPKs/.conf/GAUTH to use this OATH token file:  Enabling OAuth increases the rate limit for authenticated users.  To create an OAuth token, you can use https://github.com/settings/tokens and insert this token into the first line in GAUTH.  File [GAUTH](https://raw.githubusercontent.com/BuildAPKs/buildAPKs/master/.conf/GAUTH) has more information.  

##### Some source pages for NUNAMES:
   * [https://github.com/amitshekhariitbhu/awesome-android-complete-reference](https://github.com/amitshekhariitbhu/awesome-android-complete-reference)
   * [https://github.com/wasabeef/awesome-android-ui](https://github.com/wasabeef/awesome-android-ui)
   * [https://github.com/JStumpp/awesome-android](https://github.com/JStumpp/awesome-android)
   * [https://github.com/Trinea/android-open-project](https://github.com/Trinea/android-open-project)

##### Information about shells:
   * [https://developer.ibm.com/tutorials/l-linux-shells/](https://developer.ibm.com/tutorials/l-linux-shells/)
   * [https://www.gnu.org/software/bash/manual/bash.html](https://www.gnu.org/software/bash/manual/bash.html)
   * [http://tldp.org/guides.html](http://tldp.org/guides.html)
<!-- README.md EOF -->
