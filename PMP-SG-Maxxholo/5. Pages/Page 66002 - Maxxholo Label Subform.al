page 66002 "Maxxholo Label Subform"
{
    PageType = ListPart;
    // ApplicationArea = All;
    // UsageCategory = Administration;
    SourceTable = MaxxholoLine;
    DelayedInsert = true;
    MultipleNewLines = true;
    AutoSplitKey = true;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(I9G_DocNo; Rec.I9G_DocNo)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(I9G_LineNo; Rec.I9G_LineNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Label ID field.';
                    Visible = false;
                    Editable = false;
                }
                field(I9G_LabelID; Rec.I9G_LabelID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Label ID field.';
                }
                field(I9G_LotNo; Rec.I9G_LotNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lot No. field.';
                }
                field(I9G_SourceTable; Rec.I9G_SourceTable)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Table field.';
                    Visible = false;
                    Editable = false;
                }
                field(I9G_SourceDocNo; Rec.I9G_SourceDocNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Document No. field.';
                    Visible = false;
                    Editable = false;
                }
                field(I9G_SourceDocLineNo; Rec.I9G_SourceDocLineNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Document Line No. field.';
                    Visible = false;
                    Editable = false;
                }
                field(I9G_TargetTable; Rec.I9G_TargetTable)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Target Table field.';
                    Visible = false;
                    Editable = false;
                }
                field(I9G_TargetDocNo; Rec.I9G_TargetDocNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Target Document No. field.';
                    Visible = false;
                    Editable = false;
                }
                field(I9G_TargetDocLineNo; Rec.I9G_TargetDocLineNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Target Document Line No. field.';
                    Visible = false;
                    Editable = false;
                }
                field(I9G_BatchID; Rec.I9G_BatchID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Batch ID field.';
                    Visible = false;
                }
                field(I9G_ShipCode; Rec.I9G_ShipCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship Code field.';
                    Visible = false;
                }
                field(I9G_ShipName; Rec.I9G_ShipName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship Name field.';
                    Visible = false;
                }
                field(I9G_ShipAddress; Rec.I9G_ShipAddress)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship Address field.';
                    Visible = false;
                }
                field(I9G_BillCode; Rec.I9G_BillCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bill Code field.';
                    Visible = false;
                }
                field(I9G_BillName; Rec.I9G_BillName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bill Name field.';
                    Visible = false;
                }
                field(I9G_BillAddress; Rec.I9G_BillAddress)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bill Address field.';
                    Visible = false;
                }
                field(I9G_ProductCode; Rec.I9G_ProductCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Code field.';
                    Visible = false;
                }
                field(I9G_ProductName; Rec.I9G_ProductName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Name field.';
                    Visible = false;
                }
                field(I9G_QRCodeText; Rec.I9G_QRCodeText)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the QR Code Text field.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {

        }
    }

    var
        genum_SourceDocType: Enum "Document Type";
        gcd_SourceDocNo: Code[20];
        gint_SourceDocLineNo: Integer;
        gcd_ItemNo: Code[20];

    // trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    // var

    // begin
    //     if Rec.I9G_LabelID <> '' then begin
    //         Rec.I9G_SourceTable := genum_SourceDocType;
    //         Rec.I9G_SourceDocNo := gcd_SourceDocNo;
    //         Rec.I9G_SourceDocLineNo := gint_SourceDocLineNo;
    //         Rec.Validate(I9G_ItemNo, gcd_ItemNo);
    //     end;
    // end;

    // procedure assignSourceValue(par_SourceDocType: Enum "Document Type"; par_SourceDocNo: Code[20]; par_SourceDocLineNo: Integer; par_ItemNo: Code[20])
    // begin
    //     Clear(genum_SourceDocType);
    //     Clear(gcd_SourceDocNo);
    //     Clear(gint_SourceDocLineNo);
    //     Clear(gcd_ItemNo);

    //     genum_SourceDocType := par_SourceDocType;
    //     gcd_SourceDocNo := par_SourceDocNo;
    //     gint_SourceDocLineNo := par_SourceDocLineNo;
    //     gcd_ItemNo := par_ItemNo;
    // end;
}