report 57133 WarehouseStockTakeReport
{

    RDLCLayout = './ReportLayouts/ReportLayout 57133 - WarehouseStockTakeReport.rdl';
    Caption = 'Warehouse Stock Take Report';
    PreviewMode = PrintLayout;
    DefaultLayout = RDLC;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Warehouse Journal Line"; "Warehouse Journal Line")
        {
            DataItemTableView = sorting("Journal Template Name", "Journal Batch Name")
                        where("Journal Template Name" = const('PHYSICAL I'));

            column(Line_No_; "Line No.") { }
            column(Journal_Batch_Name; "Journal Batch Name") { }
            column(Entry_Type; "Entry Type") { }
            column(Item_No_; "Item No.") { }
            column(Description; Description) { }
            column(Bin_Code; "Bin Code") { }
            column(Lot_No_; "Lot No.") { }
            column(Expiration_Date; "Expiration Date") { }
            column(Qty___Calculated_; "Qty. (Calculated)") { }
            column(Qty___Phys__Inventory_; "Qty. (Phys. Inventory)") { }
            column(Quantity; Quantity) { }

        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInfo.SetAutoCalcFields(Picture);
        CompanyInfo.Get();

        GLSetup.Get();
        FormatAddr.Company(CompanyAddr, CompanyInfo);

    end;


    var
        FormatAddr: Codeunit "Format Address";
        CompanyInfo: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        GLAccount: Record "G/L Account";
        Currency: Record Currency;
        CompanyAddr: array[8] of Text[100];
}
