; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "MediaPoint"
#define MyAppVersion "1.0"
#define MyAppPublisher "MarsMedia"
#define MyAppURL "http://msimic.github.io/MediaPoint/"
#define MyAppExeName "MediaPoint.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{073373E5-D705-4328-8EC5-C764A62FDE9B}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
LicenseFile=..\Docs\EULA.rtf
OutputDir=..\output\Installer
OutputBaseFilename=MediaPoint_Setup
SetupIconFile=..\MediaPoint_App\Images\app.ico
Compression=lzma
SolidCompression=yes
ChangesAssociations=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1
Name: aviAssociation; Description: "Associate ""avi"" extension"; GroupDescription: File extensions:
Name: mkvAssociation; Description: "Associate ""mkv"" extension"; GroupDescription: File extensions:
Name: mp4Association; Description: "Associate ""mp4"" extension"; GroupDescription: File extensions:

[Registry]
Root: HKCR; Subkey: ".avi"; ValueType: string; ValueName: ""; ValueData: "{#MyAppName}"; Flags: uninsdeletevalue; Tasks: aviAssociation 
Root: HKCR; Subkey: ".mkv"; ValueType: string; ValueName: ""; ValueData: "{#MyAppName}"; Flags: uninsdeletevalue; Tasks: mkvAssociation 
Root: HKCR; Subkey: ".mp4"; ValueType: string; ValueName: ""; ValueData: "{#MyAppName}"; Flags: uninsdeletevalue; Tasks: mp4Association 
Root: HKCR; Subkey: "{#MyAppName}"; ValueType: string; ValueName: ""; ValueData: "Media File"; Flags: uninsdeletekey
Root: HKCR; Subkey: "{#MyAppName}\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName},0"
Root: HKCR; Subkey: "{#MyAppName}\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.mkv\UserChoice"; ValueType: none; ValueName: none; Permissions: users-full; Flags: deletekey; Tasks: mkvAssociation 
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.avi\UserChoice"; ValueType: none; ValueName: none; Permissions: users-full; Flags: deletekey; Tasks: aviAssociation 
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.mp4\UserChoice"; ValueType: none; ValueName: none; Permissions: users-full; Flags: deletekey; Tasks: mp4Association 

[Code]
function IsDotNetDetected(version: string; service: cardinal): boolean;
// Indicates whether the specified version and service pack of the .NET Framework is installed.
//
// version -- Specify one of these strings for the required .NET Framework version:
//    'v1.1.4322'     .NET Framework 1.1
//    'v2.0.50727'    .NET Framework 2.0
//    'v3.0'          .NET Framework 3.0
//    'v3.5'          .NET Framework 3.5
//    'v4\Client'     .NET Framework 4.0 Client Profile
//    'v4\Full'       .NET Framework 4.0 Full Installation
//    'v4.5'          .NET Framework 4.5
//
// service -- Specify any non-negative integer for the required service pack level:
//    0               No service packs required
//    1, 2, etc.      Service pack 1, 2, etc. required
var
    key: string;
    install, release, serviceCount: cardinal;
    check45, success: boolean;
var reqNetVer : string;
begin
    // .NET 4.5 installs as update to .NET 4.0 Full
    if version = 'v4.5' then begin
        version := 'v4\Full';
        check45 := true;
    end else
        check45 := false;

    // installation key group for all .NET versions
    key := 'SOFTWARE\Microsoft\NET Framework Setup\NDP\' + version;

    // .NET 3.0 uses value InstallSuccess in subkey Setup
    if Pos('v3.0', version) = 1 then begin
        success := RegQueryDWordValue(HKLM, key + '\Setup', 'InstallSuccess', install);
    end else begin
        success := RegQueryDWordValue(HKLM, key, 'Install', install);
    end;

    // .NET 4.0/4.5 uses value Servicing instead of SP
    if Pos('v4', version) = 1 then begin
        success := success and RegQueryDWordValue(HKLM, key, 'Servicing', serviceCount);
    end else begin
        success := success and RegQueryDWordValue(HKLM, key, 'SP', serviceCount);
    end;

    // .NET 4.5 uses additional value Release
    if check45 then begin
        success := success and RegQueryDWordValue(HKLM, key, 'Release', release);
        success := success and (release >= 378389);
    end;

    result := success and (install = 1) and (serviceCount >= service);
end;

function IsRequiredDotNetDetected(): Boolean;  
begin
    result := IsDotNetDetected('v3.5', 1);
end;

function InitializeSetup(): Boolean;
begin
    if not IsDotNetDetected('v3.5', 1) then begin
        MsgBox('{#MyAppName} requires Microsoft .NET Framework 3.5 SP1.'#13#13
          'The installer will attempt to install it at the end.'#13#13
          'Please note that you must complete this in order to run {#MyAppName}.', mbInformation, MB_OK);        
    end
    
    result := true;
end; 

procedure ShowSplashScreen(p1:HWND;p2:string;p3,p4,p5,p6,p7:integer;p8:boolean;p9:Cardinal;p10:integer); external 'ShowSplashScreen@files:isgsg.dll stdcall delayload';

procedure InitializeWizard;
begin
ExtractTemporaryFile('Splash.jpg');
ShowSplashScreen(WizardForm.Handle,ExpandConstant('{tmp}')+'\Splash.jpg',1000,3000,1000,0,255,True,$00FF00,10);
end;

const
  SHCNE_ASSOCCHANGED = $08000000;
  SHCNF_IDLIST = $00000000;

procedure SHChangeNotify(wEventID: integer; uFlags: cardinal; dwItem1, dwItem2: cardinal);
external 'SHChangeNotify@shell32.dll stdcall';

procedure SendChangeNotification;
begin
  SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, 0, 0);
end;

procedure DeinitializeSetup;
begin
SendChangeNotification();
end;

[Files]
Source: "..\output\bin\x86\MediaPoint.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\CookComputing.XmlRpcV2.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\D3DCompiler_43.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\D3DX9_43.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\DirectShowLib-2005.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\EVRPresenter32.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\fxc32.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\GoogleSearchAPI.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\HashMatcher.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\ICSharpCode.SharpZipLib.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\MediaInfo.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\MediaPoint.Common.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\MediaPoint.Controls.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\MediaPoint.MVVM.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\MediaPoint.ViewModels.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\Microsoft.Expression.Interactions.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\Microsoft.WindowsAPICodePack.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\Microsoft.WindowsAPICodePack.Shell.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\msvcr100.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\msvcr110.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\NAudio.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\ShaderEffectLibrary.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\SharpDX.DirectSound.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\SharpDX.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\SubtitleDownloader.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\System.Reactive.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\System.Windows.Controls.Input.Toolkit.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\System.Windows.Controls.Layout.Toolkit.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\System.Windows.Interactivity.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\WPFSoundVisualizationLib.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\WPFSpark.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\WPFToolkit.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\Xceed.Wpf.Toolkit.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\output\bin\x86\codecs\*"; DestDir: "{app}\codecs"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\output\bin\x86\Themes\*"; DestDir: "{app}\Themes"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\InstallerResources\dotnetfx35setup.exe"; DestDir: {tmp}; Flags: deleteafterinstall; Check: not IsRequiredDotNetDetected 
Source: "..\InstallerResources\Splash.jpg"; DestDir: {tmp}; Flags: ignoreversion dontcopy nocompression
Source: "..\InstallerResources\isgsg.dll"; DestDir: {tmp}; Flags: ignoreversion dontcopy nocompression

; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:ProgramOnTheWeb,{#MyAppName}}"; Filename: "{#MyAppURL}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
Filename: "{tmp}\dotnetfx35setup.exe"; Parameters: "/q:a /c:""install /l /q"""; Check: not IsRequiredDotNetDetected; StatusMsg: Microsoft Framework 3.5 SP1 is being installed. Please wait... 

