<#
.SYNOPSIS

Modify the JAVA_HOME env variable in your current Powershell console.
.DESCRIPTION
Author: Marc-Andre Girard
Modify the JAVA_HOME env variable in your current Powershell console from a .store file. You can add/remove/list all the version included in your stored file.
This script does not change permantely the value of the JAVA_HOME, only for the current console.
.PARAMETER Action

Will tell the script which action you want to execute.
Possible value are : "e", "echo","s","set","a","add","l","list","r","remove"
.PARAMETER Key

Refer to the key that will be used to get or set the version in the .store file.
.PARAMETER Value

Value that will be used to store in the .store file. Must be a valid Path.
#>
Param(
  [parameter(Mandatory=$true)]
  [ValidateSet("e", "echo","s","set","a","add","l","list","r","remove")]
  [string]$Action,
  [string]$Key,
  [string]$Value
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

switch ($Action){
    {"e","echo" -contains $_}{
        Output
    }
    {"s","set" -contains $_}{
        if(![string]::IsNullOrEmpty($Key)) {
            $value_from_file = GetValueFromFile($Key)
            SetJavaHome($value_from_file)
            Output
        } else {
            Write-Host "You must provide the key to set with -key or provide the second argument"
        }
    }
    {"a","add" -contains $_}{
        If (Test-Path $Value){
            AddVersionToFile $Key $Value
        } else {
            "The Path '$Value' Was Not Valid"
        }
       
    }
    {"l","list" -contains $_}{
        GetVersionsFromFile
    }
    {"r","remove" -contains $_}{
        RemoveVersionFromFile $Key
    }
    default {
        "You typed '$_' and it is has no associated action"
    }
}
