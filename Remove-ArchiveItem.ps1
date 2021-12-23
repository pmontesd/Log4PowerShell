<#
    .SYNOPSIS
    Removes a specified class file from JAR files (or any ZIP file, for that matter).

    .DESCRIPTION
    Removes a class file from JAR files (or any ZIP file) returning the files that have been modified.
    It takes a file path as target input parameter, which accepts values from pipeline, and a string
    containing the path of the class to remove.

    It supports ShouldProcess parameters, e.g., -WhatIf, Confirm, etc.

    .PARAMETER JARFilePath
    Specifies the file name of the JAR file. It accepts values from pipeline, but IT DOES NOT SUPPORT WILDCARDS.

    .PARAMETER ClassToDelete
    Specifies the path of the class to remove, e.g., 'org/apache/commons/csv/CSVFormat.class'.

    .INPUTS
    None. You can pipe file objects to Remove-ArchiveItem.ps1.

    .EXAMPLE
    PS> .\Remove-ArchiveItem.ps1 -JARFilePath C:\Users\myname\Downloads\MyJar.jar -ClassToDelete org/apache/commons/csv/CSVFormat.class
    WARNING: Deleted matching class(es): org/apache/commons/csv/CSVFormat.class in file C:\Users\myname\Downloads\MyJar.jar

    .EXAMPLE
    PS> Get-ChildItem C:\Users\myname\Downloads\*.jar | .\Remove-ArchiveItem.ps1 -ClassToDelete org/apache/commons/csv/CSVFormat.class
    WARNING: Not matching class org/apache/commons/csv/CSVFormat.class in file C:\Users\Users\myname\Downloads\MyJar0.jar
    WARNING: Deleted matching class(es): org/apache/commons/csv/CSVFormat.class in file C:\Users\myname\Downloads\MyJar1.jar
#>

[CmdletBinding(SupportsShouldProcess)]
param (

    [Parameter(Mandatory=$True,
               Position=1,
               ValueFromPipeline=$True)]
    [ValidateScript(
        {
            if (-Not ($_ | Test-Path)) { throw 'File or folder does not exist'}
            if (-Not ($_ | Test-Path -PathType Leaf)) { throw 'The Path argument must be a file. Folder paths are not allowed.'}
            return $true
        }
    )]
    [System.IO.FileInfo]
    $JARFilePath,

    [Parameter(Mandatory=$True, Position=2)]
    [String]
    $ClassToDelete
)

begin {
    Add-Type -AssemblyName System.IO.Compression.FileSystem
}

process {

    $zip =  [System.IO.Compression.ZipFile]::Open($JARFilePath, 'Update')
    Write-Verbose -Message "JAR file ${JARFilePath} opened"

    $ClassFound = $zip.Entries.Where({$_.FullName -eq $ClassToDelete})
    if (-not $ClassFound) {
        Write-Verbose -Message "Not matching class ${ClassToDelete} in file ${JARFilePath}"
        $zip.Dispose()
        return
    }

    Write-Verbose -Message "Found matching class(es) in ${JARFilePath}: $($ClassFound.FullName)"
    if ($PSCmdlet.ShouldProcess($JARFilePath, 'Removing found class(es)')) {
        $ClassFound.Delete()
        Write-Warning -Message "Deleted matching class(es): $($ClassFound.FullName) in file ${JARFilePath}"
        Write-Verbose -Message "JAR file $JARFilePath updated"
        Write-Output -Object $JARFilePath
    }

    $zip.Dispose()
}