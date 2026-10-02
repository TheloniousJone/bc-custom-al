//TN        21 Sept 2026
// Custom API port of page 59010 "Item API" (PageType = List).
// /api/illum9/pom_integration/v2.0/companies({id})/items
page 59027 "POM Item API"
{
    PageType = API;
    APIPublisher = 'illum9';
    APIGroup = 'pom_integration';
    APIVersion = 'v2.0';
    EntityName = 'item';
    EntitySetName = 'items';
    SourceTable = Item;
    SourceTableTemporary = true;
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    //ODataKeyFields = SystemId;

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
                field(item_status; ItemStatus)
                {
                }
                field(sales_uom; Rec."Sales Unit of Measure")
                {
                }
                field(generic_name; Rec."Generic Name")
                {
                }
                field(available; Available)
                {
                }
                field(expiry; Format(ExpiryDate, 0, '<Closing><Year4>/<Month,2>/<Day,2>'))
                {
                }
                field(forensic_group; Rec."Forensic Group")
                {
                }
                field(product_type; Rec."Product Type")
                {
                }
                field(storage_condition; Rec."Storage Condition")
                {
                }
                field(manufacturer; Rec.Manufacturer)
                {
                }
                field(principal; Rec.Principal)
                {
                }
                field(wholesales_price; Rec."Unit Price")
                {
                }
                field(created_at; Rec.SystemCreatedAt)
                {
                }
                field(modified_at; Rec.SystemModifiedAt)
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetPageData();
    end;

    trigger OnAfterGetRecord()
    var
        ILERec: Record "Item Ledger Entry";
    begin
        ILERec.SetLoadFields(
            ILERec."Item No.", ILERec."Variant Code", ILERec.Positive, ILERec."Remaining Quantity",
            ILERec."Expiration Date", ILERec."Location Code"
        );

        ILERec.Reset();
        ILERec.SetCurrentKey("Expiration Date");
        ILERec.SetRange("Item No.", Rec."No.");
        ILERec.SetRange("Variant Code", ''); //RL  16 Feb 2022
        ILERec.SetRange(Positive, true);
        ILERec.SetFilter("Remaining Quantity", '<>0');
        ILERec.SetFilter("Expiration Date", '>=%1', CalcDate('30D', Today));  //RL  09 Dec 2021
        ILERec.SetAscending("Expiration Date", true);
        ILERec.SetRange("Location Code", 'PMP-WH');

        if ILERec.FindFirst() then
            ExpiryDate := ILERec."Expiration Date"
        else
            ExpiryDate := 0D;

        //Inventory is a FlowField; CalcFields on the temporary record still evaluates against the database.
        Rec.CalcFields(Inventory);

        if Rec.Inventory > 0 then
            Available := 'Yes'
        else
            Available := 'No';

        ItemStatusRec.Reset();
        ItemStatusRec.SetRange("Status Code", Rec."Item Status");

        if ItemStatusRec.FindFirst() then
            ItemStatus := ItemStatusRec."POM2 Status V2"
        else
            ItemStatus := '';
    end;

    local procedure SetPageData()
    var
        ItemRec: Record Item;
    begin
        ItemRec.SetLoadFields(
            ItemRec."No.", ItemRec.Description, ItemRec."Base Unit of Measure", ItemRec."Item Status",
            ItemRec."Sales Unit of Measure", ItemRec."Generic Name", ItemRec."Forensic Group",
            ItemRec."Product Type", ItemRec."Storage Condition", ItemRec.Manufacturer, ItemRec.Principal,
            ItemRec."Unit Price", ItemRec."POM Item", ItemRec.SystemId, ItemRec.SystemCreatedAt,
            ItemRec.SystemModifiedAt, ItemRec.SystemModifiedBy
        );

        ItemRec.Reset();
        //Carried over from page 59010 as-is: the filter string only uses %1, so only DISCONTINUED is
        //excluded - INACTIVE and DISCONTINUED BY PRINCIPAL are still returned.
        ItemRec.SetFilter("Item Status", '<>%1', 'DISCONTINUED');
        ItemRec.SetFilter("POM Item", '=%1', true);
        if ItemRec.FindSet() then
            repeat
                Rec.Init();
                //Reuse the real item's SystemId so each row has a stable OData key across calls.
                Rec.SystemId := ItemRec.SystemId;
                Rec."No." := ItemRec."No.";
                Rec.Description := ItemRec.Description;
                Rec."Base Unit of Measure" := ItemRec."Base Unit of Measure";
                Rec."Item Status" := ItemRec."Item Status";
                Rec."Sales Unit of Measure" := ItemRec."Sales Unit of Measure";
                Rec."Generic Name" := ItemRec."Generic Name";
                Rec."Forensic Group" := ItemRec."Forensic Group";
                Rec."Product Type" := ItemRec."Product Type";
                Rec."Storage Condition" := ItemRec."Storage Condition";
                Rec.Manufacturer := ItemRec.Manufacturer;
                Rec.Principal := ItemRec.Principal;
                Rec."POM Item" := ItemRec."POM Item";
                Rec."Unit Price" := ItemRec."Unit Price";
                Rec.SystemCreatedAt := ItemRec.SystemCreatedAt;
                Rec.SystemModifiedAt := ItemRec.SystemModifiedAt;
                Rec.SystemModifiedBy := ItemRec.SystemModifiedBy;
                Rec.Insert(false);
            until ItemRec.Next() = 0;
    end;

    var
        ItemStatusRec: Record "Item Status";
        ItemStatus: Text[35];
        Available: Text[10];
        ExpiryDate: Date;
}
//TN        21 Sept 2026
