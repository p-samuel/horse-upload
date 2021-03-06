program Sample;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse, Horse.Upload, System.SysUtils;

var
  App: THorse;

begin
  App := THorse.Create(9000);

  App.Use(Upload);

  //In Client-side upload can be easily tested using the curl command line utility. Ex:
  //curl -F "files[]=@C:\MyFiles\Doc.pdf" -F "files[]=@C:\MyFiles\Image.jpg" http://localhost:9000/upload

  App.Post('/upload',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      LUploadConfig : TUploadConfig;
    begin
      LUploadConfig := TUploadConfig.Create('c:\serverfiles');
      LUploadConfig.ForceDir := True;
      LUploadConfig.OverrideFiles := True;

      //Optional: Callback for each file received
      LUploadConfig.UploadFileCallBack := procedure(Sender:TObject; AFile : TUploadFileInfo)
                                          begin
                                            Writeln('');
                                            Writeln('Upload file:' + AFile.filename+' '+AFile.size.ToString);
                                          end;

      //Optional: Callback on end of all files
      LUploadConfig.UploadsFishCallBack := procedure(Sender:TObject; AFiles : TUploadFiles)
                                          begin
                                            Writeln('');
                                            Writeln('Finish '+AFiles.Count.ToString+' files.' );
                                          end;


      Res.Send<TUploadConfig>(LUploadConfig);
    end);

  App.Start;

end.
