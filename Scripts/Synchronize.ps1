[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Source,
    [Parameter(Mandatory = $true)]
    [string]$Destination,
    [Parameter(Mandatory = $true)]
    [string]$ApiKey
)
begin {
    nuget setapiKey "$ApiKey" -Source $Destination
}
process {
    $packages = nuget list -AllVersions -Source $Source

    $packages | ForEach-Object {
        $id, $version = $_ -Split " "
        $nupkg = $id + "." + $version + ".nupkg"
        $path = [IO.Path]::Combine($Source, $id, $version, $nupkg)

        Write-Host "nuget push -Source $Destination ""$path"""
        & nuget push -Source $Destination $path
    }
}
