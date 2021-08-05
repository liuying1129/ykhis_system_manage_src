program ykhis_system_manage;

uses
  Forms,
  UfrmMain in 'UfrmMain.pas' {frmMain},
  UDM in 'UDM.pas' {DM: TDataModule},
  UfrmLogin in 'UfrmLogin.pas' {frmLogin},
  UfrmModifyPwd in 'UfrmModifyPwd.pas' {frmModifyPwd},
  UfrmCommCode in 'UfrmCommCode.pas' {frmCommCode},
  UfrmPower in 'UfrmPower.pas' {frmPower},
  Ufrmdocset in 'Ufrmdocset.pas' {frmdocset},
  UfrmDrugManage in 'UfrmDrugManage.pas' {frmDrugManage},
  UfrmTempDir in 'UfrmTempDir.pas' {frmTempDir},
  UfrmDgnsBigTemp in 'UfrmDgnsBigTemp.pas' {frmDgnsBigTemp};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
