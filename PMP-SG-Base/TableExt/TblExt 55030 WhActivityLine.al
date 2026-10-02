tableextension 55030 TblExtWhActivityLine extends "Warehouse Activity Line"
{
    fields
    {
        field(55000; "CS Pick Qty"; Decimal)
        {
            Caption = 'CS Pick Qty';
            DataClassification = ToBeClassified;
        }
        field(55084; MinShelf; Date)
        {
            Caption = 'Min Shelf Life';
        }
    }

    trigger OnBeforeInsert()
    begin
        SetCSPickQtyFromSOLine();
    end;

    trigger OnInsert()
    begin
        SetCSPickQtyFromSOLine();
    end;

    trigger OnAfterInsert()
    begin
        SetCSPickQtyFromSOLine();
    end;

    procedure SetCSPickQtyFromSOLine()
    var
        SalesLineRec: Record "Sales Line";
    begin
        if "Source Document" = "Source Document"::"Sales Order" then begin
            SalesLineRec.Reset();
            SalesLineRec.SetRange("Document No.", Rec."Source No.");
            SalesLineRec.SetRange("Line No.", Rec."Source Line No.");
            if SalesLineRec.FindFirst() then
                //Rec."CS Pick Qty" := SalesLineRec."Qty To Deliver" + SalesLineRec."FOC (Qty) To Deliver";
                Rec."CS Pick Qty" := Rec.Quantity;
        end;
    end;
}
