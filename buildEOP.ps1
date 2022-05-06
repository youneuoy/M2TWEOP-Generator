#requiments:
#Microsoft Visual Studio 2019 in its default folder

# &{Import-Module "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\Microsoft.VisualStudio.DevShell.dll";}
# $vsPath = &(Join-Path ${env:ProgramFiles(x86)} "\Microsoft Visual Studio\Installer\vswhere.exe") -property installationpath
# Import-Module (Join-Path $vsPath "Common7\Tools\Microsoft.VisualStudio.DevShell.dll")
# Enter-VsDevShell -VsInstallPath $vsPath -SkipAutomaticLocation

$currentLoc=(get-location).path
$color = "`e[$(35)m"
$endColor = "`e[0m`e[30;"

Write-Output "$color ======== 0) Pre Cleanup ======== $endColor"


Set-Location -Path $currentLoc
Remove-item ./logs -recurse -erroraction 'silentlycontinue'
new-item ./logs -itemtype directory -erroraction 'silentlycontinue'

# 1) Build M2TWEOP-library
Write-Output "$color ======== 1) Build M2TWEOP-library ======== $endColor"

devenv  "M2TWEOP-library\M2TWEOP library.sln" /build "Release|x86" /project "M2TWEOP library" /out "logs\library.log"
devenv  "M2TWEOP-library\M2TWEOP library.sln" /build "Release|x86" /project "M2TWEOP GUI" /out "logs\GUI.log"
devenv  "M2TWEOP-library\M2TWEOP library.sln" /build "Release|x86" /project "M2TWEOP tools"  /out "logs\tools.log"
devenv  "M2TWEOP-library\M2TWEOP library.sln" /build "Release|x86" /project "d3d9"  /out "logs\d3d9.log"

# 2) Build M2TWEOP-LuaPlugin
Write-Output "$color ======== 2) Build M2TWEOP-LuaPlugin ======== $endColor"

devenv  "M2TWEOP-luaPlugin\luaPlugin.sln" /build "Release|x86" /project "luaPlugin"  /out "logs\luaPlugin.log"

# 3) Build Documentation
Write-Output "$color ========= 3) Build M2TWEOP-Documentation ======== $endColor"

cd "documentationGenerator"
&".\generateDocs.ps1"   -Wait -NoNewWindow | Write-Verbose

# 4) Copy built files
Write-Output "$color ======== 4) Copy all created files ======== $endColor"

Set-Location -Path $currentLoc
Remove-item ./M2TWEOPGenerated -recurse -erroraction 'silentlycontinue'
new-item ./M2TWEOPGenerated  -itemtype directory -erroraction 'silentlycontinue'

Copy-Item -Path  "M2TWEOP-DataFiles\*" -Destination "./M2TWEOPGenerated" -recurse
Copy-Item -Path  "documentationGenerator\EOPDocs\build\html\*" -Destination "./M2TWEOPGenerated/eopData/helpPages" -recurse -erroraction 'silentlycontinue'

Copy-Item -Path  "M2TWEOP-luaPlugin\Release\luaPlugin.dll" -Destination "./M2TWEOPGenerated/youneuoy_Data/plugins"
Copy-Item -Path  "M2TWEOP-library\Release\d3d9.dll" -Destination "./M2TWEOPGenerated"
Copy-Item -Path  "M2TWEOP-library\Release\M2TWEOP GUI.exe" -Destination "./M2TWEOPGenerated"
Copy-Item -Path  "M2TWEOP-library\Release\M2TWEOP tools.exe" -Destination "./M2TWEOPGenerated"
Copy-Item -Path  "M2TWEOP-library\Release\M2TWEOPLibrary.dll" -Destination "./M2TWEOPGenerated"

# 5) Generate Release ZIP
Write-Output "$color======== 5) Generate Release ZIP ======== $endColor"
Remove-item M2TWEOP.zip -erroraction 'silentlycontinue'
Compress-Archive -Path "./M2TWEOPGenerated/*"  -DestinationPath "M2TWEOP.zip"
Remove-item ./M2TWEOPGenerated -recurse -erroraction 'silentlycontinue'

# 6) Done
Write-Output "$color======== 6) Success! EOP Built Successfully! ======== $endColor"
pause