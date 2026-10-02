pageextension 55063 WarehouseShipmentExt extends "Warehouse Shipment"
{
    layout
    {
        // layout changes here
        addafter(General)
        {
            field("Shipping No."; Rec."Shipping No.")
            {
                ApplicationArea = all;
            }
        }

        addafter ("Sorting Method")
        {
            field(SystemCreatedAt;Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
                Caption = 'Created At';
                Editable = false;
            }
            field(SystemCreatedBy;Rec.SystemCreatedBy)
            {
                ApplicationArea = All;
                Caption = 'Created By';
                Editable = false;
            }
            field(SystemModifiedAt; Rec.SystemModifiedAt)
            {
                ApplicationArea = All;
                Caption = 'Modified At';
                Editable = false;
            }
            field(SystemModifiedBy;Rec.SystemModifiedBy)
            {
                ApplicationArea = All;
                Caption = 'Modified By';
                Editable = false;
            }
        }
    }

    actions
    {
        modify("Create Pick")
        {
            ApplicationArea = All;

            trigger OnAfterAction()
            var
                WhseCU: Codeunit "Warehouse CU";
            begin
                WhseCU.CreateAssignmentLedgerWithPickList(Rec);
            end;
        }

    }
}
