table 66000 MaxxholoHeader
{
    DataClassification = ToBeClassified;
    Caption = 'Maxxholo Header';

    fields
    {
        field(1; I9G_DocNo; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Document No.';

            trigger OnValidate()
            var
                NoSeries: Codeunit "No. Series";
            begin
                IF I9G_DocNo <> xRec.I9G_DocNo THEN BEGIN
                    grec_MaxxholoSetup.Get();
                    // NoSeriesMgt.TestManual(GetNoSeriesCode);
                    NoSeries.TestManual(GetNoSeriesCode());
                    I9G_NoSeries := '';
                end;
            end;
        }
        field(2; I9G_NoSeries; Code[10])
        {
            Caption = 'No. Series';

            trigger OnValidate()
            begin

            end;
        }
        field(3; I9G_SourceTable; Enum "Document Type")
        {
            Caption = 'Source Table';
            InitValue = " ";
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
            InitValue = " ";
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
        field(20; I9G_SentMaxxholo; Boolean)
        {
            Caption = 'Sent to Maxxholo';
            InitValue = false;
        }
        field(21; I9G_ResponseFrmMaxxholo; Text[1000])
        {
            Caption = 'Response From Maxxholo';
        }
    }

    keys
    {
        key(Key1; I9G_DocNo)
        {
            Clustered = true;
        }
    }

    var
        grec_MaxxholoSetup: Record MaxxholoSetup;
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        SelectNoSeriesAllowed: Boolean;


    trigger OnInsert()
    begin
        InitInsert();
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    var
        lrec_MaxxholoLine: Record MaxxholoLine;
    begin
        lrec_MaxxholoLine.Reset();
        lrec_MaxxholoLine.SetRange(I9G_DocNo, I9G_DocNo);
        if lrec_MaxxholoLine.FindSet() then begin
            repeat
                lrec_MaxxholoLine.Delete();
            until lrec_MaxxholoLine.Next() = 0;
        end;
    end;

    trigger OnRename()
    begin

    end;

    procedure GetNoSeriesCode(): Code[20]
    var
        NoSeriesCode: Code[20];
        NoSeries: Codeunit "No. Series";
    begin

        NoSeriesCode := grec_MaxxholoSetup.I9G_MaxxholoNos;

        // EXIT(NoSeriesMgt.GetNoSeriesWithCheck(NoSeriesCode, SelectNoSeriesAllowed, I9G_NoSeries));
        exit(NoSeriesCode);
    end;

    procedure SetAllowSelectNoSeries()
    begin
        SelectNoSeriesAllowed := TRUE;
    end;

    procedure AssistEdit(OldRec: Record MaxxholoHeader): Boolean
    var
        NoSeries: Codeunit "No. Series";
    begin
        grec_MaxxholoSetup.Get();
        // IF NoSeriesMgt.SelectSeries(GetNoSeriesCode, OldRec.I9G_NoSeries, I9G_NoSeries) THEN BEGIN
        //     NoSeriesMgt.SetSeries(I9G_DocNo);
        //     EXIT(TRUE);
        // END;
        if NoSeries.LookupRelatedNoSeries(GetNoSeriesCode(), OldRec.I9G_NoSeries, I9G_NoSeries) then begin
            I9G_DocNo := NoSeries.GetNextNo(I9G_NoSeries);
            exit(true);
        end;
    end;

    procedure InitInsert()
    var
        IsHandled: Boolean;
        NoSeries: Codeunit "No. Series";
    begin
        grec_MaxxholoSetup.Get();
        if I9G_DocNo = '' then begin
            grec_MaxxholoSetup.TestField(I9G_MaxxholoNos);
            // NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec.I9G_NoSeries, Today, I9G_DocNo, I9G_NoSeries);

            if NoSeries.AreRelated(GetNoSeriesCode(), xRec.I9G_NoSeries) then
                I9G_NoSeries := xRec.I9G_NoSeries
            else
                I9G_NoSeries := GetNoSeriesCode();
            I9G_DocNo := NoSeries.GetNextNo(I9G_NoSeries, Today);
        end;
        InitRecord;
    end;

    procedure InitRecord()
    var
        ArchiveManagement: Codeunit ArchiveManagement;
        IsHandled: Boolean;
    begin
        // grec_MaxxholoSetup.Get();
        // NoSeriesMgt.SetDefaultSeries(I9G_NoSeries, grec_MaxxholoSetup.I9G_MaxxholoNos);
    end;

}