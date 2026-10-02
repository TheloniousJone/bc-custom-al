pageextension 80142 PostedSalesInvoiceCardExt3PL extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Salesperson Code")
        {
            field(I9G_CustVendCode; Rec.I9G_CustVendCode)
            {
                ApplicationArea = all;
            }
            field(I9G_CustVendName; Rec.I9G_CustVendName)
            {
                ApplicationArea = all;
            }
            field(I9G_NovemShipToAddress; Rec.I9G_NovemShipToAddress)
            {
                ApplicationArea = all;
            }
            field(I9G_NovemShipToAddress2; Rec.I9G_NovemShipToAddress2)
            {
                ApplicationArea = all;
            }
            field(I9G_NovemShipToAddress3; Rec.I9G_NovemShipToAddress3)
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action("TaxInvoice3PL")
            {
                Caption = 'Tax Invoice (3PL)';
                ApplicationArea = All;
                Image = SalesInvoice;
                ToolTip = 'Print Tax Invoice (3PL).';
                trigger OnAction()
                var
                    TaxInvoiceReport: Report I9G_TaxInvoice3PL;
                    SalesInvoiceHeaderRec: Record "Sales Invoice Header";
                    I9G_ThirdPartyLogisticCodeUnit: Codeunit I9G_ThirdPartyLogisticCU;
                    RecRef: RecordRef;
                    CompanyInformationRec: Record "Company Information";
                begin
                    CompanyInformationRec.Get();
                    if CompanyInformationRec.Name = 'Novem Healthcare Pte Ltd' then begin
                        SalesInvoiceHeaderRec.Reset();
                        CurrPage.SetSelectionFilter(SalesInvoiceHeaderRec);
                        Report.RunModal(80142, true, false, SalesInvoiceHeaderRec);
                    end else begin
                        SalesInvoiceHeaderRec.Reset();
                        CurrPage.SetSelectionFilter(SalesInvoiceHeaderRec);
                        RecRef.GetTable(SalesInvoiceHeaderRec);
                        TaxInvoiceReport.GetReportOptionAndFilter(Rec.I9G_FromCompanyName, I9G_ThirdPartyLogisticCodeUnit.GetSelectionFilter(RecRef, SalesInvoiceHeaderRec.FieldNo("No.")), Rec.I9G_NovemCustNoOfCopies);
                        TaxInvoiceReport.RunModal();
                    end;
                end;
            }
        }
        addlast(Category_Category6)
        {
            actionref(TaxInvoice3PL_Promoted; TaxInvoice3PL) { }
        }
    }
    trigger OnOpenPage()
    var
        I9G_ThirdPartyLogisticSetupRec: Record I9G_ThirdPartyLogisticSetup;
        I9G_ThirdPartyLogisticCodeUnit: Codeunit I9G_ThirdPartyLogisticCU;
    begin
        ReportVisible := false;
        if (I9G_ThirdPartyLogisticSetupRec.Get()) then begin
            if (I9G_ThirdPartyLogisticSetupRec.I9G_EnableThirdPartyLogistic = true) and (I9G_ThirdPartyLogisticCodeUnit.CheckCompanyName = false) then begin
                ReportVisible := true;
            end;
        end;
    end;

    var
        ReportVisible: Boolean;
}