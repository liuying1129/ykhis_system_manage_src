unit UfrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls,StrUtils, Menus, StdCtrls,IniFiles, ExtCtrls, Buttons;
  
//==Ϊ��ͨ��������Ϣ����������״̬��������==//
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
    //==Ϊ��ͨ��������Ϣ����������״̬��������==//
    procedure WMUpdateTextStatus(var message:twmupdatetextstatus);  {WM_UPDATETEXTSTATUS��Ϣ������}
                                              message WM_UPDATETEXTSTATUS;
    procedure updatestatusBar(const text:string);//TextΪ�ø�ʽ#$2+'0:abc'+#$2+'1:def'��ʾ״̬����0����ʾabc,��1����ʾdef,��������
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

  TimerIdleTracker.Enabled:=true;//TimerIdleTrackerTimer�¼������õ������ļ�����LoginTime
end;

procedure TfrmMain.updatestatusBar(const text: string);
//TextΪ�ø�ʽ#$2+'0:abc'+#$2+'1:def'��ʾ״̬����0����ʾabc,��1����ʾdef,��������
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
  if not ifhaspower(sender,operator_id) then exit;//Ȩ�޼��

  close;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  if not ifhaspower(sender,operator_id) then exit;//Ȩ�޼��

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
  //��ϵͳ����
  SCSYDW:=ScalarSQLCmd(g_Server,g_Port,g_Database,g_Username,g_Password,'select Name from commcode where TypeName=''ϵͳ����'' and ReMark=''��Ȩʹ�õ�λ'' ');
  if SCSYDW='' then SCSYDW:='2F3A054F64394BBBE3D81033FDE12313';//'δ��Ȩ��λ'���ܺ���ַ���
  //======����SCSYDW
  pInStr:=pchar(SCSYDW);
  pDeStr:=DeCryptStr(pInStr,Pchar(CryptStr));
  setlength(SCSYDW,length(pDeStr));
  for i :=1  to length(pDeStr) do SCSYDW[i]:=pDeStr[i-1];
  //==========

  CONFIGINI:=TINIFILE.Create(ChangeFileExt(Application.ExeName,'.ini'));

  LoginTime:=configini.ReadInteger('ѡ��','������¼���ڵ�ʱ��',30);

  configini.Free;
end;

procedure TfrmMain.N11Click(Sender: TObject);
var                                                                           
  ss:string;
begin
  if not ifhaspower(sender,operator_id) then exit;

  ss:='������¼���ڵ�ʱ��'+#2+'Edit'+#2+#2+'1'+#2+'ע:��ʾ�೤ʱ�����޲���,���Զ�������¼����(��λ:��)'+#2+#3;
  if ShowOptionForm('ѡ��','����'+#2+'ѡ��'+#2+'��ӡģ��',Pchar(ss),Pchar(ChangeFileExt(Application.ExeName,'.ini'))) then
	  ReadIni;
end;

procedure TfrmMain.ReadConfig;
begin
  ReadIni();
end;

procedure TfrmMain.TimerIdleTrackerTimer(Sender: TObject);
begin
  //�Զ�������¼����
  if (StopTime>LoginTime) and (FindWindow(PCHAR('TfrmLogin'),PCHAR('��¼'))=0) then
    frmLogin.ShowModal;
end;

procedure TfrmMain.BitBtn1Click(Sender: TObject);
begin
  if not ifhaspower(sender,operator_id) then exit;//Ȩ�޼��

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
