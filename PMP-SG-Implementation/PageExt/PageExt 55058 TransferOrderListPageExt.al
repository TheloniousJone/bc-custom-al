pageextension 55058 TransferOrderListPageExt extends "Transfer Orders"
{
    layout
    {
        addafter("No.")
        {
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = all;
            }
            field("Transfer-To Bin Code"; Rec."Transfer-To Bin Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transfer-To Bin Code field.', Comment = '%';
            }
            //DX        11 Oct 2021
            field(SystemCreatedBy; enhanceCU.GetUsername(Rec.SystemCreatedBy))
            {
                ApplicationArea = all;
            }
            //DX        11 Oct 2021
        }

    }
    //DX        05 Sept 2021
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        //        rec.SetFilter(SystemCreatedBy, '%1', UserSecurityId());
    end;
    //DX        05 Sept 2021
    var
        EnhanceCU: Codeunit "PMP-Enhancements";
}
