#requiments:
#Microsoft Visual Studio 2019 in its default folder
$currentLoc=(get-location).path
Write-Host "importing visual studio module"
&{Import-Module "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"; Enter-VsDevShell b3468e38}| Out-Null

Set-Location -Path $currentLoc

Remove-item ./logs -recurse -erroraction 'silentlycontinue' | Out-Null
new-item ./logs -itemtype directory -erroraction 'silentlycontinue' | Out-Null

Write-Host "build main project"
devenv  "M2TWEOP-library\M2TWEOP library.sln" /build "Release|x86" /project "M2TWEOP library" /out "logs\library.log"| Out-Null
devenv  "M2TWEOP-library\M2TWEOP library.sln" /build "Release|x86" /project "M2TWEOP GUI" /out "logs\GUI.log" | Out-Null
devenv  "M2TWEOP-library\M2TWEOP library.sln" /build "Release|x86" /project "M2TWEOP tools"  /out "logs\tools.log" | Out-Null
devenv  "M2TWEOP-library\M2TWEOP library.sln" /build "Release|x86" /project "d3d9"  /out "logs\d3d9.log" | Out-Null

Write-Host "build lua plugin"
#build plugin
devenv  "M2TWEOP-luaPlugin\luaPlugin.sln" /build "Release|x86" /project "luaPlugin"  /out "logs\luaPlugin.log" | Out-Null

Write-Host "Make documentation"
cd "documentationGenerator"


&".\generateDocs.ps1"   -Wait -NoNewWindow | Write-Verbose

Set-Location -Path $currentLoc

Write-Host "Copy all created files"

Remove-item ./M2TWEOPGenerated -recurse -erroraction 'silentlycontinue' | Out-Null
new-item ./M2TWEOPGenerated  -itemtype directory -erroraction 'silentlycontinue' | Out-Null


Copy-Item -Path  "M2TWEOP-DataFiles\*" -Destination "./M2TWEOPGenerated" -recurse 
Copy-Item -Path  "documentationGenerator\EOPDocs\build\html\*" -Destination "./M2TWEOPGenerated/eopData/helpPages" -recurse 

Copy-Item -Path  "M2TWEOP-luaPlugin\Release\luaPlugin.dll" -Destination "./M2TWEOPGenerated/youneuoy_Data/plugins"
Copy-Item -Path  "M2TWEOP-library\Release\d3d9.dll" -Destination "./M2TWEOPGenerated"
Copy-Item -Path  "M2TWEOP-library\Release\M2TWEOP GUI.exe" -Destination "./M2TWEOPGenerated" 
Copy-Item -Path  "M2TWEOP-library\Release\M2TWEOP tools.exe" -Destination "./M2TWEOPGenerated" 
Copy-Item -Path  "M2TWEOP-library\Release\M2TWEOPLibrary.dll" -Destination "./M2TWEOPGenerated" 

Remove-item M2TWEOP.zip -erroraction 'silentlycontinue' | Out-Null
Compress-Archive -Path "./M2TWEOPGenerated/*"  -DestinationPath "M2TWEOP.zip"
Remove-item ./M2TWEOPGenerated -recurse -erroraction 'silentlycontinue' | Out-Null
Write-Host "All done"
pause