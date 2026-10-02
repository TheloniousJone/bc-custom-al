page 66001 "Maxxholo Label Doc."
{
    PageType = Document;
    // ApplicationArea = All;
    // UsageCategory = Administration;
    SourceTable = MaxxholoHeader;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(I9G_DocNo; Rec.I9G_DocNo)
                {
                    ApplicationArea = All;
                    trigger OnAssistEdit()
                    begin
                        IF Rec.AssistEdit(xRec) THEN begin
                            CurrPage.UPDATE;
                        end;
                    end;

                }
                field(I9G_NoSeries; Rec.I9G_NoSeries)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Label ID field.';
                    // Visible = false;
                    Editable = false;
                }
                field(I9G_SourceTable; Rec.I9G_SourceTable)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Table field.';
                    // Visible = false;
                    Editable = false;
                }
                field(I9G_SourceDocNo; Rec.I9G_SourceDocNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Document No. field.';
                    // Visible = false;
                    Editable = false;
                }
                field(I9G_SourceDocLineNo; Rec.I9G_SourceDocLineNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Document Line No. field.';
                    // Visible = false;
                    Editable = false;
                }
                field(I9G_TargetTable; Rec.I9G_TargetTable)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Target Table field.';
                    // Visible = false;
                    Editable = false;
                }
                field(I9G_TargetDocNo; Rec.I9G_TargetDocNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Target Document No. field.';
                    Editable = false;
                }
                field(I9G_TargetDocLineNo; Rec.I9G_TargetDocLineNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Target Document Line No. field.';
                    Editable = false;
                }
                field(I9G_BatchID; Rec.I9G_BatchID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Batch ID field.';
                }
                field(I9G_ShipCode; Rec.I9G_ShipCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship Code field.';
                }
                field(I9G_ShipName; Rec.I9G_ShipName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship Name field.';
                }
                field(I9G_ShipAddress; Rec.I9G_ShipAddress)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship Address field.';
                }
                field(I9G_BillCode; Rec.I9G_BillCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bill Code field.';
                }
                field(I9G_BillName; Rec.I9G_BillName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bill Name field.';
                }
                field(I9G_BillAddress; Rec.I9G_BillAddress)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bill Address field.';
                }
                field(I9G_ProductCode; Rec.I9G_ProductCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Code field.';
                }
                field(I9G_ProductName; Rec.I9G_ProductName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Name field.';
                }
                field(I9G_QRCodeText; Rec.I9G_QRCodeText)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the QR Code Text field.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                    Visible = false;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                    Visible = false;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                    Visible = false;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                    Visible = false;
                }
                field(I9G_SentMaxxholo; Rec.I9G_SentMaxxholo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sent to Maxxholo field.';
                }
                field(I9G_ResponseFrmMaxxholo; Rec.I9G_ResponseFrmMaxxholo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Response From Maxxholo field.';
                    MultiLine = true;
                }


            }
            part(MaxxholoLabelSubform; "Maxxholo Label Subform")
            {
                Enabled = Rec.I9G_DocNo <> '';
                UpdatePropagation = Both;
                SubPageLink = I9G_DocNo = field(I9G_DocNo);
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SendToMaxxholo)
            {
                ApplicationArea = All;
                Caption = 'Send to Maxxholo';
                Image = SendTo;

                trigger OnAction()
                var
                    lrec_CheckingHeader: Record "Checking Header";
                    lcdu_MaxxholoIntegration: Codeunit "Maxxholo Integration";
                    lrec_CheckingHeaderLine: Record "Checking Line";
                begin
                    lrec_CheckingHeader.Reset();
                    lrec_CheckingHeader.SetRange("No.", Rec.I9G_SourceDocNo);
                    if lrec_CheckingHeader.FindFirst() then begin
                        Clear(lcdu_MaxxholoIntegration);
                        lcdu_MaxxholoIntegration.sendToMaxxholo(lrec_CheckingHeader, Rec.I9G_SourceDocLineNo);
                    end;
                end;
            }
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
    //     // if Rec.I9G_DocNo <> '' then begin
    //     //     Rec.I9G_SourceTable := genum_SourceDocType;
    //     //     Rec.I9G_SourceDocNo := gcd_SourceDocNo;
    //     //     Rec.I9G_SourceDocLineNo := gint_SourceDocLineNo;
    //     //     Rec.Validate(I9G_ProductCode, gcd_ItemNo);
    //     // end;
    // end;

    // trigger OnOpenPage()
    // begin
    //     Rec.I9G_SourceTable := genum_SourceDocType;
    //     Rec.I9G_SourceDocNo := gcd_SourceDocNo;
    //     Rec.I9G_SourceDocLineNo := gint_SourceDocLineNo;
    //     Rec.Validate(I9G_ProductCode, gcd_ItemNo);
    // end;

    // procedure assignSourceValue(par_SourceDocType: Enum "Document Type"; var par_SourceDocNo: Code[20]; var par_SourceDocLineNo: Integer; var par_ItemNo: Code[20])
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