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
CompressionThreads=2
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

// Disable pages
DisableWelcomePage=no
DisableProgramGroupPage=yes
DisableReadyPage=yes

// Information page
InfoBeforeFile=Information.rtf
 
[Languages] 
Name: ru; MessagesFile: "compiler:Languages\Russian.isl"

[Types]
Name: custom; Description: Custom installation; Flags: iscustom;

[Components]
Name: Universe; Description: Установить комплект модов Universe от {#VerDate}; Types: custom; Flags: fixed;
Name: DeleteMods; Description: Очистить папку модов; Types: custom; 
Name: InstallModCFG; Description: Подключить все установленные моды к игре; Types: custom;

[Files]
Source: SourceFiles\*; DestDir: {app}; Flags: ignoreversion createallsubdirs recursesubdirs; Components: Universe; 
Source: ModCFG\Universe.txt; DestDir: {app}; Flags: ignoreversion;

[Messages] 
SetupWindowTitle={#SetupSetting("AppVerName")}
ClickNext=Начальник отдела стратегического ПО "Линкус" %nПолковник Грогх
WelcomeLabel1=Добро пожаловать, рейнджер!
WelcomeLabel2=Тебя приветствует программа установки комплекта модификаций Universe для игры Космические Рейнджеры HD: Революция.%n%nДанный комплект ПО необходимо установить поверх имеющейся у вас копии (Steam или GOG) и незамедлительно освоить на деле.%n%nНесмотря на то, что дополнение к нашему тренажёру неофициальное, оно включает множество необходимых для освоения личным составом тактик: новые аркадные и планетарные карты, текстовые квесты, множество правительственных заданий и нестандартных сценариев, которые могут ожидать кадетов на реальном поле боя.

[CustomMessages]
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
 
[Code]
var
  FullPath: string;
  CutPath: string;
  GOGFlag: integer;

function GetSteamLib(const FileName, Section: string): string; // function parsing libraryfolders.vdf (variant custom path steam library)
var
  s: string;
  i: integer;
  DirLine: integer;
  LineCount: integer;
  SectionLine: integer;    
  Lines: TArrayOfString;
begin
  Result := '';
  s := '"' + Section + '"';
  i := 1;
  if LoadStringsFromFile(FileName, Lines) then
  begin
    LineCount := GetArrayLength(Lines);
    for SectionLine := 0 to LineCount - 1 do
      if Trim(Lines[SectionLine]) = s then
      begin
        if (SectionLine < LineCount) and (Trim(Lines[SectionLine + 1]) = '{') then
          for DirLine := SectionLine to LineCount - 1 do
          begin
            if (Pos('"' + IntToStr(i) + '"', Lines[DirLine]) > 0) and
              (StringChangeEx(Lines[DirLine], '"'+ IntToStr(i) + '"', '', True) > 0) then
            begin
              i := i + 1;
              s := RemoveQuotes(Trim(Lines[DirLine]));
              StringChangeEx(s, '\\', '\', True);
                if (FileSearch('Rangers.exe', s + '\steamapps\common\Space Rangers HD A War Apart\')) = '' then
                else Result := s;
            end;
            if Trim(Lines[DirLine]) = '}' then Exit;
          end;
        Exit;
      end;
  end;
end;

function InitializeSetup(): Boolean;
var   
  SteamPath: string;
  GOGPath: string;
  SRPath: dword;
begin
  GOGFlag := 0; // First check Steam game status
  if (RegQueryStringValue(HKEY_LOCAL_MACHINE, 'Software\Valve\Steam','InstallPath', SteamPath) or 
     RegQueryStringValue(HKEY_LOCAL_MACHINE, 'Software\Wow6432Node\Valve\Steam','InstallPath', SteamPath)) and 
     (RegQueryDWordValue(HKEY_CURRENT_USER, 'Software\Valve\Steam\Apps\214730','Installed', SRPath) or 
     RegQueryDWordValue(HKEY_CURRENT_USER, 'Software\Wow6432Node\Valve\Steam\Apps\214730','Installed', SRPath) or
     RegQueryDWordValue(HKEY_LOCAL_MACHINE, 'Software\Wow6432Node\Valve\Steam\Apps\214730','Installed', SRPath)) and (SRPath = 1) 
     then begin
        GOGFlag := 1; // Steam path found
        FullPath := '';
        CutPath := SteamPath + '\steamapps\';
        if (RegQueryStringValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 214730','InstallLocation', FullPath)) and 
        (FileExists(FullPath + '\Rangers.exe')) // First variant - parse system option "Control Panel\All Control Panel Items\Programs and Features"
        then FullPath := FullPath + '\'
        else if ((GetSteamLib(CutPath + 'libraryfolders.vdf','LibraryFolders')) = '') and (FileExists(SteamPath + '\steamapps\common\Space Rangers HD A War Apart' + '\Rangers.exe')) 
        then FullPath := SteamPath + '\steamapps\common\Space Rangers HD A War Apart' // Second variant - default steam path
        else if (GetSteamLib(CutPath + 'libraryfolders.vdf','LibraryFolders')) <> '' // Third variant - custom path steam library
        then FullPath := ''
        else begin FullPath := 'C:\'; GOGFlag := 2; end;
  end else 
  if (RegQueryStringValue(HKEY_LOCAL_MACHINE, 'Software\GOG.com\Games\1207667113','PATH', GOGPath) or 
     RegQueryStringValue(HKEY_LOCAL_MACHINE, 'Software\Wow6432Node\GOG.com\Games\1207667113','PATH', GOGPath)) and (GOGFlag <> 1)
     then begin 
        GOGFlag := 3; // GOG path found 
        FullPath := GOGPath; 
     end
  else FullPath := 'C:\'; // Any version game not found
Result := True;
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

  if CurPageID = wpWelcome then begin
    if (FullPath = 'C:\') then WizardForm.SelectDirLabel.Caption := ExpandConstant('{cm:GameNotFound}');  
    if (FullPath = 'C:\') and (GOGFlag = 2) then WizardForm.SelectDirLabel.Caption := ExpandConstant('{cm:GameNotFound}');
    if FullPath = '' then begin
      WizardForm.DirEdit.Text := GetSteamLib(CutPath + 'libraryfolders.vdf','LibraryFolders') + '\steamapps\common\Space Rangers HD A War Apart';
      WizardForm.SelectDirLabel.Caption := ExpandConstant('{cm:SteamGameFound}');
    end;
    if (FullPath <> '') and (GOGFlag = 1) then begin
      WizardForm.DirEdit.Text := FullPath; 
      WizardForm.SelectDirLabel.Caption := ExpandConstant('{cm:SteamGameFound}');
    end else if (FullPath <> '') and (GOGFlag = 3) then begin
      WizardForm.DirEdit.Text := FullPath;
      WizardForm.SelectDirLabel.Caption := ExpandConstant('{cm:GogGameFound}');
    end;
  end;

  if CurPageID = wpSelectComponents then begin 
    WizardForm.NextButton.Caption := ExpandConstant('{cm:InstallButton}');
    WizardForm.ComponentsList.Checked[0] := True;
    WizardForm.ComponentsList.Checked[1] := False;
    WizardForm.ComponentsList.Checked[2] := True;
  end;
  
  if CurPageID = wpFinished then begin
    WizardForm.FinishedLabel.Caption := ExpandConstant('{cm:InstallFinish}');
    if IsComponentSelected('InstallModCFG') then FileCopy(ExpandConstant('{app}\Universe.txt'), ExpandConstant('{app}\Mods\ModCFG.txt'), false);
    DeleteFile(ExpandConstant('{app}\Universe.txt'));
  end;  
   
end;
 
