# [Claude] Gives music files the icon `music-file.ico` in File Explorer.
# [Claude] The key of each music extension receives the icon, so that the icon appears even with no media player.
# [Claude] A class that a music extension points to receives the icon too, because a media player registers an icon
# on its class.
# [Claude] A class that any other extension points to is left alone, so that no video file gets a music icon.
# [Claude] This script must run outside the Claude app, because HKCU writes inside the Claude app are virtualized.

$ErrorActionPreference = 'Stop'

$musicExtensions = @(
	'.mp3', '.flac', '.wav', '.ogg', '.oga', '.opus', '.m4a', '.m4b', '.m4p', '.aac', '.wma', '.aif', '.aiff', '.aifc',
	'.ape', '.mka', '.mpa', '.mp2', '.mpc', '.wv', '.mid', '.midi', '.rmi', '.xm', '.it', '.s3m', '.au', '.snd', '.ac3',
	'.dts', '.amr', '.tta', '.spx', '.caf', '.oma', '.voc', '.w64'
)
$iconPath = Join-Path $env:USERPROFILE 'Documents\Settings\Icons\music-file.ico'
if( -not ( Test-Path -LiteralPath $iconPath ) ) { throw "File not found: $iconPath" }

$classesRoot = [Microsoft.Win32.Registry]::ClassesRoot
$currentUser = [Microsoft.Win32.Registry]::CurrentUser
$extensionsOfClass = @{}

function Add-Class( $key, $valueName, $extension )
{
	if( $null -eq $key ) { return }
	$class = $key.GetValue( $valueName )
	if( $class ) { $extensionsOfClass[$class] = @( $extensionsOfClass[$class] ) + $extension }
}

foreach( $extension in ( $classesRoot.GetSubKeyNames() -like '.*' ) )
{
	Add-Class $classesRoot.OpenSubKey( $extension ) '' $extension
}
$fileExts = $currentUser.OpenSubKey( 'Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts' )
foreach( $extension in $fileExts.GetSubKeyNames() )
{
	Add-Class $fileExts.OpenSubKey( "$extension\UserChoice" ) 'ProgId' $extension
	Add-Class $fileExts.OpenSubKey( "$extension\UserChoiceLatest\ProgId" ) 'ProgId' $extension
}

$targets = @( $musicExtensions )
foreach( $class in $extensionsOfClass.Keys )
{
	$extensions = @( $extensionsOfClass[$class] | Where-Object { $_ } )
	$music = @( $extensions | Where-Object { $musicExtensions -contains $_ } )
	if( $music.Count -eq 0 ) { continue }
	if( $null -eq $classesRoot.OpenSubKey( $class ) ) { Write-Output "Skipping unregistered class $class" }
	elseif( $music.Count -ne $extensions.Count ) { Write-Output "Skipping shared class $class" }
	else { $targets += $class }
}

foreach( $target in $targets )
{
	[Microsoft.Win32.Registry]::SetValue( "HKEY_CURRENT_USER\Software\Classes\$target\DefaultIcon", '', $iconPath )
}

# [Claude] Announce the change of the file associations, because File Explorer keeps showing the old icons otherwise.
Add-Type -Namespace Native -Name Shell -MemberDefinition @'
[DllImport( "shell32.dll" )]
public static extern void SHChangeNotify( int eventId, uint flags, IntPtr item1, IntPtr item2 );
'@
$shcneAssocChanged = 0x08000000
$shcnfFlush = 0x1000
[Native.Shell]::SHChangeNotify( $shcneAssocChanged, $shcnfFlush, [IntPtr]::Zero, [IntPtr]::Zero )
Write-Output "$( $targets.Count ) targets: $targets"
