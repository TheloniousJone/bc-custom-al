page 55013 "WH Trip Subform"
{

    Caption = 'WH Trip Subform';
    PageType = ListPart;
    SourceTable = "WH Trip Line";
    AutoSplitKey = true;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Pick Doc No."; Rec."Pick Doc No.")
                {
                    ToolTip = 'Specifies the value of the Pick Doc No. field';
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        myInt: Integer;
                        PickCard: Page 5779;
                        PickRec: Record "Warehouse Activity Header";
                        RegPickcard: Page "Registered Pick";
                        RegPic: Record "Registered Whse. Activity Hdr.";
                    begin
                        //if Rec."Basket No." = '' then
                        //    Error('Please select Basket for this picking list first before viewing the document.');

                        PickRec.reset;
                        PickRec.SetRange("No.", Rec."Pick Doc No.");
                        if pickrec.FindFirst() then begin
                            Clear(PickCard);
                            PickCard.SetTableView(PickRec);
                            PickCard.Editable(true);
                            PickCard.Run();
                        end else begin
                            RegPic.reset;
                            RegPic.SetRange("Whse. Activity No.", Rec."Pick Doc No.");
                            if RegPic.FindFirst() then begin
                                Clear(RegPickcard);
                                RegPickcard.SetTableView(RegPic);
                                RegPickcard.Editable(true);
                                RegPickcard.Run();
                            end;
                        end;
                    end;
                }
                field("Basket No."; Rec."Basket No.")
                {
                    ApplicationArea = all;
                    Editable = false;

                    trigger OnValidate()
                    var
                        myInt: Integer;
                        ALERec: Record "Assignment Ledger Entry";
                    begin

                    end;
                }
                field("2nd Pick for Cold Room"; Rec."2nd Pick")
                {
                    ApplicationArea = all;
                    Editable = false;
                }

                field("Priority Pick"; Priority)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Source Name"; Rec."Source Name")
                {
                    ToolTip = 'Specifies the value of the Source Name field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Source No."; Rec."Source No.")
                {
                    ToolTip = 'Specifies the value of the Source No. field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Line Completed"; Rec."Line Completed")
                {
                    ToolTip = 'Specifies the value of the Line Completed field';
                    ApplicationArea = All;
                    Editable = false;
                    trigger OnValidate()
                    begin
                        if WHTBA.IsTBA(Rec."Doc No.") then
                            WHCU.UpdateTripEndDateTime(rec."Doc No.");
                    end;
                }
            }
        }



    }
    actions
    {
        area(Processing)
        {

        }
    }


    trigger OnDeleteRecord(): Boolean
    var
        myInt: Integer;

    begin
        if Rec."Line Completed" = false then begin
            if Confirm('Are you sure you wish to delete this picking line from this trip?') then begin
                WHCU.DeletePickLineFromWHTrip(Rec);
            end;
        end else begin
            Message('Cannot delete completed picks.');
        end;

    end;

    trigger OnAfterGetRecord()
    var
        ALERec: Record "Assignment Ledger Entry";
    begin
        ALERec.Reset();
        ALERec.SetLoadFields("Picking Doc No.", "Pick Type");    //DX        02 May 2023
        ALERec.SetCurrentKey("Picking Doc No.");    //DX        24 May 2023
        ALERec.SetAscending("Picking Doc No.", false);   //DX        24 May 2023
        ALERec.SetRange("Picking Doc No.", Rec."Pick Doc No.");
        if ALERec.FindFirst() then
            Priority := ALERec."Priority Picking";
    end;

    trigger OnAfterGetCurrRecord()
    var
        ALERec: Record "Assignment Ledger Entry";
    begin
        ALERec.Reset();
        ALERec.SetLoadFields("Picking Doc No.", "Pick Type");    //DX        02 May 2023
        ALERec.SetCurrentKey("Picking Doc No.");    //DX        24 May 2023
        ALERec.SetAscending("Picking Doc No.", false);   //DX        24 May 2023
        ALERec.SetRange("Picking Doc No.", Rec."Pick Doc No.");
        if ALERec.FindFirst() then
            Priority := ALERec."Priority Picking";
    end;

    var
        WHCU: codeunit "Warehouse CU";
        WHTBA: Codeunit tba;
        Priority: Boolean;
}
