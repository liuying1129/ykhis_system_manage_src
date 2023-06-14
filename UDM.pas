unit UDM;

interface

uses
  SysUtils, Classes, DB, DBAccess, IniFiles,Forms,Dialogs, Menus,
  ComCtrls,StdCtrls,ExtCtrls,Buttons,Windows{TLastInputInfo}, Uni,
  UniProvider, MySQLUniProvider;

type
  PDescriptType=^TDescriptType;
  TDescriptType=record
    unid:string;//类型的unid
    UpUnid:string;//上级类型unid
    SortNum:string;//排序号
  end;

type
  TDM = class(TDataModule)
    MyConnection1: TUniConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  SYSNAME='HIS后台管理';
  
var
  DM: TDM;

  g_Server:string;//MySQL服务器
  g_Database: string;//MySQL数据库
  HisConn:string;

  operator_name:string;
  operator_id:string;
  operator_dep_name:string;

  SCSYDW:STRING;//授权使用单位
  LoginTime:integer;//弹出登录窗口的时间

  //读取ini文件，则可做为仪器供应商的绑定销售版本
  CryptStr:String;//加解密种子,默认为'lc'

procedure WriteLog(const ALogStr: Pchar);stdcall;external 'LYFunction.dll';
function GetHDSn(const RootPath:pchar):pchar;stdcall;external 'LYFunction.dll';
function DeCryptStr(aStr: Pchar; aKey: Pchar): Pchar;stdcall;external 'LYFunction.dll';//解密
function EnCryptStr(aStr: Pchar; aKey: Pchar): Pchar;stdcall;external 'LYFunction.dll';//加密
function ShowOptionForm(const pCaption,pTabSheetCaption,pItemInfo,pInifile:Pchar):boolean;stdcall;external 'OptionSetForm.dll';
  
function MakeDBConn:boolean;
function ExecSQLCmd(AHisConn:string;ASQL:string):boolean;
function ScalarSQLCmd(AHisConn:string;ASQL:string):string;
function ifhaspower(sender: tobject;const AUserCode:string): boolean;
function StopTime: integer; //返回没有键盘和鼠标事件的时间
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
  ss,newconnstr:string;
  Ini: tinifile;
  userid, password, datasource, initialcatalog,provider: string;
  port:integer;

  pInStr,pDeStr:Pchar;
  i:integer;
  Label labReadIni;
begin
  result:=false;

  labReadIni:
  Ini := tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  provider := Ini.ReadString('连接数据库', '数据提供者', '');
  datasource := Ini.ReadString('连接数据库', '服务器', '');
  port := Ini.ReadInteger('连接数据库', '端口号', -1);
  initialcatalog := Ini.ReadString('连接数据库', '数据库', '');
  userid := Ini.ReadString('连接数据库', '用户', '');
  password := Ini.ReadString('连接数据库', '口令', '107DFC967CDCFAAF');
  Ini.Free;
  //======解密password
  pInStr:=pchar(password);
  pDeStr:=DeCryptStr(pInStr,Pchar(CryptStr));
  setlength(password,length(pDeStr));
  for i :=1  to length(pDeStr) do password[i]:=pDeStr[i-1];
  //==========

  //Provider Name为MySQL时,切记设置中文字符集(如Charset=GBK).否则:select中文别名报错;字段的中文值显示乱码
  newconnstr :='';
  newconnstr := newconnstr + 'Provider Name=' + provider + ';';
  newconnstr := newconnstr + 'Login Prompt=False;Charset=GBK;';
  newconnstr := newconnstr + 'Data Source=' + datasource + ';';
  newconnstr := newconnstr + 'User ID=' + userid + ';';
  newconnstr := newconnstr + 'Password=' + password + ';';
  newconnstr := newconnstr + 'Database=' + initialcatalog + ';';
  newconnstr := newconnstr + 'Port=' + inttostr(port) + ';';
  try
    DM.MyConnection1.Connected := false;
    DM.MyConnection1.ConnectString:=newconnstr;
    DM.MyConnection1.Connect;
    result:=true;
    HisConn:=newconnstr;
    g_Server:=datasource;
    g_Database:=initialcatalog;
  except
  end;
  if not result then
  begin
    ss:='数据提供者'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '服务器'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '端口号'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '数据库'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '用户'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '口令'+#2+'Edit'+#2+#2+'0'+#2+#2+'1';
    if ShowOptionForm('连接数据库','连接数据库',Pchar(ss),Pchar(ChangeFileExt(Application.ExeName,'.ini'))) then
      goto labReadIni else application.Terminate;
  end;
end;

function ExecSQLCmd(AHisConn:string;ASQL:string):boolean;
var
  Conn:TUniConnection;
  Qry:TUniQuery;
begin
  Result:=true;

  Conn:=TUniConnection.Create(nil);
  Conn.LoginPrompt:=false;
  Conn.ConnectString:=AHisConn;
  Qry:=TUniQuery.Create(nil);
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
      WriteLog(pchar('操作者:'+operator_name+'。函数ExecSQLCmd失败:'+E.Message+'。错误的SQL:'+ASQL));
      MESSAGEDLG('函数ExecSQLCmd失败:'+E.Message+'。错误的SQL:'+ASQL,mtError,[mbOK],0);
    end;
  end;
  Qry.Free;
  Conn.Free;
end;

function ScalarSQLCmd(AHisConn:string;ASQL:string):string;
var
  Conn:TUniConnection;
  Qry:TUniQuery;
begin
  Result:='';
  Conn:=TUniConnection.Create(nil);
  Conn.LoginPrompt:=false;
  Conn.ConnectString:=AHisConn;
  Qry:=TUniQuery.Create(nil);
  Qry.Connection:=Conn;
  Qry.Close;
  Qry.SQL.Clear;
  Qry.SQL.Text:=ASQL;
  Try
    Qry.Open;
  except
    on E:Exception do
    begin
      WriteLog(pchar('操作者:'+operator_name+'。函数ScalarSQLCmd失败:'+E.Message+'。错误的SQL:'+ASQL));
      MESSAGEDLG('函数ScalarSQLCmd失败:'+E.Message+'。错误的SQL:'+ASQL,mtError,[mbOK],0);
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
  ADOquery_menuitem:TUniQuery;
begin
  result:=false;
  //===============超级用户例外=================//
  if strtoint(ScalarSQLCmd(HisConn,'select count(*) from worker where ifSuperUser=1 and code='''+operator_id+''' '))>0 then
  begin
    result:=true;
    exit;
  end;
  //=======================================================//

  ADOquery_menuitem:=TUniQuery.Create(nil);
  ADOquery_menuitem.Connection:=DM.MyConnection1;
  ADOquery_menuitem.SQL.Clear;
  ADOquery_menuitem.SQL.Text:='SELECT cc.name FROM worker w,worker_role wr,role_power rp,commcode cc where w.code='''+AUserCode+''' and w.unid=wr.worker_unid AND wr.role_unid=rp.role_unid and cc.typename=''受控功能'' AND cc.Reserve='''+SYSNAME+''' AND rp.power_unid=cc.unid';
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
      messagedlg('对不起，您没有该权限！',mtinformation,[mbok],0);
end;

function StopTime: integer;
//返回没有键盘和鼠标事件的时间
var
  LInput: TLastInputInfo;
begin
  LInput.cbSize := SizeOf(TLastInputInfo);
  GetLastInputInfo(LInput);
  Result := (GetTickCount() - LInput.dwTime) div 1000;//微秒换成秒
end;

procedure LoadGroupName(const comboBox:TcomboBox;const ASel:string);
var
  adotemp3:TUniQuery;
  tempstr:string;
begin
     adotemp3:=TUniQuery.Create(nil);
     adotemp3.Connection:=DM.MyConnection1;
     adotemp3.Close;
     adotemp3.SQL.Clear;
     adotemp3.SQL.Text:=ASel;
     adotemp3.Open;
     
     comboBox.Items.Clear;//加载前先清除comboBox项

     while not adotemp3.Eof do
     begin
      tempstr:=trim(adotemp3.Fields[0].AsString);

      comboBox.Items.Add(tempstr); //加载到comboBox

      adotemp3.Next;
     end;
     adotemp3.Free;
end;

function HasSubInDbf(Node:TTreeNode):Boolean;
//检查节点Node有无子节点,有则返回True,反之返回False
var
  adotemp22:TUniQuery;
begin
  result:=false;
  adotemp22:=TUniQuery.Create(nil);
  adotemp22.Connection:=dm.MyConnection1;
  adotemp22.Close;
  adotemp22.SQL.Clear;
  adotemp22.SQL.Text:='select * from temp_dir where up_unid='+PDescriptType(Node.Data)^.unid+' LIMIT 1';
  adotemp22.Open;
  if adotemp22.RecordCount<>0 then result:= True;
  adotemp22.Free;
end;

end.
