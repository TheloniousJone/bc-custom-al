page 55000 "TBA Ledger Entry"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "TBA Ledger Entry";
    CardPageId = "TBA Card";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(Details)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;

                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = all;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                    Editable = true;
                }
                field("Unit Of Measure Code"; Rec."Unit Of Measure Code")
                {
                    ApplicationArea = all;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = all;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = all;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = all;
                }
                field("Apply To Doc No."; Rec."Apply To Doc No.")
                {
                    ApplicationArea = all;
                }
                field("Remaining Qty"; Rec."Remaining Qty")
                {
                    ApplicationArea = all;
                }
                //DX        01 July 2021
                field("Bin Remarks"; Rec."Bin Remarks")
                {
                    ApplicationArea = all;
                }
                //DX        01 July 2021
                //DX        04 July 2021
                field("Batch No."; Rec."Batch No.")
                {
                    ApplicationArea = all;
                }
                field("Cage No."; Rec."Cage No.")
                {
                    ApplicationArea = all;
                    Caption = 'Delivery Zone';
                    TableRelation = "Delivery Zone"."Delivery Zone";
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = all;
                }
                field("Shipping Packages"; Rec."Shipping Packages")
                {
                    ApplicationArea = all;
                }
                //DX        04 July 2021
                //DX        31 Aug 2021
                field("TBA Printed"; Rec."TBA Printed")
                {
                    ApplicationArea = all;
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = all;
                }
                field("Delivery Charge"; Rec."Delivery Charge")
                {
                    ApplicationArea = all;
                }
                //DX        31 Aug 2021

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Add Delivery")
            {
                ApplicationArea = All;
                Image = AddAction;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "TBA Delivery Card";
                trigger OnAction()
                begin

                end;
            }
            /*
            action("Add Pending Delivery")
            {
                ApplicationArea = All;
                Image = AddAction;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Add Pending Del TBA Card";
                trigger OnAction()
                begin

                end;
            }
            */
            action("Insert New TBA From Sales Invoice")
            {
                ApplicationArea = All;
                Image = MakeOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page TBASalesCard;
                trigger OnAction()
                begin

                end;
            }
            //DX        04 July 2021        New function to add to shipping cage
            /*      DX      18 July 2021        Driver module not needed
            action("Push DO To Driver")
            {
                ApplicationArea = All;
                Image = Production;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page AddTBAtoDriverCage;
                trigger OnAction()
                begin

                end;
            }
            */
            //DX        04 July 2021        New function to add to shipping cage
            //DX        04 July 2021        New function to add adjustments
            action("Create Adj Line")
            {
                ApplicationArea = All;
                Image = CreateBins;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "TBA Adjustment Card";
                trigger OnAction()
                begin

                end;
            }

            //DX        04 July 2021        New function to add to swap batch number
            action("Swap Batch No.")
            {
                ApplicationArea = All;
                Image = CreateBins;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    TBARec: Record "TBA Ledger Entry";
                    SwapPage: Page "Swap TBA Batch";
                begin
                    CurrPage.SetSelectionFilter(TBARec);
                    page.Run(55045, TBARec);
                end;
            }
            //DX        04 July 2021        New function to add to shipping cage
            action("Print DO")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    RecLine: Record "TBA Ledger Entry";
                begin
                    CurrPage.SETSELECTIONFILTER(RecLine);
                    //if RecLine."Entry Type" <> RecLine."Entry Type"::Delivery then
                    //    Error('You can only print delivery entry types, please reselect.');
                    REPORT.RUN(57000, TRUE, FALSE, RecLine);
                end;
            }

            // YF 17 Feb 2022
            action("Archive TBA Ledger Entries")
            {
                ApplicationArea = All;
                Image = Archive;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    TBACU: Codeunit TBA;
                begin
                    if Confirm('Archive TBA Ledger Entries?', false) then begin
                        TBACU.ArchiveTBALedgerEntries();
                        CurrPage.Update(false);
                    end;
                end;
            }
            // YF 17 Feb 2022
        }
    }
    procedure ReturnFilters(VAR SHrec: Record "TBA Ledger Entry")
    var
        myInt: Integer;
    begin
        CurrPage.SETSELECTIONFILTER(SHrec);
        IF SHrec.FINDSET THEN
            REPEAT
                Rec.MARK;//ESSAGE(FORMAT(DLRec.Quantity));
            UNTIL SHrec.NEXT = 0;
    end;

    var
        myInt: Integer;
}