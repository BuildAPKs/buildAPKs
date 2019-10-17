Should you find APKs that build with buildAPKs in the NUNAMES and NWNAMES files and elsewhere, please pull in ONAMES, UNAMES and the appropriate ma.bash file.  This means that two pull requests can be submitted!  One in buildAPKs, by adding a name to the corresponding ONAMES or UNAMES file.  And the second pull in the appropriate module repository, by adding an _AT_ line in the ma.bash file. 

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


Adding to ONAMES, UNAMES and/or the appropriate ma.bash file will enhance this progect.  See the ~/buildAPKs/.gitmodules file to find the repository associated with a particular ma.bash file.  For the curious, the `_AT_` function is located in: 
```
grep -r _AT_ ~/buildAPKs/scripts/bash/
```


The following files are located in ~/buildAPKs/conf/:

| File Name | Purpose   |
| --------- | --------- |
| GAUTH     | OATH token file |
| NUNAMES   | List of GitHub project authors that might migrate to ONAMES, UNAMES and ma.bash. |
| NWNAMES   | List of GitHub project authors that might migrate to ONAMES, UNAMES and ma.bash. |
| ONAMES    | Organizations whose APKs build in buildAPKs on device. |
| README.md | This file |
| TNAMES    | Topics that have APK projects which build with buildAPKs on device. |
| UNAMES    | Users whose APKs build in buildAPKs on device. |
| VERSIONID | Current buildAPKs Version |
<!-- README.md EOF -->
