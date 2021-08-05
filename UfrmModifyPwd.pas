unit UfrmModifyPwd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TfrmModifyPwd = class(TForm)
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function frmModifyPwd: TfrmModifyPwd;

implementation

uses UDM;

var
  ffrmModifyPwd: TfrmModifyPwd;
  
{$R *.dfm}

////////////////////////////////////////////////////////////////////////////////
function frmModifyPwd:TfrmModifyPwd;    {动态创建窗体函数}
begin
  if ffrmModifyPwd=nil then ffrmModifyPwd:=TfrmModifyPwd.Create(application.mainform);
  result:=ffrmModifyPwd;
end;

procedure TfrmModifyPwd.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action:=cafree;
  if ffrmModifyPwd=self then ffrmModifyPwd:=nil;
end;
////////////////////////////////////////////////////////////////////////////////

procedure TfrmModifyPwd.BitBtn2Click(Sender: TObject);
begin
  close;
end;

procedure TfrmModifyPwd.BitBtn1Click(Sender: TObject);
begin
  if strtoint(ScalarSQLCmd(g_Server,g_Port,g_Database,g_Username,g_Password,'select count(*) from worker where code='''+operator_id+''' AND ifnull(password,'''')='''+LabeledEdit1.Text+''' '))<=0 then
  begin
    messagedlg('原密码不正确！',mtInformation,[mbok],0);
    LabeledEdit1.SetFocus;
    exit;
  end ;

  if trim(LabeledEdit2.Text)='' then
  begin
     messagedlg('新密码不能为空！',mtInformation,[mbok],0);
     exit;
  end;

  if(trim(LabeledEdit2.Text)<>trim(LabeledEdit3.Text)) then
  begin
     messagedlg('新密码确认错误！',mtInformation,[mbok],0);
     exit;
  end;

  if ExecSQLCmd(g_Server,g_Port,g_Database,g_Username,g_Password,'update worker set password='''+trim(LabeledEdit2.Text)+''' where code='''+operator_id+''' ') then
  begin
    messagedlg('密码修改成功！',mtInformation,[mbok],0);
    close;
  end;
end;

initialization
  ffrmModifyPwd:=nil;

end.
