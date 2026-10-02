pageextension 80148 PostedSalesCrMmListExt3PL extends "Posted Sales Credit Memos"
{
    actions
    {
        addlast(processing)
        {
            action("SalesCreditNotes3PL")
            {
                Caption = 'Sales Credit Notes (3PL)';
                ApplicationArea = All;
                Image = SalesCreditMemo;
                ToolTip = 'Print Sales Credit Notes (3PL).';
                trigger OnAction()
                var
                    SalesCreditNotesReport: Report I9G_PostedSalesCreditNote3PL;
                    SalesCrMemoHeaderRec: Record "Sales Cr.Memo Header";
                    I9G_ThirdPartyLogisticCodeUnit: Codeunit I9G_ThirdPartyLogisticCU;
                    RecRef: RecordRef;
                    CompanyInformationRec: Record "Company Information";
                begin
                    CompanyInformationRec.Get();
                    if CompanyInformationRec.Name = 'Novem Healthcare Pte Ltd' then begin
                        SalesCrMemoHeaderRec.Reset();
                        CurrPage.SetSelectionFilter(SalesCrMemoHeaderRec);
                        Report.RunModal(80143, true, false, SalesCrMemoHeaderRec);
                    end else begin
                        SalesCrMemoHeaderRec.Reset();
                        CurrPage.SetSelectionFilter(SalesCrMemoHeaderRec);
                        RecRef.GetTable(SalesCrMemoHeaderRec);
                        SalesCreditNotesReport.GetReportOptionAndFilter(Rec.I9G_FromCompanyName, I9G_ThirdPartyLogisticCodeUnit.GetSelectionFilter(RecRef, SalesCrMemoHeaderRec.FieldNo("No.")));
                        SalesCreditNotesReport.RunModal();
                    end;
                end;
            }
        }
        addlast(Category_Category7)
        {
            actionref(SalesCreditNotes3PL_Promoted; SalesCreditNotes3PL) { }
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