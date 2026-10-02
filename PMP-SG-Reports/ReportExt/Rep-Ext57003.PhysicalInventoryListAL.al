reportextension 57003 "Physical Inventory List AL" extends "Phys. Inventory List"

{
    RDLCLayout = './ReportExtLayouts/Rep-Ext57003.PhysicalInventoryListAL.rdl';
    dataset
    {
        add(ItemTrackingSpecification)
        {
            // add a new field to the dataset
            column(ExpiryDate; ExpiryDate) { }
        }
        modify(ItemTrackingSpecification)
        {
            trigger OnAfterPreDataItem()
            var

            begin
                Clear(ExpiryDate);
                ReservEntryBuffer2.SetCurrentKey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name");
                ReservEntryBuffer2.SetRange("Source ID", "Item Journal Line"."Journal Template Name");
                ReservEntryBuffer2.SetRange("Source Ref. No.", "Item Journal Line"."Line No.");
                ReservEntryBuffer2.SetRange("Source Type", DATABASE::"Item Journal Line");
                ReservEntryBuffer2.SetFilter("Source Subtype", '=%1', ReservEntryBuffer2."Source Subtype"::"0");
                ReservEntryBuffer2.SetRange("Source Batch Name", "Item Journal Line"."Journal Batch Name");
                if ReservEntryBuffer2.FindSet() then
                    if ReservEntryBuffer2."Expiration Date" <> 0D then begin
                        ExpiryDate := ReservEntryBuffer2."Expiration Date";
                    end;

            end;

            trigger OnBeforeAfterGetRecord()
            begin

            end;
        }
        modify("Item Journal Line")
        {
            trigger OnBeforeAfterGetRecord()
            begin

            end;
        }
    }

    requestpage
    {
    }

    var
        ReservEntryBuffer2: Record "Reservation Entry" temporary;
        ExpiryDate: Date;


}
