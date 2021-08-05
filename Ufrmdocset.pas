unit Ufrmdocset;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls,  ExtCtrls, 
  Grids, DBGrids,  DBCtrls, DB, ADODB,
  ActnList, DosMove, Buttons, ULYDataToExcel, MemDS, DBAccess, MyAccess,Inifiles;

type
  Tfrmdocset = class(TForm)
    DataSourcedoclist: TDataSource;
    DosMove1: TDosMove;
    DBGrid1: TDBGrid;
    Panel2: TPanel;
    Label1: TLabel;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    Panel1: TPanel;
    suiButton1: TSpeedButton;
    suiButton2: TSpeedButton;
    suiButton3: TSpeedButton;
    BitBtn1: TBitBtn;
    ADOdoclist: TMyQuery;
    ComboBox1: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    ComboBox2: TComboBox;
    procedure suiButton1Click(Sender: TObject);
    procedure suiButton2Click(Sender: TObject);
    procedure suiButton3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ADOdoclistAfterScroll(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ADOdoclistAfterOpen(DataSet: TDataSet);
    procedure FormDestroy(Sender: TObject);

  private
    procedure UpdateADOdoclist;//������Ա�б�
    procedure docrefresh;
    { Private declarations }
  public
    { Public declarations }
  end;

function frmdocset: Tfrmdocset;
//var

implementation
uses  UDM;

var
  ifdocnewadd:boolean;
  ffrmdocset: Tfrmdocset;


{$R *.dfm}

function frmdocset: Tfrmdocset;
begin
  if ffrmdocset=nil then ffrmdocset:=Tfrmdocset.Create(application.mainform);
  result:=ffrmdocset;
end;

procedure Tfrmdocset.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action:=cafree;
  if ffrmdocset=self then ffrmdocset:=nil;
end;

procedure Tfrmdocset.FormCreate(Sender: TObject);
begin
  ADOdoclist.Connection:=DM.MyConnection1;
end;

procedure Tfrmdocset.FormShow(Sender: TObject);
var
  ConfigIni:tinifile;
  selDepartment:integer;
begin
  ifdocnewadd:=false;

  LoadGroupName(ComboBox1,'select concat(''['',unid,'']'',name) from commcode where typename=''����'' ');//���ز���

  ConfigIni:=tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  selDepartment:=configini.ReadInteger('Interface','selDepartment',0);{��¼ѡ��Ĳ���}
  configini.Free;
  ComboBox1.ItemIndex:=selDepartment;

  LoadGroupName(ComboBox2,'select name from commcode where typename=''ҽ��ְ��'' ');

  UpdateADOdoclist;
  docrefresh;
end;

procedure Tfrmdocset.suiButton1Click(Sender: TObject);
begin
      LabeledEdit1.Clear;
      LabeledEdit2.Clear;
      ComboBox2.Text:='';
      LabeledEdit1.SetFocus;
      ifdocnewadd:=true;
end;

procedure Tfrmdocset.suiButton2Click(Sender: TObject);
Var
   adotemp11,adotemp12: TMyQuery;
   sDep_Unid:string;
   Insert_Identity,iDep_Unid:integer;
Begin
   if ifdocnewadd then
   begin
        ifdocnewadd:=false;

        if (trim(ComboBox1.Text)='') then
        begin
          MESSAGEDLG('��ѡ����!',mtError,[mbOK],0);
          exit;
        end;
        
        sDep_Unid:=copy(ComboBox1.Text,2,pos(']',ComboBox1.Text)-2);
        if not trystrtoint(sDep_Unid,iDep_Unid) then
        begin
          MESSAGEDLG('���Ž�������!',mtError,[mbOK],0);
          exit;
        end;

        if strtoint(ScalarSQLCmd(g_Server,g_Port,g_Database,g_Username,g_Password,'select count(*) from commcode where typename=''����'' and unid='+sDep_Unid))<=0 then
        begin
          MESSAGEDLG('���Ų�����!',mtError,[mbOK],0);
          exit;
        end;

        if (trim(LabeledEdit1.Text)='') then
        begin
          MESSAGEDLG('���ű���!',mtError,[mbOK],0);
          exit;
        end;

        adotemp12:=TMyQuery.Create(nil);
        adotemp12.Connection:=DM.MyConnection1;
        adotemp12.Close;
        adotemp12.SQL.Clear;
        adotemp12.SQL.Add(' Insert into WORKER (code,Name,doctor_title,dep_unid) values (:P_code,:P_Name,:P_doctor_title,:P_pkdeptid) ');
        //ִ�ж���MySQL��䣬Ҫ�÷ֺŷָ�
        adotemp12.SQL.Add('; SELECT LAST_INSERT_ID() AS Insert_Identity ');
        adotemp12.ParamByName('P_code').Value:=trim(LabeledEdit1.Text) ;
        adotemp12.ParamByName('P_Name').Value:=trim(LabeledEdit2.Text) ;
        adotemp12.ParamByName('P_doctor_title').Value:=trim(ComboBox2.Text) ;
        adotemp12.ParamByName('P_pkdeptid').Value:=iDep_Unid ;
        adotemp12.ExecSQL;
        Insert_Identity:=adotemp12.fieldbyname('Insert_Identity').AsInteger;
        adotemp12.Free;
        ADOdoclist.Refresh;
   end else
   begin
        IF (not ADOdoclist.Active) or (ADOdoclist.RecordCount<=0) THEN
        BEGIN
          MESSAGEDLG('����Ҫ�޸ĵļ�¼!',mtError,[mbOK],0);
          EXIT;
        END;

        Insert_Identity:=ADOdoclist.fieldbyname('Unid').AsInteger;

        adotemp11:=TMyQuery.Create(nil);
        adotemp11.Connection:=DM.MyConnection1;
        adotemp11.Close;
        adotemp11.SQL.Clear;
        adotemp11.SQL.Text:='update worker set code=:code,name=:name,doctor_title=:doctor_title where unid=:unid';
        adotemp11.ParamByName('code').Value:=trim(LabeledEdit1.Text);
        adotemp11.ParamByName('name').Value:=trim(LabeledEdit2.Text);
        adotemp11.ParamByName('doctor_title').Value:=trim(ComboBox2.Text) ;
        adotemp11.ParamByName('unid').Value:=Insert_Identity;
        adotemp11.ExecSQL;
        adotemp11.Free;
        ADOdoclist.Refresh;
   end;
   
   ADOdoclist.Locate('Unid',Insert_Identity,[loCaseInsensitive]) ;
end;

procedure Tfrmdocset.docrefresh;
begin
        ifdocnewadd:=false;
        if (ADOdoclist.Active) and (ADOdoclist.RecordCount>0) then
        begin
            LabeledEdit1.Text:=trim(ADOdoclist.FieldByName('����').AsString);
            LabeledEdit2.Text:=trim(ADOdoclist.FieldByName('����').AsString);
            ComboBox2.Text:=trim(ADOdoclist.FieldByName('ְ��').AsString);
        end else
        begin
            LabeledEdit1.Clear;
            LabeledEdit2.Clear;
            ComboBox2.Text:='';
        end;
end;

procedure Tfrmdocset.suiButton3Click(Sender: TObject);
begin
    if not ADOdoclist.Active then exit;
    if ADOdoclist.RecordCount=0 then exit;
    
    if (MessageDlg('ȷʵҪɾ���ü�¼��',mtWarning,[mbYes,mbNo],0)<>mrYes) then exit;

    ADOdoclist.Delete;
    ADOdoclist.Refresh;
end;

procedure Tfrmdocset.ADOdoclistAfterOpen(DataSet: TDataSet);
begin
  if not DataSet.Active then exit;
  dbgrid1.Columns[0].Width:=80;
  dbgrid1.Columns[1].Width:=100;
  dbgrid1.Columns[2].Width:=60;
  dbgrid1.Columns[3].Width:=80;
  dbgrid1.Columns[4].Width:=80;
end;

procedure Tfrmdocset.ADOdoclistAfterScroll(DataSet: TDataSet);
begin
  docrefresh;
end;

procedure Tfrmdocset.BitBtn1Click(Sender: TObject);
var
  LYDataToExcel1:TLYDataToExcel;
begin
  LYDataToExcel1:=TLYDataToExcel.create(nil);
  LYDataToExcel1.DataSet:=ADOdoclist;
  LYDataToExcel1.ExcelTitel:='������Ա';
  LYDataToExcel1.Execute;
  LYDataToExcel1.Free;
end;

procedure Tfrmdocset.UpdateADOdoclist;
var
  s1,s2:string;
  i,j:integer;
begin
  s1:=ComboBox1.Text;

  if trim(s1)='' then
  begin
    ADOdoclist.Close;
    ADOdoclist.SQL.Clear;
    ADOdoclist.SQL.Text:='select w.code as ����,w.name as ����,w.dep_unid as ����UNID,cc.name as ����,w.doctor_title as ְ��,w.unid from worker w LEFT join commcode cc on cc.TypeName=''����'' and cc.unid=w.dep_unid ';
    ADOdoclist.Open;
    exit;
  end;

  i:=pos(']',s1);
  s2:=copy(s1,2,i-2);

  if not trystrtoint(s2,j) then
  begin
    MESSAGEDLG('���Ž�������!',mtError,[mbOK],0);
    exit;
  end;

  ADOdoclist.Close;
  ADOdoclist.SQL.Clear;
  ADOdoclist.SQL.Text:='select w.code as ����,w.name as ����,w.dep_unid as ����UNID,cc.name as ����,w.doctor_title as ְ��,w.unid from worker w LEFT join commcode cc on cc.TypeName=''����'' and cc.unid=w.dep_unid where w.dep_unid='+s2;
  ADOdoclist.Open;
end;

procedure Tfrmdocset.ComboBox1Change(Sender: TObject);
begin
    UpdateADOdoclist;
    docrefresh;
end;

procedure Tfrmdocset.FormDestroy(Sender: TObject);
var
  ConfigIni:tinifile;
begin
  ConfigIni:=tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));

  configini.WriteInteger('Interface','selDepartment',ComboBox1.ItemIndex);{��¼ѡ��Ĳ���}

  configini.Free;
end;

initialization
  ffrmdocset:=nil;

end.
