pageextension 60102 WellCustCardPageExt extends "Customer List"
{
    layout
    {

    }
    actions
    {
        addfirst(Create)
        {
            action("Patients")
            {
                ApplicationArea = All;
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Patient List";
            }
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
                        SyncCU.SyncCustRec(Rec."No.");
                    end;
                end;
            }
            //DX        01 Aug 2021
        }
    }
}
