page 55010 "Picker Assign List"
{
    PageType = List;
    Caption = 'Picking Lists';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Assignment Ledger Entry";
    Editable = false;

    layout
    {
        area(Content)
        {
            Repeater(Details)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Name; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Picking Doc No."; Rec."Picking Doc No.")
                {
                    ApplicationArea = all;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Start Time"; Rec."Start Time")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("End Time"; Rec."End Time")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Picker; Rec.Picker)
                {
                    ApplicationArea = all;
                    Editable = true;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
  
    end;

    var
        PMPCU: Codeunit "Warehouse CU";
        EnhanceCU: Codeunit "PMP-Enhancements";
}