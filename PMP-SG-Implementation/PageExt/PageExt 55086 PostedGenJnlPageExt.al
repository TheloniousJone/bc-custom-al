pageextension 55086 PostedGenJnlPageExt extends "Posted General Journal"
{
    layout
    {
        modify("Journal Batch Name")
        {
            ApplicationArea = All;
            Visible = true;
        }

        addafter("Journal Batch Name")
        {
            field("Journal Batch Description"; Rec."Journal Batch Description")
            {
                ApplicationArea = All;
            }
        }
        //RL    18 Feb 2022  Start
        addafter(Description)
        {
            field("Payment Reference"; Rec."Payment Reference")
            {
                ApplicationArea = all;
            }
        }
        //RL    18 Feb 2022  End
    }


    trigger OnAfterGetCurrRecord()
    begin
        GetPostedJournalBatchDescr();
    end;

    trigger OnAfterGetRecord()
    begin
        GetPostedJournalBatchDescr();
    end;

    local procedure GetPostedJournalBatchDescr()
    var
        PostedGenJnlBatch: Record "Posted Gen. Journal Batch";
    begin
        PostedGenJnlBatch.Reset();
        PostedGenJnlBatch.SetRange("Journal Template Name", Rec."Journal Template Name");
        PostedGenJnlBatch.SetRange(Name, Rec."Journal Batch Name");
        if PostedGenJnlBatch.FindFirst() then
            Rec."Journal Batch Description" := PostedGenJnlBatch.Description;
    end;

}
