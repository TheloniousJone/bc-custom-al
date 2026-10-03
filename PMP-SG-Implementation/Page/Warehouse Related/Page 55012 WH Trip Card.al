page 55012 "WH Trip Card"
{

    Caption = 'WH Trip Card';
    PageType = Card;
    SourceTable = "WH Trip Header";

    layout
    {
        area(content)
        {

            group(General)
            {
                Editable = CanEdit;
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field';
                    ApplicationArea = All;
                    Editable = false;
                }

                field(Picker; Rec.Picker)
                {
                    ToolTip = 'Specifies the value of the Picker field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Trip Start"; Rec."Trip Start")
                {
                    ToolTip = 'Specifies the value of the Start field';
                    ApplicationArea = All;
                    //Editable = false;
                }
                field("Trip End"; Rec."Trip End")
                {
                    ToolTip = 'Specifies the value of the End field';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            group(Details)
            {
                part(Subform; "WH Trip Subform")
                {
                    SubPageLink = "Doc No." = field("No.");
                    UpdatePropagation = Both;
                    ApplicationArea = all;
                    Editable = CanEdit;
                }
            }

        }


    }
    actions
    {
        area(Processing)
        {
            action("Get Pick List")
            {
                ApplicationArea = all;
                Caption = 'Get Pick List to start';
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                Enabled = CanEdit;
                Image = Process;

                trigger OnAction()
                var
                    BaskRec: Record Basket;
                    SelBasketRec: Record Basket;
                    BasketPage: Page "Basket List";
                    SORec: Record "Sales Header"; // Josh

                begin
                    //Josh 03/11/2023



                    if WHCU.GotAvailPicks(UserId) then begin
                        if WHCU.CheckTripHasMaxOf2PL(Rec) then
                            Error('Unable to add anymore picking lists to trip, please proceed with picking first.');


                        rec.Init();
                        Rec.Picker := UserId;
                        //                                if Rec."Trip Start" = 0DT then begin
                        Rec."Trip Start" := CurrentDateTime;
                        if Rec."No." <> '' then begin
                            rec.Modify(true);
                        end else
                            Rec.Insert(true);
                        //end;
                        WHCU.AssignPicker(UserId, Rec."No.", '');
                    end else begin
                        Message('No available pick lists to assign, please try again later.');
                    end;
                end;
            }
            action("Add Pick List")
            {
                Visible = false;
                ApplicationArea = all;
                Caption = 'Add Delivery To Existing DO.';
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                Enabled = CanEdit;
                Image = Process;
                trigger OnAction()
                var
                    BaskRec: Record Basket;
                    SelBasketRec: Record Basket;
                    BasketPage: Page "Basket List";
                begin

                    BaskRec.reset;
                    BasketPage.SETTABLEVIEW(BaskRec);
                    BasketPage.LOOKUPMODE := TRUE;
                    BasketPage.CAPTION := 'Select Basket to update as cold room basket.';
                    if BasketPage.RunModal() = action::LookupOK then begin
                        BasketPage.SetSelectionFilter(SelBasketRec);
                        if SelBasketRec.count = 0 then
                            Error('Please select a basket to create the cold room trip.');
                        if SelBasketRec.Count > 1 then
                            error('Please select only one basket.');
                        if SelBasketRec.FindSet() then
                            repeat
                                WHCU.ManualAddPickingListToTrip(userid, Rec, SelBasketRec."No.");
                            until SelBasketRec.next = 0;

                    end;
                end;
            }

            action("End Trip")
            {
                ApplicationArea = all;
                Caption = 'End WH Trip';
                ToolTip = 'Manually end the WH Trip';
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                Enabled = CanEdit;
                Image = Process;
                trigger OnAction()
                var
                    BaskRec: Record Basket;
                    SelBasketRec: Record Basket;
                    BasketPage: Page "Basket List";
                    WHCU: Codeunit "Warehouse CU";
                begin
                    if Confirm('Are you sure you wish to manually end this trip?') then begin
                        WHCU.CompleteTrip(Rec);
                    end;

                end;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        if (Rec."Trip End" <> 0DT) then
            CanEdit := false
        else
            CanEdit := true;

        //DX        09 July 2021
        if WHCU.CheckTripHasMaxOf2PL(Rec) then
            EditableBool := false
        else
            EditableBool := true;

        //DX        09 July 2021
    end;

    trigger OnInit()
    var
        myInt: Integer;
    begin
        //    CurrPage.Update(true);
    end;

    trigger OnInsertRecord(belowxrec: Boolean): Boolean
    var
        myInt: Integer;
    begin
        CurrPage.Update(true);
    end;

    trigger OnOpenPage()
    begin

    end;

    var
        EnhanceCU: Codeunit "PMP-Enhancements";
        CanEdit: Boolean;
        EditableBool: Boolean;
        WHCU: codeunit 55002;
        BasketCode: code[20];
        ManualAdd: Boolean;
}
