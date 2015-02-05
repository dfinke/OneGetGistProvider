
$p = @{
    Name = "GistProvider"
    NuGetApiKey = $NuGetApiKey 
    LicenseUri = "https://github.com/dfinke/OneGetGistProvider/blob/master/LICENSE" 
    Tag = "Gist","Github","OneGet""Provider"
    ReleaseNote = "-VERBOSE displays location of installed package"
    ProjectUri = "https://github.com/dfinke/OneGetGistProvider"
}

Publish-Module @p