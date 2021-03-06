unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,Unit1;

type
  TAddFuncDialog = class(TForm)
    Edit1: TEdit;
    Edit4: TEdit;
    Panel1: TPanel;
    Panel4: TPanel;
    Edit2: TEdit;
    Edit3: TEdit;
    Panel3: TPanel;
    Panel7: TPanel;
    OneArgums: TRadioButton;
    TwoArgums: TRadioButton;
    ButtonClear: TButton;
    Edit5: TEdit;
    Panel6: TPanel;
    ButtonTest: TButton;
    ButtonAdd: TButton;
    ButtonDel: TButton;
    procedure ButtonAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure ButtonTestClick(Sender: TObject);
    procedure ButtonDelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

FUNCTION Testing(Var flagMessage:boolean):boolean;
Function AddFuncToFile:boolean;

var
  AddFuncDialog: TAddFuncDialog;
  flagAdd:boolean=false;
implementation
{$R *.dfm}

FUNCTION Testing(Var flagMessage:boolean):boolean;
Var StEdit,St1,St2:string;
    i:longint;
    fv:tFile;
    FuncRec:TFuncRec;
    flagCall:boolean;
begin
TRY
flagCall:=true;
result:=false;

Assign(fv,'BaseofFunc.dat');
If Not FileExists('BaseofFunc.dat') then
begin
ShowMessage('�� ������ ���� BaseofFunc.dat');
flagMessage:=false;
result:=true;Exit;
end;

///�������� ������������ ����� �-���

StEdit:=AnsiLowerCase(DelAllSpaces(AddFuncDialog.Edit1.Text));

AddFuncDialog.Edit1.Text:=StEdit;

If StEdit='' then
begin
ShowMessage('��� �-��� �� ����� ��������� ������ ������');
flagMessage:=false;flagAdd:=false;result:=true;Exit;
end;

For i:=1 to Length(StEdit) do
begin
If StEdit[i] in ['0'..'9','(','.',')','-','+','*','/'] then
begin
ShowMessage('��� ������� �������� ������������ �������');
flagMessage:=false;
flagAdd:=false;result:=true;Exit;
end;
end;//For i:=1 to Length(StEdit) do//

If (Pos('@',StEdit)<>0) or
(Pos('$',StEdit)<>0) then
begin
ShowMessage('������ ������������ ����������������� �������');
flagMessage:=false;flagAdd:=false;result:=true;Exit;
end;

For i:=0 to High(FuncMass) do
begin
If Pos(FuncMass[i],StEdit)<>0 then
begin
ShowMessage('������������ ��� �-���');
flagMessage:=false;flagAdd:=false;result:=true;Exit;
end;//If Pos(FuncMass[i],StEdit)<>0 then//
end;//For i:=0 to High(FuncMass) do//

For i:=0 to High(FuncMass2) do
begin
If Pos(FuncMass2[i],StEdit)<>0 then
begin
ShowMessage('������������ ��� �-���');
flagMessage:=false;flagAdd:=false;result:=true;Exit;
end;//If Pos(FuncMass[i],StEdit)<>0 then//
end;//For i:=0 to High(FuncMass) do//

Reset(fv);
While Not Eof(fv) do
begin
Read(fv,FuncRec);
If Pos(FuncRec.FuncName,StEdit)<>0 then
begin
ShowMessage('������������ ��� �-���');
flagMessage:=false;flagAdd:=false;Close(fv);result:=true;Exit;
end;//If Pos(FuncRec.FuncName,StEdit1)<>0 then//
end;//While Not Eof(fv) do//
Close(fv);
/////////////////

////�������� ���������� �-���

StEdit:=DelAllSpaces(AddFuncDialog.Edit2.Text);

AddFuncDialog.Edit2.Text:=StEdit;

If Not(CheckNum(StEdit)) then
begin
ShowMessage('������ �������� �-��� �� �������� ������');
flagMessage:=false;flagAdd:=false;result:=true;Exit;
end;

StEdit:=DelAllSpaces(AddFuncDialog.Edit3.Text);

AddFuncDialog.Edit3.Text:=StEdit;

If AddFuncDialog.TwoArgums.Checked then
If Not(CheckNum(StEdit)) then
begin
ShowMessage('������ �������� �-��� �� �������� ������');
flagMessage:=false;flagAdd:=false;result:=true;Exit;
end;
//////

///////�������� ���� �-���:

StEdit:=AnsiLowerCase(DelAllSpaces(AddFuncDialog.Edit4.Text));

AddFuncDialog.Edit4.Text:=StEdit;

St1:=AddFuncDialog.Edit2.Text;
St2:=AddFuncDialog.Edit3.Text;

StEdit:=StringReplace(StEdit,'@',St1,[rfReplaceAll]);
If AddFuncDialog.TwoArgums.Checked then
StEdit:=StringReplace(StEdit,'$',St2,[rfReplaceAll]);

If (StEdit='') or (Generate(StEdit,flagMessage,flagCall)) then
begin
result:=true;
If flagMessage=true then
begin
ShowMessage('�������������� ������ ��������� ������');
flagMessage:=false;flagAdd:=false;Exit;
end;
end;

///////

AddFuncDialog.Edit5.Text:=StEdit;
EXCEPT
Else
flagMessage:=false;ShowMessage('������ ������������ �-���');
flagAdd:=false;result:=true;Exit;
end;//Try//
END;//Testing//

FUNCTION AddFuncToFile:boolean;
//////////////////////////////////////
Procedure App_End (Var fv:tFile);
Var buf:tFuncRec;
BEGIN
Reset(fv);
While Not(Eof(fv)) do
begin
Read(fv,buf);
end;//While Not(Eof(fv)) do//
END;//App_End//
/////////////////////////////////////

Var   FuncRec:TFuncRec;
begin
TRY
Assign(fv,'BaseofFunc.dat');
If Not FileExists('BaseofFunc.dat') then
begin
ShowMessage('�� ������ ���� BaseofFunc.dat');
result:=true;Exit;
end;
result:=false;
FuncRec.FuncName:=AddFuncDialog.Edit1.Text;
FuncRec.FuncKod:=AddFuncDialog.Edit4.Text;
If AddFuncDialog.TwoArgums.Checked then
FuncRec.flagTwoArg:=true else
FuncRec.flagTwoArg:=false;
App_End(fv);
Write(fv,FuncRec);
CloseFile(fv);
EXCEPT
Else
begin
ShowMessage('������ � �������� ����������');
Result:=true;
end;
end;//TRY//
END;//AddFuncToFile//

procedure TAddFuncDialog.ButtonAddClick(Sender: TObject);
begin
If flagAdd=false then
begin
ShowMessage('������ �������� ������������������ �������');
Exit;
end;//If flagAdd=false then//
If AddFuncToFile=false then
ShowMessage('������� ������� ���������');
flagAdd:=false;
end;

procedure TAddFuncDialog.FormCreate(Sender: TObject);
begin

flagAdd:=false;
end;

procedure TAddFuncDialog.Edit1Change(Sender: TObject);
begin
If flagAdd then flagAdd:=false;
end;

procedure TAddFuncDialog.Edit4Change(Sender: TObject);
begin
If flagAdd then flagAdd:=false;
end;

procedure TAddFuncDialog.ButtonClearClick(Sender: TObject);
begin
AddFuncDialog.Edit1.Text:='';
AddFuncDialog.Edit2.Text:='';
AddFuncDialog.Edit3.Text:='';
AddFuncDialog.Edit4.Text:='';
AddFuncDialog.Edit5.Text:='';
end;

procedure TAddFuncDialog.ButtonTestClick(Sender: TObject);
Var flagMessage:boolean;
begin
flagMessage:=true;
If Not Testing(flagMessage) then
begin
flagAdd:=true;
If flagMessage then
ShowMessage('������� ������� ��������������');
end;
end;

procedure TAddFuncDialog.ButtonDelClick(Sender: TObject);
//////////////////////////
Procedure Write_Current_in_Pred_Komponent(Var fv:tFile); //���� ������ ���� ������
Var i:longint;
    buf:tFuncRec;
BEGIN
i:=FilePos(fv);
Read(fv,buf);
Seek(fv,i-1);
Write(fv,buf);
Read(fv,buf);
END;//Write_Current_in_Pred_Komponent//

Procedure Num_last_komponent (Var fv:tFile;Var i:longint);
Var buf:tFuncRec;
BEGIN
i:=-1;
Reset(fv);
While Not(Eof(fv)) do
begin
Read(fv,buf);
Inc(i);
end;//While Not(Eof(fv)) do//
END;//Num_last_komponent//

Procedure Del_last_komponent(Var fv:tFile);
Var i:longint;
BEGIN
Num_last_komponent(fv,i);
Seek(fv,i);
Truncate(fv);
CloseFile(fv);
END;//Del_last_komponent//
////////////////////////////
Var fv:tFile;
    buf:TFuncrec;
    i:longint;
    St:string;
    flag:boolean;
begin
TRY
AssignFile(fv,'BaseofFunc.dat');
If Not FileExists('BaseofFunc.dat') then
begin
ShowMessage('�� ������ ���� BaseofFunc.dat');
Exit;
end;

St:=AddFuncDialog.Edit1.Text;
St:=AnsiLowerCase(DelAllSpaces(St));
flag:=false;

Reset(fv);
While Not Eof(fv) do
begin
i:=FilePos(fv);
Read(fv,buf);

If buf.FuncName=St then
begin
If flag=false then flag:=true;
If Not Eof(fv) then Read(fv,buf);
While Not(Eof(fv)) do
begin
Write_Current_in_Pred_Komponent(fv);
end;//While Not(Eof(fv)) do//
CloseFile(fv);
Del_Last_komponent(fv);
Reset(fv);
Seek(fv,i);
If Not Eof(fv) then Read(fv);
end;//If buf.FuncName=St then//

end;//While Not Eof(fv) do//
CloseFile(fv);
EXCEPT
Else ShowMessage('������ �������� �������');
Exit;
END;//TRY//
If flag then ShowMessage('�-��� ������� �������')
Else ShowMessage('�� ���������� ����� �-��� � BaseofFunc.dat');
end;
               
end.//Unit2//
