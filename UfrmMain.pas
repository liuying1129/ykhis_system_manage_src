unit UfrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls,StrUtils, Menus, StdCtrls,IniFiles, ExtCtrls, Buttons;
  
//==为了通过发送消息更新主窗体状态栏而增加==//
const
  WM_UPDATETEXTSTATUS=WM_USER+1;
TYPE
  TWMUpdateTextStatus=TWMSetText;
//=========================================//

type
  TfrmMain = class(TForm)
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    TimerIdleTracker: TTimer;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure TimerIdleTrackerTimer(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
    //==为了通过发送消息更新主窗体状态栏而增加==//
    procedure WMUpdateTextStatus(var message:twmupdatetextstatus);  {WM_UPDATETEXTSTATUS消息处理函数}
                                              message WM_UPDATETEXTSTATUS;
    procedure updatestatusBar(const text:string);//Text为该格式#$2+'0:abc'+#$2+'1:def'表示状态栏第0格显示abc,第1格显示def,依此类推
    //==========================================//
    procedure ReadIni;
    procedure ReadConfig;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses UfrmLogin, UDM, UfrmModifyPwd, UfrmCommCode, UfrmPower, Ufrmdocset,
  UfrmDrugManage, UfrmTempDir, UfrmDgnsBigTemp;

{$R *.dfm}

procedure TfrmMain.FormShow(Sender: TObject);
begin
  frmLogin.ShowModal;

  ReadConfig;
  UpdateStatusBar(#$2+'0:'+SYSNAME);
  UpdateStatusBar(#$2+'6:'+SCSYDW);
  UpdateStatusBar(#$2+'8:'+g_Server);
  UpdateStatusBar(#$2+'10:'+g_Database);

  TimerIdleTracker.Enabled:=true;//TimerIdleTrackerTimer事件中需用到配置文件变量LoginTime
end;

procedure TfrmMain.updatestatusBar(const text: string);
//Text为该格式#$2+'0:abc'+#$2+'1:def'表示状态栏第0格显示abc,第1格显示def,依此类推
var
  i,J2Pos,J2Len,TextLen,j:integer;
  tmpText:string;
begin
  TextLen:=length(text);
  for i :=0 to StatusBar1.Panels.Count-1 do
  begin
    J2Pos:=pos(#$2+inttostr(i)+':',text);
    J2Len:=length(#$2+inttostr(i)+':');
    if J2Pos<>0 then
    begin
      tmpText:=text;
      tmpText:=copy(tmpText,J2Pos+J2Len,TextLen-J2Pos-J2Len+1);
      j:=pos(#$2,tmpText);
      if j<>0 then tmpText:=leftstr(tmpText,j-1);
      StatusBar1.Panels[i].Text:=tmpText;
    end;
  end;
end;

procedure TfrmMain.WMUpdateTextStatus(var message: twmupdatetextstatus);
begin
  UpdateStatusBar(pchar(message.Text));
  message.Result:=-1;
end;

procedure TfrmMain.N5Click(Sender: TObject);
begin
  if not ifhaspower(sender,operator_id) then exit;//权限检查

  close;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  if not ifhaspower(sender,operator_id) then exit;//权限检查

  frmCommCode.ShowModal;
end;

procedure TfrmMain.N6Click(Sender: TObject);
begin
  frmLogin.ShowModal;
end;

procedure TfrmMain.N8Click(Sender: TObject);
begin
  frmModifyPwd.ShowModal;
end;

procedure TfrmMain.ReadIni;
var
  configini:tinifile;

  pInStr,pDeStr:Pchar;
  i:integer;
begin
  //读系统代码
  SCSYDW:=ScalarSQLCmd(g_Server,g_Port,g_Database,g_Username,g_Password,'select Name from commcode where TypeName=''系统代码'' and ReMark=''授权使用单位'' ');
  if SCSYDW='' then SCSYDW:='2F3A054F64394BBBE3D81033FDE12313';//'未授权单位'加密后的字符串
  //======解密SCSYDW
  pInStr:=pchar(SCSYDW);
  pDeStr:=DeCryptStr(pInStr,Pchar(CryptStr));
  setlength(SCSYDW,length(pDeStr));
  for i :=1  to length(pDeStr) do SCSYDW[i]:=pDeStr[i-1];
  //==========

  CONFIGINI:=TINIFILE.Create(ChangeFileExt(Application.ExeName,'.ini'));

  LoginTime:=configini.ReadInteger('选项','弹出登录窗口的时间',30);

  configini.Free;
end;

procedure TfrmMain.N11Click(Sender: TObject);
var                                                                           
  ss:string;
begin
  if not ifhaspower(sender,operator_id) then exit;

  ss:='弹出登录窗口的时间'+#2+'Edit'+#2+#2+'1'+#2+'注:表示多长时间内无操作,则自动弹出登录窗口(单位:秒)'+#2+#3;
  if ShowOptionForm('选项','报表'+#2+'选项'+#2+'打印模板',Pchar(ss),Pchar(ChangeFileExt(Application.ExeName,'.ini'))) then
	  ReadIni;
end;

procedure TfrmMain.ReadConfig;
begin
  ReadIni();
end;

procedure TfrmMain.TimerIdleTrackerTimer(Sender: TObject);
begin
  //自动弹出登录窗口
  if (StopTime>LoginTime) and (FindWindow(PCHAR('TfrmLogin'),PCHAR('登录'))=0) then
    frmLogin.ShowModal;
end;

procedure TfrmMain.BitBtn1Click(Sender: TObject);
begin
  if not ifhaspower(sender,operator_id) then exit;//权限检查

  frmPower.ShowModal;
end;

procedure TfrmMain.BitBtn2Click(Sender: TObject);
begin
  if not ifhaspower(sender,operator_id) then exit;

  frmdocset.showmodal;
end;

procedure TfrmMain.SpeedButton1Click(Sender: TObject);
begin
  if not ifhaspower(sender,operator_id) then exit;

  frmDrugManage.showmodal;
end;

procedure TfrmMain.SpeedButton2Click(Sender: TObject);
begin
  if not ifhaspower(sender,operator_id) then exit;

  frmTempDir.ShowModal;
end;

procedure TfrmMain.SpeedButton3Click(Sender: TObject);
begin
  if not ifhaspower(sender,operator_id) then exit;

  frmDgnsBigTemp.ShowModal;
end;

end.
