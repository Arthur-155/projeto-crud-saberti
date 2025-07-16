unit Dm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset;

type

  { TDmf }

  TDmf = class(TDataModule)
    ZConnection1: TZConnection;
    qryGenerica: TZQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure ZConnection1AfterConnect(Sender: TObject);
  private

  public

  end;

var
  Dmf: TDmf;

implementation

{$R *.lfm}

{ TDmf }

procedure TDmf.DataModuleCreate(Sender: TObject);
begin
  ZConnection1.HostName := 'localhost';
  ZConnection1.DataBase := 'postgres';
  ZConnection1.User     := 'postgres';
  ZConnection1.Password := '12345';
  ZConnection1.Port     := 5432;
  ZConnection1.Protocol  := 'postgresql';
  ZConnection1.Connected := True;
end;

procedure TDmf.ZConnection1AfterConnect(Sender: TObject);
begin

end;

end.

