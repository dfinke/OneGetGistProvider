PowerShell PackageManagement Gist Provider
-
**Gist-as-a-package**

This PowerShell module implements the [PackageManagement PowerShell provider SDK]( http://oneget.org/provider-ps.zip).


Notes
-
* Supports your supplied Github credentials so there is no rate limiting
* `-Source` takes an array of user names
* Stores the downloaded gists in `$env:LOCALAPPDATA\OneGet\Gist`
* The fast package reference data in a csv in the same directory
* Supports `$request.IsCancelled`
* WIP:
	* Implement `Get-Package` 

![image](https://raw.githubusercontent.com/dfinke/OneGetGistProvider/master/images/OneGetProvider.gif)
