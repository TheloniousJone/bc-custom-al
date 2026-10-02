page 55044 AddTBAtoDriverCage
{

    Caption = 'Add TBA to Driver Cage';
    PageType = Card;
    SourceTable = "TBA Ledger Entry";
    SourceTableTemporary = true;
    ObsoleteState = Pending;
    ObsoleteReason = 'Not used according to customer update';
    layout
    {
        area(content)
        {
            group(General)
            {
                field(EntryNo; EntryNo)
                {
                    ApplicationArea = All;
                    Caption = 'Select Delivery to add to driver.';
                    TableRelation = "TBA Ledger Entry"."Entry No." where("Entry Type" = const(Delivery));
                    trigger OnValidate()
                    begin
                        if EntryNo <> 0 then begin
                            GetTBALines(entryNo);
                        end;
                    end;
                }
                field("Customer No."; lTBARec."Customer No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Customer Name"; lTBARec."Customer Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(CageSelection; CageSelection)
                {
                    ApplicationArea = all;
                    Caption = 'Select Cage to assign.';
                    TableRelation = "Delivery Zone"."Delivery Zone";
                }


            }
            repeater(Details)
            {
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
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Batch No."; Rec."Batch No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Shipping Packages"; Rec."Shipping Packages")
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    var
                        myInt: Integer;
                        tbaRec: Record "TBA Ledger Entry";
                    begin
                        /*
                        TotalPackages := 0;
                        if Rec.FindSet() then
                            repeat

                                TotalPackages += Rec."Shipping Packages";
                            until Rec.next = 0;
                        */
                        if Rec."Shipping Packages" <> xRec."Shipping Packages" then begin
                            tbaRec.reset;
                            tbaRec.SetRange("Entry No.", Rec."Entry No.");
                            if tbaRec.FindFirst() then begin
                                tbaRec."Shipping Packages" := Rec."Shipping Packages";
                                tbaRec.Modify(TRUe);
                            end;
                        end;

                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Process)
            {
                action("Confirm addition")
                {
                    ApplicationArea = all;
                    Caption = 'Confirm addition';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Process;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                    begin
                        if CageSelection <> '' then begin
                            if confirm('Are you sure you wish to add the TBA delivery to the selected Cage?') then begin
                                TBACU.CreateALEforTBA(lTBARec);
                                TBACU.UpdateTBALineCage(Rec."Document No.", CageSelection);
                                Message('TBA Delivery added sucessfully.');
                            end;
                        end;
                    end;
                }
            }
        }

    }

    local procedure GetTBALines(EntryNo: Integer)
    var
        myInt: Integer;
        LoopRec: Record "TBA Ledger Entry";
    begin
        lTBARec.reset;
        lTBARec.SetRange("Entry No.", EntryNo);
        if lTBARec.FindFirst() then begin
            if Rec.IsTemporary then
                Rec.DeleteAll();
            LoopRec.reset;
            LoopRec.SetRange("Document No.", lTBARec."Document No.");
            LoopRec.SetFilter("Cage No.", '%1', '');//DX      04 July 2021    Only retrieve TBA lines that has not been assigned cages.            
            if LoopRec.FindSet() then
                repeat
                    Rec.reset;
                    Rec.init;
                    Rec.Copy(LoopRec);
                    Rec.Insert(false);
                until LoopRec.next = 0;

            CustRec.reset;
            CustRec.SetRange("No.", lTBARec."Customer No.");
            if CustRec.FindFirst() then
                CageSelection := CustRec."Delivery Zone";
        end;
    end;


    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        EditableBool := false;
    end;

    trigger OnModifyRecord(): Boolean
    var
        myInt: Integer;
    begin

    end;

    var
        entryNo: Integer;
        ContractRec: Record "TBA Ledger Entry";
        CustRec: Record Customer;
        itemRec: Record item;
        lTBARec: Record "TBA Ledger Entry";
        TotalPackages: Decimal;

        EditableBool: Boolean;
        CageSelection: code[20];
        TBACU: Codeunit TBA;

}
