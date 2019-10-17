Should you find APKs that build with buildAPKs in the NUNAMES and NWNAMES files and elsewhere, please pull in ONAMES, UNAMES and the appropriate ma.bash file.  This means that two pull requests can be submitted!  One in buildAPKs, by adding a name to the corresponding ONAMES or UNAMES file.  And the second pull in the appropriate module repository, by adding an _AT_ line in the ma.bash file. 

1) To see the available ma.bash files you can use: find ~/buildAPKs/sources/ -type f -name ma.bash -exec cat {} \;

2) The line of interest in ma.bash is: find ~/buildAPKs/sources/ -type f -name ma.bash -exec cat {} \; | grep _AT_

	Usage: _AT_ org/repo commit
	Usage: _AT_ user/repo commit

Adding to ONAMES, UNAMES and the appropriate ma.bash file will enhance this progect.  To find the repository associated with a particular ma.bash file see ~/buildAPKs/.gitmodules

For the curious, the _AT_ function is located in: grep -r _AT_ ~/buildAPKs/scripts/bash/  

These files are located in ~/buildAPKs/conf/:

GAUTH		OATH token file
NUNAMES		Possible new APKs that may migrate to ONAMES, UNAMES and ma.bash.
NWNAMES		Possible new APKs that may migrate to ONAMES, UNAMES and ma.bash.
ONAMES		Organizations that build APKs with buildAPKs on device.
README.md	This file
TNAMES		Topics that build APKs with buildAPKs on device.
UNAMES		Users that build APKs with buildAPKs on device.
VERSIONID	buildAPKs version
<!-- README.md -->
