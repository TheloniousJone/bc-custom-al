table 66001 MaxxholoLine
{
    DataClassification = ToBeClassified;
    Caption = 'Maxxholo Line';

    fields
    {
        field(1; I9G_LineNo; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Line No.';
        }
        field(2; I9G_LabelID; Code[50])
        {
            Caption = 'Label ID';

            trigger OnValidate()
            begin
                checkLabelID();
            end;
        }
        field(3; I9G_SourceTable; Enum "Document Type")
        {
            Caption = 'Source Table';
        }
        field(4; I9G_SourceDocNo; Code[20])
        {
            Caption = 'Source Document No.';
        }
        field(5; I9G_SourceDocLineNo; Integer)
        {
            Caption = 'Source Document Line No.';
        }
        field(7; I9G_TargetTable; Enum "Document Type")
        {
            Caption = 'Target Table';
        }
        field(8; I9G_TargetDocNo; Code[20])
        {
            Caption = 'Target Document No.';
        }
        field(9; I9G_TargetDocLineNo; Integer)
        {
            Caption = 'Target Document Line No.';
        }
        field(10; I9G_BatchID; Text[300])
        {
            Caption = 'Batch ID';
        }
        field(11; I9G_ShipCode; Text[300])
        {
            Caption = 'Ship Code';
        }
        field(12; I9G_ShipName; Text[300])
        {
            Caption = 'Ship Name';
        }
        field(13; I9G_ShipAddress; Text[300])
        {
            Caption = 'Ship Address';
        }
        field(14; I9G_BillCode; Text[300])
        {
            Caption = 'Bill Code';
        }
        field(15; I9G_BillName; Text[300])
        {
            Caption = 'Bill Name';
        }
        field(16; I9G_BillAddress; Text[300])
        {
            Caption = 'Bill Address';
        }
        field(17; I9G_ProductCode; Code[20])
        {
            Caption = 'Product Code';
            TableRelation = Item."No.";

            trigger OnValidate()
            var
                lrec_Item: Record Item;
            begin
                if I9G_ProductCode <> '' then begin
                    lrec_Item.Reset();
                    lrec_Item.SetRange("No.", I9G_ProductCode);
                    if lrec_Item.FindFirst() then begin
                        I9G_ProductName := lrec_Item.Description;
                    end;
                end else begin
                    I9G_ProductName := '';
                end;
            end;
        }
        field(18; I9G_ProductName; Text[100])
        {
            Caption = 'Product Name';
        }
        field(19; I9G_QRCodeText; Text[1000])
        {
            Caption = 'QR Code Text';
        }
        field(20; I9G_DocNo; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = MaxxholoHeader.I9G_DocNo;
        }
        field(21; I9G_LotNo; Code[50])
        {
            Caption = 'Lot No.';
        }
    }

    keys
    {
        key(Key1; I9G_DocNo, I9G_LineNo)
        {
            Clustered = true;
        }
        key(Key2; I9G_LabelID)
        {
        }
    }

    var


    trigger OnInsert()
    begin
        // checkLabelID();
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure checkLabelID()
    var
        lrec_MaxxholoLine: Record MaxxholoLine;
        lint_IntValid: Integer;
    begin
        if Rec.I9G_LabelID <> '' then begin
            lrec_MaxxholoLine.Reset();
            lrec_MaxxholoLine.SetRange(I9G_LabelID, Rec.I9G_LabelID);
            if lrec_MaxxholoLine.Count > 0 then begin
                Error('Label ID already exists.');
            end;

            if Evaluate(lint_IntValid, Rec.I9G_LabelID) then begin

            end else begin
                Error('only 0-9 are allow to insert for field Label ID.');
            end;
        end else begin
            Error('Label ID CANNOT be BLANK.');
        end;
    end;

}