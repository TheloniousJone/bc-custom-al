page 55045 "Swap TBA Batch"
{

    Caption = 'Swap TBA Batch';
    PageType = Card;
    SourceTable = "TBA Ledger Entry";

    layout
    {
        area(content)
        {
            group(General)
            {
                /*
                field(EntryNo; EntryNo)
                {
                    ApplicationArea = All;
                    Caption = 'Select original sales batch to swap.';
                    TableRelation = "TBA Ledger Entry"."Entry No." where("Entry Type" = const(sale));
                    trigger OnValidate()
                    begin
                        if (EntryNo <> 0) or (EntryNo <> xRec."Entry No.") then begin
                            Rec.Reset;
                            Rec.SetRange("Entry No.", EntryNo);
                            If Rec.FindFirst() then begin end;
                        end;
                    end;
                }
                */
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Customer Name"; Rec."Customer Name")
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
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Remaining Qty"; Rec."Remaining Qty")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Batch No."; Rec."Batch No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(BatchNo; BatchNo)
                {
                    ApplicationArea = all;
                    Caption = 'Select new Batch No.';
                    trigger OnLookup(var Text: text): Boolean
                    var
                        myInt: Integer;
                        ILEFilter: Record "Item Ledger Entry";
                        ILERec: Record "Item Ledger Entry";
                        ILEPage: Page "Item Ledger Entries";
                    begin
                        //ItemRec.Reset();
                        ILEFilter.reset;
                        ILEFilter.SetRange("Item No.", Rec."Item No.");
                        ILEFIlter.Setfilter("Remaining Quantity", '<>0');
                        ILEFilter.SetFilter("Lot No.", '<>%1', rec."Batch No.");
                        Clear(ILEPage);
                        ILEPage.LookupMode := true;
                        ILEPage.SetTableView(ILEFilter);
                        if ILEPage.RunModal() = Action::LookupOK then begin
                            ILEPage.GetRecord(ILERec);
                            BatchNo := ILERec."Lot No.";
                        end;

                    end;
                    //                    TableRelation = "Item Ledger Entry"."Lot No." where("Item No." = field("Item No."), "Remaining Quantity" = filter('>0'));



                }
            }

        }

    }
    actions
    {
        area(Processing)
        {
            action("Confirm Swap")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                image = Completed;
                trigger OnAction()
                begin
                    if (BatchNo <> '') or (BatchNo <> Rec."Batch No.") then begin
                        if Confirm('Are you sure you wish to swap the batch?') then begin
                            TBACU.SwapBatch(Rec, BatchNo);
                            CurrPage.Update(true);
                            //Rec."Batch No." := BatchNo;
                            //Rec.Modify(false);
                            Message('Batches have been updated.');
                            BatchNo := '';
                        end;
                    end;

                end;
            }
        }
    }
    var
        EntryNo: Integer;
        BatchNo: Code[50];
        TBACU: Codeunit TBA;
}
