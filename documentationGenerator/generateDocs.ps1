#remove old lua doc files
Write-Host "======== 3.1) Remove old documentation ========\n" -ForegroundColor Yellow
Remove-item generatedLuaDocs -recurse  -erroraction 'silentlycontinue'

#create folder for temporary place scripting docs
new-item ./generatedLuaDocs -itemtype directory

Write-Host "======== 3.2) Generate documentation config ========\n" -ForegroundColor Yellow
#.\luarocks\ldoc.lua.bat . -c ../luaPlugin/config.ld
.\luarocks\lua.exe ./luarocks/rocks/ldoc/1.4.6-2/bin/ldoc.lua . -c config.ld

Write-Host "======== 3.3) Remove old files ========\n" -ForegroundColor Yellow
#remove old scripting files in main docs path
Remove-item EOPDocs/source/_static/LuaLib/* -recurse  -erroraction 'silentlycontinue'
#erase build path
Remove-item EOPDocs/build/* -recurse  -erroraction 'silentlycontinue'

Write-Host "======== 3.4) Build documentation files  ========\n" -ForegroundColor Yellow
#copy created scripting docs to main docs source folder
Copy-Item -Path "generatedLuaDocs/*" -Destination "EOPDocs/source/_static/LuaLib" -recurse
Start-Process -FilePath ".\EOPDocs\WPy32-3890\scripts\cmdEOPDOCS.bat" -Wait -NoNewWindow

Write-Host "======== 3.5) Success! Documentation built successfully.  ========\n" -ForegroundColor Yellow
