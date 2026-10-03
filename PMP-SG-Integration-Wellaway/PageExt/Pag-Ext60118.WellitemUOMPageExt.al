pageextension 60118 WellitemUOMPageExt extends "Item Units of Measure"
{
    layout
    {
        //DX        23 Sept 2021
        modify("Qty. per Unit of Measure")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                if (Rec."Qty. per Unit of Measure" <> xRec."Qty. per Unit of Measure") and (Rec."Qty. per Unit of Measure" < 1) then begin
                    //CurrPage.Update(true);
                    if WellCode.IsWellawayCompany() then begin
                        if Confirm('Do you want to update to PMP?') then begin
                            WellCU.SyncWellItemUOMRec(Rec."Item No.", Rec.Code);
                            WellCode.CreateLoosePrice(Rec."Item No.", Rec.Code, Rec."Qty. per Unit of Measure");
                        end;
                    end;

                end;
            end;
        }
        //DX        23 Sept 2021
    }
    var
        WellCU: Codeunit WellawaySync;
        WellCode: Codeunit "Wellaway CU";
}
