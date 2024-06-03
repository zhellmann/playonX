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
    Label1: TKOLLabel;
    editDecrypt: TKOLEditBox;
    KOLProject1: TKOLProject;
    editEncrypt: TKOLEditBox;
    procedure editDecryptDropFiles(Sender: PControl;
      const FileList: KOL_String; const Pt: TPoint);
    procedure editEncryptDropFiles(Sender: PControl;
      const FileList: KOL_String; const Pt: TPoint);
    procedure KOLForm1FormCreate(Sender: PObj);
  private
    procedure Convert(FileName: KOLString; Encrypt: Boolean);
  public
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;


{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

uses KOLAES;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

{$R rssdec.res}

procedure TForm1.Convert(FileName: KOLString; Encrypt: Boolean);
const
  Klucz: array[0..15] of Byte = ($6D,$28,$56,$37,$5E,$6C,$2D,$39,$33,$35,$2E,$31,$64,$4B,$6C,$35);
var
  Source, Dest: PStream;
  DestDir, DestFile: String;
  Size, i: Integer;
  Key128: TAESKey128;
begin
  for i:=0 to 15 do Key128[i] := Klucz[i];

  Source := NewReadFileStream(FileName);
  DestDir := GetStartDir + 'tmp\';

  if not DirectoryExists(DestDir) then CreateDir(DestDir);

  try
    DestFile := DestDir + ExtractFileName(FileName);
    Dest := NewWriteFileStream(DestFile);
    try
      Size := Source.Size;
      Dest.Write(Size,SizeOf(Size)-4);

      if Encrypt then EncryptAES128StreamECB(Source, Size, Key128, Dest)
      else DecryptAES128StreamECB(Source, Size, Key128, Dest);
    finally
      Dest.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure TForm1.editDecryptDropFiles(Sender: PControl;
  const FileList: KOL_String; const Pt: TPoint);
begin
  Convert(FileList, False);
end;

procedure TForm1.editEncryptDropFiles(Sender: PControl;
  const FileList: KOL_String; const Pt: TPoint);
begin
  Convert(FileList, True);
end;

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
var
  Lista: PStrList;
  i: Integer;
begin
 { Str2File('lis1.txt', PChar(GetFileListStr(GetStartDir + '\rss','*.rss')));

  Lista := NewStrList;
  Lista.NameDelimiter := Char(#13);
  Lista.LoadFromFile('lis1.txt');

  for i:=0 to Lista.Count-1 do
    Convert(Lista.Items[i], False);
  Lista.Free;    }
end;

end.























































