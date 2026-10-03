page 55091 TempSOTotalPage
{

    Caption = 'SO Details';
    PageType = ListPart;
    SourceTable = "Warehouse Activity Line";
    SourceTableTemporary = true;
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'SO Order Details.';
                field("Item No."; Rec."Item No.")
                {
                    Caption = 'Item No.';
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field';
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Order Qty';
                    Caption = 'Order Qty';
                    ApplicationArea = All;
                }
                field(DelQty; Rec."Qty. (Base)")
                {
                    ToolTip = 'To Del Qty';
                    Caption = 'Deliver Qty';
                    ApplicationArea = all;
                    Style = StrongAccent;
                }
            }
        }
    }

    procedure LoadData(WHRec: Record "Registered Whse. Activity Hdr.")
    var
        myInt: Integer;
        SLRec: Record "Sales Line";
        RWLRec: Record "Registered Whse. Activity Line";
        ItemRec: Record item;
        TLRec: Record "Transfer Line";
    begin
        myInt := 10000;
        if Rec.IsTemporary then
            Rec.DeleteAll(true);
        RWLRec.Reset();
        RWLRec.SetRange("No.", WHRec."No.");
        RWLRec.SetRange("Action Type", RWLRec."Action Type"::Take);
        //RWLRec.SetRange(Breakbulk, false);
        if RWLRec.FindFirst() then begin
            SLRec.reset;
            SLRec.SetRange("Document No.", RWLRec."Source No.");
            SLRec.SetRange("Document Type", RWLRec."Source Document");
            SLRec.SetRange(Type, SLRec.Type::Item);
            SLRec.SetFilter("No.", '<>%1', '');
            SLRec.SetFilter(Quantity, '<>0');
            SLRec.SetFilter("Reserved Quantity", '<>0');
            if SLRec.FindSet() then begin
                repeat
                    if SLRec.Type = SLRec.Type::Item then begin
                        ItemRec.reset;
                        ItemRec.SetRange("No.", SLRec."No.");
                        ItemRec.SetRange(Type, ItemRec.Type::"Inventory");
                        if ItemRec.FindFirst() then begin
                            Rec.reset;
                            rec.init;
                            Rec."Line No." := myInt;
                            Rec."Action Type" := Rec."Activity Type"::Pick;
                            Rec."No." := WHRec."No.";
                            Rec.Description := SLRec.Description;
                            rec.Quantity := SLRec.Quantity + SLRec."FOC Qty";
                            rec."Qty. (Base)" := SLRec."Qty To Deliver" + SLRec."FOC (Qty) To Deliver";
                            Rec.Insert(FALSE);
                            myInt += 10000;
                        end;
                    end;
                until SLRec.Next() = 0;
            end else begin
                TLRec.reset;
                TLRec.SetRange("Document No.", RWLRec."Source No.");
                TLRec.SetFilter(Quantity, '<>0');
                if TLRec.FindSet() then begin
                    repeat

                        Rec.reset;
                        rec.init;
                        Rec."Line No." := myInt;
                        Rec."Action Type" := Rec."Activity Type"::Pick;
                        Rec."No." := WHRec."No.";
                        Rec.Description := TLRec.Description;
                        rec.Quantity := TLRec.Quantity;
                        rec."Qty. (Base)" := TLRec.Quantity;
                        Rec.Insert(FALSE);
                        myInt += 10000;

                    until TLRec.Next() = 0;
                end;
            end;
        end;
    end;
}
