
$p = @{
    Name = "GistProvider"
    NuGetApiKey = $NuGetApiKey 
    LicenseUri = "https://github.com/dfinke/OneGetGistProvider/blob/master/LICENSE" 
    Tag = "Gist","Github","PackageManagement","Provider"
    ReleaseNote = "Updated to work with rename to PackageManagement"
    ProjectUri = "https://github.com/dfinke/OneGetGistProvider"
}

Publish-Module @p