{ KOL MCK } // Do not remove this line!
program rfut;

uses
KOL,
  Unit1 in 'Unit1.pas' {Form1};

//{$R *.res}

begin // PROGRAM START HERE -- Please do not remove this comment

{$IFDEF KOL_MCK} {$I rfut_0.inc} {$ELSE}

  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;

{$ENDIF}

end.
