
$p = @{
    Name = "GistProvider"
    NuGetApiKey = $NuGetApiKey 
    LicenseUri = "https://github.com/dfinke/OneGetGistProvider/blob/master/LICENSE" 
    Tag = "Gist","Github","OneGet""Provider"
    ReleaseNote = "Gist-as-a-Package - OneGet PowerShell Provider to interop with Github Gists"
    ProjectUri = "https://github.com/dfinke/OneGetGistProvider"
}

Publish-Module @p