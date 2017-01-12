<#
    Name: javaenv
    Date: 12 September 2016
    Author: Marc-Andre Girard
    Purpose: Modify the JAVA_HOME env variable based on Java installations on the computer.
#>

Param(
  [Parameter(Mandatory=$True)]
  [string]$action,
  [string]$key,
  [string]$value
)

<#
    Show the JAVA_HOME variable to the screen
#>
function Output() {
    Get-ChildItem Env:JAVA_HOME
}

<#
    Set the JAVA_HOME variable in the Process scope to only influence the current process.
#>
function SetJavaHome([string]$value_to_set) {
    [Environment]::SetEnvironmentVariable("JAVA_HOME", $value_to_set, "Process")
}

<#
    Get a value from the version file, based on a key provided.
#>
function GetValueFromFile([string]$key_in_file) {
    $javaVersions = GetVersionsFromFile
    if($javaVersions.ContainsKey($key_in_file)) {
        $javaVersions.$key_in_file
    } else {
        Write-Host "The key does not exit in this file"
        exit
    }
}

<#
    Add a version to the version file, based on a key-value provided.
#>
function AddVersionToFile([string]$key_in_file, [string]$value_to_add) {
    $javaVersions = GetVersionsFromFile
    if (!$javaVersions.ContainsKey($key_in_file)) {
        Add-Content $dir/java_versions.store "$key_in_file=$value_to_add"
    } else {
        Write-Host "Key already exist in the file"
        exit
    }
    Write-Host "$key_in_file=$value_to_add"
    
}

function GetVersionsFromFile() {
    ConvertFrom-StringData (Get-Content $dir/java_versions.store | Out-String)
}

function RemoveVersionFromFile([string]$key_to_remove) {
    Write-Host $key_to_remove
    $javaVersions = GetVersionsFromFile
    $javaVersions.remove($key_to_remove)
    $content = HashConvertToString $javaVersions
    $content | Out-File $dir/java_versions.store
}

function HashConvertToString($ht) {
    $content_file = ""
    foreach($pair in $ht.GetEnumerator()) {
        $content_file += "{0}={1}`n" -f $($pair.key),$($pair.Value)
    }

    $content_file
}


Set-StrictMode -Version Latest

$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath


if($action -eq "e" -or $action -eq "echo") {
    Output
}


if($action -eq "s" -or $action -eq "set") {
    if(![string]::IsNullOrEmpty($key)) {
        $value_from_file = GetValueFromFile($key)
        SetJavaHome($value_from_file)
        Output
    } else {
        Write-Host "You must provide the key to set with -key or provide the second argument"
    }
    
}

if($action -eq "a" -or $action -eq "add") {
    AddVersionToFile $key $value
}

if($action -eq "l" -or $action -eq "list") {
    GetVersionsFromFile
}

if($action -eq "r" -or $action -eq "remove") {
    RemoveVersionFromFile $key
}
