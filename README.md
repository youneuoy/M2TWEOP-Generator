
<div align="center">
    <a href="https://www.twcenter.net/forums/forumdisplay.php?2296-M2TW-Engine-Overhaul-Project"><img src="https://cdn.discordapp.com/attachments/744306199075225627/819869043866468382/unknown.png" width="1920" alt="EOP" /></a>
    <br>
    <br>
  <p>
    <a href="https://discord.gg/Epqjm8u2WK"><img src="https://i.imgur.com/lWD9kdU.png" alt="Discord server" width="250" height="70"></a>
    <a href="https://www.twcenter.net/forums/forumdisplay.php?2296-M2TW-Engine-Overhaul-Project"><img src="https://i.imgur.com/rvo91ZR.png" alt="TWC" width="250" height="70"/></a>
    <a href="https://www.youtube.com/channel/UCMyHomaKeeGR4ZPGrBo9dYw"><img src="https://i.imgur.com/iwypXWd.png" alt="YouTube" width="250" height="70"/></a>
  </p>
</div>

## This project is solely for building M2TWEOP and its documentation

Requirements:

1. Microsoft Visual Studio 2019 in its default folder
2. [DirectX SDK](https://www.microsoft.com/en-us/download/details.aspx?id=6812)

How build:

1. Run buildEOP.ps1

## FAQ
1. My DirectX SDK installation failed, how can I fix it?
   Try running these commands in a command prompt and re-run the installer. 
   ```
   # Removes old Visual C++ 2010 Redistributable Package 
   MsiExec.exe /passive /X{F0C3E5D1-1ADE-321E-8167-68EF0DE699A5}

  MsiExec.exe /passive /X{1D8E6291-B0D5-35EC-8441-6616F567A0F7}
  ```
  You can then just run Windows update to restore the files if you need them.