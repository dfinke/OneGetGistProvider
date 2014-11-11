$ModuleName = "GistProvider"
$ModulePath = ($env:PSModulePath -split ';')[0]
$ProviderPath = "$($ModulePath)\$($ModuleName)"

if(!(Test-Path $ProviderPath)) { md $ProviderPath | out-null}

echo GistProvider.psd1 GistProvider.psm1 | % {
	Copy-Item -Verbose -Path $_ -Destination "$($ProviderPath)\$($_)"
}
