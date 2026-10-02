tableextension 80150 TransferHeaderTableExt3PL extends "Transfer Header"
{
    fields
    {
        field(80130; "I9G_TOCreated"; Boolean)
        {
            Caption = 'Transfer Order Created';
            Editable = false;
        }
        field(80131; "I9G_TONo"; Code[20])
        {
            Caption = 'Transfer Order No.';
            Editable = false;
        }
        field(80132; "I9G_TOCreatedDateTime"; DateTime)
        {
            Caption = 'Transfer Order Created Date Time';
            Editable = false;
        }
        field(80133; "I9G_TOCreatedBy"; Code[50])
        {
            Caption = 'Transfer Order Created By';
            Editable = false;
        }
        field(80134; "I9G_NeedToCreateTO"; Boolean)
        {
            Caption = 'Create Transfer Order';
        }
        field(80135; "I9G_FromCompanyName"; Text[30])
        {
            Caption = 'From Company Name';
            TableRelation = Company.Name;
            Editable = false;
        }
        field(80136; "I9G_TOLastModifiedDateTime"; DateTime)
        {
            Caption = 'Transfer Order Last Modifited Date Time';
            Editable = false;
        }
        field(80137; "I9G_ReceiptNo"; Code[20])
        {
            Caption = 'ReceiptNo';
            Editable = false;
        }
        field(80138; "I9G_3PLRemarks"; Text[500])
        {
            Caption = '3PL Remarks';
        }
        field(80139; "I9G_TransferFromName"; Text[100])
        {
            Caption = 'Transfer-From Name';
            Editable = false;
        }
        field(80140; "I9G_TransferToName"; Text[100])
        {
            Caption = 'Transfer-To Name';
            Editable = false;
        }
    }
}