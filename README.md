# PowerShell scripts for Log4Shell

So far, it only includes the script `Remove-ArchiveItem.ps1`, which removes a specified class file from JAR files (or any ZIP file, for that matter).

This allows to implement one of the proposed workarounds for the Log4Shell vulnerability found in Log4j 2.X Java library (CVE-2021-44228 and CVE-2021-45046). The workaround consists in removing the `org/apache/logging/log4j/core/lookup/JndiLookup.class` class from the impacted JAR file.

It may be also useful for vulnerability CVE-2021-4104 found in Log4j 1.x, in which the class to remove is `org/apache/log4j/net/JMSAppender.class`. 

## `Remove-ArchiveItem.ps1`

Removes a class file from JAR files (or any ZIP file) returning the files that have been modified.

It takes a file path as target input parameter, which accepts values from pipeline, and a string containing the path of the class to remove.

It supports ShouldProcess parameters, e.g., -WhatIf, Confirm, etc.

### Usage

Examples of usage:

```powershell
PS> .\Remove-ArchiveItem.ps1 -JARFilePath C:\Users\myname\Downloads\MyJar.jar -ClassToDelete org/apache/commons/csv/CSVFormat.class
WARNING: Deleted matching class(es): org/apache/commons/csv/CSVFormat.class in file C:\Users\myname\Downloads\MyJar.jar

PS> Get-ChildItem C:\Users\myname\Downloads\*.jar | .\Remove-ArchiveItem.ps1 -ClassToDelete org/apache/commons/csv/CSVFormat.class
WARNING: Not matching class org/apache/commons/csv/CSVFormat.class in file C:\Users\Users\myname\Downloads\MyJar0.jar
WARNING: Deleted matching class(es): org/apache/commons/csv/CSVFormat.class in file C:\Users\myname\Downloads\MyJar1.jar
```

For further information, check the help of the script:

```powershell
Get-Help ./Remove-ArchiveItem.ps1
```
