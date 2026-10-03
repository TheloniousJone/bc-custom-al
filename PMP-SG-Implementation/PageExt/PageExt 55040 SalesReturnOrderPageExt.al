pageextension 55040 SalesReturnOrderPageExt extends "Sales Return Order"
{
    layout
    {
        addlast(General)
        {
            //DX        17 Aug 2021
            field(Rebill; Rec.Rebill)
            {
                ApplicationArea = all;
                //DX        22 Aug 2021                

            }
            field("Delivery Charge"; Rec."Delivery Charge")
            {
                ApplicationArea = all;
            }
            field("Delivery Zone"; Rec."Delivery Zone")
            {
                ApplicationArea = all;
            }

            //DX        22 Aug 2021

            field("Return Status"; Rec."Return Status")
            {
                ApplicationArea = All;
            }
            //RL        19 Oct 2021
            field("Branch/Subsidiary"; Rec."Branch/Subsidiary")
            {
                ApplicationArea = All;
            }
            field(I9G_ReturnReasonCode; Rec.I9G_ReturnReasonCode)
            {
                ApplicationArea = All;
            }
            field(I9G_Reason_Text; Rec.I9G_Reason_Text)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reason Text field.';
            }
            field("Customer Group"; Rec."Customer Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Group field.', Comment = '%';
            }


        }
        //RL 18 Oct 2022
        addafter("Sell-to Customer Name")
        {
            field("Posting Description"; Rec."Posting Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Posting Description field';
            }
        }
        //RL 18 Oct 2022
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Document Date")
        {
            Caption = 'Collection Date';
        }
        moveafter("Sell-to Customer Name"; "Location Code")


    }
    actions
    {
        addafter("&Return Order")
        {
            action("Delete Warehouse Documents")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ALERec: Record "Assignment Ledger Entry";
                    WHCU: Codeunit "Warehouse CU";
                begin
                    If confirm('Are you sure you wish to delete the warehouse documents?') then begin
                        WHCU.DeleteWHSalesReturnandDoc(Rec);
                        Rec.Modify(FALSE);
                    end;
                end;
            }

            //DX        07 Oct 2021
        }

        modify(Reopen)
        {
            trigger OnBeforeAction()
            var
                WHCU: Codeunit "Warehouse CU";
                myInt: Integer;
            begin
                WHCU.DeleteWHSalesReturnandDoc(Rec);
                Rec."Order Status" := rec."Order Status"::Open;
                Rec.Modify(FALSE);
            end;
            //DX        07 Oct 2021
        }

        //DX        05 Sept 2021
        modify(Release)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                if Rec."Document Date" = 0D then
                    Error('Please enter collection date before releasing.');
            end;

        }
        //DX        17 Sept 2021
        modify(Post)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
                CustRec: Record customer;
            begin
                if Rec."Sell-to Customer No." <> '' then begin
                    CustRec.reset;
                    CustRec.get(Rec."Sell-to Customer No.");
                    if CustRec."Mandatory Ext Doc. No." = true then begin
                        if Rec."External Document No." = '' then
                            Error('Please ensure Customer PO (Ext Doc No.) is entered before releasing to warehouse.');
                    end;
                end;

            end;
        }
        modify("Create &Whse. Receipt")
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
                CustRec: Record customer;
                SLRec: Record "Sales Line";
            begin
                if Rec.I9G_ReturnReasonCode = '' then begin
                    Error('Please enter a Return Reason Code');
                end;
                if Rec."Sell-to Customer No." <> '' then begin
                    CustRec.reset;
                    CustRec.get(Rec."Sell-to Customer No.");
                    if CustRec."Mandatory Ext Doc. No." = true then begin
                        if Rec."External Document No." = '' then
                            Error('Please ensure Customer PO (Ext Doc No.) is entered before releasing to warehouse.');
                    end;
                end;

                SLRec.Reset();
                SLRec.SetRange("Document Type", Rec."Document Type");
                SLRec.SetRange("Document No.", Rec."No.");
                SLRec.SetFilter("No.", '<>%1', '');
                SLRec.SetFilter("Return Reason Code", '%1', '');
                SLRec.SetLoadFields("No.", "Document No.", "Document Type", "Return Reason Code");
                if SLRec.FindFirst() then
                    Error('Please enter a Return Reason Code for %1', SLRec."No.");

            end;
        }
        //DX        17 Sept 2021
        //DX        05 Sept 2021

        //RL    15Dec 2021
        // modify(GetPostedDocumentLinesToReverse)
        // {
        //     trigger OnAfterAction()
        //     var
        //         SLRec: Record "Sales Line";

        //     begin
        //         SLRec.Reset();
        //         SLRec.SetFilter("Document No.", rec."No.");
        //         SLRec.SetFilter("Document Type", '%1', rec."Document Type");
        //         SLRec.SETFILTER("No.", '<>%1', '');
        //         if SLRec.FindSet() then begin
        //             repeat
        //                 SLRec.Validate("Inv. Discount Amount", 0);
        //                 SLRec.Validate("Line Discount Amount", 0);
        //                 CurrPage.Update();
        //             UNTIL SLRec.NEXT = 0;
        //         end;

        //     end;
        // }
        addafter(GetPostedDocumentLinesToReverse)
        {
            action(ResetTrackingLines)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Caption = 'Reset Tracking Lines';

                trigger OnAction()
                var
                    SLRec: Record "Sales Line";
                    reserveEntry: Record "Reservation Entry";
                begin
                    SLRec.RESET;
                    SLRec.SETRANGE("Document No.", Rec."No.");
                    SLRec.SETFILTER("Quantity (Base)", '<>0');
                    SLRec.SETRANGE(Type, SLRec.Type::Item);
                    SLRec.SETFILTER("No.", '<>%1', '');
                    SLRec.SetRange("Special Order", false);//KM20200113

                    IF SLRec.FINDSET THEN
                        REPEAT
                            reserveEntry.RESET;
                            reserveEntry.SETRANGE("Item No.", SLRec."No.");
                            reserveEntry.SETRANGE("Source ID", SLRec."Document No.");
                            reserveEntry.SETRANGE("Source Ref. No.", SLRec."Line No.");
                            reserveEntry.SETRANGE("Location Code", SLRec."Location Code");
                            // YF 10 Aug 2022 // To avoid unnecessary table lock
                            if not reserveEntry.IsEmpty then
                                reserveEntry.DELETEALL(TRUE);
                        // YF 10 Aug 2022 // To avoid unnecessary table lock

                        UNTIL SLRec.NEXT = 0;
                end;
            }
        }
        //RL    15Dec 2021
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        myInt: Integer;
    begin
        //DX        05 Sept 2021
        Rec."Document Date" := 0D;
        //DX        05 Sept 2021
    end;

}
