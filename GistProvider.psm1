$targetGistPath = "C:\TryOneGet"
$JSONFileName = "$($targetGistPath)\OneGetData.json"

$SwidFindCache    = @{}
$SwidInstallCache = @{}

#function Find-Gist {
#    param(
#        [Parameter(ValueFromPipeLine)]
#        [string[]]$User
#    )
#
#    Process {
#        Find-Package -ProviderName GistProvider -Source $User
#    }
#}

function Register-PackageSource { 
    param(
        [string] $name, 
        [string] $location, 
        [bool] $trusted
    )  
	write-debug "In GistProvider - Register-PackageSource"
	write-debug "In GistProvider - Register-PackageSource name: {0}" $name
}

<# 

#>
function Unregister-PackageSource { 
    param(
        [string] $name
    )
	write-debug "In GistProvider - Unregister-PackageSource"
}


<# 

#>  
function Find-Package { 
    param(
        [string[]] $names,
        [string] $requiredVersion,
        [string] $minimumVersion,
        [string] $maximumVersion
    )

	write-debug "In GistProvider - Find-Package"	
	write-debug "In GistProvider - Find-Package PackageSources: {0}" $request.PackageSources.Count
	write-debug "In GistProvider - Find-Package request keys: {0}" ($request.Keys|out-string)
	
	#write-debug ($names|out-string)	

	#$User = $request.PackageSources[0]

	$(foreach($User in ($request.PackageSources)) {	
	    ForEach($gist in (Invoke-RestMethod "https://api.github.com/users/$($User)/gists")) {
		
		    $FileName = ($gist.files| Get-Member -MemberType NoteProperty).Name
		    #write-debug "In GistProvider - Find-Package $FileName"

		    #$user=$request.YieldDynamicOption("GithubUser", "String", $true)
		    #write-debug ($request|gm|out-string)

		    $rawUrl = ($gist.files).($FileName).raw_url            

		    if($rawUrl) { 
			    $SWID=@{            
				fastPackageReference = $rawUrl
				name = $FileName
				version ="1.0"
				versionScheme="semver"
				source=$User
				summary=($gist.description).tostring()
				searchKey=$FileName.split('.')[0]
			    }            

			    if(!$SwidFindCache.ContainsKey($rawUrl)) {            
				$SwidFindCache.$rawUrl=New-SoftwareIdentity @SWID
			    }

			    $SwidFindCache.$rawUrl
                   }
   	    }
	})| Where {$_.Name -match $names} 
}

function Find-PackageByFile { 
    param(
        [string[]] $files
    )

    write-debug "In GistProvider - Find-PackageByFile"
}

function Find-PackageByUri { 
    param(
        [Uri[]] $uris
    )
	write-debug "In GistProvider - Find-PackageByUri"
}

function Get-InstalledPackage { 
    param(
        [string] $name
    )
    
    #write-debug "In GistProvider - Get-InstalledPackage {0} {1}" $InstalledPackages.Count $name
    write-debug "In GistProvider - Get-InstalledPackage {0} {1}" $SwidInstallCache.Keys.Count $name
    
    if($name) {
    	write-debug "In GistProvider - Get-InstalledPackage {0}" $name
        $SwidInstallCache.GetEnumerator()| Where { $_.key -match $name } | % {
            $h=$_.Value
    	    New-SoftwareIdentity @h
        }
    } else {
    	write-debug "In GistProvider - Get-InstalledPackage no name" 
    	$SwidInstallCache.GetEnumerator() | % {            
            $h=$_.Value            
            write-debug "In GistProvider - Get-InstalledPackage {0} {1}" $_.key $h.name            
    	    #New-SoftwareIdentity @h
    	}
    }    
}

function Get-PackageProviderName { 
    param()
    return "GistProvider"
}

function Resolve-PackageSource { 
    param()
   
    write-debug "In GistProvider - Resolve-PackageSources"    
    write-debug "In GistProvider - Resolve-PackageSources ps: {0}" $request.PackageSources[0]
    write-debug "In GistProvider - Resolve-PackageSources gs: {0}" $request.GetSources().count
    #write-debug "In GistProvider - Resolve-PackageSources keys: {0}" ($request|gm|out-string)
    
    foreach($user in @($request.PackageSources)) {
        write-debug "In GistProvider - Resolve-PackageSources gist: {0}" "https://api.github.com/users/$($user)/gists"
        New-Object Microsoft.OneGet.MetaProvider.PowerShell.PackageSource -ArgumentList $user,"https://api.github.com/users/$($user)/gists",$false,$false,$true
        write-debug "Done In GistProvider - Get-PackageSources"    
    }
}

function Initialize-Provider { 
    param()
    write-debug "In GistProvider - Initialize-Provider"
    
    $data = (Get-Content -Raw $JSONFileName -ErrorAction Ignore) | ConvertFrom-Json     
    if($data) {
    	$names = ($data | Get-Member -MemberType NoteProperty).Name
    	
    	foreach($name in $names) {
    	    $record = $data.$name
    	    $SwidInstallCache.$name = @{
                fastPackageReference = $record.fastPackageReference
                name = $record.name
                version = $record.version
                versionScheme = $record.versionScheme
                source=$record.source
                summary=$record.summary
                searchKey=$record.searchKey
    	    }
    	}    	
    }    
}

function Install-Package { 
    param(
        [string] $fastPackageReference
    )
	write-debug "In GistProvider - Install-Package - $fastPackageReference "
	#write-debug "In GistProvider - Install-Package - $($request.Options.InputObject[0]|out-string)"
	
	$rawUrl = $fastPackageReference
	$psFileName=Split-Path -Leaf $rawUrl
	
	write-debug "In GistProvider - Install-Package - {0} exists? {1}" $targetGistPath (Test-Path $targetGistPath)
	
	if(!(Test-Path $targetGistPath)) {
		md $targetGistPath | Out-Null
	}
	
	$targetOut = "$($targetGistPath)\$($psFileName)"
    
	Invoke-RestMethod -Uri $rawUrl | Set-Content -Encoding Ascii $targetOut	
	
	#if(!$SwidInstallCache.ContainsKey($fastPackageReference)) {
	#	$SwidInstallCache.$fastPackageReference=$SwidFindCache.$fastPackageReference
	#}
	
	$SwidInstallCache.$fastPackageReference=$SwidFindCache.$fastPackageReference
	$SwidInstallCache | ConvertTo-Json | Set-Content -Encoding Ascii $JSONFileName
}

function Is-TrustedPackageSource { 
    param(
        [string] $packageSource
    )

    write-debug "In GistProvider - Is-TrustedPackageSource"

	return false;
}

function Is-ValidPackageSource { 
    param(
        [string] $packageSource
    )
	write-debug "In GistProvider - Is-ValidPackageSource"
	return false;
}

function Uninstall-Package { 
    param(
        [string] $fastPackageReference
    )
    write-debug "In GistProvider - Uninstall-Package"
}

function Get-Feature { 
    param()
	# Metadata that describes what this provider is used for.
    write-debug "In GistProvider - get-feature"

}

function Download-Package { 
    param(
        [string] $fastPackageReference,
        [string] $location
    )
    write-debug "In GistProvider - Download-Package"
}

function Get-PackageDependencies { 
    param(
        [string] $fastPackageReference
    )
    write-debug "In GistProvider - Get-PackageDependencies"
}

function Get-PackageDetail { 
    param(
        [string] $fastPackageReference
    )
    # NOT_IMPLEMENTED_YET
}

function Get-DynamicOptions { 
    param(
        [Microsoft.OneGet.MetaProvider.PowerShell.OptionCategory] $category
    )
    
    write-debug "In GistProvider - Get-DynamicOption for category $category"
 
    switch( $category ) {
        Package {
            # options when the user is trying to specify a package 
            
	    #[Parameter(Mandatory=$true)][Microsoft.OneGet.MetaProvider.PowerShell.OptionCategory]   $category,
	    #[Parameter(Mandatory=$true)][string]                                                    $name,
	    #[Parameter(Mandatory=$true)][Microsoft.OneGet.MetaProvider.PowerShell.OptionType]       $expectedType,
	    #[Parameter(Mandatory=$true)][bool]                                                      $isRequired,
	    #[System.Collections.ArrayList]                                                          $permittedValues = $null
	    
            #write-Output (New-DynamicOption $category "hint" String $false )
            #write-Output (New-DynamicOption $category  "color" String $false @("red","green","blue"))
            #write-Output (New-DynamicOption $category  "flavor" String $false @("chocolate","vanilla","peach"))
            
            #New-DynamicOption -Category $category -Name "GithubUser" -ExpectedType StringArray -isRequired $false
        }

        Source {
           #options when the user is trying to specify a source
        }

	Install {
    	    #options for installation/uninstallation 
	    #get-package  -destination .\ 
	}
    }   
}