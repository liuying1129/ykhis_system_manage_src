unit UfrmTempDir;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, ToolWin, StdCtrls, ExtCtrls, Buttons,ADODB,StrUtils,
  DosMove, ActnList, DBCtrls, DB, MemDS, DBAccess, Uni;

type
  TfrmTempDir = class(TForm)
    GroupBox1: TGroupBox;
    tvWareHouse: TTreeView;
    Panel1: TPanel;
    labWhId: TLabel;
    labWhName: TLabel;
    edtWhId: TEdit;
    edtWhName: TEdit;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    Splitter1: TSplitter;
    DosMove1: TDosMove;
    ActionList1: TActionList;
    ActAdd1: TAction;
    ActAdd2: TAction;
    ActSave: TAction;
    ActDel: TAction;
    ActRefresh: TAction;
    ActExit: TAction;
    procedure FormShow(Sender: TObject);
    procedure tvWareHouseChange(Sender: TObject; Node: TTreeNode);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtWhNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tvWareHouseDeletion(Sender: TObject; Node: TTreeNode);
  private
    { Private declarations }
    procedure UpdatetvWareHouse;
    procedure ClearEdit;
    procedure UpdateEdit(Node:TTreeNode);
  public
    { Public declarations }
  end;

//var
function  frmTempDir: TfrmTempDir;

implementation

uses UDM;

var
  ffrmTempDir: TfrmTempDir;
  InsertPwhid:string;
  ifInsert:boolean;

{$R *.dfm}

////////////////////////////////////////////////////////////////////////////////
function  frmTempDir: TfrmTempDir;  {动态创建窗体函数}
begin
  if ffrmTempDir=nil then ffrmTempDir:=tfrmTempDir.Create(application.mainform);
  result:=ffrmTempDir;
end;

procedure TfrmTempDir.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action:=cafree;
  if ffrmTempDir=self then ffrmTempDir:=nil;
end;
////////////////////////////////////////////////////////////////////////////////

procedure TfrmTempDir.UpdatetvWareHouse;
var
  adotemp11:TUniQuery;
  Node: TTreeNode;
  DescriptType:PDescriptType;
begin
  tvWareHouse.Items.Clear;
  adotemp11:=TUniQuery.Create(nil);
  adotemp11.Connection:=dm.MyConnection1;

  adotemp11.Close;
  adotemp11.SQL.Clear;
  adotemp11.SQL.Text:='select * from temp_dir where IFNULL(up_unid,-1)<0 order by sort_num';
  adotemp11.Open;
  while not adotemp11.Eof do
  begin
    new(DescriptType);//为指针分配内存
    DescriptType^.unid:=adotemp11.fieldbyname('unid').AsString;
    DescriptType^.UpUnid:=adotemp11.fieldbyname('up_unid').AsString;
    DescriptType^.SortNum:=adotemp11.fieldbyname('sort_num').AsString;
    Node:=tvWareHouse.Items.AddChildObject(nil,adotemp11.fieldbyname('name').AsString,DescriptType);//.Add(nil,'['+adotemp11.fieldbyname('Id').AsString+']'+adotemp11.fieldbyname('name').AsString);

    if HasSubInDbf(node) then Node.HasChildren := True;//判断是否有子节点，用来控制是否显示前面的'+'

    adotemp11.Next;
  end;
  adotemp11.free;

  ClearEdit;      //因为重新加载TREEVIEW后就没了焦点
end;

procedure TfrmTempDir.ClearEdit;
begin
  edtWhId.Clear;
  edtWhName.Clear;
end;

procedure TfrmTempDir.BitBtn1Click(Sender: TObject);
var
  RecNum:integer;
  SelectID:string;
begin
  RecNum:=strtoint(ScalarSQLCmd(HisConn,'select count(*) as RecNum from temp_dir LIMIT 1'));

  if RecNum<>0 then//否则,没有记录SelectID为默认值空('')
  begin
    if tvWareHouse.Selected=nil then
    begin
      MessageDlg('请选择一个类别！',mtError,[mbOK],0);
      exit;
    end;
    SelectID:=PDescriptType(tvWareHouse.Selected.Data)^.unid;
    InsertPwhid:=ScalarSQLCmd(HisConn,'select up_unid from temp_dir where unid='+SelectID);
  end;

  ClearEdit;
  edtWhId.Enabled:=true;
  edtWhId.SetFocus;
  ifInsert:=true;

  if InsertPwhid='' then InsertPwhid:='-1';
end;

procedure TfrmTempDir.BitBtn2Click(Sender: TObject);
begin
  if tvWareHouse.Selected=nil then
  begin
    MessageDlg('请选择一个类别！',mtError,[mbOK],0);
    exit;
  end;

  ClearEdit;
  edtWhId.Enabled:=true;
  edtWhId.SetFocus;
  InsertPwhid:=PDescriptType(tvWareHouse.Selected.Data)^.unid;
  ifInsert:=true;
end;

procedure TfrmTempDir.BitBtn3Click(Sender: TObject);
var
  adotemp11:TUniQuery;
  i_sort_num:integer;
begin
  adotemp11:=TUniQuery.Create(nil);
  adotemp11.Connection:=dm.MyConnection1;
  adotemp11.Close;
  adotemp11.SQL.Clear;

  if ifInsert then
  begin
    adotemp11.SQL.Text:='Insert into temp_dir (sort_num,Name,up_unid) Values (:sort_num,:Name,:up_unid)';
    adotemp11.ParamByName('up_unid').Value:=InsertPwhid;
  end else
  begin
    if tvWareHouse.Selected=nil then begin adotemp11.Free;exit;end;

    adotemp11.SQL.Text:='UPDATE temp_dir SET Name=:Name,sort_num=:sort_num Where unid=:unid';//+QuotedStr());
    adotemp11.ParamByName('unid').Value:=PDescriptType(tvWareHouse.Selected.Data)^.unid;
  end;
  try
    adotemp11.ParamByName('Name').Value:=edtWhName.Text;
    if trystrtoint(edtWhId.Text,i_sort_num) then
      adotemp11.ParamByName('sort_num').Value:=i_sort_num
    else adotemp11.ParamByName('sort_num').Value:=null;

    adotemp11.ExecSQL;
  finally
    adotemp11.Free;
    ifInsert:=false;
    UpdatetvWareHouse;
  end;
end;

procedure TfrmTempDir.UpdateEdit(Node:TTreeNode);
begin
  edtWhId.Text:=PDescriptType(tvWareHouse.Selected.Data)^.SortNum;
  edtWhName.Text:=Node.Text;
end;

procedure TfrmTempDir.BitBtn4Click(Sender: TObject);
var
  RecNum,RecNum33:integer;
begin
  if tvWareHouse.Selected=nil then
  begin
    MessageDlg('请选择一个类别！',mtError,[mbOK],0);
    exit;
  end;
  
  RecNum:=strtoint(ScalarSQLCmd(HisConn,'select count(*) as RecNum from temp_dir where up_unid='+PDescriptType(tvWareHouse.Selected.Data)^.unid));

  if RecNum<>0 then
  begin
    MessageDlg('该节点有子节点,不能删除！',mtError,[mbOK],0);
    exit;
  end;

  RecNum33:=strtoint(ScalarSQLCmd(HisConn,'select count(*) as RecNum33 from temp_body where dir_unid='+PDescriptType(tvWareHouse.Selected.Data)^.unid));

  if RecNum33<>0 then
  begin
    MessageDlg('该节点下有模板内容,不能删除！',mtError,[mbOK],0);
    exit;
  end;

  if (MessageDlg('确定删除当前节点吗？', mtConfirmation, [mbYes, mbNo], 0) <> mrYes) then exit;

  ExecSQLCmd(HisConn,'delete from temp_dir where unid='+PDescriptType(tvWareHouse.Selected.Data)^.unid);

  UpdatetvWareHouse;
end;

procedure TfrmTempDir.FormShow(Sender: TObject);
begin
  ifInsert:=false;
  ClearEdit;
  UpdatetvWareHouse;
end;

procedure TfrmTempDir.tvWareHouseChange(Sender: TObject;
  Node: TTreeNode);
var
  adotemp11:TUniQuery;
  ChildNode:ttreenode;
  DescriptType:PDescriptType;
begin
  node.DeleteChildren;//清除节点下的所有子节点

  adotemp11:=TUniQuery.Create(nil);
  adotemp11.Connection:=dm.MyConnection1;

  adotemp11.Close;
  adotemp11.SQL.Clear;
  adotemp11.SQL.Text:='select * from temp_dir where up_unid=:up_unid order by sort_num';
  adotemp11.ParamByName('up_unid').Value:=PDescriptType(Node.Data)^.unid;
  adotemp11.Open;
  while not adotemp11.Eof do
  begin
    new(DescriptType);//为指针分配内存
    DescriptType^.unid:=adotemp11.fieldbyname('unid').AsString;
    DescriptType^.UpUnid:=adotemp11.fieldbyname('up_unid').AsString;
    DescriptType^.SortNum:=adotemp11.fieldbyname('sort_num').AsString;

    ChildNode:=tvWareHouse.Items.AddChildObject(node,adotemp11.fieldbyname('Name').AsString,DescriptType);

    if HasSubInDbf(ChildNode) then ChildNode.HasChildren := True;//判断是否有子节点，用来控制是否显示前面的'+'

    adotemp11.Next;
  end;

  UpdateEdit(Node);
end;

procedure TfrmTempDir.BitBtn6Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmTempDir.BitBtn5Click(Sender: TObject);
begin
  UpdatetvWareHouse;
end;

procedure TfrmTempDir.FormCreate(Sender: TObject);
begin
  SetWindowLong(edtWhId.Handle,GWL_STYLE,GetWindowLong(edtWhId.Handle,GWL_STYLE) or ES_NUMBER);//只能输入数字
end;

procedure TfrmTempDir.edtWhNameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=13 then
    if bitbtn3.CanFocus then bitbtn3.SetFocus;
end;

procedure TfrmTempDir.tvWareHouseDeletion(Sender: TObject;
  Node: TTreeNode);
begin
  Dispose(Node.Data);{释放节点数据内存}
end;

initialization
  ffrmTempDir:=nil;

end.
