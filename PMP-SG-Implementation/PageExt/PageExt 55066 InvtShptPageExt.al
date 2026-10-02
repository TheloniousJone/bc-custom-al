pageextension 55066 InvtShptPageExt extends "Invt. Shipment"
{
    layout
    {
        addbefore("External Document No.")
        {
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = All;

                trigger OnValidate()
                var
                    InvtDocLines: Record "Invt. Document Line";
                begin
                    // set all lines to this transfer to gen prod posting group
                    // if Confirm('This will update all lines! Proceed?', false) then begin  //RL 10 Nov 2021 - remove prompt
                    InvtDocLines.Reset;
                    InvtDocLines.SetRange("Document No.", Rec."No.");
                    if InvtDocLines.FindSet() then
                        repeat
                            // update transfer to bin code for line
                            InvtDocLines."Customer No." := Rec."Customer No.";
                            InvtDocLines.Modify(false);
                        until InvtDocLines.Next() = 0;

                    CurrPage.ShipmentLines.Page.Update();
                    // end
                    // else
                    //     Error('Update cancelled');
                end;
            }
        }

        modify("Salesperson/Purchaser Code")
        {
            ApplicationArea = All;

            trigger OnAfterValidate()
            var
                InvtDocLines: Record "Invt. Document Line";
            begin
                // set all lines to this transfer to bin code
                // if Confirm('This will update all lines! Proceed?', false) then begin//RL 10 Nov 2021 - remove prompt
                InvtDocLines.Reset;
                InvtDocLines.SetRange("Document No.", Rec."No.");
                if InvtDocLines.FindSet() then
                    repeat
                        // update transfer to bin code for line
                        InvtDocLines."Salespers./Purch. Code" := Rec."Salesperson/Purchaser Code";
                        InvtDocLines.Modify(false);
                    until InvtDocLines.Next() = 0;

                CurrPage.ShipmentLines.Page.Update();
                // end
                // else
                //     Error('Update cancelled');
            end;
        }

        addafter("Location Code")
        {
            field("Bin Code"; Rec."Bin Code")
            {
                ApplicationArea = All;

                trigger OnValidate()
                var
                    InvtDocLines: Record "Invt. Document Line";
                begin
                    // set all lines to this transfer to bin code
                    // if Confirm('This will update all lines! Proceed?', false) then begin //RL 10 Nov 2021 - remove prompt
                    InvtDocLines.Reset;
                    InvtDocLines.SetRange("Document No.", Rec."No.");
                    if InvtDocLines.FindSet() then
                        repeat
                            // update transfer to bin code for line
                            InvtDocLines."Bin Code" := Rec."Bin Code";
                            InvtDocLines.Modify(false);
                        until InvtDocLines.Next() = 0;

                    CurrPage.ShipmentLines.Page.Update();
                    // end
                    // else
                    //     Error('Update cancelled');
                end;
            }
        }

        addafter("Gen. Bus. Posting Group")
        {
            field("I9 Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;

                trigger OnValidate()
                var
                    InvtDocLines: Record "Invt. Document Line";
                begin
                    // set all lines to this transfer to gen prod posting group
                    // if Confirm('This will update all lines! Proceed?', false) then begin  //RL 10 Nov 2021 - remove prompt
                    InvtDocLines.Reset;
                    InvtDocLines.SetRange("Document No.", Rec."No.");
                    if InvtDocLines.FindSet() then
                        repeat
                            // update transfer to bin code for line
                            InvtDocLines."Gen. Prod. Posting Group" := Rec."Gen. Prod. Posting Group";
                            InvtDocLines.Modify(false);
                        until InvtDocLines.Next() = 0;

                    CurrPage.ShipmentLines.Page.Update();
                    // end
                    // else
                    //     Error('Update cancelled');
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // set default Gen. Prod. Posting Group for now
        Rec."Gen. Prod. Posting Group" := 'CLEARING A/C';
    end;

}
