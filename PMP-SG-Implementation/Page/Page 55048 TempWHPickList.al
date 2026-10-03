page 55048 TempWHPickList
{

    Caption = 'TempWHPickList';
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

                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field';
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field';
                    ApplicationArea = All;
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
    begin
        myInt := 10000;
        if Rec.IsTemporary then
            Rec.DeleteAll(true);
        RWLRec.Reset();
        RWLRec.SetLoadFields("No.", "Action Type", "Source Document", "Source No.");   //DX        24 May 2023
        RWLRec.SetRange("No.", WHRec."No.");
        RWLRec.SetRange("Action Type", RWLRec."Action Type"::Take);
        //RWLRec.SetRange(Breakbulk, false);
        if RWLRec.FindFirst() then begin
            SLRec.reset;
            SLRec.SetLoadFields("Document No.", "Document Type", Quantity, Description, "No.", Type);     //DX        24 May 2023
            SLRec.SetRange("Document No.", RWLRec."Source No.");
            SLRec.SetRange("Document Type", RWLRec."Source Document");

            //SLRec.SetRange(Type, SLRec.Type::Item);
            //            SLRec.SetRange("Unit Price", 0);
            if SLRec.FindSet() then
                repeat
                    if SLRec.Type = SLRec.Type::Item then begin
                        ItemRec.reset;
                        ItemRec.SetRange("No.", SLRec."No.");
                        ItemRec.SetFilter(Type, '%1|%2', ItemRec.Type::"Non-Inventory", ItemRec.Type::Service);
                        if ItemRec.FindFirst() then begin
                            Rec.reset;
                            rec.init;
                            Rec."Line No." := myInt;
                            Rec."Action Type" := Rec."Activity Type"::Pick;
                            Rec."No." := WHRec."No.";
                            Rec.Description := SLRec.Description;
                            rec.Quantity := SLRec.Quantity;
                            Rec.Insert(FALSE);
                            myInt += 10000;
                        end;
                    end else begin
                        Rec.reset;
                        rec.init;
                        Rec."Line No." := myInt;
                        Rec."Action Type" := Rec."Activity Type"::Pick;
                        Rec."No." := WHRec."No.";
                        Rec.Description := SLRec.Description;
                        rec.Quantity := SLRec.Quantity;
                        Rec.Insert(FALSE);
                        myInt += 10000;
                    end;
                until SLRec.Next() = 0;
        end;
    end;

}
