unit Modulo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, ComCtrls, DBGrids, DBCtrls, ZDataset, ZSqlUpdate, ZAbstractRODataset,
  Dm;

type

  { TModelo }

  TModelo = class(TForm)
    btnNovo: TBitBtn;
    btnSair: TBitBtn;
    btnGravar: TBitBtn;
    btnEditar: TBitBtn;
    btnCancelar: TBitBtn;
    btnExcluir: TBitBtn;
    dbId: TDBEdit;
    dbNome_completo: TDBEdit;
    dbUsuario: TDBEdit;
    dbSenha: TDBEdit;
    dsUsuarios: TDataSource;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    LabeledEdit1: TLabeledEdit;
    Panel3: TPanel;
    pgControl: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    pgnPesquisar: TTabSheet;
    pgnCadastro: TTabSheet;
    qryUsuarios: TZQuery;
    qryUsuariosid: TZIntegerField;
    qryUsuariosnome_completo: TZRawStringField;
    qryUsuariossenha: TZRawStringField;
    qryUsuariosusuario: TZRawStringField;
    rgPesquisar: TRadioGroup;
    updtUsuarios: TZUpdateSQL;
    procedure btnNovoClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure dsUsuariosStateChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure pgControlChange(Sender: TObject);
    procedure qryUsuariosAfterInsert(DataSet: TDataSet);
    procedure qryUsuariosBeforeInsert(DataSet: TDataSet);
    procedure qryUsuariosBeforePost(DataSet: TDataSet);

  private

  public

  end;

var
  Modelo: TModelo;

implementation

{$R *.lfm}

{ TModelo }


procedure TModelo.btnNovoClick(Sender: TObject);
begin

    pgControl.ActivePage := pgnCadastro;
    qryUsuarios.Insert;
    dbNome_completo.Enabled:=True;
    dbUsuario.Enabled:= true;
    dbSenha.Enabled:=true;
end;

procedure TModelo.btnSairClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TModelo.btnGravarClick(Sender: TObject);
begin
  pgControl.ActivePage := pgnPesquisar;
  qryUsuarios.Post;
end;

procedure TModelo.btnEditarClick(Sender: TObject);
begin
  qryUsuarios.Edit;
    dbNome_completo.Enabled:=True;
    dbUsuario.Enabled:= true;
    dbSenha.Enabled:=true;
end;

procedure TModelo.btnCancelarClick(Sender: TObject);
begin
  pgControl.ActivePage := pgnPesquisar;
  qryUsuarios.Cancel;
end;

procedure TModelo.btnExcluirClick(Sender: TObject);
begin
  qryUsuarios.Delete;
end;

procedure TModelo.DBGrid1DblClick(Sender: TObject);
begin
  pgControl.ActivePage:= pgnCadastro;
    dbId.Enabled := false;
    dbNome_completo.Enabled:=false;
    dbUsuario.Enabled:= false;
    dbSenha.Enabled:=false;
end;

procedure TModelo.dsUsuariosStateChange(Sender: TObject);
begin
   btnNovo.Enabled := (Sender as TDataSource).State in [dsBrowse];
   btnGravar.Enabled := (Sender as TDataSource).State in [dsEdit, dsInsert];
   btnCancelar.Enabled := btnGravar.Enabled;
   btnEditar.Enabled := (btnNovo.Enabled) and not ((Sender as TDataSource).DataSet.IsEmpty);
   btnExcluir.Enabled := btnEditar.Enabled;
end;

procedure TModelo.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  qryUsuarios.Close;
end;

procedure TModelo.FormShow(Sender: TObject);
begin
  pgControl.ActivePage := pgnPesquisar;
  qryUsuarios.Open;
end;

procedure TModelo.LabeledEdit1Change(Sender: TObject);
begin
  
  if LabeledEdit1.Text <> '' then
  begin
    qryUsuarios.Close;
    qryUsuarios.SQL.Clear;
    if rgPesquisar.ItemIndex = 0 then
    begin
      qryUsuarios.SQL.Add('select id, ' +
                          'nome_completo, ' +
                          'senha, ' +
                          'usuario ' +
                          'from usuarios ' + 'where id  = ' + LabeledEdit1.Text);
          qryUsuarios.Open;
    end
    else if rgPesquisar.ItemIndex = 1 then
    begin
      qryUsuarios.SQL.Add('select id, ' +
                          'nome_completo, ' +
                          'senha, ' +
                          'usuario ' +
                          'from usuarios ' + 'where nome_completo ILIKE ' + '''' + '%' + LabeledEdit1.Text + '%' + '''');
          qryUsuarios.Open;
    end
    else if rgPesquisar.ItemIndex = 2 then
    begin
      qryUsuarios.SQL.Add('select id, ' +
                          'nome_completo, ' +
                          'senha, ' +
                          'usuario ' +
                          'from usuarios ' + 'where usuario ILIKE ' + '''' + '%' + LabeledEdit1.Text  + '%' + '''');
          qryUsuarios.Open;
    end;
  end
  else
  begin
    qryUsuarios.Close;
    qryUsuarios.SQL.Clear;
    qryUsuarios.SQL.Add('select id, ' +
                        'nome_completo, ' +
                        'senha, ' +
                        'usuario ' +
                        'from usuarios ' +
                        'order by id desc');
    qryUsuarios.Open;
  end;
end;

procedure TModelo.pgControlChange(Sender: TObject);
begin
    dbId.Enabled := false;
    dbNome_completo.Enabled:=false;
    dbUsuario.Enabled:= false;
    dbSenha.Enabled:=false;
end;

procedure TModelo.qryUsuariosBeforePost(DataSet: TDataSet);
begin
  DmF.qryGenerica.SQL.add('SELECT nextval (' +''''+ 'usuario_idtemp' +''''+')');
  DmF.qryGenerica.SQL.Clear;
  DmF.qryGenerica.SQL.add('SELECT nextval (' + QuotedStr('usuario_idtemp')+') AS COD');
  DmF.qryGenerica.Open;
  qryUsuariosid.AsInteger := DmF.qryGenerica.FieldByName('COD').AsInteger;
end;
end.
