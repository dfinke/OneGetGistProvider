$ModuleName   = "GistProvider"
$ModulePath   = "C:\Program Files\WindowsPowerShell\Modules"
$ProviderPath = "$($ModulePath)\$($ModuleName)"

if(!(Test-Path $ProviderPath)) { md $ProviderPath | out-null}

$FilesToCopy = echo GistProvider.psd1 GistProvider.psm1 

$FilesToCopy | ForEach {
	Copy-Item -Verbose -Path $_ -Destination "$($ProviderPath)\$($_)"
}