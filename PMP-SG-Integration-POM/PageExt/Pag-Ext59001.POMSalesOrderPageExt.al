pageextension 59001 POMSalesOrderPageExt extends "Sales Order"
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
                trigger OnValidate()
                var
                    PaymentTermsRec: Record "Payment Terms";
                    CustRec: Record Customer;
                    PaymentMethodRec: Record "Payment Method";

                begin
                    If Rec."Amount Collected by POM" <> 0 then begin
                        if PaymentTermsRec.Get('CREDITCARD') then
                            Rec.Validate("Payment Terms Code", 'CREDITCARD');
                        if PaymentMethodRec.Get('CREDITCARD') then
                            Rec.Validate("Payment Method Code", 'CREDITCARD');
                    end else begin
                        if CustRec.get(Rec."Bill-to Customer No.") then begin
                            Rec.Validate("Payment Terms Code", CustRec."Payment Terms Code");
                            Rec.Validate("Payment Method Code", CustRec."Payment Method Code");
                        end;
                    end;
                end;
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

    actions
    {
        modify("Create &Warehouse Shipment")
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
                SIHRec: Record "Sales Header";
                TotalInvAmtDec: Decimal;
            begin
                //DX        03 Apr 2026 As requested by SAbrina, to only allow pom orders to go to warehouse if Invoice amount is < amount collected by POM

            end;
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
