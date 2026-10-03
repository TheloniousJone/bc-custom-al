report 57015 "Salesperson Balance Report"
{
    ApplicationArea = All;
    Caption = 'Salesperson Balance Report';
    RDLCLayout = './ReportLayouts/ReportLayout 57015 - Salesperson Balance Report.rdl';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            DataItemTableView = sorting("Entry No.", "Posting Date");
            column(Quantity; Quantity)
            {
            }
            column(RemainingQuantity; "Remaining Quantity")
            {
            }
            column(UnitofMeasureCode; "Unit of Measure Code")
            {
            }
            column(Item_No_; "Item No.")
            {

            }
            column(ItemDesc; ItemDesc)
            {

            }
            column(LotNo; "Lot No.")
            {
            }
            column(ExpirationDate; FORMAT("Expiration Date"))
            {
            }
            column(Posting_Date; Format("Posting Date"))
            {


            }
            column(DocumentNo; "Document No.")
            {
            }
            column(DocumentType; "Document Type")
            {
            }
            column(SPCode; SPCode)
            {

            }
            column(SPName; SPName)
            {

            }
            column(HideDetail; HideDetail)
            {

            }

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                if StartDate > EndDate then
                    Error('Start date must be before end date.');

                ItemLedgerEntry.SetRange("Location Code", LocCode);
                ItemLedgerEntry.SetFilter("Posting Date", '..%1', StartDate);
            end;

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                SPCode := '';
                SPCode := GetSPCode(ItemLedgerEntry."Dimension Set ID");
                SPName := GetSPName(SPCode);
                if ItemLedgerEntry."Item No." <> '' then begin
                    ItemRec.reset;
                    ItemRec.SetRange("No.", ItemLedgerEntry."Item No.");
                    if ItemRec.FindFirst() then begin
                        ItemDesc := ItemRec.Description;
                    end else
                        ItemDesc := '';
                end;
            end;
        }

    }


    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field("Start Date"; StartDate)
                    {
                        ApplicationArea = all;
                        Caption = 'As Of Date';
                    }
                    field("End Date"; EndDate)
                    {
                        ApplicationArea = all;
                        Visible = false;
                        Caption = 'End Date';

                    }
                    field(HideDetail; HideDetail)
                    {
                        ApplicationArea = all;
                        Caption = 'Check to unhide details';
                    }
                    field(LocCode; LocCode)
                    {
                        ApplicationArea = all;
                        Caption = 'Select Location';
                        TableRelation = Location.Code;
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {

            }
        }
    }

    trigger OnPreReport()
    var
        myInt: Integer;
    begin

    end;

    trigger OnInitReport()
    var
        myInt: Integer;
    begin
        StartDate := Today;
        EndDate := today;
        HideDetail := true;
        LocCode := 'SAMPLE';
    end;

    local procedure GetSPCode(DimSetID: Integer): code[50]
    var
        myInt: Integer;
        DimSetRec: Record "Dimension Set Entry";
        SSSetup: Record "Sales & Receivables Setup";
    begin
        SSSetup.reset;
        SSSetup.get;
        SSSetup.TestField("Salesperson Dimension Code");

        DimSetRec.reset;
        DimSetRec.SetRange("Dimension Set ID", DimSetID);
        DimSetRec.SetRange("Dimension Code", SSSetup."Salesperson Dimension Code");
        if DimSetRec.FindFirst() then begin
            exit(DimSetRec."Dimension Value Code");
        end;
    end;

    local procedure GetSPName(SPCode: Code[50]): Text[100]
    var
        myInt: Integer;
        SPRec: Record "Salesperson/Purchaser";
    begin
        SPRec.reset;
        SPRec.SetRange(Code, SPCode);
        if SPRec.FindFirst() then
            exit(SPRec.Name)
        else
            exit(SPRec.Code);
    end;

    var
        StartDate: date;
        EndDate: date;
        SPCode: Code[50];
        SPName: Text[100];
        HideDetail: Boolean;
        ItemRec: Record Item;
        ItemDesc: Text[100];
        LocCode: Code[20];

}
