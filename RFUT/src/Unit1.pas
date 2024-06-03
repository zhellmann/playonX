{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, KOL {$IFNDEF KOL_MCK}, mirror, Classes, Controls, mckCtrls, mckObjs, Graphics {$ENDIF (place your units here->)};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  mirror;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} {$I TForm1class.inc} {$ELSE OBJECTS} PForm1 = ^TForm1; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TForm1.inc}{$ELSE} TForm1 = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm1 = class(TForm)
  {$ENDIF KOL_MCK}
    KOLForm1: TKOLForm;
    OpenDialog: TKOLOpenSaveDialog;
    Label1: TKOLLabel;
    editFile: TKOLEditBox;
    KOLProject1: TKOLProject;
    Label3: TKOLLabel;
    editKey: TKOLEditBox;
    procedure editFileDropFiles(Sender: PControl;
      const FileList: KOL_String; const Pt: TPoint);
  private
    procedure Convert(FileName: KOLString);
  public
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;


{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

{$R rfut.res}

procedure ExecNewProcess(ProgramName: String);
var
  StartInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
begin
    { fill with known state }
  FillChar(StartInfo,SizeOf(TStartupInfo),#0);
  FillChar(ProcInfo,SizeOf(TProcessInformation),#0);
  StartInfo.cb := SizeOf(TStartupInfo);
  if CreateProcess(nil, PChar(ProgramName), nil, nil,False,
              CREATE_NEW_PROCESS_GROUP+NORMAL_PRIORITY_CLASS,
              nil, nil, StartInfo, ProcInfo)
  then WaitForSingleObject(ProcInfo.hProcess, INFINITE)
  else ShowMessage(ProgramName + ' not found..');

  CloseHandle(ProcInfo.hProcess);
  CloseHandle(ProcInfo.hThread);
end;

procedure TForm1.Convert(FileName: KOLString);
var
  Ext, TarPath, ImgYaffs, ImgEnc, ImgSquash, UsrBz2, UsrTar: String;
  StartTime, EndTime: Cardinal;
begin
  StartTime:= GetTickCount;

  Ext := ExtractFileExt(FileName);
  if Ext = '.zip' then
  begin
    Form.SimpleStatusText := 'Extracting zip..';
    ExecNewProcess('7za.exe x -oinstall -y "' + FileName + '"');
    TarPath := GetWorkDir + 'install\install.img';
  end

  else if Ext = '.img' then TarPath := FileName
  else begin
    ShowMessage('Invalid file');
    Exit;
  end;


  Form.SimpleStatusText := 'Extracting tar..';
  ExecNewProcess('7za.exe x -oinstall -y "' + TarPath + '"');

  ImgYaffs := GetWorkDir + 'install\package2\yaffs2_1.img';
  if FileExists(ImgYaffs) then
  begin
    Form.SimpleStatusText := 'Extracting yaffs2 image..';
    ExecNewProcess('unyaffs.exe "' + ImgYaffs + '"');
  end;


  ImgEnc := GetWorkDir + 'install\package2\squashfs1.upg';
  ImgSquash := GetWorkDir + 'install\package2\squashfs1.img';
  if FileExists(ImgEnc) then
  begin
    Form.SimpleStatusText := 'Decrypting squashfs image..';
    ExecNewProcess('pfcd.exe /D ' + ImgEnc + ' ' + ImgSquash + ' ' + editKey.Text);
  end;

  if FileExists(ImgSquash) then
  begin
    Form.SimpleStatusText := 'Extracting squashfs image..';
    ExecNewProcess('unsquashfs.exe -d squash "' + ImgSquash + '"');
  end;


  UsrBz2 := GetWorkDir + 'install\package2\usr.local.etc.tar.bz2';
  UsrTar := GetWorkDir + 'install\package2\usr.local.etc.tar';
  if FileExists(UsrBz2) then
  begin
    Form.SimpleStatusText := 'Extracting usr.local.etc bzip2..';
    ExecNewProcess('7za.exe x -oinstall\package2 -y "' + UsrBz2 + '"');

    Form.SimpleStatusText := 'Extracting usr.local.etc tar..';
    ExecNewProcess('7za.exe x -ousr.local.etc -y "' + UsrTar + '"');
  end;

  EndTime := GetTickCount - StartTime;
  Form.SimpleStatusText := PChar('Finished in: ' + Int2Str(EndTime) + ' ms');
end;

procedure TForm1.editFileDropFiles(Sender: PControl;
  const FileList: KOL_String; const Pt: TPoint);
begin
  Convert(FileList);
end;

end.























































