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

  SetWindowLong(LabeledEdit21.Handle, GWL_STYLE, GetWindowLong(LabeledEdit21.Handle, GWL_STYLE) or ES_NUMBER);//只能输入数字
end;

procedure TfrmDrugManage.FormShow(Sender: TObject);
begin
  ifNewAdd:=false;
  ifPackNewAdd:=false;

  LoadGroupName(ComboBox1,'select Type_Name from drug_manage group by Type_Name');//加载ComboBox1
  if ComboBox1.Items.Count>=1 then ComboBox1.ItemIndex:=0;

  LoadGroupName(ComboBox2,'select name from commcode where typename=''常用单位'' ');
  LoadGroupName(ComboBox3,'select name from commcode where typename=''常用单位'' ');
  LoadGroupName(ComboBox4,'select name from commcode where typename=''用法'' ');
  LoadGroupName(ComboBox5,'select name from commcode where typename=''给药频次'' ');
  LoadGroupName(ComboBox6,'select name from commcode where typename=''煎法'' ');

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
    LabeledEdit1.Text:=trim(adoquery1.fieldbyname('代码').AsString);
    LabeledEdit2.Text:=trim(adoquery1.fieldbyname('通用名').AsString);
    LabeledEdit14.Text:=trim(adoquery1.fieldbyname('化学名').AsString);
    LabeledEdit22.Text:=trim(adoquery1.fieldbyname('型号').AsString);
    LabeledEdit15.Text:=trim(adoquery1.fieldbyname('规格').AsString);
    LabeledEdit24.Text:=trim(adoquery1.fieldbyname('生产厂家').AsString);
    LabeledEdit25.Text:=trim(adoquery1.fieldbyname('批准文号').AsString);
    LabeledEdit16.Text:=trim(adoquery1.fieldbyname('默认用量').AsString);
    ComboBox4.Text:=trim(adoquery1.fieldbyname('默认用法').AsString);
    ComboBox6.Text:=trim(adoquery1.fieldbyname('默认煎法').AsString);
    ComboBox5.Text:=trim(adoquery1.fieldbyname('默认频次').AsString);
    LabeledEdit23.Text:=trim(adoquery1.fieldbyname('默认天数').AsString);
    LabeledEdit3.Text:=trim(adoquery1.fieldbyname('备注').AsString);
    LabeledEdit4.Text:=trim(adoquery1.fieldbyname('拉丁名').AsString);
    LabeledEdit5.Text:=trim(adoquery1.fieldbyname('英文名').AsString);
    LabeledEdit10.Text:=adoquery1.fieldbyname('最小含量').AsString;
    Label9.Caption:=adoquery1.fieldbyname('最小含量单位').AsString;
    Label10.Caption:=adoquery1.fieldbyname('默认用量单位').AsString;
    LabeledEdit6.Text:=adoquery1.fieldbyname('默认收费单位').AsString;
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
  if ifNewAdd then //新增
  begin
    ifNewAdd:=false;

    if ComboBox1.ItemIndex=-1 then
    BEGIN
      adotemp11.Free;
      SHOWMESSAGE('请选择代码类别！');
      EXIT;
    END;

    sqlstr:='Insert into drug_manage ('+
                        ' Type_Name,code,gene_name,chem_name,latin_name,english_name,model,specs,sccj,approval_no,min_content,dosage_dft,use_method_dft,made_method_dft,drug_freq_dft,drug_days_dft,Remark) values ('+
                        ':TypeName,:code,:gene_name,:chem_name,:latin_name,:english_name,:model,:specs,:sccj,:approval_no,:min_content,:dosage_dft,:use_method_dft,:made_method_dft,:drug_freq_dft,:drug_days_dft,:Remark)';
    adotemp11.Close;
    adotemp11.SQL.Clear;
    adotemp11.SQL.Add(sqlstr);
    //执行多条MySQL语句，要用分号分隔
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
  end else //修改
  begin
    IF AdoQuery1.RecordCount=0 THEN
    BEGIN
      adotemp11.Free;
      SHOWMESSAGE('没有记录供你修改，若要新增，请先点击"新增按钮"！');
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

  if (MessageDlg('确实要删除该记录吗？',mtWarning,[mbYes,mbNo],0)<>mrYes) then exit;

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
  adoquery1.SQL.Text:='select code as 代码,'+
  'gene_name as 通用名,'+
  'chem_name as 化学名,'+
  'latin_name as 拉丁名,english_name as 英文名,'+
  'model as 型号,'+
  'specs as 规格,'+
  'sccj as 生产厂家,'+
  'approval_no as 批准文号,'+
  'min_content as 最小含量,'+
  '(select dp.pack_name from drug_pack dp where dp.drug_unid=dm.unid and dp.unit_min_content=1 LIMIT 1) as 最小含量单位,'+
  'dosage_dft as 默认用量,'+
  '(select dp.pack_name from drug_pack dp where dp.drug_unid=dm.unid and dp.unit_dosage_dft=1 LIMIT 1) as 默认用量单位,'+
  '(select dp.pack_name from drug_pack dp where dp.drug_unid=dm.unid and dp.unit_fee_dft=1 LIMIT 1) as 默认收费单位,'+
  'use_method_dft as 默认用法,'+
  'made_method_dft as 默认煎法,'+
  'drug_freq_dft as 默认频次,'+
  'drug_days_dft as 默认天数,'+
  'Remark as 备注,'+
  'creat_date_time as 创建时间,'+
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
  dbgrid1.Columns.Items[0].Width:=60;//代码
  dbgrid1.Columns.Items[1].Width:=100;//通用名
  dbgrid1.Columns.Items[2].Width:=100;//化学名
  dbgrid1.Columns.Items[3].Width:=50;//拉丁名
  dbgrid1.Columns.Items[4].Width:=50;//英文名
  dbgrid1.Columns.Items[5].Width:=60;//型号
  dbgrid1.Columns.Items[6].Width:=80;//规格
  dbgrid1.Columns.Items[7].Width:=80;//生产厂家
  dbgrid1.Columns.Items[8].Width:=80;//批准文号
  dbgrid1.Columns.Items[9].Width:=55;//最小含量
  dbgrid1.Columns.Items[10].Width:=80;//最小含量单位
  dbgrid1.Columns.Items[11].Width:=55;//默认用量
  dbgrid1.Columns.Items[12].Width:=80;//默认用量单位
  dbgrid1.Columns.Items[13].Width:=80;//默认收费单位
  dbgrid1.Columns.Items[14].Width:=55;//默认用法
  dbgrid1.Columns.Items[15].Width:=55;//默认煎法
  dbgrid1.Columns.Items[16].Width:=55;//默认频次
  dbgrid1.Columns.Items[17].Width:=55;//默认天数
  dbgrid1.Columns.Items[18].Width:=100;//备注
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
  if not InputQuery('提示','请输入要增加的类型',sTypeName) then exit;
  sTypeName:=trim(sTypeName);
  if sTypeName='' then
  begin
    MESSAGEDLG('类型不能为空!',MTINFORMATION,[MBOK],0);
    exit;
  end;
  iNum:=strtoint(ScalarSQLCmd(g_Server,g_Port,g_Database,g_Username,g_Password,'select count(*) as iNum from drug_manage where Type_Name='''+sTypeName+''' '));
  if iNum<=0 then
  begin
    ExecSQLCmd(g_Server,g_Port,g_Database,g_Username,g_Password,'Insert into drug_manage (code,gene_name,Type_Name) values (''初始ID'',''初始Name'','''+sTypeName+''') ');

    LoadGroupName(ComboBox1,'select Type_Name from drug_manage group by Type_Name');//加载ComboBox1
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
    MESSAGEDLG('包装单位不能为空!',mtError,[MBOK],0);
    ComboBox2.SetFocus;
    exit;
  end;

  if (trim(LabeledEdit21.Text)<>'')and(not trystrtoint(LabeledEdit21.Text,iParentSL2)) then
  begin
    MESSAGEDLG('非法比率!',mtError,[MBOK],0);
    LabeledEdit21.SetFocus;
    exit;
  end;

  if (trim(LabeledEdit21.Text)<>'')and(iParentSL2<=0) then
  begin
    MESSAGEDLG('比率必须是大于0的整理!',mtError,[MBOK],0);
    LabeledEdit21.SetFocus;
    exit;
  end;

  if ((trim(LabeledEdit21.Text)<>'')and(trim(ComboBox3.Text)=''))
  or ((trim(LabeledEdit21.Text)='')and(trim(ComboBox3.Text)<>'')) then
  begin
    MESSAGEDLG('【比率】与【下级包装单位】必须同时为空或同时填写!',mtError,[MBOK],0);
    LabeledEdit21.SetFocus;
    exit;
  end;

  if not ADOQuery1.Active then exit;
  if ADOQuery1.RecordCount=0 then exit;
  
  adotemp11:=TMyQuery.Create(nil);
  adotemp11.Connection:=DM.MyConnection1;

  if ifPackNewAdd then //新增
  begin
    ifPackNewAdd:=false;

    sqlstr:='Insert into drug_pack ('+
                        '  drug_unid, Pack_Name, unit_fee_dft, unit_price, unit_dosage_dft, unit_min_content, Parent_num, Son_Pack_Name) values ('+
                        ' :drug_unid,:Pack_Name,:unit_fee_dft,:unit_price,:unit_dosage_dft,:unit_min_content,:Parent_num,:Son_Pack_Name) ';
    adotemp11.Close;
    adotemp11.SQL.Clear;
    adotemp11.SQL.Add(sqlstr);
    //执行多条MySQL语句，要用分号分隔
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
  end else //修改
  begin
    IF MyQuery2.RecordCount=0 THEN
    BEGIN
      adotemp11.Free;
      SHOWMESSAGE('没有记录供你修改，若要新增，请先点击"新增按钮"！');
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
  
  if (MessageDlg('是否真要删除当前记录？', mtConfirmation, [mbYes, mbNo], 0) <> mrYes) then exit;

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
    ComboBox2.Text:=trim(MyQuery2.fieldbyname('包装单位').AsString);
    ComboBox3.Text:=trim(MyQuery2.fieldbyname('下级包装单位').AsString);
    LabeledEdit21.Text:=MyQuery2.fieldbyname('比率').AsString;
    LabeledEdit26.Text:=MyQuery2.fieldbyname('单价').AsString;
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
  MyQuery2.SQL.Text:='select Pack_Name as 包装单位,unit_price as 单价,Parent_num as 比率,Son_Pack_Name as 下级包装单位,'+
  '(case unit_fee_dft when 1 then ''是'' else null end) as 默认收费单位,'+
  '(case unit_dosage_dft when 1 then ''是'' else null end) as 默认用量单位,'+
  '(case unit_min_content when 1 then ''是'' else null end) as 最小含量单位,'+
  'Create_Date_Time as 创建时间,drug_unid,Unid,unit_fee_dft,unit_dosage_dft,unit_min_content from drug_pack '+
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
  tmpADOLYGetcode.OpenStr:='select name,code from commcode where typename=''用法'' ';
  tmpADOLYGetcode.InField:='code,pinyin,wbm';
  tmpADOLYGetcode.InValue:=TComboBox(sender).Text;
  tmpADOLYGetcode.ShowX:=left+TComboBox(SENDER).Left+TComboBox(SENDER).Parent.Left;
  tmpADOLYGetcode.ShowY:=TComboBox(SENDER).Height+top+22{当前窗体标题栏高度}+21{当前窗体菜单高度}+10{补偿高度}+TComboBox(SENDER).Top+TComboBox(SENDER).Parent.Top+TComboBox(SENDER).Parent.Parent.Top;

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
  tmpADOLYGetcode.OpenStr:='select name,code from commcode where typename=''煎法'' ';
  tmpADOLYGetcode.InField:='code,pinyin,wbm';
  tmpADOLYGetcode.InValue:=TComboBox(sender).Text;
  tmpADOLYGetcode.ShowX:=left+TComboBox(SENDER).Left+TComboBox(SENDER).Parent.Left;
  tmpADOLYGetcode.ShowY:=TComboBox(SENDER).Height+top+22{当前窗体标题栏高度}+21{当前窗体菜单高度}+10{补偿高度}+TComboBox(SENDER).Top+TComboBox(SENDER).Parent.Top+TComboBox(SENDER).Parent.Parent.Top;

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
