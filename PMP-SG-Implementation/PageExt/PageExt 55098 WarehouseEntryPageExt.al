pageextension 55098 WarehouseEntryPageExt extends "Warehouse Entries"
{
    layout
    {
        //DX        11 Oct 2021
        addafter("Item No.")
        {
            // field(SystemCreatedBy; enhanceCU.GetUsername(Rec.SystemCreatedBy))
            // {
            //     ApplicationArea = all;
            // }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
                Caption = 'Created At';
                Editable = false;
            }
            field(SystemCreatedBy; enhanceCU.GetUsername(Rec.SystemCreatedBy))  // CL 23 July 2024
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
            field(SystemModifiedBy; enhanceCU.GetUsername(Rec.SystemModifiedBy))  // CL 23 July 2024
            {
                ApplicationArea = All;
                Caption = 'Modified By';
                Editable = false;
            }
        }

        //DX        11 Oct 2021
        //RL    12 Jan 2022
        addafter(Description)
        {
            field(Remarks; Rec.Remarks)
            {
                ApplicationArea = All;
            }
        }
        //RL    12 Jan 2022
        addafter(Quantity)
        {
            field("Qty. Calculated"; Rec."Qty. Calculated")
            {
                ApplicationArea = all;
            }
            field("Qty. Phy Count"; Rec."Qty. Phy Count")
            {
                ApplicationArea = all;
            }
        }
    }
    var
        EnhanceCU: Codeunit "PMP-Enhancements";
}
