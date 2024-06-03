{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'RSS Encrypt/Decrypt' ).SetPosition( 128, 66 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
{$IFDEF UNICODE_CTRLS}
     Result.Form.SetUnicode(TRUE);
{$ENDIF UNICODE_CTRLS}
   {$IFDEF USE_NAMES}
    Result.Form.SetName( Applet, 'Form1' );
   {$ENDIF}
    Result.Form.SizeGrip := FALSE;
    Result.Form.Style := Result.Form.Style and not WS_MAXIMIZEBOX;
    Result.Form.SetClientSize( 387, 160 );
    Result.Form.StayOnTop := True;
    // Result.Label1.TabOrder = -1
    Result.Label1 := NewLabel( Result.Form, 'Algorithm provided by Lossless. Delphi port by Mikka.' ).SetPosition( 16, 72 ).SetSize( 353, 17 );
   {$IFDEF USE_NAMES}
    Result.Label1.SetName( Result.Form, 'Label1' ); 
   {$ENDIF}
   {$IFDEF UNICODE_CTRLS}
   Result.Label1.SetUnicode(TRUE);
   {$ENDIF UNICODE_CTRLS}
    // Result.editDecrypt.TabOrder = 1
    Result.editDecrypt := NewEditBox( Result.Form, [  ] ).SetPosition( 16, 16 ).SetSize( 353, 41 );
   {$IFDEF USE_NAMES}
    Result.editDecrypt.SetName( Result.Form, 'editDecrypt' ); 
   {$ENDIF}
    {$IFNDEF UNICODE_CTRLS}Result.editDecrypt.SetUnicode( TRUE );{$ENDIF}
    Result.editDecrypt.Text := 'Drag and drop file here to decrypt';
    // Result.editEncrypt.TabOrder = 1
    Result.editEncrypt := NewEditBox( Result.Form, [  ] ).SetPosition( 16, 104 ).SetSize( 353, 41 );
   {$IFDEF USE_NAMES}
    Result.editEncrypt.SetName( Result.Form, 'editEncrypt' ); 
   {$ENDIF}
    {$IFNDEF UNICODE_CTRLS}Result.editEncrypt.SetUnicode( TRUE );{$ENDIF}
    Result.editEncrypt.Text := 'Drag and drop file here to encrypt';
      Result.editDecrypt.OnDropFiles := Result.editDecryptDropFiles;
      Result.editEncrypt.OnDropFiles := Result.editEncryptDropFiles;
    Result.Form.CenterOnParent.CanResize := False;
    Result.Form.Perform( WM_INITMENU, 0, 0 );
    Result.KOLForm1FormCreate( Result );

end;
