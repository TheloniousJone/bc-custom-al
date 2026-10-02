pageextension 70153 ItemLedgerEntryPageExt extends "Item Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field(I9G_CaseNumber; Rec.I9G_CaseNumber)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
            field(I9G_CaseDR; Rec.I9G_CaseDR)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
            field(I9G_ShipToDistrictCode; Rec.I9G_ShipToDistrictCode)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
            field(I9G_ShipToPostCode; Rec.I9G_ShipToPostCode)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
        }
        addafter("Location Code")
        {
            field("Last Invoice Date"; Rec."Last Invoice Date")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addafter("Application Worksheet")
        {
            action(InventoryTurnover)
            {
                Caption = 'Inventory Turnover Analysis';
                ApplicationArea = All;
                Visible = CustomizedVisible;
                Image = Report;
                PromotedCategory = Report;
                Promoted = true;

                trigger OnAction()
                var
                    ItemLedgEnt: Record "Item Ledger Entry";
                    InvtTurnoverReport: Report InventoryTurnover;
                begin
                    Report.Run(70051, true, false, ItemLedgEnt);
                end;
            }
            action(ImportDimensions)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import Dimensions';
                Image = MapDimensions;
                ToolTip = 'Update dimension values for current records.';
                Visible = CustomizedVisible;
                PromotedCategory = Process;
                Promoted = true;
                trigger OnAction()
                var
                    I9G_ImportDimensionsCodeUnit: Codeunit I9G_ImportDimensionsIle;
                begin
                    I9G_ImportDimensionsCodeUnit.ImportExcel();
                end;
            }

        }
    }

    trigger OnOpenPage()
    var
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();
    end;

    var
        I9G_NovemEventSubscribersCodeUnit: Codeunit I9G_NovemEventSubscribers;
        CustomizedVisible: Boolean;
}