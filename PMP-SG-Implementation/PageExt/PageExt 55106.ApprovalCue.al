pageextension 55106 ApprovalCue extends "Approvals Activities"

{
    layout
    {
        // Add changes to page layout here
        addafter("Requests to Approve")
        {
            field("Approved Request"; Rec."Approved Request")
            {
                ApplicationArea = all;
                DrillDownPageId = "Approval Entries";
                
            }

        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}

