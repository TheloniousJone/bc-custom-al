pageextension 60110 WellItemCardPageExt extends "Item Card"
{
    layout
    {
        //DX        15 Aug 2021
        addafter("Packing Instructions")
        {
            field("Prescription 1"; Rec."Prescription 1")
            {
                ApplicationArea = all;
                MultiLine = true;
            }
            field("Prescription 2"; Rec."Prescription 2")
            {
                ApplicationArea = all;
                MultiLine = true;
            }
        }
        //DX        15 Aug 2021
    }
    actions
    {
        addafter("Historial OB Transactions")
        {
            //DX        01 Aug 2021
            action("Sync Record")
            {
                ApplicationArea = all;
                Image = Task;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    myInt: Integer;
                    SyncCU: Codeunit WellawaySync;
                begin
                    if Confirm('Are you sure you wish to synchronize this record?') then begin
                        SyncCU.SyncPMPItemRec(Rec."No.");
                    end;
                end;
            }
            //DX        01 Aug 2021
        }

    }
}
