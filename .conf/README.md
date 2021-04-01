BuildAPKs/.conf README.md

These configuration files are located in ~/buildAPKs/.conf and their purpose is outlined in this table:

| File Name | Purpose |
| --------- | ------- |
| DOSO      | use cmake && make to build `*.so` files and add them to the APK |
| DOSON     | use cmake && ninja to build `*.so` files and add them to the APK |
| DRLIM     | display rate limit |
| EXTSTDO   | install most of the installation and the sources in in external storage **(partial design ; testing )** |
| GAUTH     | OAUTH GitHub authentication, file GAUTH has more informtion |
| LIBAUTH   | add libraries and artifacts into the APK build, file LIBAUTH has more informtion **(partial design ; stable )** |
| QUIET     | display build warning and error messages |
| RDR       | project root directory |
| README.md | this file |
| VERSIONID | current project version |
<!-- BuildAPKs/.conf README.md EOF -->
