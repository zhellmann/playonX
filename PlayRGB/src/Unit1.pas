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
    KOLProject1: TKOLProject;
    KOLForm1: TKOLForm;
    OpenDialog: TKOLOpenSaveDialog;
    ButtonOpen: TKOLButton;
    Label1: TKOLLabel;
    editFile: TKOLEditBox;
    procedure ButtonOpenClick(Sender: PObj);
    procedure editFileDropFiles(Sender: PControl;
      const FileList: KOL_String; const Pt: TPoint);
    procedure KOLForm1FormCreate(Sender: PObj);
  private
    procedure Convert(FileName: KOLString);
  public
  end;


type
  PRGBArray = ^TRGBArray;
  TRGBArray = array[0..32767] of TRGBTriple;
  
  PWordArray = ^TWordArray;
  TWordArray = array[0..16383] of Word;


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

{$R playrgb.res}

procedure TForm1.Convert(FileName: KOLString);
var
  i, j: Integer;
  Row16: PWordArray;
  Row24: PRGBArray;
  BMP16, BMP32: PBitmap;
begin
  BMP32 := NewBitmap(0, 0);
  BMP32.LoadFromFile(Filename);
  BMP16 := NewDIBBitmap(BMP32.Width, BMP32.Height, pf16bit);

  for j := 0 to BMP32.Height-1 do
  begin
    Row16 := BMP16.Scanline[j];
    Row24 := BMP32.Scanline[j];
    for i := 0 to BMP32.Width-1 do
      with Row24[i] do Row16[i] := (rgbtRed shr 3) shl 11 or (rgbtGreen shr 2) shl 5 or rgbtBlue shr 3;
  end;

  BMP32.Free;
  BMP16.SaveToFile(GetStartDir + 'tmp\' + ExtractFileName(FileName));
  BMP16.Free;
end;

procedure TForm1.ButtonOpenClick(Sender: PObj);
begin
  if OpenDialog.Execute then
  begin
    editFile.Caption := OpenDialog.Filename;
    Convert(editFile.Caption);
  end;
end;

procedure TForm1.editFileDropFiles(Sender: PControl;
  const FileList: KOL_String; const Pt: TPoint);
begin
  editFile.Caption := FileList;
  Convert(editFile.Caption);
end;

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
var
  Lista: PStrList;
  i: Integer;
begin
  Str2File('lis1.txt', PChar(GetFileListStr(GetStartDir + 'bmp','*.bmp')));

  Lista := NewStrList;
  Lista.NameDelimiter := Char(#13);
  Lista.LoadFromFile('lis1.txt');

  for i:=0 to Lista.Count-1 do
    Convert(Lista.Items[i]);
  Lista.Free;
end;

end.
































