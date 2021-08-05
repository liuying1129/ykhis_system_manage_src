unit UDM;

interface

uses
  SysUtils, Classes, DB, DBAccess, MyAccess,IniFiles,Forms,Dialogs, Menus,
  ComCtrls,StdCtrls,ExtCtrls,Buttons,Windows{TLastInputInfo};

type
  PDescriptType=^TDescriptType;
  TDescriptType=record
    unid:string;//���͵�unid
    UpUnid:string;//�ϼ�����unid
    SortNum:string;//�����
  end;

type
  TDM = class(TDataModule)
    MyConnection1: TMyConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  SYSNAME='HIS��̨����';
  
var
  DM: TDM;

  g_Server:string;//MySQL������
  g_Port:integer;//MySQL�˿ں�
  g_Database: string;//MySQL���ݿ�
  g_Username:string;//MySQL�û���
  g_Password:string;//MySQL����

  operator_name:string;
  operator_id:string;
  operator_dep_name:string;

  SCSYDW:STRING;//��Ȩʹ�õ�λ
  LoginTime:integer;//������¼���ڵ�ʱ��

  //��ȡini�ļ��������Ϊ������Ӧ�̵İ����۰汾
  CryptStr:String;//�ӽ�������,Ĭ��Ϊ'lc'

procedure WriteLog(const ALogStr: Pchar);stdcall;external 'LYFunction.dll';
function GetHDSn(const RootPath:pchar):pchar;stdcall;external 'LYFunction.dll';
function DeCryptStr(aStr: Pchar; aKey: Pchar): Pchar;stdcall;external 'DESCrypt.dll';//����
function EnCryptStr(aStr: Pchar; aKey: Pchar): Pchar;stdcall;external 'DESCrypt.dll';//����
function ShowOptionForm(const pCaption,pTabSheetCaption,pItemInfo,pInifile:Pchar):boolean;stdcall;external 'OptionSetForm.dll';
  
function MakeDBConn:boolean;
function ExecSQLCmd(AServer:string;APort:integer;ADataBase:string;AUserName:string;APassword:string;ASQL:string):boolean;
function ScalarSQLCmd(AServer:string;APort:integer;ADataBase:string;AUserName:string;APassword:string;ASQL:string):string;
function ifhaspower(sender: tobject;const AUserCode:string): boolean;
function StopTime: integer; //����û�м��̺�����¼���ʱ��
procedure LoadGroupName(const comboBox:TcomboBox;const ASel:string);
function HasSubInDbf(Node:TTreeNode):Boolean;

implementation

{$R *.dfm}

procedure TDM.DataModuleCreate(Sender: TObject);
var
  CONFIGINI:tinifile;
begin
  CONFIGINI:=TINIFILE.Create(ChangeFileExt(Application.ExeName,'.ini'));
  CryptStr:=CONFIGINI.ReadString('Interface','CompanyId','lc');
  CONFIGINI.Free;

  MakeDBConn;
end;

function MakeDBConn:boolean;
var
  ss:string;
  Ini: tinifile;
  userid, password, datasource, initialcatalog: string;
  port:integer;

  pInStr,pDeStr:Pchar;
  i:integer;
  Label labReadIni;
begin
  result:=false;

  labReadIni:
  Ini := tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  datasource := Ini.ReadString('�������ݿ�', '������', '');
  port := Ini.ReadInteger('�������ݿ�', '�˿ں�', -1);
  initialcatalog := Ini.ReadString('�������ݿ�', '���ݿ�', '');
  userid := Ini.ReadString('�������ݿ�', '�û�', '');
  password := Ini.ReadString('�������ݿ�', '����', '107DFC967CDCFAAF');
  Ini.Free;
  //======����password
  pInStr:=pchar(password);
  pDeStr:=DeCryptStr(pInStr,Pchar(CryptStr));
  setlength(password,length(pDeStr));
  for i :=1  to length(pDeStr) do password[i]:=pDeStr[i-1];
  //==========

  try
    dm.MyConnection1.Connected := false;
    dm.MyConnection1.LoginPrompt:=false;
    //ʹ��gb2312,���롾�h��ʱ����.��Ϊgbk���
    dm.MyConnection1.Options.Charset:='gbk';
    dm.MyConnection1.Server:=datasource;
    dm.MyConnection1.Port:=port;
    dm.MyConnection1.Database:=initialcatalog;
    dm.MyConnection1.Username:=userid;
    dm.MyConnection1.Password:=password;
    dm.MyConnection1.Connected := true;
    result:=true;

    g_Server:=datasource;//MySQL������
    g_Port:=port;//MySQL�˿ں�
    g_Database:=initialcatalog;//MySQL���ݿ�
    g_Username:=userid;//MySQL�û���
    g_Password:=password;//MySQL����
  except
  end;
  if not result then
  begin
    ss:='������'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '�˿ں�'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '���ݿ�'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '�û�'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '����'+#2+'Edit'+#2+#2+'0'+#2+#2+'1';
    if ShowOptionForm('�������ݿ�','�������ݿ�',Pchar(ss),Pchar(ChangeFileExt(Application.ExeName,'.ini'))) then
      goto labReadIni else application.Terminate;
  end;
end;

function ExecSQLCmd(AServer:string;APort:integer;ADataBase:string;AUserName:string;APassword:string;ASQL:string):boolean;
var
  Conn:TMyConnection;
  Qry:TMyQuery;
begin
  Result:=true;

  Conn:=TMyConnection.Create(nil);
  Conn.LoginPrompt:=false;
  Conn.Options.Charset:='gb2312';
  Conn.Server:=AServer;
  Conn.Port:=APort;
  Conn.Database:=ADataBase;
  Conn.Username:=AUserName;
  Conn.Password:=APassword;
  Qry:=TMyQuery.Create(nil);
  Qry.Connection:=Conn;
  Qry.Close;
  Qry.SQL.Clear;
  Qry.SQL.Text:=ASQL;
  Try
    Qry.ExecSQL;
  except
    on E:Exception do
    begin
      Result:=false;
      WriteLog(pchar('������:'+operator_name+'������ExecSQLCmdʧ��:'+E.Message+'�������SQL:'+ASQL));
      MESSAGEDLG('����ExecSQLCmdʧ��:'+E.Message+'�������SQL:'+ASQL,mtError,[mbOK],0);
    end;
  end;
  Qry.Free;
  Conn.Free;
end;

function ScalarSQLCmd(AServer:string;APort:integer;ADataBase:string;AUserName:string;APassword:string;ASQL:string):string;
var
  Conn:TMyConnection;
  Qry:TMyQuery;
begin
  Result:='';
  Conn:=TMyConnection.Create(nil);
  Conn.LoginPrompt:=false;
  Conn.Options.Charset:='gb2312';
  Conn.Server:=AServer;
  Conn.Port:=APort;
  Conn.Database:=ADataBase;
  Conn.Username:=AUserName;
  Conn.Password:=APassword;
  Qry:=TMyQuery.Create(nil);
  Qry.Connection:=Conn;
  Qry.Close;
  Qry.SQL.Clear;
  Qry.SQL.Text:=ASQL;
  Try
    Qry.Open;
  except
    on E:Exception do
    begin
      WriteLog(pchar('������:'+operator_name+'������ScalarSQLCmdʧ��:'+E.Message+'�������SQL:'+ASQL));
      MESSAGEDLG('����ScalarSQLCmdʧ��:'+E.Message+'�������SQL:'+ASQL,mtError,[mbOK],0);
      Qry.Free;
      Conn.Free;
      exit;
    end;
  end;
  Result:=Qry.Fields[0].AsString;
  Qry.Free;
  Conn.Free;
end;

function haspower(AUserCode, menuname: string): boolean;
var
  ADOquery_menuitem:TMyQuery;
begin
  result:=false;
  //===============�����û�����=================//
  if strtoint(ScalarSQLCmd(g_Server,g_Port,g_Database,g_Username,g_Password,'select count(*) from worker where ifSuperUser=1 and code='''+operator_id+''' '))>0 then
  begin
    result:=true;
    exit;
  end;
  //=======================================================//

  ADOquery_menuitem:=TMyQuery.Create(nil);
  ADOquery_menuitem.Connection:=DM.MyConnection1;
  ADOquery_menuitem.SQL.Clear;
  ADOquery_menuitem.SQL.Text:='SELECT cc.name FROM worker w,worker_role wr,role_power rp,commcode cc where w.code='''+AUserCode+''' and w.unid=wr.worker_unid AND wr.role_unid=rp.role_unid and cc.typename=''�ܿع���'' AND cc.Reserve='''+SYSNAME+''' AND rp.power_unid=cc.unid';
  ADOquery_menuitem.Open;

  while not ADOquery_menuitem.Eof do
  begin
    if UpperCase(trim(ADOquery_menuitem.fieldbyname('name').AsString))=UpperCase(Trim(menuname)) then
    begin
      result:=true;
      ADOquery_menuitem.Free;
      exit;
    end;

    ADOquery_menuitem.Next;
  end;

  if ADOquery_menuitem<>nil then ADOquery_menuitem.Free;
end;

function ifhaspower(sender: tobject;const AUserCode:string): boolean;
begin
  result:=true;

  if sender is tmenuitem then
  begin
    if not haspower(AUserCode,tmenuitem(sender).Caption) then result:=false;
  end;

  if sender is ttoolbutton then
  begin
    if not haspower(AUserCode,ttoolbutton(sender).Caption) then result:=false;
  end;

  if sender is tbutton then
  begin
    if not haspower(AUserCode,tbutton(sender).Caption) then result:=false;
  end;

  if sender is tpanel then
  begin
    if not haspower(AUserCode,tpanel(sender).Caption) then result:=false;
  end;

  if sender is tspeedbutton then
  begin
    if not haspower(AUserCode,tspeedbutton(sender).Caption) then result:=false;
  end;

  if sender is tcombobox then  
  begin
    if not haspower(AUserCode,inttostr(tcombobox(sender).tag)) then result:=false;
  end;

  if sender is tedit then
  begin
    if not haspower(AUserCode,inttostr(tedit(sender).tag)) then result:=false;
  end;

  if sender is tLabeledEdit then
  begin
    if not haspower(AUserCode,tLabeledEdit(sender).EditLabel.Caption) then result:=false;
  end;

  if not result then
      messagedlg('�Բ�����û�и�Ȩ�ޣ�',mtinformation,[mbok],0);
end;

function StopTime: integer;
//����û�м��̺�����¼���ʱ��
var
  LInput: TLastInputInfo;
begin
  LInput.cbSize := SizeOf(TLastInputInfo);
  GetLastInputInfo(LInput);
  Result := (GetTickCount() - LInput.dwTime) div 1000;//΢�뻻����
end;

procedure LoadGroupName(const comboBox:TcomboBox;const ASel:string);
var
  adotemp3:TMyQuery;
  tempstr:string;
begin
     adotemp3:=TMyQuery.Create(nil);
     adotemp3.Connection:=DM.MyConnection1;
     adotemp3.Close;
     adotemp3.SQL.Clear;
     adotemp3.SQL.Text:=ASel;
     adotemp3.Open;
     
     comboBox.Items.Clear;//����ǰ�����comboBox��

     while not adotemp3.Eof do
     begin
      tempstr:=trim(adotemp3.Fields[0].AsString);

      comboBox.Items.Add(tempstr); //���ص�comboBox

      adotemp3.Next;
     end;
     adotemp3.Free;
end;

function HasSubInDbf(Node:TTreeNode):Boolean;
//���ڵ�Node�����ӽڵ�,���򷵻�True,��֮����False
var
  adotemp22:TMyQuery;
begin
  result:=false;
  adotemp22:=TMyQuery.Create(nil);
  adotemp22.Connection:=dm.MyConnection1;
  adotemp22.Close;
  adotemp22.SQL.Clear;
  adotemp22.SQL.Text:='select * from temp_dir where up_unid='+PDescriptType(Node.Data)^.unid+' LIMIT 1';
  adotemp22.Open;
  if adotemp22.RecordCount<>0 then result:= True;
  adotemp22.Free;
end;

end.
