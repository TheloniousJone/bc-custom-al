page 57002 BIItemAPI
{
    ApplicationArea = All;
    Caption = 'BIItemAPI';
    PageType = List;
    SourceTable = Item;
    UsageCategory = Lists;
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ITEMGROUPID; '')
                {
                    ApplicationArea = all;
                }
                field(ITEMID; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field(ITEMNAME; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field(VENDOR; Rec."Vendor No.")
                {
                    ApplicationArea = all;
                }
                field(DIM1; AXDimCode1)
                {
                    ApplicationArea = all;
                }
                field(DIM2; AXDimCode2)
                {
                    ApplicationArea = all;
                }
                field(DIM3; AXDimCode3)
                {
                    ApplicationArea = all;
                }
                field(COMMISIONGROUPID; Rec."Item Commission Group")
                {
                    ApplicationArea = all;
                }
                field(ADMINROUTE; Rec."Administration Route")
                {
                    ApplicationArea = all;
                }
                field(STORAGECONDITION; Rec."Storage Condition")
                {
                    ApplicationArea = all;
                }
                field(MANUFACTURER; Rec.Manufacturer)
                {
                    ApplicationArea = all;
                }
                field(FORENSIC; Rec."Forensic Group")
                {
                    ApplicationArea = all;
                }
                field(PRINCIPAL; Rec.Principal)
                {
                    ApplicationArea = all;
                }
                field(STATUS; Rec."Item Status")
                {
                    ApplicationArea = all;
                }
                field(ACTIVATESPECIAL; '0')
                {
                    ApplicationArea = all;
                }
                field(ITEMANALYSISGRP3; '')
                {
                    ApplicationArea = all;
                }
                field(ITEMANALYSISGRP2; '')
                {
                    ApplicationArea = all;
                }
                field(ITEMANALYSISGRP1; '')
                {
                    ApplicationArea = all;
                }
                field(PDTTYPE; Rec."Product Type")
                {
                    ApplicationArea = all;
                }
                field(SELLONLINE; SellOnline)
                {
                    ApplicationArea = all;
                }
                field(THERAPEUTIC; Rec."Therapeutic Code")
                {
                    ApplicationArea = all;
                }
                field(DATAREADID; Rec.CurrentCompany)
                {
                    ApplicationArea = all;
                }
                field(BC_PRODUCT_CODE; rec.ShortcutDim4Code)
                {
                    ApplicationArea = all;
                }
                field(BC_INVENTORY_POSTING_GROUP; Rec."Inventory Posting Group")
                {
                    ApplicationArea = all;
                }
            }
        }


    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        if Rec."POM Item" = true then
            SellOnline := '1'
        else
            SellOnline := '0';
        defdim.reset;
        defdim.SetCurrentKey("Table ID", "No.", "Dimension Code", "Dimension Value Code");
        defdim.LoadFields("Table ID", "No.", "Dimension Code", "Dimension Value Code");
        defdim.SetRange("Table ID", 27);
        defdim.SetRange("No.", Rec."No.");
        defdim.SetRange("Dimension Code", 'AXDIM1');
        if defdim.FindFirst() then
            AXDimCode1 := defdim."Dimension Value Code"
        else
            AXDimCode1 := '';
        defdim.reset;
        defdim.SetCurrentKey("Table ID", "No.", "Dimension Code", "Dimension Value Code");
        defdim.LoadFields("Table ID", "No.", "Dimension Code", "Dimension Value Code");
        defdim.SetRange("Table ID", 27);
        defdim.SetRange("No.", Rec."No.");
        defdim.SetRange("Dimension Code", 'AXDIM2');
        if defdim.FindFirst() then
            AXDimCode2 := defdim."Dimension Value Code"
        else
            AXDimCode2 := '';
        defdim.reset;
        defdim.SetCurrentKey("Table ID", "No.", "Dimension Code", "Dimension Value Code");
        defdim.LoadFields("Table ID", "No.", "Dimension Code", "Dimension Value Code");
        defdim.SetRange("Table ID", 27);
        defdim.SetRange("No.", Rec."No.");
        defdim.SetRange("Dimension Code", 'AXDIM3');
        if defdim.FindFirst() then
            AXDimCode3 := defdim."Dimension Value Code"
        else
            AXDimCode3 := '';

    end;

    var
        SellOnline: Code[20];
        AXDimCode1: Code[50];
        AXDimCode2: Code[50];
        AXDimCode3: Code[50];
        DimVal: Record "Dimension Value";
        defdim: Record "Default Dimension";

}