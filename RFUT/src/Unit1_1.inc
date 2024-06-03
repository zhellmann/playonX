{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'RSS Decryptor' ).SetPosition( 279, 49 );
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
    Result.Form.SetClientSize( 387, 118 );
    Result.Form.StayOnTop := True;
    // Result.Label1.TabOrder = -1
    Result.Label1 := NewLabel( Result.Form, 'Algorithm provided by Lossless. Delphi port by Mikka.' ).SetPosition( 16, 88 ).SetSize( 353, 17 );
   {$IFDEF USE_NAMES}
    Result.Label1.SetName( Result.Form, 'Label1' ); 
   {$ENDIF}
   {$IFDEF UNICODE_CTRLS}
   Result.Label1.SetUnicode(TRUE);
   {$ENDIF UNICODE_CTRLS}
    // Result.editFile.TabOrder = 1
    Result.editFile := NewEditBox( Result.Form, [  ] ).SetPosition( 16, 32 ).SetSize( 353, 41 );
   {$IFDEF USE_NAMES}
    Result.editFile.SetName( Result.Form, 'editFile' ); 
   {$ENDIF}
    {$IFNDEF UNICODE_CTRLS}Result.editFile.SetUnicode( TRUE );{$ENDIF}
    Result.editFile.Text := 'Drag and drop file here';
      Result.editFile.OnDropFiles := Result.editFileDropFiles;
    Result.Form.CenterOnParent.CanResize := False;
    Result.Form.Perform( WM_INITMENU, 0, 0 );

end;
