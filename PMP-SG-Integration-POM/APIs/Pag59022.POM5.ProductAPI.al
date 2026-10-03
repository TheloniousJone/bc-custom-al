page 59022 "POM5 Product API"
{
    PageType = API;
    APIPublisher = 'illum9';
    APIGroup = 'pom_integration';
    APIVersion = 'v2.0';
    EntityName = 'product';
    EntitySetName = 'products';
    SourceTable = Item;
    SourceTableTemporary = true;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(number; Rec."No.")
                {
                }
                field(description; Rec.Description)
                {
                }
                field(base_uom; Rec."Base Unit of Measure")
                {
                }
                field(item_status; Rec."Item Status")
                {
                }
                field(generic_name; Rec."Generic Name")
                {
                }
                field(manufacturer; Rec.Manufacturer)
                {
                }
                field(principal; Rec.Principal)
                {
                }
                field(Inventory; Rec.Inventory)
                {
                }
                field(sales_uom; Rec."Sales Unit of Measure")
                {
                }
                field(vendor; Rec."Vendor No.")
                {
                }
                field(search_desc; Rec."Search Description")
                {
                }
                field(minorder; Rec."Minimum Order Quantity")
                {
                }
                field(maxorder; Rec."Maximum Order Quantity")
                {
                }
                field(pom_item; Rec."POM Item")
                {
                }
                field(item_sub_counter; Rec."Common Item No.")
                {
                }
                field(allow_invoice_disc; Rec."Allow Invoice Disc.")
                {
                }
                field(expiry; format(ExpiryDate, 0, '<Closing><Year4>/<Month,2>/<Day,2>'))
                {
                }
                field(balance; Balance)
                {
                }
                field(modified_at; Rec.SystemModifiedAt)
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        ItemRec: Record Item;
    begin
        ItemRec.SetLoadFields(
            ItemRec."Item Status", ItemRec."POM Item", ItemRec."No.", ItemRec.Description,
            ItemRec."Base Unit of Measure", ItemRec."Item Status", ItemRec."Generic Name", ItemRec.Manufacturer,
            ItemRec.Principal, ItemRec.Inventory, ItemRec."Sales Unit of Measure", ItemRec."Vendor No.",
            ItemRec."Search Description", ItemRec."Minimum Order Quantity", ItemRec."Maximum Order Quantity",
            ItemRec."Common Item No.", ItemRec."Allow Invoice Disc.", ItemRec."POM Item", ItemRec."Location Filter", ItemRec.SystemModifiedAt
        );

        // KL: don't filter, cuz need updates for status changes
        // ItemRec.SetFilter("Item Status", '<>%1&<>%2&<>%3', 'DISCONTINUED', 'INACTIVE', 'DISCONTINUED BY PRINCIPAL');
        // ItemRec.SetFilter("POM Item", '=%1', true);
        // ItemRec.SetRange("Location Filter", 'PMP-WH'); // YF 09 Mar 2022

        if ItemRec.FindSet() then
            repeat

                // YF 09 Mar 2022
                ItemRec.CalcFields("Qty. on Sales Order");
                Rec."Unit Cost" := ItemRec."Qty. on Sales Order";
                // YF 09 Mar 2022

                Rec.CalcFields(Inventory);

                Rec."No." := ItemRec."No.";
                Rec.Description := ItemRec.Description;
                Rec."Base Unit of Measure" := ItemRec."Base Unit of Measure";
                Rec."Item Status" := ItemRec."Item Status";
                Rec."Generic Name" := ItemRec."Generic Name";
                Rec.Manufacturer := ItemRec.Manufacturer;
                Rec.Principal := ItemRec.Principal;
                Rec.Inventory := ItemRec.Inventory;
                Rec."Sales Unit of Measure" := ItemRec."Sales Unit of Measure";
                Rec."Vendor No." := ItemRec."Vendor No.";
                Rec."Search Description" := ItemRec."Search Description";
                Rec."Minimum Order Quantity" := ItemRec."Minimum Order Quantity";
                Rec."Maximum Order Quantity" := ItemRec."Maximum Order Quantity";
                Rec."Common Item No." := ItemRec."Common Item No.";
                Rec."Allow Invoice Disc." := ItemRec."Allow Invoice Disc.";
                Rec."POM Item" := ItemRec."POM Item";
                Rec.SystemModifiedAt := ItemRec.SystemModifiedAt;

                Rec.Insert(false);

            until ItemRec.next = 0;
    end;

    trigger OnAfterGetRecord()
    var
        ILERec: Record "Item Ledger Entry";
    begin
        ILERec.SetLoadFields(
            ILERec."Item No.", ILERec."Variant Code", ILERec.Positive, ILERec."Remaining Quantity",
            ILERec."Expiration Date", ILERec."Location Code"
        );

        ILERec.SetRange("Item No.", Rec."No.");
        ILERec.SetCurrentKey("Expiration Date");
        ILERec.SetRange("Variant Code", ''); //RL  16 Feb 2022
        ILERec.SetRange(Positive, true);
        ILERec.SetFilter("Remaining Quantity", '<>0');
        ILERec.SetFilter("Expiration Date", '''''|>=%1', CalcDate('30D', Today));  //RL  09 Dec 2021
        ILERec.SetAscending("Expiration Date", true);
        ILERec.SetRange("Location Code", 'PMP-WH');

        ILERec.CalcSums("Remaining Quantity");
        Balance := ILERec."Remaining Quantity" - Rec."Unit Cost"; // YF 09 Mar 2022 - "Remaining qty - qty on sales order"
        if Balance < 0 then //RL 06 Sept 2022
            Balance := 0;

        if ILERec.FindFirst() then
            ExpiryDate := ILERec."Expiration Date"
        else
            ExpiryDate := 0D;

    end;

    var
        Balance: Decimal;
        ExpiryDate: Date;
}