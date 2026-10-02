page 55041 "TBA Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "TBA Ledger Entry";
    //Editable = false;
    layout
    {
        area(Content)
        {
            group(Details)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                    //Editable = false;
                }
                field("Unit Of Measure Code"; Rec."Unit Of Measure Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = all;
                    // Editable = false;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = all;
                    // Editable = false;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Delivery Charge"; Rec."Delivery Charge")
                {
                    ApplicationArea = all;
                    Editable = false;

                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = all;
                    //Editable = false;
                }
                field("Apply To Doc No."; Rec."Apply To Doc No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Remaining Qty"; Rec."Remaining Qty")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                //DX        01 July 2021
                field("Bin Remarks"; Rec."Bin Remarks")
                {
                    ApplicationArea = all;
                    TableRelation = "TBA Bin"."Bin Code";
                    trigger OnValidate()
                    var
                        myInt: Integer;
                        TBARec: Record "TBA Ledger Entry";
                    begin
                        if Rec."Bin Remarks" <> xRec."Bin Remarks" then begin
                            if Confirm('Are you sure you wish to update the TBA Bin?') then begin
                                TBARec.reset;
                                TBARec.SetRange("Apply To Doc No.", Rec."Document No.");
                                TBARec.SetRange("Item No.", Rec."Item No.");
                                if TBARec.FindSet() then
                                    repeat
                                        TBARec."Bin Remarks" := Rec."Bin Remarks";
                                        TBARec.Modify(FALSE);
                                    until TBARec.next = 0;
                            end;
                        end;
                    end;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = all;
                }
                field("Batch No."; Rec."Batch No.")
                {
                    ApplicationArea = all;


                }
                field("Delivery Zone"; Rec."Cage No.")
                {
                    ApplicationArea = all;
                    Caption = 'Delivery Zone';
                }
                field("TBA Printed"; Rec."TBA Printed")
                {
                    Caption = 'Printed';
                    ApplicationArea = all;
                    ToolTip = 'Check to indicate that TBA has been printed already.';
                }

                //DX        01 July 2021

            }
        }
    }

    actions
    {
        area(Processing)
        {

        }
    }

    var
        myInt: Integer;
}