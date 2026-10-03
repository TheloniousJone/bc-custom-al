pageextension 70203 ItemJournalExt extends "Item Journal"
{
    layout
    {
        modify("Item No.")
        {
            trigger OnAfterValidate()
            var
                CompanyInformationRec: Record "Company Information";
                ItemRec: Record Item;
            begin
                CompanyInformationRec.Get();
                if CompanyInformationRec.I9G_Novem = true then begin
                    ItemRec.Reset();
                    ItemRec.SetRange("No.", Rec."Item No.");
                    ItemRec.SetFilter(I9G_ItemLocationCode, '<>%1', '');
                    if ItemRec.FindFirst() then begin
                        Rec.Validate("Location Code", ItemRec.I9G_ItemLocationCode);
                    end else begin
                        Rec.Validate("Location Code", '');
                    end;
                end;
            end;
        }

    }
}