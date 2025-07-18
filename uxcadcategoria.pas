unit uXCadCategoria;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, DBGrids,
  DBCtrls, StdCtrls, Buttons, ZDataset, ZSqlUpdate, ZAbstractRODataset, xCadPai,
  DB;

type

  { TxCadCategoriaF }

  TxCadCategoriaF = class(TxCadPaiF)
    btnExcluir: TBitBtn;
    btnGravar: TBitBtn;
    btnEditar: TBitBtn;
    btnCancelar: TBitBtn;
    BitBtn5: TBitBtn;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    dsCategoria: TDataSource;
    DBGrid1: TDBGrid;
    edtPesquisado: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    qryCategoriacategoriaprodutoid: TZIntegerField;
    qryCategoriads_categoria_produto: TZRawStringField;
    rgEscolhaPesquisa: TRadioGroup;
    qryCategoria: TZQuery;
    updtCategoria: TZUpdateSQL;
    procedure BitBtn1Click(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure dsCategoriaStateChange(Sender: TObject);
    procedure edtPesquisadoChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure pgControlChange(Sender: TObject);
  private

  public

  end;

var
  xCadCategoriaF: TxCadCategoriaF;

implementation

{$R *.lfm}

{ TxCadCategoriaF }

procedure TxCadCategoriaF.btnInserirClick(Sender: TObject);
begin
  pgControl.ActivePage := pgCadastro;
  qryCategoria.Insert;
end;

procedure TxCadCategoriaF.btnGravarClick(Sender: TObject);
begin
  qryCategoria.Post;
  pgControl.ActivePage := pgPesquisa;
end;

procedure TxCadCategoriaF.BitBtn1Click(Sender: TObject);
begin
  pgControl.ActivePage := pgCadastro;
  qryCategoria.Insert;
end;

procedure TxCadCategoriaF.btnExcluirClick(Sender: TObject);
begin
  pgControl.ActivePage := pgPesquisa;
  qryCategoria.Delete;
end;

procedure TxCadCategoriaF.btnEditarClick(Sender: TObject);
begin
  qryCategoria.Edit;
  btnGravar.Enabled:= true;
  btnEditar.Enabled := false;
  btnCancelar.Enabled := true;
  btnExcluir.Enabled := true;
end;

procedure TxCadCategoriaF.btnCancelarClick(Sender: TObject);
begin
  qryCategoria.Cancel;
  pgControl.ActivePage := pgPesquisa;
end;

procedure TxCadCategoriaF.BitBtn5Click(Sender: TObject);
begin
  Close;
end;

procedure TxCadCategoriaF.btnSairClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TxCadCategoriaF.DBGrid1DblClick(Sender: TObject);
begin
  pgControl.ActivePage := pgCadastro;
  btnEditar.Enabled := true;
  btnCancelar.Enabled := true;
  btnExcluir.Enabled := false;
end;

procedure TxCadCategoriaF.dsCategoriaStateChange(Sender: TObject);
begin
   BitBtn1.Enabled := (Sender as TDataSource).State in [dsBrowse];
   btnGravar.Enabled := (Sender as TDataSource).State in [dsEdit, dsInsert];
   btnCancelar.Enabled := btnGravar.Enabled;
   btnEditar.Enabled := (BitBtn1.Enabled) and not ((Sender as TDataSource).DataSet.IsEmpty);
   btnExcluir.Enabled := btnEditar.Enabled;
end;

procedure TxCadCategoriaF.edtPesquisadoChange(Sender: TObject);
var
  valorID : Integer;
  valorPesq : String;
begin

  if edtPesquisado.Text <> '' then
  begin
      qryCategoria.close;
      qryCategoria.SQL.clear;
      if rgEscolhaPesquisa.ItemIndex = 0 then
      begin
      if not TryStrToInt(edtPesquisado.Text, valorID) then
      begin
             ShowMessage('Você está pesquisando por ID. Letras não são permitidas. ' +
                         'Se deseja pesquisar por texto, mude o modo de pesquisa!');
             Exit;
      end;
             qryCategoria.SQL.Add('SELECT categoriaprodutoid, ds_categoria_produto ' +
                              'FROM categoria_produto ' +
                              'WHERE categoriaprodutoid = ' + edtPesquisado.Text);
             qryCategoria.Open;
      end
      else if rgEscolhaPesquisa.ItemIndex = 1 then
         begin
             if TryStrToInt(edtPesquisado.Text, valorID) then
             begin
             ShowMessage('Você está tentando pesquisar por texto, mas digitou apenas números. ' +
                'Se deseja buscar por ID, altere o modo de pesquisa.');
             Exit;
             end;
            qryCategoria.SQL.Add('SELECT categoriaprodutoid, ds_categoria_produto ' +
                              'FROM categoria_produto ' +
                              'WHERE ds_categoria_produto ILIKE ' + '''' + '%' +  edtPesquisado.Text + '%' + '''' + ';');
            qryCategoria.Open;
         end;
  end
  else
  begin
      qryCategoria.close;
      qryCategoria.SQL.clear;
      qryCategoria.SQL.Add('SELECT categoriaprodutoid, ds_categoria_produto ' +
                              'FROM categoria_produto ' +
                              'order by categoriaprodutoid desc');
      qryCategoria.open;
  end;
end;


procedure TxCadCategoriaF.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  qryCategoria.Close;
end;

procedure TxCadCategoriaF.FormShow(Sender: TObject);
begin
  pgControl.ActivePage := pgPesquisa;
  qryCategoria.Open;
end;

procedure TxCadCategoriaF.pgControlChange(Sender: TObject);
begin
  btnGravar.enabled := false;
  btnEditar.Enabled := false;
  btnCancelar.Enabled := true;
  btnExcluir.Enabled := false;
  btnSair.enabled := true;
end;

end.

