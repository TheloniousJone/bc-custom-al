page 55037 "Allowed Cust-Item"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Allowed Cust-Item";
    Caption = 'Chain Pharmacy - Item Allowed List';

    layout
    {
        area(Content)
        {
            Repeater(General)
            {
                field("Cust No."; Rec."Cust No.")
                {
                    ApplicationArea = All;

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(UOM; Rec.UOM)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        myInt: Integer;
        CustRec: Record customer;
        ItemRec: Record item;
    begin
        if Rec."Cust No." <> xRec."Cust No." then begin
            CustRec.reset;
            CustRec.SetRange("No.", Rec."Cust No.");
            if CustRec.FindFirst() then begin
                Rec.Description := CustRec.Name;
                //rec.Modify(FALSE);
            end;
        end;

        if Rec."Item No." <> xRec."Item No." then begin
            ItemRec.reset;
            ItemRec.SetRange("No.", Rec."Item No.");
            if ItemRec.FindFirst() then begin
                Rec."Item Description" := ItemRec.Description;
                //Rec.Modify(FALSE);
            end;
        end;


    end;

    trigger OnModifyRecord(): Boolean;
    var
        myInt: Integer;
        CustRec: Record customer;
        ItemRec: Record item;
    begin
        if Rec."Cust No." <> xRec."Cust No." then begin
            CustRec.reset;
            CustRec.SetRange("No.", Rec."Cust No.");
            if CustRec.FindFirst() then begin
                Rec.Description := CustRec.Name;
                rec.Modify(FALSE);
            end;
        end;

        if Rec."Item No." <> xRec."Item No." then begin
            ItemRec.reset;
            ItemRec.SetRange("No.", Rec."Item No.");
            if ItemRec.FindFirst() then begin
                Rec."Item Description" := ItemRec.Description;
                Rec.Modify(FALSE);
            end;
        end;
    end;


    var
        myInt: Integer;
}