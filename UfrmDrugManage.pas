unit UfrmDrugManage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, DBGrids, StdCtrls, Buttons, DB, ADODB, DosMove,StrUtils,
  ULYDataToExcel, ComCtrls, MemDS, DBAccess, MyAccess, UfrmLocateRecord,
  ADOLYGetcode;

type
  TfrmDrugManage = class(TForm)
    DataSource1: TDataSource;
    Panel1: TPanel;
    DosMove1: TDosMove;
    LabeledEdit2: TLabeledEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    BitBtn4: TBitBtn;
    LabeledEdit4: TLabeledEdit;
    LabeledEdit5: TLabeledEdit;
    ADOQuery1: TMyQuery;
    LabeledEdit14: TLabeledEdit;
    LabeledEdit15: TLabeledEdit;
    LabeledEdit16: TLabeledEdit;
    LabeledEdit23: TLabeledEdit;
    ComboBox4: TComboBox;
    Label4: TLabel;
    ComboBox5: TComboBox;
    Label5: TLabel;
    DataSource2: TDataSource;
    MyQuery2: TMyQuery;
    LabeledEdit22: TLabeledEdit;
    LabeledEdit24: TLabeledEdit;
    LabeledEdit25: TLabeledEdit;
    Label8: TLabel;
    ComboBox6: TComboBox;
    LabeledEdit10: TLabeledEdit;
    Label9: TLabel;
    Label10: TLabel;
    LabeledEdit6: TLabeledEdit;
    Panel4: TPanel;
    DBGrid1: TDBGrid;
    Panel2: TPanel;
    Panel3: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LabeledEdit21: TLabeledEdit;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    CheckBox1: TCheckBox;
    LabeledEdit26: TLabeledEdit;
    CheckBox2: TCheckBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    CheckBox3: TCheckBox;
    DBGrid2: TDBGrid;
    Panel5: TPanel;
    LabeledEdit7: TLabeledEdit;
    BitBtn10: TBitBtn;
    Label1: TLabel;
    ComboBox1: TComboBox;
    SpeedButton1: TSpeedButton;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure ADOQuery1AfterScroll(DataSet: TDataSet);
    procedure BitBtn3Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ADOQuery1AfterOpen(DataSet: TDataSet);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure MyQuery2AfterScroll(DataSet: TDataSet);
    procedure MyQuery2AfterOpen(DataSet: TDataSet);
    procedure ComboBox4KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ComboBox6KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BitBtn10Click(Sender: TObject);
  private
    { Private declarations }
    procedure ClearEdit;
    procedure updateEdit;
    procedure updateAdoQuery1(const AType:integer;const Agene_name:string);
    procedure updatePackEdit;
    procedure ClearPackEdit;
    procedure updateAdoQuery2;
  public
    { Public declarations }
  end;

//var
function  frmDrugManage: TfrmDrugManage;

implementation

uses    UDM, UfrmMain;
var
  ffrmDrugManage: TfrmDrugManage;
  ifNewAdd,ifPackNewAdd:boolean;
  
{$R *.dfm}
function  frmDrugManage: TfrmDrugManage;
begin
  if ffrmDrugManage=nil then ffrmDrugManage:=TfrmDrugManage.Create(application.mainform);
  result:=ffrmDrugManage;
end;

procedure TfrmDrugManage.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action:=cafree;
  if ffrmDrugManage=self then ffrmDrugManage:=nil;
end;

procedure TfrmDrugManage.FormCreate(Sender: TObject);
begin
  adoquery1.Connection:=DM.MyConnection1;
  MyQuery2.Connection:=DM.MyConnection1;

  SetWindowLong(LabeledEdit21.Handle, GWL_STYLE, GetWindowLong(LabeledEdit21.Handle, GWL_STYLE) or ES_NUMBER);//ֻ����������
end;

procedure TfrmDrugManage.FormShow(Sender: TObject);
begin
  ifNewAdd:=false;
  ifPackNewAdd:=false;

  LoadGroupName(ComboBox1,'select Type_Name from drug_manage group by Type_Name');//����ComboBox1
  if ComboBox1.Items.Count>=1 then ComboBox1.ItemIndex:=0;

  LoadGroupName(ComboBox2,'select name from commcode where typename=''���õ�λ'' ');
  LoadGroupName(ComboBox3,'select name from commcode where typename=''���õ�λ'' ');
  LoadGroupName(ComboBox4,'select name from commcode where typename=''�÷�'' ');
  LoadGroupName(ComboBox5,'select name from commcode where typename=''��ҩƵ��'' ');
  LoadGroupName(ComboBox6,'select name from commcode where typename=''�巨'' ');

  updateAdoQuery1(0,'');
end;

procedure TfrmDrugManage.ClearEdit;
begin
  LabeledEdit1.Clear;
  LabeledEdit2.Clear;
  LabeledEdit14.Clear;
  LabeledEdit22.Clear;
  LabeledEdit15.Clear;
  LabeledEdit24.Clear;
  LabeledEdit25.Clear;
  LabeledEdit16.Clear;
  ComboBox4.Text:='';
  ComboBox6.Text:='';
  ComboBox5.Text:='';
  LabeledEdit23.Clear;
  LabeledEdit3.Clear;
  LabeledEdit4.Clear;
  LabeledEdit5.Clear;
  LabeledEdit10.Clear;
  Label9.Caption:='';
  Label10.Caption:='';
  LabeledEdit6.Clear;
end;

procedure TfrmDrugManage.updateEdit;
begin
  if adoquery1.RecordCount<>0 then
  begin
    LabeledEdit1.Text:=trim(adoquery1.fieldbyname('����').AsString);
    LabeledEdit2.Text:=trim(adoquery1.fieldbyname('ͨ����').AsString);
    LabeledEdit14.Text:=trim(adoquery1.fieldbyname('��ѧ��').AsString);
    LabeledEdit22.Text:=trim(adoquery1.fieldbyname('�ͺ�').AsString);
    LabeledEdit15.Text:=trim(adoquery1.fieldbyname('���').AsString);
    LabeledEdit24.Text:=trim(adoquery1.fieldbyname('��������').AsString);
    LabeledEdit25.Text:=trim(adoquery1.fieldbyname('��׼�ĺ�').AsString);
    LabeledEdit16.Text:=trim(adoquery1.fieldbyname('Ĭ������').AsString);
    ComboBox4.Text:=trim(adoquery1.fieldbyname('Ĭ���÷�').AsString);
    ComboBox6.Text:=trim(adoquery1.fieldbyname('Ĭ�ϼ巨').AsString);
    ComboBox5.Text:=trim(adoquery1.fieldbyname('Ĭ��Ƶ��').AsString);
    LabeledEdit23.Text:=trim(adoquery1.fieldbyname('Ĭ������').AsString);
    LabeledEdit3.Text:=trim(adoquery1.fieldbyname('��ע').AsString);
    LabeledEdit4.Text:=trim(adoquery1.fieldbyname('������').AsString);
    LabeledEdit5.Text:=trim(adoquery1.fieldbyname('Ӣ����').AsString);
    LabeledEdit10.Text:=adoquery1.fieldbyname('��С����').AsString;
    Label9.Caption:=adoquery1.fieldbyname('��С������λ').AsString;
    Label10.Caption:=adoquery1.fieldbyname('Ĭ��������λ').AsString;
    LabeledEdit6.Text:=adoquery1.fieldbyname('Ĭ���շѵ�λ').AsString;
  end else
  begin
    ClearEdit;
  end;
end;

procedure TfrmDrugManage.BitBtn1Click(Sender: TObject);
begin
  ClearEdit;
  LabeledEdit1.SetFocus;
  ifNewAdd:=true;
end;

procedure TfrmDrugManage.BitBtn2Click(Sender: TObject);
var
  adotemp11:TMyQuery;
  sqlstr:string;
  Insert_Identity:integer;
  i_drug_days_dft:integer;
  f_min_content,f_dosage_dft:single;
begin
  adotemp11:=TMyQuery.Create(nil);
  adotemp11.Connection:=DM.MyConnection1;
  if ifNewAdd then //����
  begin
    ifNewAdd:=false;

    if ComboBox1.ItemIndex=-1 then
    BEGIN
      adotemp11.Free;
      SHOWMESSAGE('��ѡ��������');
      EXIT;
    END;

    sqlstr:='Insert into drug_manage ('+
                        ' Type_Name,code,gene_name,chem_name,latin_name,english_name,model,specs,sccj,approval_no,min_content,dosage_dft,use_method_dft,made_method_dft,drug_freq_dft,drug_days_dft,Remark) values ('+
                        ':TypeName,:code,:gene_name,:chem_name,:latin_name,:english_name,:model,:specs,:sccj,:approval_no,:min_content,:dosage_dft,:use_method_dft,:made_method_dft,:drug_freq_dft,:drug_days_dft,:Remark)';
    adotemp11.Close;
    adotemp11.SQL.Clear;
    adotemp11.SQL.Add(sqlstr);
    //ִ�ж���MySQL��䣬Ҫ�÷ֺŷָ�
    adotemp11.SQL.Add('; SELECT LAST_INSERT_ID() AS Insert_Identity ');
    adotemp11.ParamByName('TypeName').Value:=trim(ComboBox1.Text);
    adotemp11.ParamByName('code').Value:=trim(LabeledEdit1.Text);
    adotemp11.ParamByName('gene_name').Value:=trim(LabeledEdit2.Text);
    adotemp11.ParamByName('chem_name').Value:=trim(LabeledEdit14.Text);
    adotemp11.ParamByName('model').Value:=trim(LabeledEdit22.Text);
    adotemp11.ParamByName('specs').Value:=trim(LabeledEdit15.Text);
    adotemp11.ParamByName('sccj').Value:=trim(LabeledEdit24.Text);
    adotemp11.ParamByName('approval_no').Value:=trim(LabeledEdit25.Text);
    if trystrtofloat(LabeledEdit16.Text,f_dosage_dft) then
      adotemp11.ParamByName('dosage_dft').Value:=f_dosage_dft
    else adotemp11.ParamByName('dosage_dft').Value:=null;
    adotemp11.ParamByName('use_method_dft').Value:=trim(ComboBox4.Text);
    adotemp11.ParamByName('made_method_dft').Value:=trim(ComboBox6.Text);
    adotemp11.ParamByName('drug_freq_dft').Value:=trim(ComboBox5.Text);
    if trystrtoint(LabeledEdit23.Text,i_drug_days_dft) then
      adotemp11.ParamByName('drug_days_dft').Value:=i_drug_days_dft
    else adotemp11.ParamByName('drug_days_dft').Value:=null;
    adotemp11.ParamByName('Remark').Value:=trim(LabeledEdit3.Text);
    adotemp11.ParamByName('latin_name').Value:=trim(LabeledEdit4.Text);
    adotemp11.ParamByName('english_name').Value:=trim(LabeledEdit5.Text);
    if trystrtofloat(LabeledEdit10.Text,f_min_content) then
      adotemp11.ParamByName('min_content').Value:=f_min_content
    else adotemp11.ParamByName('min_content').Value:=null;
    adotemp11.ExecSQL;
    Insert_Identity:=adotemp11.fieldbyname('Insert_Identity').AsInteger;
    ADOQuery1.Refresh;
  end else //�޸�
  begin
    IF AdoQuery1.RecordCount=0 THEN
    BEGIN
      adotemp11.Free;
      SHOWMESSAGE('û�м�¼�����޸ģ���Ҫ���������ȵ��"������ť"��');
      EXIT;
    END;

    Insert_Identity:=ADOQuery1.fieldbyname('Unid').AsInteger;
    adotemp11.Close;
    adotemp11.SQL.Clear;
    adotemp11.SQL.Text:=' Update drug_manage  '+
    '  set code=:code,gene_name=:gene_name,chem_name=:chem_name,latin_name=:latin_name,english_name=:english_name,model=:model,specs=:specs,sccj=:sccj,approval_no=:approval_no,min_content=:min_content,dosage_dft=:dosage_dft,'+
    ' use_method_dft=:use_method_dft,made_method_dft=:made_method_dft,drug_freq_dft=:drug_freq_dft,drug_days_dft=:drug_days_dft,Remark=:Remark '+
    '  Where    Unid=:Unid      ';
    adotemp11.ParamByName('code').Value:=trim(LabeledEdit1.Text);
    adotemp11.ParamByName('gene_name').Value:=trim(LabeledEdit2.Text);
    adotemp11.ParamByName('chem_name').Value:=trim(LabeledEdit14.Text);
    adotemp11.ParamByName('model').Value:=trim(LabeledEdit22.Text);
    adotemp11.ParamByName('specs').Value:=trim(LabeledEdit15.Text);
    adotemp11.ParamByName('sccj').Value:=trim(LabeledEdit24.Text);
    adotemp11.ParamByName('approval_no').Value:=trim(LabeledEdit25.Text);
    if trystrtofloat(LabeledEdit16.Text,f_dosage_dft) then
      adotemp11.ParamByName('dosage_dft').Value:=f_dosage_dft
    else adotemp11.ParamByName('dosage_dft').Value:=null;
    adotemp11.ParamByName('use_method_dft').Value:=trim(ComboBox4.Text);
    adotemp11.ParamByName('made_method_dft').Value:=trim(ComboBox6.Text);
    adotemp11.ParamByName('drug_freq_dft').Value:=trim(ComboBox5.Text);
    if trystrtoint(LabeledEdit23.Text,i_drug_days_dft) then
      adotemp11.ParamByName('drug_days_dft').Value:=i_drug_days_dft
    else adotemp11.ParamByName('drug_days_dft').Value:=null;
    adotemp11.ParamByName('Remark').Value:=trim(LabeledEdit3.Text);
    adotemp11.ParamByName('latin_name').Value:=trim(LabeledEdit4.Text);
    adotemp11.ParamByName('english_name').Value:=trim(LabeledEdit5.Text);
    if trystrtofloat(LabeledEdit10.Text,f_min_content) then
      adotemp11.ParamByName('min_content').Value:=f_min_content
    else adotemp11.ParamByName('min_content').Value:=null;
    adotemp11.ParamByName('Unid').Value:=Insert_Identity;
    adotemp11.ExecSQL;
    AdoQuery1.Refresh;
  end;

  adotemp11.Free;
  AdoQuery1.Locate('Unid',Insert_Identity,[loCaseInsensitive]) ;
  updateEdit;
end;

procedure TfrmDrugManage.ADOQuery1AfterScroll(DataSet: TDataSet);
begin
  updateAdoQuery2;
  
  ifNewAdd:=false;
  updateEdit;
end;

procedure TfrmDrugManage.BitBtn3Click(Sender: TObject);
begin
  if not DBGrid1.DataSource.DataSet.Active then exit;
  if DBGrid1.DataSource.DataSet.RecordCount=0 then exit;

  if (MessageDlg('ȷʵҪɾ���ü�¼��',mtWarning,[mbYes,mbNo],0)<>mrYes) then exit;

    DBGrid1.DataSource.DataSet.Delete;

    adoquery1.Refresh;
    updateEdit;
end;

procedure TfrmDrugManage.updateAdoQuery1(const AType:integer;const Agene_name:string);
var
  ss:string;
begin
  if(AType=1)and(trim(Agene_name)<>'') then ss:=' and (gene_name like ''%'+Agene_name+'%'' or gene_pinyin like ''%'+Agene_name+'%'' or gene_wbm like ''%'+Agene_name+'%'') ';
  adoquery1.Close;
  adoquery1.SQL.Clear;
  adoquery1.SQL.Text:='select code as ����,'+
  'gene_name as ͨ����,'+
  'chem_name as ��ѧ��,'+
  'latin_name as ������,english_name as Ӣ����,'+
  'model as �ͺ�,'+
  'specs as ���,'+
  'sccj as ��������,'+
  'approval_no as ��׼�ĺ�,'+
  'min_content as ��С����,'+
  '(select dp.pack_name from drug_pack dp where dp.drug_unid=dm.unid and dp.unit_min_content=1 LIMIT 1) as ��С������λ,'+
  'dosage_dft as Ĭ������,'+
  '(select dp.pack_name from drug_pack dp where dp.drug_unid=dm.unid and dp.unit_dosage_dft=1 LIMIT 1) as Ĭ��������λ,'+
  '(select dp.pack_name from drug_pack dp where dp.drug_unid=dm.unid and dp.unit_fee_dft=1 LIMIT 1) as Ĭ���շѵ�λ,'+
  'use_method_dft as Ĭ���÷�,'+
  'made_method_dft as Ĭ�ϼ巨,'+
  'drug_freq_dft as Ĭ��Ƶ��,'+
  'drug_days_dft as Ĭ������,'+
  'Remark as ��ע,'+
  'creat_date_time as ����ʱ��,'+
  'Unid '+
  ' from drug_manage dm WHERE Type_Name='''+ComboBox1.Text+''' '+
  ss+
  ' order by code ';
  adoquery1.Open;
end;

procedure TfrmDrugManage.ComboBox1Change(Sender: TObject);
begin
  updateAdoQuery1(0,'');
end;

procedure TfrmDrugManage.ADOQuery1AfterOpen(DataSet: TDataSet);
begin
  if not DataSet.Active then exit;
  dbgrid1.Columns.Items[0].Width:=60;//����
  dbgrid1.Columns.Items[1].Width:=100;//ͨ����
  dbgrid1.Columns.Items[2].Width:=100;//��ѧ��
  dbgrid1.Columns.Items[3].Width:=50;//������
  dbgrid1.Columns.Items[4].Width:=50;//Ӣ����
  dbgrid1.Columns.Items[5].Width:=60;//�ͺ�
  dbgrid1.Columns.Items[6].Width:=80;//���
  dbgrid1.Columns.Items[7].Width:=80;//��������
  dbgrid1.Columns.Items[8].Width:=80;//��׼�ĺ�
  dbgrid1.Columns.Items[9].Width:=55;//��С����
  dbgrid1.Columns.Items[10].Width:=80;//��С������λ
  dbgrid1.Columns.Items[11].Width:=55;//Ĭ������
  dbgrid1.Columns.Items[12].Width:=80;//Ĭ��������λ
  dbgrid1.Columns.Items[13].Width:=80;//Ĭ���շѵ�λ
  dbgrid1.Columns.Items[14].Width:=55;//Ĭ���÷�
  dbgrid1.Columns.Items[15].Width:=55;//Ĭ�ϼ巨
  dbgrid1.Columns.Items[16].Width:=55;//Ĭ��Ƶ��
  dbgrid1.Columns.Items[17].Width:=55;//Ĭ������
  dbgrid1.Columns.Items[18].Width:=100;//��ע
end;

procedure TfrmDrugManage.BitBtn4Click(Sender: TObject);
var
  LYDataToExcel11:TLYDataToExcel;
begin
  LYDataToExcel11:=TLYDataToExcel.create(nil);
  LYDataToExcel11.DataSet:=adoquery1;
  LYDataToExcel11.ExcelTitel:=ComboBox1.text;
  LYDataToExcel11.Execute;
  LYDataToExcel11.Free;
end;

procedure TfrmDrugManage.BitBtn5Click(Sender: TObject);
var
  sTypeName:string;
  iNum:integer;
begin
  if not InputQuery('��ʾ','������Ҫ���ӵ�����',sTypeName) then exit;
  sTypeName:=trim(sTypeName);
  if sTypeName='' then
  begin
    MESSAGEDLG('���Ͳ���Ϊ��!',MTINFORMATION,[MBOK],0);
    exit;
  end;
  iNum:=strtoint(ScalarSQLCmd(g_Server,g_Port,g_Database,g_Username,g_Password,'select count(*) as iNum from drug_manage where Type_Name='''+sTypeName+''' '));
  if iNum<=0 then
  begin
    ExecSQLCmd(g_Server,g_Port,g_Database,g_Username,g_Password,'Insert into drug_manage (code,gene_name,Type_Name) values (''��ʼID'',''��ʼName'','''+sTypeName+''') ');

    LoadGroupName(ComboBox1,'select Type_Name from drug_manage group by Type_Name');//����ComboBox1
  end;

  ComboBox1.ItemIndex:=ComboBox1.Items.IndexOf(sTypeName);

  updateAdoQuery1(0,'');
end;

procedure TfrmDrugManage.BitBtn7Click(Sender: TObject);
var
  adotemp11:TMyQuery;
  sqlstr:string;
  Insert_Identity:integer;
  iParentSL,iParentSL2:integer;
  f_unit_price:single;
begin
  if trim(ComboBox2.Text)='' then
  begin
    MESSAGEDLG('��װ��λ����Ϊ��!',mtError,[MBOK],0);
    ComboBox2.SetFocus;
    exit;
  end;

  if (trim(LabeledEdit21.Text)<>'')and(not trystrtoint(LabeledEdit21.Text,iParentSL2)) then
  begin
    MESSAGEDLG('�Ƿ�����!',mtError,[MBOK],0);
    LabeledEdit21.SetFocus;
    exit;
  end;

  if (trim(LabeledEdit21.Text)<>'')and(iParentSL2<=0) then
  begin
    MESSAGEDLG('���ʱ����Ǵ���0������!',mtError,[MBOK],0);
    LabeledEdit21.SetFocus;
    exit;
  end;

  if ((trim(LabeledEdit21.Text)<>'')and(trim(ComboBox3.Text)=''))
  or ((trim(LabeledEdit21.Text)='')and(trim(ComboBox3.Text)<>'')) then
  begin
    MESSAGEDLG('�����ʡ��롾�¼���װ��λ������ͬʱΪ�ջ�ͬʱ��д!',mtError,[MBOK],0);
    LabeledEdit21.SetFocus;
    exit;
  end;

  if not ADOQuery1.Active then exit;
  if ADOQuery1.RecordCount=0 then exit;
  
  adotemp11:=TMyQuery.Create(nil);
  adotemp11.Connection:=DM.MyConnection1;

  if ifPackNewAdd then //����
  begin
    ifPackNewAdd:=false;

    sqlstr:='Insert into drug_pack ('+
                        '  drug_unid, Pack_Name, unit_fee_dft, unit_price, unit_dosage_dft, unit_min_content, Parent_num, Son_Pack_Name) values ('+
                        ' :drug_unid,:Pack_Name,:unit_fee_dft,:unit_price,:unit_dosage_dft,:unit_min_content,:Parent_num,:Son_Pack_Name) ';
    adotemp11.Close;
    adotemp11.SQL.Clear;
    adotemp11.SQL.Add(sqlstr);
    //ִ�ж���MySQL��䣬Ҫ�÷ֺŷָ�
    adotemp11.SQL.Add('; SELECT LAST_INSERT_ID() AS Insert_Identity ');
    adotemp11.ParamByName('drug_unid').Value:=ADOQuery1.fieldbyname('Unid').AsInteger;
    adotemp11.ParamByName('Pack_Name').Value:=trim(ComboBox2.Text);
    adotemp11.ParamByName('Son_Pack_Name').Value:=trim(ComboBox3.Text);
    if trystrtoint(LabeledEdit21.Text,iParentSL) then
      adotemp11.ParamByName('Parent_num').Value:=iParentSL
    else adotemp11.ParamByName('Parent_num').Value:=null;
    adotemp11.ParamByName('unit_fee_dft').Value:=CheckBox1.Checked;
    adotemp11.ParamByName('unit_dosage_dft').Value:=CheckBox2.Checked;
    adotemp11.ParamByName('unit_min_content').Value:=CheckBox3.Checked;
    if trystrtofloat(LabeledEdit26.Text,f_unit_price) then
      adotemp11.ParamByName('unit_price').Value:=f_unit_price
    else adotemp11.ParamByName('unit_price').Value:=null;
    adotemp11.Open;
    MyQuery2.Refresh;
    Insert_Identity:=adotemp11.fieldbyname('Insert_Identity').AsInteger;
  end else //�޸�
  begin
    IF MyQuery2.RecordCount=0 THEN
    BEGIN
      adotemp11.Free;
      SHOWMESSAGE('û�м�¼�����޸ģ���Ҫ���������ȵ��"������ť"��');
      EXIT;
    END;

    Insert_Identity:=MyQuery2.fieldbyname('Unid').AsInteger;
    adotemp11.Close;
    adotemp11.SQL.Clear;
    adotemp11.SQL.Text:=' Update drug_pack  '+
    '  set Pack_Name=:Pack_Name, unit_fee_dft=:unit_fee_dft, unit_price=:unit_price, unit_dosage_dft=:unit_dosage_dft,unit_min_content=:unit_min_content, Parent_num=:Parent_num, Son_Pack_Name=:Son_Pack_Name '+
    '  Where    Unid=:Unid      ';
    adotemp11.ParamByName('Pack_Name').Value:=trim(ComboBox2.Text);
    adotemp11.ParamByName('Son_Pack_Name').Value:=trim(ComboBox3.Text);
    if trystrtoint(LabeledEdit21.Text,iParentSL) then
      adotemp11.ParamByName('Parent_num').Value:=iParentSL
    else adotemp11.ParamByName('Parent_num').Value:=null;
    adotemp11.ParamByName('unit_fee_dft').Value:=CheckBox1.Checked;
    adotemp11.ParamByName('unit_dosage_dft').Value:=CheckBox2.Checked;
    adotemp11.ParamByName('unit_min_content').Value:=CheckBox3.Checked;
    if trystrtofloat(LabeledEdit26.Text,f_unit_price) then
      adotemp11.ParamByName('unit_price').Value:=f_unit_price
    else adotemp11.ParamByName('unit_price').Value:=null;
    adotemp11.ParamByName('Unid').Value:=Insert_Identity;
    adotemp11.ExecSQL;
    MyQuery2.Refresh;
  end;

  adotemp11.Free;
  MyQuery2.Locate('Unid',Insert_Identity,[loCaseInsensitive]) ;
  updatePackEdit;
end;

procedure TfrmDrugManage.BitBtn6Click(Sender: TObject);
begin
  ClearPackEdit;
  ComboBox2.SetFocus;
  ifPackNewAdd:=true;
end;

procedure TfrmDrugManage.BitBtn8Click(Sender: TObject);
begin
  if not MyQuery2.Active then exit;
  if MyQuery2.RecordCount<=0 then exit;
  
  if (MessageDlg('�Ƿ���Ҫɾ����ǰ��¼��', mtConfirmation, [mbYes, mbNo], 0) <> mrYes) then exit;

  MyQuery2.Delete;
end;

procedure TfrmDrugManage.MyQuery2AfterScroll(DataSet: TDataSet);
begin
  ifPackNewAdd:=false;
  updatePackEdit;
end;

procedure TfrmDrugManage.updatePackEdit;
begin
  if MyQuery2.RecordCount<>0 then
  begin
    ComboBox2.Text:=trim(MyQuery2.fieldbyname('��װ��λ').AsString);
    ComboBox3.Text:=trim(MyQuery2.fieldbyname('�¼���װ��λ').AsString);
    LabeledEdit21.Text:=MyQuery2.fieldbyname('����').AsString;
    LabeledEdit26.Text:=MyQuery2.fieldbyname('����').AsString;
    CheckBox1.Checked:=MyQuery2.fieldbyname('unit_fee_dft').AsBoolean;
    CheckBox2.Checked:=MyQuery2.fieldbyname('unit_dosage_dft').AsBoolean;
    CheckBox3.Checked:=MyQuery2.fieldbyname('unit_min_content').AsBoolean;
  end else
  begin
    ClearPackEdit;
  end;
end;

procedure TfrmDrugManage.ClearPackEdit;
begin
  LabeledEdit21.Clear;
  LabeledEdit26.Clear;
  ComboBox2.Text:='';
  ComboBox3.Text:='';
  CheckBox1.Checked:=false;
  CheckBox2.Checked:=false;
  CheckBox3.Checked:=false;
end;

procedure TfrmDrugManage.updateAdoQuery2;
begin
  if not adoquery1.Active then exit;

  MyQuery2.Close;
  MyQuery2.SQL.Clear;
  MyQuery2.SQL.Text:='select Pack_Name as ��װ��λ,unit_price as ����,Parent_num as ����,Son_Pack_Name as �¼���װ��λ,'+
  '(case unit_fee_dft when 1 then ''��'' else null end) as Ĭ���շѵ�λ,'+
  '(case unit_dosage_dft when 1 then ''��'' else null end) as Ĭ��������λ,'+
  '(case unit_min_content when 1 then ''��'' else null end) as ��С������λ,'+
  'Create_Date_Time as ����ʱ��,drug_unid,Unid,unit_fee_dft,unit_dosage_dft,unit_min_content from drug_pack '+
  ' where drug_unid='+adoquery1.FieldByName('Unid').AsString;
  MyQuery2.Open;
end;

procedure TfrmDrugManage.MyQuery2AfterOpen(DataSet: TDataSet);
begin
  if not DataSet.Active then exit;
  dbgrid2.Columns.Items[0].Width:=55;
  dbgrid2.Columns.Items[1].Width:=52;
  dbgrid2.Columns.Items[2].Width:=35;
  dbgrid2.Columns.Items[3].Width:=82;
  dbgrid2.Columns.Items[4].Width:=82;
  dbgrid2.Columns.Items[5].Width:=82;
  dbgrid2.Columns.Items[6].Width:=82;
  dbgrid2.Columns.Items[7].Width:=135;
end;

procedure TfrmDrugManage.ComboBox4KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  tmpADOLYGetcode:TADOLYGetcode;
begin
  if key<>13 then exit;
  tmpADOLYGetcode:=TADOLYGetcode.create(nil);
  tmpADOLYGetcode.MyConnection:=DM.MyConnection1;
  tmpADOLYGetcode.OpenStr:='select name,code from commcode where typename=''�÷�'' ';
  tmpADOLYGetcode.InField:='code,pinyin,wbm';
  tmpADOLYGetcode.InValue:=TComboBox(sender).Text;
  tmpADOLYGetcode.ShowX:=left+TComboBox(SENDER).Left+TComboBox(SENDER).Parent.Left;
  tmpADOLYGetcode.ShowY:=TComboBox(SENDER).Height+top+22{��ǰ����������߶�}+21{��ǰ����˵��߶�}+10{�����߶�}+TComboBox(SENDER).Top+TComboBox(SENDER).Parent.Top+TComboBox(SENDER).Parent.Parent.Top;

  if tmpADOLYGetcode.Execute then
  begin
    TComboBox(SENDER).Text:=tmpADOLYGetcode.OutValue[0];
  end;
  tmpADOLYGetcode.Free;
end;

procedure TfrmDrugManage.ComboBox6KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  tmpADOLYGetcode:TADOLYGetcode;
begin
  if key<>13 then exit;
  tmpADOLYGetcode:=TADOLYGetcode.create(nil);
  tmpADOLYGetcode.MyConnection:=DM.MyConnection1;
  tmpADOLYGetcode.OpenStr:='select name,code from commcode where typename=''�巨'' ';
  tmpADOLYGetcode.InField:='code,pinyin,wbm';
  tmpADOLYGetcode.InValue:=TComboBox(sender).Text;
  tmpADOLYGetcode.ShowX:=left+TComboBox(SENDER).Left+TComboBox(SENDER).Parent.Left;
  tmpADOLYGetcode.ShowY:=TComboBox(SENDER).Height+top+22{��ǰ����������߶�}+21{��ǰ����˵��߶�}+10{�����߶�}+TComboBox(SENDER).Top+TComboBox(SENDER).Parent.Top+TComboBox(SENDER).Parent.Parent.Top;

  if tmpADOLYGetcode.Execute then
  begin
    TComboBox(SENDER).Text:=tmpADOLYGetcode.OutValue[0];
  end;
  tmpADOLYGetcode.Free;
end;

procedure TfrmDrugManage.BitBtn10Click(Sender: TObject);
begin
  updateAdoQuery1(1,LabeledEdit7.Text);
end;

initialization
  ffrmDrugManage:=nil;

end.
