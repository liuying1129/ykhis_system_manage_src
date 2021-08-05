unit UfrmDgnsBigTemp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, Grids, DBGrids, StdCtrls, DB, ADODB, Buttons,
  ActnList, UfrmLocateRecord,inifiles, MemDS, DBAccess, MyAccess,
  ADOLYGetcode,Math, DosMove;

type
  TfrmDgnsBigTemp = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    tvWareHouse: TTreeView;
    DataSource1: TDataSource;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn6: TBitBtn;
    ActionList1: TActionList;
    ActAdd: TAction;
    ActSave: TAction;
    ActDel: TAction;
    ActEsc: TAction;
    ActSearch: TAction;
    Panel3: TPanel;
    Panel4: TPanel;
    LabeledEdit2: TLabeledEdit;
    Splitter2: TSplitter;
    ADOQuery1: TMyQuery;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    LabeledEdit5: TLabeledEdit;
    LabeledEdit6: TLabeledEdit;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    Label2: TLabel;
    ComboBox4: TComboBox;
    Label3: TLabel;
    ComboBox5: TComboBox;
    Label16: TLabel;
    DosMove1: TDosMove;
    Memo1: TMemo;
    Label4: TLabel;
    DBGrid1: TDBGrid;
    ComboBox1: TComboBox;
    Label1: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure tvWareHouseChange(Sender: TObject; Node: TTreeNode);
    procedure FormCreate(Sender: TObject);
    procedure ADOQuery1AfterOpen(DataSet: TDataSet);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure ADOQuery1AfterScroll(DataSet: TDataSet);
    procedure BitBtn4Click(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure tvWareHouseDeletion(Sender: TObject; Node: TTreeNode);
    procedure FormDestroy(Sender: TObject);
    procedure LabeledEdit2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LabeledEdit4Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateAdoquery1(const ADir_Unid:string);
    procedure UpdatetvWareHouse;
    procedure UpdateEdit;
    procedure ClearEdit;
    function CalcZhiLiaoNum(const drug_freq,drug_days:string):integer;
    function CalcXiYaoNum(const dosage, drug_freq, drug_days: string): single;
    function UnitsConverterMethod(const ADrug_Unid,AUnit_Dosage,AUnit_Fee:String):integer;
    procedure EnableOrDisableEdit(const AType_Name:string);
  public
    { Public declarations }
  end;

//var
function  frmDgnsBigTemp: TfrmDgnsBigTemp;

implementation

uses UDM, UfrmMain;
var
  ffrmDgnsBigTemp: TfrmDgnsBigTemp;
  ifNewAdd:boolean;

{$R *.dfm}
////////////////////////////////////////////////////////////////////////////////
function  frmDgnsBigTemp: TfrmDgnsBigTemp;  {��̬�������庯��}
begin
  if ffrmDgnsBigTemp=nil then ffrmDgnsBigTemp:=TfrmDgnsBigTemp.Create(application.mainform);
  result:=ffrmDgnsBigTemp;
end;

procedure TfrmDgnsBigTemp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action:=cafree;
  if ffrmDgnsBigTemp=self then ffrmDgnsBigTemp:=nil;
end;
////////////////////////////////////////////////////////////////////////////////

procedure TfrmDgnsBigTemp.UpdatetvWareHouse;
var
  adotemp11:TMyQuery;
  Node: TTreeNode;
  DescriptType:PDescriptType;
begin
  tvWareHouse.Items.Clear;
  adotemp11:=TMyQuery.Create(nil);
  adotemp11.Connection:=dm.MyConnection1;

  adotemp11.Close;
  adotemp11.SQL.Clear;
  adotemp11.SQL.Text:='select * from temp_dir where IFNULL(up_unid,-1)<0 order by sort_num ';
  adotemp11.Open;
  while not adotemp11.Eof do
  begin
    new(DescriptType);//Ϊָ������ڴ�
    DescriptType^.unid:=adotemp11.fieldbyname('unid').AsString;
    DescriptType^.UpUnid:=adotemp11.fieldbyname('up_unid').AsString;
    DescriptType^.SortNum:=adotemp11.fieldbyname('sort_num').AsString;
    Node:=tvWareHouse.Items.AddChildObject(nil,adotemp11.fieldbyname('name').AsString,DescriptType);//.Add(nil,'['+adotemp11.fieldbyname('Id').AsString+']'+adotemp11.fieldbyname('name').AsString);

    if HasSubInDbf(node) then Node.HasChildren := True;//�ж��Ƿ����ӽڵ㣬���������Ƿ���ʾǰ���'+'

    adotemp11.Next;
  end;
  adotemp11.free;
end;

procedure TfrmDgnsBigTemp.FormShow(Sender: TObject);
var
  configini:tinifile;
begin
  CONFIGINI:=TINIFILE.Create(ChangeFileExt(Application.ExeName,'.ini'));
  ComboBox1.Text:=configini.ReadString('Interface','temp_body_type','');
  Panel2.Width:=configini.ReadInteger('Interface','Panel2Width',211);
  configini.Free;

  ifNewAdd:=false;

  UpdatetvWareHouse;

  LoadGroupName(ComboBox1,'select name from commcode where typename=''ģ����������'' ');

  LoadGroupName(ComboBox2,'select name from commcode where typename=''���õ�λ'' ');
  LoadGroupName(ComboBox5,'select name from commcode where typename=''���õ�λ'' ');
  LoadGroupName(ComboBox4,'select name from commcode where typename=''��ҩƵ��'' ');
  LoadGroupName(ComboBox3,'select name from commcode where typename=''�÷�'' ');

  EnableOrDisableEdit(ComboBox1.Text);

  if tvWareHouse.Selected = nil then
  begin
    exit;
  end;

  UpdateAdoquery1(PDescriptType(tvWareHouse.Selected.data)^.unid);

  updateEdit;
end;

procedure TfrmDgnsBigTemp.tvWareHouseChange(Sender: TObject; Node: TTreeNode);
var
  adotemp11:TMyQuery;
  ChildNode:ttreenode;
  DescriptType:PDescriptType;
begin
  node.DeleteChildren;//����ڵ��µ������ӽڵ�

  adotemp11:=TMyQuery.Create(nil);
  adotemp11.Connection:=dm.MyConnection1;

  adotemp11.Close;
  adotemp11.SQL.Clear;
  adotemp11.SQL.Text:='select * from temp_dir where up_unid=:up_unid order by sort_num';
  adotemp11.ParamByName('up_unid').Value:=PDescriptType(Node.Data)^.unid;
  adotemp11.Open;
  while not adotemp11.Eof do
  begin
    new(DescriptType);//Ϊָ������ڴ�
    DescriptType^.unid:=adotemp11.fieldbyname('unid').AsString;
    DescriptType^.UpUnid:=adotemp11.fieldbyname('up_unid').AsString;
    DescriptType^.SortNum:=adotemp11.fieldbyname('sort_num').AsString;

    ChildNode:=tvWareHouse.Items.AddChildObject(node,adotemp11.fieldbyname('Name').AsString,DescriptType);

    if HasSubInDbf(ChildNode) then ChildNode.HasChildren := True;//�ж��Ƿ����ӽڵ㣬���������Ƿ���ʾǰ���'+'

    adotemp11.Next;
  end;

  UpdateAdoquery1(PDescriptType(Node.Data)^.unid);
end;

procedure TfrmDgnsBigTemp.UpdateAdoquery1(const ADir_Unid:string);
begin
  adoquery1.Close;
  adoquery1.SQL.Clear;
  adoquery1.SQL.Text:='select type_name as ����,temp_body.name as ����,group_num as ���,dosage as ����,unit_dosage as ������λ,'+
                     'use_method as �÷�,drug_freq as Ƶ��,drug_days as ������,'+
                     'drug_num as ����,unit_drug as ������λ,'+
                     'Content as ����,create_date_time as ����ʱ��,temp_body.unid,dir_unid,item_unid '+
                     ' from temp_body '+
                     //Ҫ��ģ���������͡����������ƾ���Ψһ�ԣ������SQL����Ľ�����ظ�
                     ' left JOIN commcode cc on cc.TypeName=''ģ����������'' AND cc.name=type_name '+
                     ' where dir_unid='+ADir_Unid+' order by cc.code,group_num';
  adoquery1.Open;
end;

procedure TfrmDgnsBigTemp.FormCreate(Sender: TObject);
begin
  adoquery1.Connection:=dm.MyConnection1;
  
  SetWindowLong(LabeledEdit3.Handle, GWL_STYLE, GetWindowLong(LabeledEdit3.Handle, GWL_STYLE) or ES_NUMBER);//���.ֻ����������
  SetWindowLong(LabeledEdit5.Handle, GWL_STYLE, GetWindowLong(LabeledEdit5.Handle, GWL_STYLE) or ES_NUMBER);//��/����.ֻ����������
end;

procedure TfrmDgnsBigTemp.ADOQuery1AfterOpen(DataSet: TDataSet);
begin
  dbgrid1.Columns[0].Width:=55;//����
  dbgrid1.Columns[1].Width:=135;//����
  dbgrid1.Columns[2].Width:=30;//���
  dbgrid1.Columns[3].Width:=30;//����
  dbgrid1.Columns[4].Width:=55;//������λ
  dbgrid1.Columns[5].Width:=55;//�÷�
  dbgrid1.Columns[6].Width:=65;//Ƶ��
  dbgrid1.Columns[7].Width:=55;//��/����
  dbgrid1.Columns[8].Width:=30;//����
  dbgrid1.Columns[9].Width:=55;//������λ
  dbgrid1.Columns[10].Width:=350;//����
  dbgrid1.Columns[11].Width:=135;//����ʱ��
end;

procedure TfrmDgnsBigTemp.BitBtn6Click(Sender: TObject);
begin
  close;
end;

procedure TfrmDgnsBigTemp.UpdateEdit;
begin
  if adoquery1.RecordCount<>0 then
  begin
    ComboBox1.Text:=trim(adoquery1.fieldbyname('����').AsString);
    Label16.Caption:=trim(adoquery1.fieldbyname('item_unid').AsString);
    LabeledEdit2.Text:=trim(adoquery1.fieldbyname('����').AsString);
    Memo1.Lines.Text:=(adoquery1.fieldbyname('����').AsString);
    LabeledEdit3.Text:=trim(adoquery1.fieldbyname('���').AsString);
    LabeledEdit4.Text:=trim(adoquery1.fieldbyname('����').AsString);
    ComboBox2.Text:=trim(adoquery1.fieldbyname('������λ').AsString);
    LabeledEdit5.Text:=trim(adoquery1.fieldbyname('������').AsString);
    ComboBox3.Text:=trim(adoquery1.fieldbyname('�÷�').AsString);
    ComboBox4.Text:=trim(adoquery1.fieldbyname('Ƶ��').AsString);
    LabeledEdit6.Text:=trim(adoquery1.fieldbyname('����').AsString);
    ComboBox5.Text:=trim(adoquery1.fieldbyname('������λ').AsString);
  end else
  begin
    ClearEdit;
  end;
end;

procedure TfrmDgnsBigTemp.ClearEdit;
begin
  LabeledEdit2.Clear;
  Memo1.Lines.Clear;
  LabeledEdit3.Clear;
  LabeledEdit4.Clear;
  ComboBox2.Text:='';
  LabeledEdit5.Clear;
  ComboBox3.Text:='';
  ComboBox4.Text:='';
  LabeledEdit6.Clear;
  ComboBox5.Text:='';
  Label16.Caption:='';
end;

procedure TfrmDgnsBigTemp.BitBtn1Click(Sender: TObject);
begin
  ClearEdit;
  if LabeledEdit2.CanFocus then LabeledEdit2.SetFocus;
  ifNewAdd:=true;
end;

procedure TfrmDgnsBigTemp.BitBtn3Click(Sender: TObject);
var
  adotemp11:TMyQuery;
  Insert_Identity:integer;
  sqlstr:string;
  i_group_num,i_drug_days,i_item_unid:integer;//i_ji_num
  f_dosage,f_drug_num:single;
begin
  if tvWareHouse.Selected=nil then
  begin
    MessageDlg('��ѡ��һ�����',mtError,[mbOK],0);
    exit;
  end;

  if trim(ComboBox1.Text)='' then
  begin
    MessageDlg('��ѡ��ģ���������ͣ�',mtError,[mbOK],0);
    exit;
  end;

  if not ADOQuery1.Active then exit;

  adotemp11:=TMyQuery.Create(nil);
  adotemp11.Connection:=dm.MyConnection1;
  if ifNewAdd then //����
  begin
    ifNewAdd:=false;
    sqlstr:='Insert into temp_body ('+
                        ' dir_unid,item_unid,name,Content,type_name,group_num,dosage,unit_dosage,use_method,drug_freq,drug_days,drug_num,unit_drug) values ('+
                        ' :dir_unid,:item_unid,:name,:Content,:type_name,:group_num,:dosage,:unit_dosage,:use_method,:drug_freq,:drug_days,:drug_num,:unit_drug) ';
    adotemp11.Close;
    adotemp11.SQL.Clear;
    adotemp11.SQL.Add(sqlstr);
    //ִ�ж���MySQL��䣬Ҫ�÷ֺŷָ�
    adotemp11.SQL.Add('; SELECT LAST_INSERT_ID() AS Insert_Identity ');
    //adotemp11.ParamByName('code').Value:=trim(LabeledEdit1.Text);
    adotemp11.ParamByName('name').Value:=trim(LabeledEdit2.Text);
    adotemp11.ParamByName('Content').Value:=memo1.Lines.Text;
    adotemp11.ParamByName('dir_unid').Value:=PDescriptType(tvWareHouse.Selected.Data)^.unid;
    adotemp11.ParamByName('type_name').Value:=ComboBox1.Text;
    if trystrtoint(LabeledEdit3.Text,i_group_num) then
    begin
      adotemp11.ParamByName('group_num').Value:=i_group_num;
      //g_group_num:=i_group_num;
    end else adotemp11.ParamByName('group_num').Value:=null;
    if trystrtofloat(LabeledEdit4.Text,f_dosage) then
      adotemp11.ParamByName('dosage').Value:=f_dosage
    else adotemp11.ParamByName('dosage').Value:=null;
    adotemp11.ParamByName('unit_dosage').Value:=trim(ComboBox2.Text);
    adotemp11.ParamByName('use_method').Value:=trim(ComboBox3.Text);
    adotemp11.ParamByName('drug_freq').Value:=trim(ComboBox4.Text);
    if trystrtoint(LabeledEdit5.Text,i_drug_days) then
      adotemp11.ParamByName('drug_days').Value:=i_drug_days
    else adotemp11.ParamByName('drug_days').Value:=null;
    if trystrtofloat(LabeledEdit6.Text,f_drug_num) then
      adotemp11.ParamByName('drug_num').Value:=f_drug_num
    else adotemp11.ParamByName('drug_num').Value:=null;
    adotemp11.ParamByName('unit_drug').Value:=trim(ComboBox5.Text);
    if trystrtoint(Label16.Caption,i_item_unid) then
      adotemp11.ParamByName('item_unid').Value:=i_item_unid
    else adotemp11.ParamByName('item_unid').Value:=null;
    adotemp11.Open;
    Insert_Identity:=adotemp11.fieldbyname('Insert_Identity').AsInteger;
  end else //�޸�
  begin
    IF AdoQuery1.RecordCount<=0 THEN
    BEGIN
      adotemp11.Free;
      SHOWMESSAGE('û�м�¼�����޸ģ���Ҫ���������ȵ��"������ť"��');
      EXIT;
    END;
    Insert_Identity:=adoquery1.fieldbyname('unid').AsInteger;

    adotemp11.Close;
    adotemp11.SQL.Clear;
    adotemp11.SQL.Text:=' Update temp_body  '+
    '  set item_unid=:item_unid,name=:name,Content=:Content,type_name=:type_name,'+
    ' group_num=:group_num,dosage=:dosage,unit_dosage=:unit_dosage,use_method=:use_method,'+
    ' drug_freq=:drug_freq,drug_days=:drug_days,drug_num=:drug_num,unit_drug=:unit_drug '+
    '  Where Unid=:Unid  ';
    adotemp11.ParamByName('name').Value:=trim(LabeledEdit2.Text);
    adotemp11.ParamByName('Content').Value:=memo1.Lines.Text;
    adotemp11.ParamByName('unid').Value:=Insert_Identity;
    adotemp11.ParamByName('type_name').Value:=ComboBox1.Text;
    if trystrtoint(LabeledEdit3.Text,i_group_num) then
    begin
      adotemp11.ParamByName('group_num').Value:=i_group_num;
      //g_group_num:=i_group_num;
    end else adotemp11.ParamByName('group_num').Value:=null;
    if trystrtofloat(LabeledEdit4.Text,f_dosage) then
      adotemp11.ParamByName('dosage').Value:=f_dosage
    else adotemp11.ParamByName('dosage').Value:=null;
    adotemp11.ParamByName('unit_dosage').Value:=trim(ComboBox2.Text);
    adotemp11.ParamByName('use_method').Value:=trim(ComboBox3.Text);
    adotemp11.ParamByName('drug_freq').Value:=trim(ComboBox4.Text);
    if trystrtoint(LabeledEdit5.Text,i_drug_days) then
      adotemp11.ParamByName('drug_days').Value:=i_drug_days
    else adotemp11.ParamByName('drug_days').Value:=null;
    if trystrtofloat(LabeledEdit6.Text,f_drug_num) then
      adotemp11.ParamByName('drug_num').Value:=f_drug_num
    else adotemp11.ParamByName('drug_num').Value:=null;
    adotemp11.ParamByName('unit_drug').Value:=trim(ComboBox5.Text);
    if trystrtoint(Label16.Caption,i_item_unid) then
      adotemp11.ParamByName('item_unid').Value:=i_item_unid
    else adotemp11.ParamByName('item_unid').Value:=null;
    adotemp11.ExecSQL;
  end;
  adotemp11.Free;

  AdoQuery1.Refresh;
  AdoQuery1.Locate('unid',Insert_Identity,[loCaseInsensitive]) ;
  updateEdit;
end;

procedure TfrmDgnsBigTemp.BitBtn4Click(Sender: TObject);
begin
  if not DBGrid1.DataSource.DataSet.Active then exit;
  if DBGrid1.DataSource.DataSet.RecordCount=0 then exit;
  
  DBGrid1.DataSource.DataSet.Delete;

  adoquery1.Refresh;
  updateEdit;
end;

procedure TfrmDgnsBigTemp.ADOQuery1AfterScroll(DataSet: TDataSet);
begin
{  ifNewAdd:=false;
  updateEdit;//}//��ADOQuery1����û�м�¼,���ᴥ�����¼�,�༭�򲻻����.����DataSource1DataChange�¼�����

  EnableOrDisableEdit(ComboBox1.Text);
end;

procedure TfrmDgnsBigTemp.DataSource1DataChange(Sender: TObject;
  Field: TField);
begin
  ifNewAdd:=false;
  updateEdit;
end;

procedure TfrmDgnsBigTemp.tvWareHouseDeletion(Sender: TObject;
  Node: TTreeNode);
begin
  Dispose(Node.Data);//�ͷŽڵ������ڴ�
end;

procedure TfrmDgnsBigTemp.FormDestroy(Sender: TObject);
var
  ConfigIni:tinifile;
begin
  ConfigIni:=tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));

  configini.WriteString('Interface','temp_body_type',ComboBox1.Text);
  configini.WriteInteger('Interface','Panel2Width',Panel2.Width);

  configini.Free;
end;

procedure TfrmDgnsBigTemp.LabeledEdit2KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  tmpADOLYGetcode:TADOLYGetcode;

  f1:single;
  i1:integer;
begin
  if key<>13 then exit;

  if(ComboBox1.Text='��ҩ')or(ComboBox1.Text='��ҩ')then
  begin
    tmpADOLYGetcode:=TADOLYGetcode.create(nil);
    tmpADOLYGetcode.MyConnection:=DM.MyConnection1;
    tmpADOLYGetcode.ifAbetChineseChar:=true;
    tmpADOLYGetcode.OpenStr:='select gene_name as ����,'+
    'dosage_dft as Ĭ������,'+
    '(select pack_name from drug_pack dp where dp.drug_unid=drug_manage.unid and dp.unit_dosage_dft=1 LIMIT 1) as Ĭ��������λ,'+
    '(select pack_name from drug_pack dp where dp.drug_unid=drug_manage.unid and dp.unit_fee_dft=1 LIMIT 1) as �շѵ�λ,'+
    '(select unit_price from drug_pack dp where dp.drug_unid=drug_manage.unid and dp.unit_fee_dft=1 LIMIT 1) as ����,'+
    'use_method_dft as Ĭ���÷�,'+
    'drug_freq_dft as Ĭ��Ƶ��,'+
    'made_method_dft as Ĭ�ϼ巨,unid from drug_manage where Type_Name='''+ComboBox1.Text+''' ';
    tmpADOLYGetcode.InField:='code,gene_name,gene_pinyin,gene_wbm,chem_name,chem_pinyin,chem_wbm,latin_name,english_name';
    tmpADOLYGetcode.InValue:=tLabeledEdit(sender).Text;
    tmpADOLYGetcode.ShowX:=Panel2.Width+left+tLabeledEdit(SENDER).Left+tLabeledEdit(SENDER).Parent.Left;
    tmpADOLYGetcode.ShowY:=Panel1.Height+tLabeledEdit(SENDER).Height+top+22{��ǰ����������߶�}+10{�����߶�}+tLabeledEdit(SENDER).Top+tLabeledEdit(SENDER).Parent.Top;

    if tmpADOLYGetcode.Execute then
    begin
      tLabeledEdit(SENDER).Text:=tmpADOLYGetcode.OutValue[0];
      LabeledEdit4.Text:=tmpADOLYGetcode.OutValue[1];//����
      ComboBox2.Text:=tmpADOLYGetcode.OutValue[2];//������λ
      ComboBox5.Text:=tmpADOLYGetcode.OutValue[3];//�շѵ�λ
      ComboBox3.Text:=tmpADOLYGetcode.OutValue[5];//�÷�
      ComboBox4.Text:=tmpADOLYGetcode.OutValue[6];//Ƶ��
      Label16.Caption:=tmpADOLYGetcode.OutValue[8];//ҩƷΨһ���
    end;
    tmpADOLYGetcode.Free;

    f1:=CalcXiYaoNum(LabeledEdit4.Text,ComboBox4.Text,LabeledEdit5.Text);
    i1:=UnitsConverterMethod(Label16.Caption,ComboBox2.Text,ComboBox5.Text);
    if i1<0 then LabeledEdit6.Text:=inttostr(ceil(f1/abs(i1))) else LabeledEdit6.Text:=inttostr(ceil(f1*i1));
  end;

  if ComboBox1.Text='���' then
  begin
    tmpADOLYGetcode:=TADOLYGetcode.create(nil);
    tmpADOLYGetcode.MyConnection:=DM.MyConnection1;
    tmpADOLYGetcode.ifAbetChineseChar:=true;
    tmpADOLYGetcode.OpenStr:='select name from commcode where typename=''������ϱ���'' ';
    tmpADOLYGetcode.InField:='code,pinyin,wbm';
    tmpADOLYGetcode.InValue:=tLabeledEdit(sender).Text;
    tmpADOLYGetcode.ShowX:=Panel2.Width+left+tLabeledEdit(SENDER).Left+tLabeledEdit(SENDER).Parent.Left;
    tmpADOLYGetcode.ShowY:=Panel1.Height+tLabeledEdit(SENDER).Height+top+22{��ǰ����������߶�}+10{�����߶�}+tLabeledEdit(SENDER).Top+tLabeledEdit(SENDER).Parent.Top;

    if tmpADOLYGetcode.Execute then
    begin
      tLabeledEdit(SENDER).Text:=tmpADOLYGetcode.OutValue[0];
    end;
    tmpADOLYGetcode.Free;
  end;

  if ComboBox1.Text='����' then
  begin
    tmpADOLYGetcode:=TADOLYGetcode.create(nil);
    tmpADOLYGetcode.MyConnection:=DM.MyConnection1;
    tmpADOLYGetcode.ifAbetChineseChar:=true;
    tmpADOLYGetcode.OpenStr:='select name as ����,'+
    'reserve as Ĭ��������λ,'+
    'reserve2 as Ĭ��Ƶ��,'+
    'reserve3 as Ĭ�ϲ�λ,'+
    'reserve5 as Ĭ������,'+
    'reserve7 as ����, '+
    'unid from commcode where TypeName=''������Ŀ'' ';
    tmpADOLYGetcode.InField:='code,name,pinyin,wbm';
    tmpADOLYGetcode.InValue:=tLabeledEdit(sender).Text;
    tmpADOLYGetcode.ShowX:=Panel2.Width+left+tLabeledEdit(SENDER).Left+tLabeledEdit(SENDER).Parent.Left;
    tmpADOLYGetcode.ShowY:=Panel1.Height+tLabeledEdit(SENDER).Height+top+22{��ǰ����������߶�}+10{�����߶�}+tLabeledEdit(SENDER).Top+tLabeledEdit(SENDER).Parent.Top;

    if tmpADOLYGetcode.Execute then
    begin
      tLabeledEdit(SENDER).Text:=tmpADOLYGetcode.OutValue[0];
      ComboBox5.Text:=tmpADOLYGetcode.OutValue[1];//������λ
      ComboBox4.Text:=tmpADOLYGetcode.OutValue[2];//Ƶ��
      LabeledEdit5.Text:=tmpADOLYGetcode.OutValue[4];//����
      Label16.Caption:=tmpADOLYGetcode.OutValue[6];//Ψһ���
    end;
    tmpADOLYGetcode.Free;
  end;

  if ComboBox1.Text='����' then
  begin
    tmpADOLYGetcode:=TADOLYGetcode.create(nil);
    tmpADOLYGetcode.MyConnection:=DM.MyConnection1;
    tmpADOLYGetcode.ifAbetChineseChar:=true;
    tmpADOLYGetcode.OpenStr:='select name as ����,'+
    'reserve as Ĭ��������λ,'+
    'reserve7 as ����, '+
    'unid from commcode where TypeName=''������Ŀ'' ';
    tmpADOLYGetcode.InField:='code,name,pinyin,wbm';
    tmpADOLYGetcode.InValue:=tLabeledEdit(sender).Text;
    tmpADOLYGetcode.ShowX:=Panel2.Width+left+tLabeledEdit(SENDER).Left+tLabeledEdit(SENDER).Parent.Left;
    tmpADOLYGetcode.ShowY:=Panel1.Height+tLabeledEdit(SENDER).Height+top+22{��ǰ����������߶�}+10{�����߶�}+tLabeledEdit(SENDER).Top+tLabeledEdit(SENDER).Parent.Top;

    if tmpADOLYGetcode.Execute then
    begin
      tLabeledEdit(SENDER).Text:=tmpADOLYGetcode.OutValue[0];
      ComboBox5.Text:=tmpADOLYGetcode.OutValue[1];//������λ
      Label16.Caption:=tmpADOLYGetcode.OutValue[3];//Ψһ���
    end;
    tmpADOLYGetcode.Free;
  end;
  if ComboBox1.Text='���' then
  begin
    tmpADOLYGetcode:=TADOLYGetcode.create(nil);
    tmpADOLYGetcode.MyConnection:=DM.MyConnection1;
    tmpADOLYGetcode.ifAbetChineseChar:=true;
    tmpADOLYGetcode.OpenStr:='select name as ����,'+
    'reserve as Ĭ��������λ,'+
    'reserve3 as Ĭ�ϲ�λ,'+
    'reserve7 as ����, '+
    'unid from commcode where TypeName=''�����Ŀ'' ';
    tmpADOLYGetcode.InField:='code,name,pinyin,wbm';
    tmpADOLYGetcode.InValue:=tLabeledEdit(sender).Text;
    tmpADOLYGetcode.ShowX:=Panel2.Width+left+tLabeledEdit(SENDER).Left+tLabeledEdit(SENDER).Parent.Left;
    tmpADOLYGetcode.ShowY:=Panel1.Height+tLabeledEdit(SENDER).Height+top+22{��ǰ����������߶�}+10{�����߶�}+tLabeledEdit(SENDER).Top+tLabeledEdit(SENDER).Parent.Top;

    if tmpADOLYGetcode.Execute then
    begin
      tLabeledEdit(SENDER).Text:=tmpADOLYGetcode.OutValue[0];
      ComboBox5.Text:=tmpADOLYGetcode.OutValue[1];//������λ
      Label16.Caption:=tmpADOLYGetcode.OutValue[4];//Ψһ���
    end;
    tmpADOLYGetcode.Free;
  end;
end;

function TfrmDgnsBigTemp.CalcXiYaoNum(const dosage, drug_freq, drug_days: string): single;
//ͨ��������Ƶ�Ρ�������������
//���ص���������������λ��ͬ
var
  s1:string;
  i1,i2:integer;
  f1:single;
begin
  Result:=0;
  s1:=ScalarSQLCmd(g_Server,g_Port,g_Database,g_Username,g_Password,'select Reserve5 from commcode where TypeName=''��ҩƵ��'' AND name='''+drug_freq+''' LIMIT 1');
  if not trystrtoint(s1,i1) then exit;
  if not trystrtoint(drug_days,i2) then exit;
  if not trystrtofloat(dosage,f1) then exit;
  Result:=i1*i2*f1;
end;

function TfrmDgnsBigTemp.UnitsConverterMethod(const ADrug_Unid,AUnit_Dosage,AUnit_Fee:String):integer;
//ADrug_Unid:������λ
//AUnit_Fee//�շѵ�λ
//return 0:û�ҵ�ת����ϵ,����:ת������,����:ת������
var
  iiDown,ii1,iiUp:integer;
  s2,s3:string;
  adotemp12:TMyQuery;
begin
  Result:=0;
		
  //������λ���շѵ�λ��ͬ(����������λ��Ϊ��),��ת������Ϊ1
  if AUnit_Dosage=AUnit_Fee then begin Result:=1;exit;end;
		
  if(AUnit_Dosage='')or(AUnit_Fee='') then begin Result:=0;exit;end;

  //˼·:ͨ��������λ�����շѵ�λ,��û����ϵ
  //���²���
  iiDown := 1;
    
  s2 := AUnit_Dosage;
  while AUnit_Fee<>s2 do
  begin
    adotemp12:=TMyQuery.Create(nil);
    adotemp12.Connection:=DM.MyConnection1;
    adotemp12.Close;
    adotemp12.SQL.Clear;
    adotemp12.SQL.Text:='select * from drug_pack where drug_Unid='+ADrug_Unid+' and Pack_Name='''+s2+''' ';
    adotemp12.Open;

    if adotemp12.RecordCount<=0 then begin adotemp12.Free;break;end;
        	
    s2 := adotemp12.fieldbyname('Son_Pack_Name').AsString;
    if s2='' then begin adotemp12.Free;break;end;
    ii1 := adotemp12.fieldbyname('Parent_num').AsInteger;
    adotemp12.Free;
    iiDown := iiDown*ii1;
  end;
    	
  if AUnit_Fee=s2 then begin Result:=iiDown;exit;end;//�ҵ�
    	
  //���ϲ���
  iiUp := -1;
  s3 := AUnit_Dosage;
  while AUnit_Fee<>s3 do
  begin			
    adotemp12:=TMyQuery.Create(nil);
    adotemp12.Connection:=DM.MyConnection1;
    adotemp12.Close;
    adotemp12.SQL.Clear;
    adotemp12.SQL.Text:='select * from drug_pack where drug_Unid='+ADrug_Unid+' and Son_Pack_Name='''+s3+''' ';
    adotemp12.Open;

    if adotemp12.RecordCount<=0 then begin adotemp12.Free;break;end;
        	
    s3 := adotemp12.fieldbyname('Pack_Name').AsString;
    ii1 := adotemp12.fieldbyname('Parent_num').AsInteger;
    iiUp := iiUp*ii1;
  end;
    	
  if AUnit_Fee=s3 then begin Result:=iiUp;exit;end;//�ҵ�
end;

procedure TfrmDgnsBigTemp.LabeledEdit4Change(Sender: TObject);
var
  f1:single;
  i1:integer;
begin
  if(ComboBox1.Text='��ҩ')or(ComboBox1.Text='��ҩ') then
  begin
    f1:=CalcXiYaoNum(LabeledEdit4.Text,ComboBox4.Text,LabeledEdit5.Text);
    i1:=UnitsConverterMethod(Label16.Caption,ComboBox2.Text,ComboBox5.Text);
    if i1<0 then LabeledEdit6.Text:=inttostr(ceil(f1/abs(i1))) else LabeledEdit6.Text:=inttostr(ceil(f1*i1));
  end;

  if ComboBox1.Text='����' then
    LabeledEdit6.Text:=inttostr(CalcZhiLiaoNum(ComboBox4.Text,LabeledEdit5.Text));
end;

function TfrmDgnsBigTemp.CalcZhiLiaoNum(const drug_freq,
  drug_days: string): integer;
var
  s1:string;
  i1,i2:integer;
begin
  Result:=0;
  s1:=ScalarSQLCmd(g_Server,g_Port,g_Database,g_Username,g_Password,'select Reserve5 from commcode where TypeName=''��ҩƵ��'' AND name='''+drug_freq+''' LIMIT 1');
  if not trystrtoint(s1,i1) then exit;
  if not trystrtoint(drug_days,i2) then exit;
  Result:=i1*i2;
end;

procedure TfrmDgnsBigTemp.ComboBox1Change(Sender: TObject);
begin
  EnableOrDisableEdit((Sender as TComboBox).Text);
end;

procedure TfrmDgnsBigTemp.EnableOrDisableEdit(const AType_Name: string);
begin
  if(AType_Name='����')or(AType_Name='��Ҫ��ʷ')or(AType_Name='���')or(AType_Name='�������')or(AType_Name='����')then
  begin
    LabeledEdit2.Color:=clMenu;
    LabeledEdit2.Enabled:=false;
    
    LabeledEdit3.Color:=clMenu;
    LabeledEdit3.Enabled:=false;

    LabeledEdit4.Color:=clMenu;
    LabeledEdit4.Enabled:=false;
    
    ComboBox2.Color:=clMenu;
    ComboBox2.Enabled:=false;
    
    ComboBox3.Color:=clMenu;
    ComboBox3.Enabled:=false;
    
    ComboBox4.Color:=clMenu;
    ComboBox4.Enabled:=false;
    
    LabeledEdit5.Color:=clMenu;
    LabeledEdit5.Enabled:=false;
    
    LabeledEdit6.Color:=clMenu;
    LabeledEdit6.Enabled:=false;
    
    ComboBox5.Color:=clMenu;
    ComboBox5.Enabled:=false;
    
    Memo1.Color:=clWindow;
    Memo1.Enabled:=true;
  end;
  
  if AType_Name='���' then
  begin
    LabeledEdit2.Color:=clWindow;
    LabeledEdit2.Enabled:=true;
    
    LabeledEdit3.Color:=clMenu;
    LabeledEdit3.Enabled:=false;

    LabeledEdit4.Color:=clMenu;
    LabeledEdit4.Enabled:=false;
    
    ComboBox2.Color:=clMenu;
    ComboBox2.Enabled:=false;
    
    ComboBox3.Color:=clMenu;
    ComboBox3.Enabled:=false;
    
    ComboBox4.Color:=clMenu;
    ComboBox4.Enabled:=false;
    
    LabeledEdit5.Color:=clMenu;
    LabeledEdit5.Enabled:=false;
    
    LabeledEdit6.Color:=clMenu;
    LabeledEdit6.Enabled:=false;
    
    ComboBox5.Color:=clMenu;
    ComboBox5.Enabled:=false;
    
    Memo1.Color:=clMenu;
    Memo1.Enabled:=false;
  end;
  
  if(AType_Name='��ҩ')or(AType_Name='��ҩ')then
  begin
    LabeledEdit2.Color:=clWindow;
    LabeledEdit2.Enabled:=true;
    
    LabeledEdit3.Color:=clWindow;
    LabeledEdit3.Enabled:=true;

    LabeledEdit4.Color:=clWindow;
    LabeledEdit4.Enabled:=true;
    
    ComboBox2.Color:=clWindow;
    ComboBox2.Enabled:=true;
    
    ComboBox3.Color:=clWindow;
    ComboBox3.Enabled:=true;
    
    ComboBox4.Color:=clWindow;
    ComboBox4.Enabled:=true;
    
    LabeledEdit5.Color:=clWindow;
    LabeledEdit5.Enabled:=true;
    
    LabeledEdit6.Color:=clMenu;
    LabeledEdit6.Enabled:=false;

    ComboBox5.Color:=clWindow;
    ComboBox5.Enabled:=true;
    
    Memo1.Color:=clMenu;
    Memo1.Enabled:=false;
  end;
  
  if AType_Name='����' then
  begin
    LabeledEdit2.Color:=clWindow;
    LabeledEdit2.Enabled:=true;
    
    LabeledEdit3.Color:=clWindow;
    LabeledEdit3.Enabled:=true;

    LabeledEdit4.Color:=clMenu;
    LabeledEdit4.Enabled:=false;
    
    ComboBox2.Color:=clMenu;
    ComboBox2.Enabled:=false;
    
    ComboBox3.Color:=clMenu;
    ComboBox3.Enabled:=false;
    
    ComboBox4.Color:=clWindow;
    ComboBox4.Enabled:=true;
    
    LabeledEdit5.Color:=clWindow;
    LabeledEdit5.Enabled:=true;
    
    LabeledEdit6.Color:=clMenu;
    LabeledEdit6.Enabled:=false;

    ComboBox5.Color:=clWindow;
    ComboBox5.Enabled:=true;
    
    Memo1.Color:=clMenu;
    Memo1.Enabled:=false;
  end;
  
  if(AType_Name='����')or(AType_Name='���')then
  begin
    LabeledEdit2.Color:=clWindow;
    LabeledEdit2.Enabled:=true;
    
    LabeledEdit3.Color:=clWindow;
    LabeledEdit3.Enabled:=true;

    LabeledEdit4.Color:=clMenu;
    LabeledEdit4.Enabled:=false;
    
    ComboBox2.Color:=clMenu;
    ComboBox2.Enabled:=false;
    
    ComboBox3.Color:=clMenu;
    ComboBox3.Enabled:=false;
    
    ComboBox4.Color:=clMenu;
    ComboBox4.Enabled:=false;
    
    LabeledEdit5.Color:=clMenu;
    LabeledEdit5.Enabled:=false;
    
    LabeledEdit6.Color:=clWindow;
    LabeledEdit6.Enabled:=true;

    ComboBox5.Color:=clWindow;
    ComboBox5.Enabled:=true;
    
    Memo1.Color:=clMenu;
    Memo1.Enabled:=false;
  end;
end;

initialization
  ffrmDgnsBigTemp:=nil;

end.
