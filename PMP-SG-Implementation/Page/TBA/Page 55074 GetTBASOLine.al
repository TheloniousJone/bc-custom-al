page 55074 GetTBASOLine
{

    Caption = 'Get TBA SO Line';
    PageType = List;
    SourceTable = "Sales Line";
    //SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(SHName; SHName)
                {
                    ApplicationArea = all;
                    Caption = 'Name';
                }
                field(SHAdd; SHAdd)
                {
                    ApplicationArea = all;
                    Caption = 'Address';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;

        SHRec: Record "Sales Header";
    begin
        SHName := '';
        SHAdd := '';

        if Rec."Document No." <> '' then begin
            SHRec.reset;
            shrec.SetRange("No.", rec."Document No.");
            SHRec.SetRange("TBA Order", true);
            if SHRec.FindFirst() then begin
                SHName := SHRec."Sell-to Customer Name";
                SHAdd := SHRec."Sell-to Address";
            end else begin

            end;

        end;
    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        //Loaddata();

    end;

    local procedure Loaddata()
    var
        myInt: Integer;
        ItemList: page "Item List";
        ItemRec: Record item;
        ItemFilter: code[300];
        RecRun: integer;
        RecordCount: Integer;
        SLRec: Record "Sales Line";
        SHrec: Record "Sales Header";
    begin
        if Rec.IsTemporary then
            Rec.DeleteAll();

        SHrec.reset;
        shrec.SetRange("TBA Order", true);
        if SHrec.FindSet() then
            repeat
                SLRec.reset;
                SLRec.SetRange("Document No.", SHrec."No.");
                SLRec.SetRange("Document Type", SHrec."Document Type");
                SLRec.SetRange(Type, SLRec.Type::Item);
                SLRec.SetFilter("No.", '<>%1', '');
                SLRec.SetFilter(Quantity, '<>0');
                if SLRec.FindSet() then
                    repeat
                        Rec.reset;
                        rec.init;
                        rec."Document Type" := SLRec."Document Type";
                        Rec."Document No." := SLRec."Document No.";
                        Rec."Line No." := SLRec."Line No.";
                        Rec."No." := SLRec."No.";
                        rec.Description := SLRec.Description;
                        Rec.Quantity := SLRec.Quantity;
                        Rec."Unit of Measure Code" := SLRec."Unit of Measure Code";
                        Rec.insert(false);
                    until SLRec.next = 0;
            until SHrec.next = 0;

    end;

    var
        SHName: Text[100];
        SHAdd: Text[100];

}
