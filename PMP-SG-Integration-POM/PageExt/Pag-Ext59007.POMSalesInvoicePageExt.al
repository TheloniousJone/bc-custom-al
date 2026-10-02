pageextension 59007 POMSalesInvoicePageExt extends "Sales Invoice"
{
    layout
    {
        addafter("Assigned User ID")
        {
            field("Placed By"; Rec."Placed By")
            {
                ApplicationArea = all;
            }

            // YF 08 Sep 2022
            field("Amount Collected by POM"; Rec."Amount Collected by POM")
            {
                ApplicationArea = All;
            }
            // YF 08 Sep 2022
        }

        addafter(Status)
        {
            field("Invoice Discount Amount"; POM3InvoiceDiscountAmount)
            {
                ApplicationArea = Basic, Suite;
                AutoFormatType = 1;
                Caption = 'Invoice Discount Amount';
                Editable = true; // override for POM3 API, check set at onvalidate
                // Editable = InvDiscAmountEditable;
                Visible = SuppressTotals;
                ToolTip = 'Specifies a discount amount that is deducted from the value of the Total Incl. VAT field, based on sales lines where the Allow Invoice Disc. field is selected. You can enter or change the amount manually.';

                trigger OnValidate()
                var
                    SalesLines: Record "Sales Line";
                    SalesCalcDiscountByType: Codeunit "Sales - Calc Discount By Type";
                    DocumentTotals: Codeunit "Document Totals";
                begin
                    SuppressTotals := false; // override for POM3 (Testing)

                    SalesLines.Reset;
                    SalesLines.SetRange("Document Type", Rec."Document Type");
                    SalesLines.SetRange("Document No.", Rec."No.");
                    if (SalesLines.Count > 0) And InvDiscAmountEditable then begin
                        if SuppressTotals then
                            exit;

                        DocumentTotals.SalesDocTotalsNotUpToDate();
                        SalesCalcDiscountByType.ApplyInvDiscBasedOnAmt(POM3InvoiceDiscountAmount, Rec);
                        DocumentTotals.SalesDocTotalsNotUpToDate();
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SuppressTotals := CurrentClientType() = ClientType::ODataV4;
    end;

    trigger OnAfterGetRecord()
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get;
        CurrPageIsEditable := CurrPage.Editable;
        InvDiscAmountEditable :=
            CurrPageIsEditable and not SalesSetup."Calc. Inv. Discount" and
            (Rec.Status = Rec.Status::Open);
    end;

    var
        POM3InvoiceDiscountAmount: Decimal;
        InvDiscAmountEditable: Boolean;
        CurrPageIsEditable: Boolean;
        SuppressTotals: Boolean;
}
