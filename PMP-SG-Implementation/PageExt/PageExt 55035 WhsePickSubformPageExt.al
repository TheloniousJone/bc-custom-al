pageextension 55035 WhsePickSubformPageExt extends "Whse. Pick Subform"
{
    layout
    {

        modify("Action Type")
        {
            StyleExpr = ColourBool;
            Style = Attention;
        }
        modify("Source No.")
        {
            StyleExpr = ColourBool;
            Style = Attention;
        }
        modify("Item No.")
        {
            StyleExpr = ColourBool;
            Style = Attention;
        }
        modify(Description)
        {
            StyleExpr = ColourBool;
            Style = Attention;
        }
        modify("Bin Code")
        {
            StyleExpr = ColourBool;
            Style = Attention;
        }
        modify("Qty. Outstanding")
        {
            Visible = false;
            Editable = Canedit;
        }

        //DX        28 July 2021
        addbefore("Qty. to Handle")
        {
            field("CS Pick Qty"; Rec."CS Pick Qty")
            {
                ApplicationArea = all;
                Caption = 'To Pick Qty';
                DecimalPlaces = 0 : 2;
                //Editable = Canedit;
            }
        }
        modify("Qty. to Handle")
        {
            //Editable = Canedit;
            StyleExpr = Canedit;
            Style = Favorable;
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                if Rec."Qty. to Handle" > Rec."CS Pick Qty" then
                    Error('Cannot pick more than indicated Pick qty by CS.');

            end;
        }
        modify(Quantity)
        {
            Editable = false;
            Visible = true; // set to true as instructed by dix 12 aug 2021
        }
        //DX        28 July 2021

        addafter("Bin Code")
        {
            field(MinShelf; VarMinShelf)
            {
                ApplicationArea = All;
                Editable = false;
                Style = Favorable;
            }
        }

    }

    actions
    {
        addafter("F&unctions")
        {
            action("Get QR Text")
            {
                ApplicationArea = all;
                ToolTip = 'Get QR Text E.G : SKU0001|A01-201|BAT000201|PCS';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = GetEntries;
                trigger OnAction()
                var
                    myInt: Integer;
                    TextStr: text[100];
                begin
                    TextStr := StrSubstNo('%1|%2|%3|%4', Rec."Item No.", Rec."Bin Code", Rec."Lot No.", Rec."Unit of Measure Code");
                    Message(TextStr);
                end;
            }
            action("Reset SO Batches")
            {
                ApplicationArea = all;

                Caption = 'Reset SO Batch';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Visible = false;
                trigger OnAction()
                var
                    myInt: Integer;
                    WHActLine: Record "Warehouse Activity Line";
                    PMPEnhance: Codeunit "PMP-Enhancements";
                begin
                    //if Rec."Basket Code" = '' then
                    //    Error('Please select Basket first before processing.');

                    if Confirm('Are you sure you wish to reset the item tracking in the SO?') then begin
                        PMPEnhance.DeleteItemTrackSO(Rec);
                    end;

                end;
            }

        }


    }

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        PLRec.SetRange("No.", Rec."No.");
        PLRec.SetFilter("Basket Code", '<>%1', '');
        if PLRec.findfirst then
            Canedit := true
        else
            Canedit := false;

    end;

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        PLRec.SetRange("No.", Rec."No.");
        PLRec.SetFilter("Basket Code", '<>%1', '');
        if PLRec.findfirst then
            Canedit := true
        else
            Canedit := false;
    end;

    trigger OnModifyRecord(): Boolean
    var
        myInt: Integer;
    begin
        PLRec.SetRange("No.", Rec."No.");
        PLRec.SetFilter("Basket Code", '<>%1', '');
        if PLRec.findfirst then
            Canedit := true
        else
            Canedit := false;
    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        if Rec."Action Type" = Rec."Action Type"::Take then
            ColourBool := true
        else
            ColourBool := false;

        PLRec.reset;
        PLRec.SetRange("No.", Rec."No.");
        PLRec.SetFilter("Basket Code", '<>%1', '');
        if PLRec.findfirst then
            Canedit := true
        else
            Canedit := false;

        Clear(VarMinShelf);

        WhShipeLine.Reset();
        WhShipeLine.SetRange("Source No.", Rec."Source No.");
        if WhShipeLine.FindFirst() then begin
            WhShipeHdr.Reset();
            WhShipeHdr.SetRange("No.", WhShipeLine."No.");
            if WhShipeHdr.FindFirst() then begin
                WhActyHdr.Reset();
                WhActyHdr.SetRange("No.", Rec."No.");
                if WhActyHdr.FindFirst() then begin
                    Cust.Reset();
                    Cust.SetRange("No.", WhActyHdr."Source Vend/Cust No.");
                    if Cust.FindFirst() then begin
                        MiniShelf.Reset();
                        MiniShelf.SetRange("No.", Rec."Item No.");
                        MiniShelf.SetRange(Code, Cust."Customer Price Group");
                        if MiniShelf.FindFirst() then begin
                            VarMinShelf := CalcDate(MiniShelf.MinShelf, WhShipeHdr."Posting Date");
                        end;
                    end;

                end;
            end;
        end;

    end;

    trigger OnDeleteRecord(): Boolean

    begin
        if ((CurrentClientType = ClientType::Tablet) or (CurrentClientType = ClientType::Phone)) then
            Error('You cannot delete lines');

    end;


    var
        Canedit: Boolean;
        ColourBool: Boolean;
        PLRec: Record "Warehouse Activity Header";
        VarMinShelf: Date;
        Cust: Record Customer;
        MiniShelf: Record MinimumShelf;
        SalesShipHdr: Record "Sales Shipment Header";
        WhShipeLine: Record "Warehouse Shipment Line";
        WhShipeHdr: Record "Warehouse Shipment Header";
        WhActyHdr: Record "Warehouse Activity Header";

}
