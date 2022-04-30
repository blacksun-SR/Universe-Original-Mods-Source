[Setup]
#define VerDate GetDateTimeString('dd.mm.yy', '', ''); 
AppID={{E89E8EF6-EBA6-4D66-99E4-3512AF8208ED}
AppName=Space Rangers Universe Original
AppVersion={#VerDate}
AppVerName=Space Rangers Universe Original
AppCopyright=Space Rangers Community
AppPublisher=Space Rangers Community
AppPublisherURL="https://discord.gg/SY4aDtDxET"

// Directory setup
SourceDir=. 
OutputDir=.\Build
DefaultDirName=\
OutputBaseFilename=Universe_Original_{#VerDate}

// Compression
Compression=lzma2/ultra64
InternalCompressLevel=ultra
CompressionThreads=4
SolidCompression=yes

// Images & Icons
WizardImageFile=Images\Logo100.bmp,Images\Logo125.bmp,Images\Logo150.bmp,Images\Logo175.bmp,Images\Logo200.bmp
WizardSmallImageFile=Images\LogoTop100.bmp
SetupIconFile=Icon.ico

// Options
AppendDefaultDirName=no
DirExistsWarning=no
Uninstallable=false
AllowRootDirectory=yes
WizardStyle=classic

// Disable pages
DisableWelcomePage=no
DisableProgramGroupPage=yes
DisableReadyPage=yes
 
[Languages]
Name: en; MessagesFile: "compiler:Default.isl"; InfoBeforeFile: "Information-English.rtf"
Name: ru; MessagesFile: "compiler:Languages\Russian.isl"; InfoBeforeFile: "Information-Russian.rtf"

[Types]
Name: custom; Description: Custom installation; Flags: iscustom;

[Components]
Name: Universe; Description: {cm:Universe}; Types: custom; Flags: fixed;
Name: DeleteMods; Description: {cm:DeleteMods}; Types: custom; 
Name: InstallModCFG; Description: {cm:InstallModCFG}; Types: custom;

[Files]
Source: SourceFiles\*; DestDir: {app}; Flags: ignoreversion createallsubdirs recursesubdirs; Components: Universe; 
Source: ModCFG\Universe.txt; DestDir: {app}; Flags: ignoreversion;

[Messages]
// English
en.SetupWindowTitle={#SetupSetting("AppVerName")}
en.ClickNext=Chief of Strategic Software Department "Linux" %nColonel Grogh
en.WelcomeLabel1=Welcome, ranger!
en.WelcomeLabel2=Program of installation for Universe modification pack for Space Rangers HD: A War Apart greets you.%n%nThis software package should be installed over your copy of the game (from Steam or GOG) and immediately tried in practice.%n%nAlthough this add-on for our simulator is unofficial, it includes many required for mastering by staff tactics: new arcade and planetary battles' maps, text quests, many governmental tasks and non-standard situations which cadets can meet on the real battlefield. 
// Russian
ru.SetupWindowTitle={#SetupSetting("AppVerName")}
ru.ClickNext=Начальник отдела стратегического ПО "Линкус" %nПолковник Грогх
ru.WelcomeLabel1=Добро пожаловать, рейнджер!
ru.WelcomeLabel2=Тебя приветствует программа установки комплекта модификаций Universe для игры Космические Рейнджеры HD: Революция.%n%nДанный комплект ПО необходимо установить поверх имеющейся у вас копии (Steam или GOG) и незамедлительно освоить на деле.%n%nНесмотря на то, что дополнение к нашему тренажёру неофициальное, оно включает множество необходимых для освоения личным составом тактик: новые аркадные и планетарные карты, текстовые квесты, множество правительственных заданий и нестандартных сценариев, которые могут ожидать кадетов на реальном поле боя.

[CustomMessages]
// English
en.GameExist=Can't find the game in the specified directory, check if the path is correct!
en.GameNotFound=Steam or GOG-version of game not found, choose path for installation by yourself
en.SteamGameFound=Steam-version of the game has been found, path for installation chosen automatically
en.GogGameFound=GOG-version of the game has been found, path for installation chosen automatically
en.Information=Carefully read information about presented modifications
en.ModsOptions=Select the options you want to install; uncheck the options you don't want to install.%n%nClick «Install», when you'll be ready. 
en.InstallButton=Install
en.InstallComplete=Do you want some coffee or a secret task?
en.InstallFinish=Modification pack {#SetupSetting("AppVerName")} was successfully installed!
en.Discord=Discord server
en.Universe=Install Universe modpack v. {#VerDate}
en.DeleteMods=Clean the Mods folder
en.InstallModCFG=Enable all installed mods in the game
// Russian
ru.GameExist=В указанной директории игра не обнаружена, проверьте правильность пути!
ru.GameNotFound=Steam или GOG версия игры не обнаружена, укажите путь вручную
ru.SteamGameFound=Обнаружена Steam-версия игры, путь установки выбран автоматически
ru.GogGameFound=Обнаружена GOG-версия игры, путь установки выбран автоматически
ru.Information=Внимательно изучите информацию о представленных модификациях
ru.ModsOptions=Выберите опции, которые хотите установить; снимите флажки с опций, устанавливать которые не требуется.%n%nНажмите «Установить», когда будете готовы.
ru.InstallButton=Установить
ru.InstallComplete=Хотите кофейку или секретное задание?
ru.InstallFinish=Комплект модификаций {#SetupSetting("AppVerName")} успешно установлен!
ru.Discord=Discord сервер
ru.Universe=Установить комплект модов Universe от {#VerDate}
ru.DeleteMods=Очистить папку модов
ru.InstallModCFG=Подключить все установленные моды к игре
 
[Code]
var
  FullPath: string;
  GOGFlag: boolean;

function GetSteamLibs(FileName: string; var Paths: TArrayOfString): Boolean;
var
  Lines: TArrayOfString;
  i: Integer;
  Line: string;
  p: Integer;
  Key: string;
  Value: string;
  Count: Integer;
  InstallFolderKey: string;
begin
  InstallFolderKey := 'path';
  Result := LoadStringsFromFile(FileName, Lines);
  Count := 0;
  for i := 0 to GetArrayLength(Lines) - 1 do
  begin
    Line := Trim(Lines[i]);
    if Copy(Line, 1, 1) = '"' then
    begin
      Delete(Line, 1, 1);
      p := Pos('"', Line);
      if p > 0 then
      begin
        Key := Trim(Copy(Line, 1, p - 1));
        Delete(Line, 1, p);
        Line := Trim(Line);
        if (CompareText(Copy(Key, 1, Length(InstallFolderKey)), InstallFolderKey) = 0) and (Line[1] = '"') then
        begin
          Delete(Line, 1, 1);
          p := Pos('"', Line);
          if p > 0 then
          begin
            Value := Trim(Copy(Line, 1, p - 1));
            StringChange(Value, '\\', '\');
            Count := Count + 1;
            SetArrayLength(Paths, Count);
            Paths[Count - 1] := Value;
          end;
        end;
      end;
    end;
  end;
end;

function GetGamePath(): string;
var          
  InstallPath: string;
  SteamPath: string;
  SteamConfigFileArray: TArrayOfString;
  SteamLibs: TArrayOfString;
  SteamConfigFilePath: string;
  i: integer;
begin
  // Steam path
  SteamPath := ExpandConstant('{reg:HKLM\Software\Valve\Steam,InstallPath}');
  if SteamPath = '' then SteamPath := ExpandConstant('{reg:HKLM\Software\WOW6432Node\Valve\Steam,InstallPath}');
  if SteamPath = '' then SteamPath := {pf} + '\Steam';
  if SteamPath <> '' then SteamConfigFilePath := SteamPath + '\steamapps\libraryfolders.vdf';
  // Default game path
  if FileExists(SteamPath + '\steamapps\common\Space Rangers HD A War Apart\Rangers.exe') then Result := SteamPath + '\steamapps\common\Space Rangers HD A War Apart'
  // Parse Steam libs - sharedconfig.vdf  
  else if FileExists(SteamConfigFilePath) then 
  begin
    if LoadStringsFromFile(SteamConfigFilePath, SteamConfigFileArray) then
    begin
      GetSteamLibs(SteamConfigFilePath, SteamLibs);
      for i := 0 to GetArrayLength(SteamLibs) - 1 do
      begin
        if FileExists(SteamLibs[i] + '\steamapps\common\Space Rangers HD A War Apart\Rangers.exe') then
        begin
          Result := SteamLibs[i] + '\steamapps\common\Space Rangers HD A War Apart';
          break;
        end;
      end;
    end;
  end;
  // Parse GOG
  if (RegQueryStringValue(HKLM, 'Software\GOG.com\Games\1207667113','path', InstallPath)) and (Result = '') and ((FileExists(InstallPath + '\Rangers.exe'))) then 
  begin Result := InstallPath; GOGFlag := true; end
  else if (RegQueryStringValue(HKLM, 'Software\Wow6432Node\GOG.com\Games\1207667113','path', InstallPath)) and (Result = '') and ((FileExists(InstallPath + '\Rangers.exe'))) then
  begin Result := InstallPath; GOGFlag := true; end;

end;

function PrepareToInstall(var NeedsRestart: Boolean): String;
begin
  if WizardIsComponentSelected('DeleteMods') then
  begin
    ForceDirectories(ExpandConstant('{app}\TempStorageFolder'));
    if not WizardIsComponentSelected('InstallModCFG') then RenameFile(ExpandConstant('{app}\Mods\ModCFG.txt'), ExpandConstant('{app}\TempStorageFolder\ModCFG.txt'));
    RenameFile(ExpandConstant('{app}\Mods\Tweaks\German'), ExpandConstant('{app}\TempStorageFolder\German'));
    RenameFile(ExpandConstant('{app}\Mods\Tweaks\LeoDomikShipsUpdate15'), ExpandConstant('{app}\TempStorageFolder\LeoDomikShipsUpdate15'));
    RenameFile(ExpandConstant('{app}\Mods\Tweaks\LeoDomikShipsUpdate30'), ExpandConstant('{app}\TempStorageFolder\LeoDomikShipsUpdate30'));
    RenameFile(ExpandConstant('{app}\Mods\Tweaks\SR2LoadingScreen'), ExpandConstant('{app}\TempStorageFolder\SR2LoadingScreen'));
    RenameFile(ExpandConstant('{app}\Mods\Tweaks\SR2PQuestStyle'), ExpandConstant('{app}\TempStorageFolder\SR2PQuestStyle'));
    DelTree(ExpandConstant('{app}\Mods\*'), false, true, true);
    ForceDirectories(ExpandConstant('{app}\Mods\Tweaks'));
    if not WizardIsComponentSelected('InstallModCFG') then RenameFile(ExpandConstant('{app}\TempStorageFolder\ModCFG.txt'), ExpandConstant('{app}\Mods\ModCFG.txt'));
    RenameFile(ExpandConstant('{app}\TempStorageFolder\German'), ExpandConstant('{app}\Mods\Tweaks\German'));
    RenameFile(ExpandConstant('{app}\TempStorageFolder\LeoDomikShipsUpdate15'), ExpandConstant('{app}\Mods\Tweaks\LeoDomikShipsUpdate15'));
    RenameFile(ExpandConstant('{app}\TempStorageFolder\LeoDomikShipsUpdate30'), ExpandConstant('{app}\Mods\Tweaks\LeoDomikShipsUpdate30'));
    RenameFile(ExpandConstant('{app}\TempStorageFolder\SR2LoadingScreen'), ExpandConstant('{app}\Mods\Tweaks\SR2LoadingScreen'));
    RenameFile(ExpandConstant('{app}\TempStorageFolder\SR2PQuestStyle'), ExpandConstant('{app}\Mods\Tweaks\SR2PQuestStyle'));
    RemoveDir(ExpandConstant('{app}\TempStorageFolder'));
  end;
end;

function NextButtonClick(CurPageID: Integer): Boolean; 
begin 
  Result := True; 
  if CurPageID = wpSelectDir then 
  begin 
    if (FileSearch('Rangers.exe', ExpandConstant('{app}')) = '') then  
    begin 
      SuppressibleMsgBox(ExpandConstant('{cm:GameExist}'), mbCriticalError, MB_OK, MB_OK); 
      Result := False; 
    end else Result := True; 
  end; 
end;

procedure URLLabelOnClick(Sender: TObject);
var
  ErrorCode: Integer;
begin
  ShellExec('open', '{#SetupSetting("AppPublisherURL")}', '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
end;

procedure InitializeWizard;
var
  URLLabel: TNewStaticText;
begin

  URLLabel := TNewStaticText.Create(WizardForm);
  URLLabel.Caption := ExpandConstant('{cm:Discord}');
  URLLabel.Cursor := crHand;
  URLLabel.OnClick := @URLLabelOnClick;
  URLLabel.Parent := WizardForm;
  URLLabel.Font.Style := URLLabel.Font.Style + [fsBold];
  URLLabel.Font.Color := clGray;
  URLLabel.Top := WizardForm.ClientHeight - URLLabel.Height - ScaleY(16);
  URLLabel.Left := ScaleX(20);

  with WizardForm.InfoBeforeMemo do
  begin
    Color := clBlack;
  end;

  with WizardForm.InfoBeforeClickLabel do
  begin
    Caption := ExpandConstant('{cm:Information}');
  end;

  with WizardForm.SelectDirLabel do
  begin
    Font.Style := [fsBold];
  end;

  with WizardForm.SelectComponentsLabel do
  begin
    Caption := ExpandConstant('{cm:ModsOptions}');
  end;

  with WizardForm.FinishedHeadingLabel do
  begin
    Caption := ExpandConstant('{cm:InstallComplete}');
  end;

  with WizardForm.WizardSmallBitmapImage do
  begin
    Left := ScaleX(0);
    Width := ScaleX(500);
    Height := ScaleY(60);
  end;

  with WizardForm.PageNameLabel do
  begin
    Visible := False;
  end;

  with WizardForm.PageDescriptionLabel do
  begin
    Visible := False;
  end;

end;
 
procedure CurPageChanged(CurPageID: Integer);
begin

  if CurPageID = wpWelcome then
  begin
    FullPath := GetGamePath();
    if (FullPath = '') then 
    begin
      WizardForm.DirEdit.Text := 'C:\'; 
      WizardForm.SelectDirLabel.Caption := ExpandConstant('{cm:GameNotFound}'); 
    end 
    else if (FullPath <> '') and (GOGFlag = false) then 
    begin
      WizardForm.DirEdit.Text := FullPath; 
      WizardForm.SelectDirLabel.Caption := ExpandConstant('{cm:SteamGameFound}');
    end 
    else if (FullPath <> '') and (GOGFlag = true) then 
    begin
      WizardForm.DirEdit.Text := FullPath;
      WizardForm.SelectDirLabel.Caption := ExpandConstant('{cm:GogGameFound}');
    end;
  end;

  if CurPageID = wpSelectComponents then 
  begin 
    WizardForm.NextButton.Caption := ExpandConstant('{cm:InstallButton}');
    WizardForm.ComponentsList.Checked[0] := True;
    WizardForm.ComponentsList.Checked[1] := False;
    WizardForm.ComponentsList.Checked[2] := False;
  end;
  
  if CurPageID = wpFinished then 
  begin
    WizardForm.FinishedLabel.Caption := ExpandConstant('{cm:InstallFinish}');
    if WizardIsComponentSelected('InstallModCFG') then FileCopy(ExpandConstant('{app}\Universe.txt'), ExpandConstant('{app}\Mods\ModCFG.txt'), false);
    DeleteFile(ExpandConstant('{app}\Universe.txt'));
  end;
    
end;
 
