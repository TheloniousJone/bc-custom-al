page 59019 "POM Payt Recon List"
{

    ApplicationArea = All;
    Caption = 'POM Payment Reconciliation List';
    PageType = List;
    SourceTable = "POM Payt Recon Buffer";
    UsageCategory = Lists;
    SourceTableTemporary = true;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }

                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = All;
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        SHRec: Record "Sales Header";
                        SalesOrderPage: Page "Sales Order";
                    begin
                        Clear(SalesOrderPage);

                        if SHRec.Get(SHRec."Document Type"::Order, Rec."Sales Order No.") then begin
                            SalesOrderPage.SetRecord(SHRec);
                            SalesOrderPage.Editable(false);
                            SalesOrderPage.RunModal();
                        end;
                    end;
                }

                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }

                field("POM Reference No."; Rec."POM Reference No.")
                {
                    ApplicationArea = All;
                }

                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                }

                field("Paid Amount"; Rec."Paid Amount")
                {
                    ApplicationArea = All;
                }

                field("Invoiced Amount"; Rec."Invoiced Amount")
                {
                    ApplicationArea = All;
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        SIHRec: Record "Sales Invoice Header";
                        SalesInvoiceList: Page "Posted Sales Invoices";
                    begin
                        Clear(SalesInvoiceList);
                        SIHRec.Reset;
                        SIHRec.SetRange("Your Reference", Rec."POM Reference No.");
                        // Page.RunModal(Page::"Posted Sales Invoices", SIHRec);
                        SalesInvoiceList.SetTableView(SIHRec);
                        SalesInvoiceList.SetRecord(SIHRec);
                        // SalesInvoiceList.Editable(false);
                        SalesInvoiceList.RunModal();
                    end;
                }

                field("Amount Difference"; Rec."Amount Difference")
                {
                    ApplicationArea = All;
                }
            }
        }
    }


    trigger OnOpenPage()
    begin
        GetDataFromQuery();
    end;

    local procedure GetDataFromQuery()
    var
        EntryNo: Integer;
        PaytReconQuery: Query "POM Payt Recon Query";
        PaytReconPSIQuery: Query "POM Payt Recon PSI Query"; // YF 21 Sep 2022
        SRSetup: Record "Sales & Receivables Setup";
    begin
        EntryNo := 0;
        SRSetup.Get;

        if SRSetup."POM Collect Payt Method Filter" <> '' then begin
            PaytReconQuery.SetRange(Payment_Method_Code, SRSetup."POM Collect Payt Method Filter");
            PaytReconPSIQuery.SetRange(Payment_Method_Code, SRSetup."POM Collect Payt Method Filter"); // YF 21 Sep 2022
        end;

        if PaytReconQuery.Open() then begin
            while PaytReconQuery.Read() do begin
                EntryNo += 1;
                Rec.Reset();
                Rec.Init();
                Rec."Entry No." := EntryNo;
                Rec."Sales Order No." := PaytReconQuery.No_;
                Rec."Customer No." := PaytReconQuery.Sell_to_Customer_No_;
                Rec."POM Reference No." := PaytReconQuery.Your_Reference;
                Rec."Order Date" := PaytReconQuery.Posting_Date;
                Rec."Paid Amount" := PaytReconQuery.Amount_Collected_by_POM;
                Rec."Invoiced Amount" := PaytReconQuery.Amount_Including_VAT;
                Rec."Amount Difference" := PaytReconQuery.Amount_Collected_by_POM - PaytReconQuery.Amount_Including_VAT;
                Rec."Posted Sales Invoice No." := '';
                Rec.Insert(false);
            end;
        end;
        PaytReconQuery.Close();

        // YF 21 Sep 2022
        if PaytReconPSIQuery.Open() then begin
            while PaytReconPSIQuery.Read() do begin
                if (PaytReconPSIQuery.Amount_Collected_by_POM - PaytReconPSIQuery.Amount_Including_VAT) <> 0 then begin
                    EntryNo += 1;
                    Rec.Reset();
                    Rec.Init();
                    Rec."Entry No." := EntryNo;
                    Rec."Sales Order No." := PaytReconPSIQuery.Order_No_;
                    Rec."Customer No." := PaytReconPSIQuery.Sell_to_Customer_No_;
                    Rec."POM Reference No." := PaytReconPSIQuery.Your_Reference;
                    Rec."Order Date" := PaytReconPSIQuery.Posting_Date;
                    Rec."Paid Amount" := PaytReconPSIQuery.Amount_Collected_by_POM;
                    Rec."Invoiced Amount" := PaytReconPSIQuery.Amount_Including_VAT;
                    Rec."Amount Difference" := PaytReconPSIQuery.Amount_Collected_by_POM - PaytReconPSIQuery.Amount_Including_VAT;
                    Rec."Posted Sales Invoice No." := PaytReconPSIQuery.No_;
                    Rec.Insert(false);
                end;
            end;
        end;
        PaytReconPSIQuery.Close();
        // YF 21 Sep 2022  
    end;
}
