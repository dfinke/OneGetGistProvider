PowerShell OneGet Gist Provider
-
This PowerShell module implements the [OneGet PowerShell provider SDK]( http://oneget.org/provider-ps.zip).


Note
-
* This currently only looks at my gists (dfinke)
* WIP - implement dynamic options to handle any user id for gists* It is hard coded to create a directory `TryOneget` in C:\
	* it is stored in a variable at the top of the module
	* It stores the gist files retrieved
	* Creates a JSON file with SWID info  
* Need to get `Get-Package` to work against all packages installed
* `Get-PackageProvider` shows the GIST provider. `Find-Package` and `Install-Package` work with the `-ProviderName` parameter

![image](https://raw.githubusercontent.com/dfinke/OneGetGistProvider/master/images/OneGetProvider.gif)