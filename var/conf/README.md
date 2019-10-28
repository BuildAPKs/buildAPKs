Github \*NAMES README.md

When you find a GitHub username with APKs that builds with buildAPKs, concider adding to this project by submitting a [pull request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request) at https://github.com/BuildAPKs/buildAPKs/pulls by adding to CNAMES, ONAMES and/or UNAMES, and possibly to appropriate ma.bash files with the desired APK project(s) source code GitHub commit reference(s). 
This means that two very simple pull requests can be submitted:  One in buildAPKs, by adding a name to the corresponding CNAMES, ONAMES and/or UNAMES files, just one word in the corresponding files per GitHub login.  The second pull request can be added in an appropriate https://github.com/BuildAPKs module repository by adding an `_AT_` line in the suitable ma.bash file, one per project.  This means that if a GitHub login has many interesting projects, multiple buildAPKs can recieve pull requests regarding the same user.    

#### The NUNAMES file should be a good starting point in fullfilling this desire.

1) To see the available ma.bash files you can use: 
```
find ~/buildAPKs/sources/ -type f -name ma.bash -exec cat {} \;
```

2) The line of interest in ma.bash is: 
```
find ~/buildAPKs/sources/ -type f -name ma.bash -exec grep -H _AT_ {} \; 
```
Usage: `_AT_ login/repo commit`

Adding information to CNAMES, ONAMES and/or UNAMES and the corresponding ma.bash file shall enhance this project.  The file ~/buildAPKs/.gitmodules has information about the repository associated with any particular ma.bash file.  The `_AT_` function is located in `grep -r _AT_ ~/buildAPKs/scripts/` after the first APKs have been built and the corresponding submodules have been cloned.

These files contain duplicate names: CNAMES, ENAMES, ONAMES, UNAMES and ZNAMES.  File rm.dups.bash has more information.  The following files are located in ~/buildAPKs/var/conf/ and their purpose is listed below:

| File Name   | Purpose   |
| ----------- | --------- |
| CNAMES      | checked names |
| ENAMES      | names with exceptional APK projects |
| GAUTH       | OATH token file:  Enabling OAuth increases the rate limit for authenticated users.  To create an OAuth token, you can use https://github.com/settings/tokens and insert this token into the first line in GAUTH.  File GAUTH has more information. |
| NUNAMES     | names with possible new APKs that might migrate to ONAMES, UNAMES and ma.bash |
| ONAMES      | organization names whose APKs build in buildAPKs on device |
| PNAMES      | pending names that might transition to ONAMES, UNAMES and ma.bash |
| README.md   | this file |
| TNAMES      | GitHub topics that build with buildAPKs on device |
| UNAMES      | user names whose APKs build in buildAPKs on device |
| ZNAMES      | user names who have zero APK projects |
| rm.dups.bash | parses files for duplicate names |

##### Some source pages for NUNAMES:
   * [https://github.com/amitshekhariitbhu/awesome-android-complete-reference](https://github.com/amitshekhariitbhu/awesome-android-complete-reference)
   * [https://github.com/wasabeef/awesome-android-ui](https://github.com/wasabeef/awesome-android-ui)
   * [https://github.com/JStumpp/awesome-android](https://github.com/JStumpp/awesome-android)
   * [https://github.com/Trinea/android-open-project](https://github.com/Trinea/android-open-project)

##### Information about shells:
   * [https://developer.ibm.com/tutorials/l-linux-shells/](https://developer.ibm.com/tutorials/l-linux-shells/)
   * [http://tldp.org/guides.html](http://tldp.org/guides.html)
<!-- README.md EOF -->
