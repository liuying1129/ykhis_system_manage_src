unit UfrmPower;

interface

uses
  Windows, Messages, SysUtils, Classes, Forms,
  Dialogs, DB, Buttons,
  StrUtils, DBCtrls, ADODB,inifiles, StdCtrls, ExtCtrls, CheckLst,
  Menus, Mask, Controls, Grids, DBGrids, ComCtrls, MemDS, DBAccess,
  Uni;

type
  TfrmPower = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    GroupBox3: TGroupBox;
    DBGrid_js1: TDBGrid;
    GroupBox6: TGroupBox;
    DBGrid_zy: TDBGrid;
    DataSource_js: TDataSource;
    DataSource_zy: TDataSource;
    Label4: TLabel;
    ComboBox1: TComboBox;
    CheckListBox2: TCheckListBox;
    CheckListBox1: TCheckListBox;
    ADOQuery_js: TUniQuery;
    ADOQuery_zy: TUniQuery;
    Panel2: TPanel;
    LabeledEdit1: TLabeledEdit;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ADOQuery_jsAfterScroll(DataSet: TDataSet);
    procedure ADOQuery_zyAfterScroll(DataSet: TDataSet);
    procedure ComboBox1Change(Sender: TObject);
    procedure CheckListBox1ClickCheck(Sender: TObject);
    procedure CheckListBox2ClickCheck(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LabeledEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    procedure MakeCombinChecklistbox;
    procedure MakeCombinChecklistbox_JS;
    procedure CheckTheListBox;//���ݵ�ǰ��ɫ��Ȩ����checklistbox1�д�
    procedure CheckTheListBox_JS;//���ݵ�ǰ�û��Ľ�ɫ��checklistbox2�д�
    procedure UpdateADOQuery_zy;//������Ա�б�
  public
    { Public declarations }
  end;

function frmPower: TfrmPower;

implementation

uses UDM;

var
  ffrmPower: TfrmPower;

{$R *.dfm}

function  frmPower: TfrmPower;
begin
  if ffrmPower=nil then ffrmPower:=TfrmPower.Create(application.mainform);
  result:=ffrmPower;
end;

procedure TfrmPower.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action:=cafree;
  if ffrmPower=self then ffrmPower:=nil;
end;

procedure TfrmPower.FormCreate(Sender: TObject);
begin
  ADOQuery_js.Connection:=DM.MyConnection1;
  ADOQuery_zy.Connection:=DM.MyConnection1;
end;

procedure TfrmPower.FormShow(Sender: TObject);
var
  ConfigIni:tinifile;
  selSysName:integer;
begin
  pagecontrol1.ActivePageIndex:=0;

  LoadGroupName(ComboBox1,'select Distinct Reserve from commcode where typename=''�ܿع���'' ');//����ϵͳ����

  ConfigIni:=tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  selSysName:=configini.ReadInteger('Interface','selSysName',0);{��¼ѡ���ϵͳ����}
  configini.Free;
  ComboBox1.ItemIndex:=selSysName;

  MakeCombinChecklistbox;//����Ȩ�޹�ѡ�б�
  MakeCombinChecklistbox_JS;//���ؽ�ɫ��ѡ�б�
  
  UpdateADOQuery_zy;//������Ա�б�

  ADOQuery_js.Close;
  ADOQuery_js.SQL.Clear;
  ADOQuery_js.SQL.Text:='select name,code,unid from commcode where TypeName=''��ɫ'' ';
  ADOQuery_js.Open;
end;

procedure TfrmPower.ADOQuery_jsAfterScroll(DataSet: TDataSet);
begin
  CheckTheListBox;
end;

procedure TfrmPower.ADOQuery_zyAfterScroll(DataSet: TDataSet);
begin
  Edit1.Text:='['+DataSet.fieldbyname('����').AsString+']'+DataSet.fieldbyname('����').AsString;
  
  CheckTheListBox_JS;
end;

procedure TfrmPower.ComboBox1Change(Sender: TObject);
begin
  MakeCombinChecklistbox;
  CheckTheListBox;
end;

procedure TfrmPower.MakeCombinChecklistbox;
var
  adotemp3:TUniQuery;
begin
     CheckListBox1.Items.Clear;

     adotemp3:=TUniQuery.Create(nil);
     adotemp3.Connection:=DM.MyConnection1;
     adotemp3.Close;
     adotemp3.SQL.Clear;
     adotemp3.SQL.Text:='select * from commcode WHERE typename=''�ܿع���'' and Reserve='''+ComboBox1.Text+''' ';
     adotemp3.Open;
     while not adotemp3.Eof do
     begin
       CheckListBox1.Items.Add(adotemp3.fieldbyname('unid').AsString+'   '+adotemp3.fieldbyname('name').AsString);

       adotemp3.Next;
     end;
     adotemp3.Free;
end;

procedure TfrmPower.CheckTheListBox;
var
  i:integer;
  b:integer;
  ss,sss:string;
begin
   if not ADOQuery_js.Active then exit;
   if ADOQuery_js.RecordCount<=0 then exit;

   for i:=0 to CheckListBox1.Items.Count-1 do CheckListBox1.Checked[i]:=false;

   for i:=0 to CheckListBox1.Items.Count-1 do
   begin
      ss:=CheckListBox1.Items.Strings[i];
      b:=pos('   ',ss);
      sss:=copy(ss,1,b-1);
      if strtoint(ScalarSQLCmd(HisConn,'select count(*) from role_power where role_unid='+ADOQuery_js.fieldbyname('unid').AsString+' and power_unid='+sss))>0 then
      begin
        CheckListBox1.Checked[i]:=true;
      end;
   end;
end;

procedure TfrmPower.CheckListBox1ClickCheck(Sender: TObject);
var
  i,b:integer;
  menu_bm:string;
begin
  i:=(Sender as TCheckListBox).ItemIndex;

  if (not ADOQuery_js.Active) or (ADOQuery_js.RecordCount <= 0) then
  begin
    Application.MessageBox('����ѡ���ɫ', '��ʾ��Ϣ',MB_OK + MB_ICONEXCLAMATION + MB_DEFBUTTON1 + MB_APPLMODAL);
    (Sender as TCheckListBox).Checked[i]:=false;
    exit;
  end;

  menu_bm:=(Sender as TCheckListBox).Items.Strings[i];
  b:=pos('   ',menu_bm);
  menu_bm:=copy(menu_bm,1,b-1);

  if (Sender as TCheckListBox).Checked[i] then
  begin
    ExecSQLCmd(HisConn,'insert into role_power (role_unid,power_unid) values ('+ADOquery_js.FieldByName('unid').AsString+','+menu_bm+')');
  end else
  begin
    ExecSQLCmd(HisConn,'delete from role_power where role_unid='+ADOquery_js.FieldByName('unid').AsString+' and power_unid='+menu_bm);
  end;
end;

procedure TfrmPower.CheckTheListBox_JS;
var
  i,b:integer;
  ss,sss:string;
begin
   if not ADOquery_zy.Active then exit;
   if ADOquery_zy.RecordCount<=0 then exit;

   for i:=0 to CheckListBox2.Items.Count-1 do CheckListBox2.Checked[i]:=false;

   for i:=0 to CheckListBox2.Items.Count-1 do
   begin
      ss:=CheckListBox2.Items.Strings[i];
      b:=pos('   ',ss);
      sss:=copy(ss,1,b-1);
      if strtoint(ScalarSQLCmd(HisConn,'select count(*) from worker_role where worker_unid='+ADOquery_zy.fieldbyname('unid').AsString+' and role_unid='+sss))>0 then
      begin
        CheckListBox2.Checked[i]:=true;
      end;
   end;
end;

procedure TfrmPower.MakeCombinChecklistbox_JS;
var
  adotemp3:TUniQuery;
begin
     CheckListBox2.Items.Clear;

     adotemp3:=TUniQuery.Create(nil);
     adotemp3.Connection:=DM.MyConnection1;
     adotemp3.Close;
     adotemp3.SQL.Clear;
     adotemp3.SQL.Text:='select * from commcode where typename=''��ɫ'' ';
     adotemp3.Open;
     while not adotemp3.Eof do
     begin
      CheckListBox2.Items.Add(adotemp3.fieldbyname('unid').AsString+'   '+adotemp3.fieldbyname('name').AsString);

      adotemp3.Next;
     end;
     adotemp3.Free;
end;

procedure TfrmPower.CheckListBox2ClickCheck(Sender: TObject);
var
  i,b:integer;
  jsmc,js_unid:string;
begin
  i:=(Sender as TCheckListBox).ItemIndex;

  if (not ADOQuery_zy.Active) or (ADOQuery_zy.RecordCount <= 0) then
  begin
    Application.MessageBox('����ѡ���û�', '��ʾ��Ϣ',MB_OK + MB_ICONEXCLAMATION + MB_DEFBUTTON1 + MB_APPLMODAL);
    (Sender as TCheckListBox).Checked[i]:=false;
    exit;
  end;

  jsmc:=trim((Sender as TCheckListBox).Items.Strings[i]);
  b:=pos('   ',jsmc);
  js_unid:=copy(jsmc,1,b-1);

  if (Sender as TCheckListBox).Checked[i] then
  begin
    ExecSQLCmd(HisConn,'insert into worker_role (worker_unid,role_unid) values ('+ADOQuery_zy.FieldByName('unid').AsString+','+js_unid+')');
  end else
  begin
    ExecSQLCmd(HisConn,'delete from worker_role where worker_unid='+ADOQuery_zy.FieldByName('unid').AsString+' and role_unid='+js_unid);
  end;
end;

procedure TfrmPower.FormDestroy(Sender: TObject);
var
  ConfigIni:tinifile;
begin
  ConfigIni:=tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));

  configini.WriteInteger('Interface','selSysName',ComboBox1.ItemIndex);{��¼ѡ���ϵͳ����}

  configini.Free;
end;

procedure TfrmPower.UpdateADOQuery_zy;
begin
    ADOQuery_zy.Close;
    ADOQuery_zy.SQL.Clear;
    ADOQuery_zy.SQL.Text:='select code as ����,name as ����,dep_unid as ����Ψһ���,unid from worker ';
    ADOQuery_zy.Open;
end;

procedure TfrmPower.LabeledEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key<>13 then EXIT;

  if (Sender as TLabeledEdit).CanFocus then begin (Sender as TLabeledEdit).SetFocus;(Sender as TLabeledEdit).SelectAll; end;

  if trim((Sender as TLabeledEdit).Text)='' then exit;

  //��ͨ�����ƶ�λ,��ͨ�����Ŷ�λ
  if not ADOQuery_zy.Locate('����',(Sender as TLabeledEdit).Text,[loCaseInsensitive]) then
    ADOQuery_zy.Locate('����',(Sender as TLabeledEdit).Text,[loCaseInsensitive]);
end;

initialization
  ffrmPower:=nil;

end.
