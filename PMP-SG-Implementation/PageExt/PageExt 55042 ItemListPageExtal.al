pageextension 55042 "ItemListPageExt.al" extends "Item List"
{
    layout
    {

        addafter(Description)
        {
            field("Item Status"; Rec."Item Status")
            {
                ApplicationArea = all;
            }
            field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
            {
                ApplicationArea = all;
            }
            field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
            {
                ApplicationArea = all;
            }

            // YF 26 Oct 2021
            field("I9_Qty. on Blanket Sales Order"; Rec."I9_Qty. on Blanket Sales Order")
            {
                ApplicationArea = All;
            }
            field("Qty. on Transfer Inbound"; Rec."Qty. on Transfer Inbound")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Qty. on Transfer Outbound field.';
            }
            field("Qty. on Transfer Outbound"; Rec."Qty. on Transfer Outbound")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Qty. on Transfer Outbound field.';
            }

            field(LotNo; LotNo)
            {
                Caption = 'Lot No.';
                ApplicationArea = All;
                Editable = false;
            }

            field(ExpiryDate; ExpiryDate)
            {
                Caption = 'Expiry Date';
                ApplicationArea = All;
                Editable = false;
            }
            // YF 26 Oct 2021

            field("Generic Name"; Rec."Generic Name")
            {
                ApplicationArea = all;
            }
            //DX        30 Aug 2021
            field("Forensic Group"; Rec."Forensic Group")
            {
                ApplicationArea = all;
            }
            field(Principal; Rec.Principal)
            {
                ApplicationArea = all;
            }
            field(SystemCreatedBy; enhanceCU.GetUsername(Rec.SystemCreatedBy))
            {
                ApplicationArea = all;
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = all;
            }
            field(SystemModifiedAt; Rec.SystemModifiedAt)
            {
                ApplicationArea = all;
            }
            //DX        30 Aug 2021
            field("POM Item"; Rec."POM Item")
            {
                ApplicationArea = all;
            }
            field("Wellaway Item"; Rec."Wellaway Item")
            {
                ApplicationArea = all;
            }

        }
        addafter("Vendor No.")
        {
            field(VendorName; VendorName)
            {
                ApplicationArea = All;
            }
        }

        addafter(VendorName)
        {
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
                Visible = true;
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(ShortcutDim3Code; Rec.ShortcutDim3Code)
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(ShortcutDim4Code; Rec.ShortcutDim4Code)
            {
                ApplicationArea = All;
            }
            field(ShortcutDim5Code; Rec.ShortcutDim5Code)
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(ShortcutDim6Code; Rec.ShortcutDim6Code)
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(ShortcutDim7Code; Rec.ShortcutDim7Code)
            {
                ApplicationArea = All;
            }
            field(ShortcutDim8Code; Rec.ShortcutDim8Code)
            {
                ApplicationArea = All;
            }

        }
    }
    actions
    {
        moveafter("Item Refe&rences"; "&Bin Contents")

        addafter(Action40)
        {
            action("POM2 Therapeutic Group")
            {
                ApplicationArea = All;
                Image = ShowList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "POM2 Therapeutic Group";
            }
            action("POM3 Therapeutic Group")
            {
                ApplicationArea = All;
                Image = ShowList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "POM3 Therapeutic Setup";
            }
            action("Check Stock Avail.")
            {
                ApplicationArea = All;
                Image = ShowList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page CheckStockAvail;
            }
            action("Tracing")
            {
                ApplicationArea = All;
                Image = ShowList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Item Tracing";
            }
            action("Bin Contents")
            {
                ApplicationArea = All;
                Image = ShowList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Bin Content"; // YF 08 Aug 2024 // MS BC Patch
                // RunObject = page 7379; // YF 08 Aug 2024 // MS BC Patch
            }
            action("Item Re&ferences2")
            {
                ApplicationArea = All;
                Caption = 'Item Re&ferences';
                Visible = True;
                Image = Change;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Item Reference Entries";
                RunPageLink = "Item No." = FIELD("No.");
                ToolTip = 'Set up a customer''s or vendor''s own identification of the item. Item references to the customer''s item number means that the item number is automatically shown on sales documents instead of the number that you use.';
            }
            action("Item Restrictions")
            {
                ApplicationArea = All;
                Image = ShowList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page ItemRestrictions; // YF 08 Aug 2024 // MS BC Patch
                // RunObject = page 7379; // YF 08 Aug 2024 // MS BC Patch
            }
            action("NF Line Remarks")
            {
                ApplicationArea = All;
                Image = ShowList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page NFLineRemarks; // YF 08 Aug 2024 // MS BC Patch
                // RunObject = page 7379; // YF 08 Aug 2024 // MS BC Patch
            }
        }
    }

    var
        enhanceCU: Codeunit "PMP-Enhancements";
        ExpiryDate: Date;
        LotNo: Code[50];
        VendorName: text[100];

    local procedure RefreshLotInfo()
    var
        ILERec: Record "Item Ledger Entry";
        CompInfo: Record "Company Information";
    begin
        CompInfo.Get;
        LotNo := '';
        ExpiryDate := 0D;
        ILERec.Reset;
        ILERec.SetLoadFields("Item No.", "Location Code", Open, "Remaining Quantity", "Variant Code", "Entry No.", "Expiration Date", "Lot No.");  //DX    03 May 2023
        ILERec.SetCurrentKey("Item No.", "Location Code", Open, "Expiration Date", "Remaining Quantity");      //DX        24 May 2023
        ILERec.SetRange("Item No.", Rec."No.");
        //RL    13 Jan 2022
        // ILERec.SetRange("Location Code", 'PMP-WH');
        ILERec.SetRange("Location Code", CompInfo."Location Code");
        //RL    13 Jan 2022
        ILERec.SetRange(Open, true);
        ILERec.SetFilter("Remaining Quantity", '>0');
        ILERec.SetFilter("Variant Code", '%1', ''); //RL    10 Jan 2023        
        if ILERec.FindFirst() then begin
            LotNo := ILERec."Lot No.";
            ExpiryDate := ILERec."Expiration Date";
        end;
    end;

    trigger OnAfterGetCurrRecord()
    var
        Vendor: Record Vendor;
    begin
        RefreshLotInfo();
        clear(VendorName);
        Vendor.Reset();
        Vendor.SetLoadFields(Name, "No.");  //DX        03 May 2023
        Vendor.SetRange("No.", rec."Vendor No.");
        if Vendor.FindFirst() then begin
            VendorName := Vendor.Name;
        end;
    end;


    trigger OnAfterGetRecord()
    var
        Vendor: Record Vendor;
    begin
        RefreshLotInfo();
        clear(VendorName);
        Vendor.Reset();
        Vendor.SetLoadFields(Name, "No.");  //DX        03 May 2023
        Vendor.SetRange("No.", rec."Vendor No.");
        if Vendor.FindFirst() then begin
            VendorName := Vendor.Name;
        end;
    end;
}
