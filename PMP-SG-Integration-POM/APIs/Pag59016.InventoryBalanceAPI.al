page 59016 "Inventory Balance API"
{

    ApplicationArea = All;
    Caption = 'Inventory Balance API';
    PageType = List;
    SourceTable = Item;
    SourceTableTemporary = true;
    UsageCategory = Lists;

    layout
    {

        area(content)
        {
            repeater(General)
            {

                field("No."; rec."No.")
                {
                    ApplicationArea = All;
                }

                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Balance; Balance)
                {
                    ApplicationArea = All;
                }

                // field("Base Unit of Measure"; rec."Base Unit of Measure")
                // {
                //     ApplicationArea = All;
                // }

                // field("Item Status"; ItemStatus)
                // {
                //     ApplicationArea = All;
                // }

                // field("Sales Unit of Measure"; rec."Sales Unit of Measure")
                // {
                //     ApplicationArea = All;
                // }

                // field("Generic Name"; rec."Generic Name")
                // {
                //     ApplicationArea = All;
                // }

                // //avilable
                // field("Available"; Available)
                // {
                //     ApplicationArea = All;
                // }
                // //expiry date
                // // field("Expiry"; ExpiryDate)
                // // {
                // //     ApplicationArea = All;
                // // }
                // field("Expiry"; format(ExpiryDate, 0, '<Closing><Year4>/<Month,2>/<Day,2>'))
                // {
                //     ApplicationArea = All;
                // }

                // field("Forensic Group"; rec."Forensic Group")
                // {
                //     ApplicationArea = All;
                // }

                // //product type
                // field("Product Type"; rec."Product Type")
                // {
                //     ApplicationArea = All;
                // }
                // field("Storage Condition"; rec."Storage Condition")
                // {
                //     ApplicationArea = All;
                // }

                // field(Manufacturer; rec.Manufacturer)
                // {
                //     ApplicationArea = All;
                // }

                // field(Principal; rec.Principal)
                // {
                //     ApplicationArea = All;
                // }

                // //whole sales price
                // field("Wholesales Price"; rec."Unit Price")
                // {
                //     ApplicationArea = All;
                // }
                // field(SystemCreatedAt; Rec.SystemCreatedAt)
                // {
                //     ApplicationArea = all;
                // }
                // field(SystemModifiedAt; Rec.SystemModifiedAt)
                // {
                //     ApplicationArea = all;
                // }
            }

        }
    }
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        ILERec: Record "Item Ledger Entry";
    begin
        Clear(Balance);
        ILERec.Reset();
        ILERec.SetCurrentKey("Expiration Date");
        ILERec.SetRange("Item No.", rec."No.");
        ILERec.SetRange("Variant Code", ''); //RL  16 Feb 2022
        ILERec.SetRange(Positive, true);
        ILERec.SetFilter("Remaining Quantity", '<>0');
        ILERec.SetFilter("Expiration Date", '>=%1', CalcDate('30D', Today));  //RL  09 Dec 2021
        ILERec.SetAscending("Expiration Date", true);
        ILERec.SetRange("Location Code", 'PMP-WH');
        ILERec.CalcSums("Remaining Quantity");
        Balance := ILERec."Remaining Quantity";

        // if ILERec.findfirst then begin
        //     LOtNum := ILERec."Lot No.";
        //     ExpiryDate := ILERec."Expiration Date";
        // end else begin
        //     LOtNum := '';
        //     ExpiryDate := 0D;
        // end;



        // if rec."POM Item" = true then begin
        //     Available := 'Yes';
        // end else begin
        //     Available := 'No';
        // end;

        //rec.SetFilter("Location Filter", 'PMP-WH');
        // rec.CalcFields(Inventory);

        // if rec.Inventory > 0 then begin
        //     Available := 'Yes';
        // end else begin
        //     Available := 'No';
        // end;


        // ItemStatusRec.reset;
        // ItemStatusRec.setrange("Status Code", rec."Item Status");

        // if ItemStatusRec.FindFirst() then begin
        //     ItemStatus := ItemStatusRec."POM2 Status V2";

        //     // Message(ItemStatus);
        // end else begin
        //     ItemStatus := '';
        // end;

    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        SetPageData();
    end;

    local procedure SetPageData()
    var
        myInt: Integer;
        ItemRec: Record Item;
        ILERec: Record "Item Ledger Entry";
    begin
        ItemRec.reset;
        ItemRec.setfilter("Item Status", '<>%1&<>%2&<>%3', 'DISCONTINUED', 'INACTIVE', 'DISCONTINUED BY PRINCIPAL');
        itemrec.SetFilter("POM Item", '=%1', true);
        if ItemRec.FindSet() then
            repeat
                Clear(Balance);
                ILERec.Reset();
                ILERec.SetCurrentKey("Expiration Date");
                ILERec.SetRange("Item No.", ItemRec."No.");
                ILERec.SetRange(Positive, true);
                ILERec.SetRange("Variant Code", ''); //RL  16 Feb 2022
                ILERec.SetFilter("Remaining Quantity", '<>0');
                ILERec.SetFilter("Expiration Date", '>=%1', CalcDate('30D', Today));  //RL  09 Dec 2021
                ILERec.SetAscending("Expiration Date", true);
                ILERec.SetRange("Location Code", 'PMP-WH');
                ILERec.CalcSums("Remaining Quantity");

                // ItemRec.SetFilter("Location Filter", '%1', 'PMP-WH');
                // ItemRec.CalcFields(Inventory);
                if ILERec."Remaining Quantity" < ItemRec."Reorder Point" then begin

                    Rec."No." := ItemRec."No.";
                    rec.Description := itemrec.Description;
                    // Balance := ILERec."Remaining Quantity";
                    // rec."Base Unit of Measure" := ItemRec."Base Unit of Measure";
                    // rec."Item Status" := ItemRec."Item Status";
                    // rec."Sales Unit of Measure" := ItemRec."Sales Unit of Measure";
                    // rec."Generic Name" := ItemRec."Generic Name";
                    // rec."Forensic Group" := ItemRec."Forensic Group";
                    // rec."Storage Condition" := itemrec."Storage Condition";
                    // rec.Manufacturer := ItemRec.Manufacturer;
                    // rec."POM Item" := itemrec."POM Item";
                    // rec.Principal := ItemRec.Principal;
                    // Rec.SystemModifiedAt := ItemRec.SystemModifiedAt;
                    // Rec.SystemCreatedAt := ItemRec.SystemCreatedAt;
                    // Rec.SystemModifiedAt := ItemRec.SystemModifiedAt;
                    // Rec.SystemModifiedBy := ItemRec.SystemModifiedBy;
                    // if ItemRec."Product Type" = ' ' then begin
                    //     rec."Product Type" := ' ';
                    // end else begin
                    //     rec."Product Type" := ItemRec."Product Type";
                    // end;

                    // rec."Unit Price" := ItemRec."Unit Price";
                    // rec.Inventory := itemrec.Inventory;
                    Rec.insert(FALSE);
                end;
            until ItemRec.next = 0;
    end;

    var
        Addr: Text[1000];
        LOtNum: text[30];
        Available: text[10];
        ExpiryDate: date;
        ItemStatus: text[35];
        ItemStatusRec: Record "Item Status";
        Balance: Decimal;
    //Customer account	Customer name	Branch/subsidiary	Fax	Telephone	E-mail	Contact person	Street name	ZIP code	Customer status	Corporate sales rep (PMP)		

}
