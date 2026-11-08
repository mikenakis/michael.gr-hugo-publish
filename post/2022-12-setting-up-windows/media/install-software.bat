@echo off
::Hugo (https://gohugo.io/installation/windows)
call :install Hugo.Hugo.Extended
::VLC (https://www.videolan.org)
call :install VideoLAN.VLC 
::Git (https://git-scm.com/downloads/win)
call :install Git.Git
::SickSartori SvgPreview (https://github.com/SickSartori/svg-preview)
call :install SickSartori.SvgPreview 
::KeePassXC (https://keepassxc.org)
call :install KeePassXCTeam.KeePassXC
::SyncThing (https://syncthing.net)
call :install Syncthing.Syncthing
::Chrome (https://www.google.com/chrome)
call :install Google.Chrome
::WhatsApp
call :install 9NKSQGP7F2NH --source msstore
::Obsidian (https://obsidian.md)
call :install Obsidian.Obsidian
::Sumatra PDF (https://www.sumatrapdfreader.org)
call :install SumatraPDF.SumatraPDF
::Inkscape (https://inkscape.org)
call :install Inkscape.Inkscape
::Foobar2000 (https://www.foobar2000.org)
call :install PeterPawlowski.foobar2000
::Foobar2000 Encoder Pack (https://www.foobar2000.org/encoderpack)
call :install PeterPawlowski.foobar2000.EncoderPack
::Audacious (https://audacious-media-player.org)
call :install Audacious.MediaPlayer
::Ditto (https://ditto-cp.sourceforge.io)
call :install Ditto.Ditto
::7-zip (https://www.7-zip.org)
call :install 7zip.7zip
::Firefox (https://www.mozilla.org/en-US)
call :install Mozilla.Firefox
::Notepad++ (https://notepad-plus-plus.org)
call :install Notepad++.Notepad++
::Autohotkey (https://www.autohotkey.com)
call :install AutoHotkey.AutoHotkey
::TortoiseGit (https://tortoisegit.org)
call :install TortoiseGit.TortoiseGit
::Microsoft Visual Studio Community Edition (https://visualstudio.microsoft.com)
call :install Microsoft.VisualStudio.Community
::SysInternals Process Explorer (https://learn.microsoft.com/en-us/sysinternals/downloads/process-explorer)
call :install Microsoft.Sysinternals.ProcessExplorer
::Opera (https://www.opera.com)
call :install Opera.Opera
goto :eof

::Optionally:
::MPC-HC
call :install clsid2.mpc-hc
::QBitTorrent
call :install qBittorrent.qBittorrent


:install
	winget install --exact --id %1 --accept-source-agreements --accept-package-agreements --disable-interactivity
