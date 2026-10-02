report 71501 "Import PTA"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;


    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            dataitem(Item; Item)
            {
                DataItemTableView = sorting("No.");
                RequestFilterFields = "No.";
                trigger OnAfterGetRecord()
                begin
                    PharmaPurchasePrice.Reset();
                    PharmaPurchasePrice.SetRange("Vendor No.", Vendor."No.");
                    PharmaPurchasePrice.SetRange("Item No.", Item."No.");
                    if not PharmaPurchasePrice.FindFirst() then begin
                        PharmaPurchasePrice.Init();
                        PharmaPurchasePrice.Validate("Vendor No.", Vendor."No.");
                        PharmaPurchasePrice.Validate("Item No.", Item."No.");
                        PharmaPurchasePrice.Validate("Starting Date", Today);
                        PharmaPurchasePrice.Validate("Ending Date", 21001231D);
                        PharmaPurchasePrice.Validate(Status, PharmaPurchasePrice.Status::Active);
                        PharmaPurchasePrice.Insert(true);
                    end;
                end;
            }

            trigger OnPostDataItem()
            begin
                Message('Import Completed.')
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {

            }
        }

        actions
        {

        }
    }

    var
        PharmaPurchasePrice: Record "Pharma Purchase Price";
}