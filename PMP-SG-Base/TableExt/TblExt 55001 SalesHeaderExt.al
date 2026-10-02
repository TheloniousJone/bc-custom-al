tableextension 55001 SalesHeaderExt extends "Sales Header"
{
    fields
    {
        // Add changes to table fields here
        field(55000; "Customer Instructions"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(55001; "Picking Instructions"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(55002; "Delivery Instructions"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(55003; "Order Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,Processing,Picking,"Pending Checking",Checking,"Pending Delivery","Delivery In Progress",Delivered,Invoiced,Completed;
        }
        field(55004; "TBA Order"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(55005; "Logistics Service"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(55006; "Credit Period App. Required"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(55007; "Max Qty Item App. Required"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        // YF 29 Jul 2021 for Issue #55
        field(55008; "Partial Delivery"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Partial Delivery';
        }
        // YF 29 Jul 2021 for Issue #55
        //DX        02 Aug 2021 for issue #54
        field(55009; Archived; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //DX        02 Aug 2021
        //DX        08 Aug 2021 for Issue #78
        field(55010; "Samples SO"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //DX        08 Aug 2021 for Issue #78
        //DX        15 Aug 2021 for Issue 106
        field(55011; "Hold"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'On Hold SO';
            trigger OnValidate()
            var
                myInt: Integer;
                ALERec: Record "Assignment Ledger Entry";
            begin
                //DX        21 Sept 2021
                if Rec."Document Type" = Rec."Document Type"::Order then begin
                    ALERec.reset;
                    ALERec.SetRange("Document No.", Rec."No.");
                    if ALERec.FindFirst() then begin
                        ALERec."On Hold" := Rec.Hold;
                        ALERec.Modify(FALSE);
                    end;
                end;
                //DX        21 Sept 2021
            end;
        }
        //DX        15 Aug 2021 
        //DX        17 Aug 2021
        field(55019; "Delivery Zone"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Delivery Zone";
        }
        field(55020; "Sales Area"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sales Area";
        }
        field(55021; "Delivery Charge"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Delivery Charge";
        }
        //DX        17 Aug 2021

        // YF        20 Aug 2021
        // For PO Integration Source Identifier
        field(55022; "PO Integration Source"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(55023; "PO Integration Source Ref No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        // YF        20 Aug 2021
        //DX        22 Aug 2021
        field(55024; Rebill; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(55025; "Rebill SO"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        //DX        22 Aug 2021
        //DX        30 Aug 2021
        field(55026; "SO Placed By"; Text[50])
        {
            Caption = 'SO Placed By';
            DataClassification = ToBeClassified;
        }
        //DX        30 Aug 2021
        //DX        31 Aug 2021
        field(55027; "Priority Picking"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(55028; "Chain Pharmacy"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(55029; "Exported"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //DX        31 Aug 2021

        field(55030; "Return Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Checker to verify","Checker verified","Return Goods In Warehouse","CSO Request for Collection","Collection Requested from Driver","Issue Encountered Upon Collection","QC to verify","QC verified";     //DX    08 Jun 2023 New Value
        }

        field(55031; "LS Account"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "LS Account".Code;
            Caption = 'LS Account';
        }

        // YF 21 Sept 2021

        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            begin
                UpdateWithCustomerAdditionalDetails(true);
            end;
        }

        modify("Sell-to Customer Name")
        {
            trigger OnAfterValidate()
            begin
                UpdateWithCustomerAdditionalDetails(true);
            end;
        }

        field(55032; "Branch/Subsidiary"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        // YF 21 Sept 2021
        //DX        26 Sept 2021
        field(55033; "Order Taken By"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        //DX        26 Sept 2021
        //DX        06 Oct 2021 //ADDED TO WRONG TABLE
        field(55034; "Single PO"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //DX        06 Oct 2021

        // YF        14 Oct 2021
        field(55035; "Out of Stock"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Out of Stock';
        }

        field(55036; "Insufficient Stocks in Pick"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Insufficient Stocks in Active Area';
        }
        // YF        14 Oct 2021

        //RL    12 Jan 2022
        field(55037; "Arrival Port"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Arrival Port';
        }
        field(55038; "Sub-Acct Name"; text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sub-Acct Name';
        }
        //RL    12 Jan 2022
        //RL        14 Feb 2022
        field(55070; "ShortcutDim3Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, ShortcutDim3Code);
            end;
        }
        field(55071; "ShortcutDim4Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 4 Code';
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, ShortcutDim4Code);
            end;
        }
        field(55072; "ShortcutDim5Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 5 Code';
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(5, ShortcutDim5Code);
            end;
        }
        field(55073; "ShortcutDim6Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 6 Code';
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(6, ShortcutDim6Code);
            end;
        }
        field(55074; "ShortcutDim7Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 7 Code';
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(7, ShortcutDim7Code);
            end;
        }
        field(55075; "ShortcutDim8Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 8 Code';
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(8, ShortcutDim8Code);
            end;
        }
        //RL        14 Feb 2022
        //RL        19 July 2022
        field(55076; "I9G_ReturnReasonCode"; Code[10])
        {
            Caption = 'Return Reason Code';
            TableRelation = "Return Reason";
        }
        //RL        19 July 2022
        //RL        01 Dec 2022 - FOR chain orders
        field(55077; "I9G_Ready_to_Process_SO"; Boolean)
        {
            Caption = 'Ready to Process_SO';
        }
        field(55078; "I9G_Push_to_Open_SO"; Boolean)
        {
            Caption = 'Push to Open SO';
        }
        //RL        01 Dec 2022
        field(55079; "I9G_Reason_Text"; Text[500])
        {
            Caption = 'Reason Text';
        }
        field(55080; "I9G_Import_License_No"; Code[35])
        {
            Caption = 'Import License No (For Unregistered TP)';
        }
        field(55081; "WS Membership"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "WS Membership";
        }
        field(55082; "Issue Encountered"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(55083; "I9G_Wellaway_Pick"; Boolean)
        {
            Caption = 'Wellaway Pick';
        }
        //RL08102024 - Do not use field 55084 as already used in posted table
        field(55085; "Customer Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Customer Group";
        }
        //KP11Nov2024
        field(55086; I9G_RequirementApproval; Boolean)
        {
            Caption = 'Requirement Approval';
            Editable = false;
        }
        //KP11Nov2024
        field(55087; I9G_ContractRef; Text[100])
        {
            Caption = 'Contract Ref.';
        }
        //DX        26 May 2026
        field(55088; "I9G_NFRemarks"; Text[250])
        {
            caption = 'NF Remarks';
        }
        //DX        26 May 2026
    }

    // YF 21 Sept 2021 Global Table Function to Handle Instructions and other details
    trigger OnAfterInsert()
    begin
        UpdateWithCustomerAdditionalDetails(false);
        Rec.Modify(true);
    end;

    procedure UpdateWithCustomerAdditionalDetails(IsFieldTriggered: Boolean)
    var
        SSSetup: Record "Sales & Receivables Setup";
        CustRec: Record Customer;
        SHRec: Record "Sales Header";
        AllowedList: Record "Allowed Cust-Item";
        // UserGrpMemberRec: Record "User Group Member"; // YF 2024-10-11 // BC 25 Upgrade
        AccessControlRec: Record "Access Control"; // YF 2024-10-11 // BC 25 Upgrade
    begin

        if (CustRec.Get(Rec."Sell-to Customer No.")) And IsFieldTriggered then begin
            Rec."Customer Instructions" := CustRec."Customer Instructions";
            Rec."Delivery Instructions" := CustRec."Delivery Instructions";
            Rec."Picking Instructions" := CustRec."Picking Instructions";
            Rec."Delivery Charge" := CustRec."Delivery Charge";
            rec."Delivery Zone" := CustRec."Delivery Zone";
            Rec."Priority Picking" := CustRec."Priority Picking";
            Rec."Chain Pharmacy" := CustRec."Chain Pharmacy";
            Rec."Sales Area" := CustRec."Sales Area";
            Rec."Logistics Service" := CustRec."Logistics Service";
            Rec."Branch/Subsidiary" := CustRec."Branch/Subsidiary";
            Rec."WS Membership" := CustRec."WS Membership";
            Rec."Customer Group" := CustRec."Customer Group";

            //DX        03 Sept 2021
            AllowedList.reset;
            if SHRec."Bill-to Customer No." <> '' then
                AllowedList.SetRange("Cust No.", SHRec."Bill-to Customer No.")
            else
                AllowedList.SetRange("Cust No.", SHRec."Sell-to Customer No.");

            // if AllowedList.FindFirst() then begin
            //     Rec."Chain Pharmacy" := true;
            // end;
            //DX        03 Sept 2021
            //DX        06 Oct 2021
            if CustRec."Bill Name" <> '' then begin
                Rec."Bill-to Name" := CustRec."Bill Name";
                Rec."Bill-to Name 2" := CustRec."Bill Name 2";
                Rec."Bill-to Address" := CustRec."Bill Address"; // YF 08 Sep 2023 // Remove trailing spaces
                // Rec."Bill-to Address 2" := CustRec."Bill Address 2"; // YF 18 Nov 2021 // Bug Fix
                Rec."Bill-to Address 2" := CopyStr(CustRec."Bill Address 2", 1, 50); // YF 18 Nov 2021 // Bug Fix
                // Rec."Bill-to City" := CustRec."Bill City"; // YF 18 Nov 2021 // Bug Fix
                Rec."Bill-to City" := CopyStr(CustRec."Bill City", 1, 30); // YF 18 Nov 2021 // Bug Fix
                Rec."Bill-to Contact" := CustRec."Bill Contact";
                Rec."Bill-to Country/Region Code" := CustRec."Bill Country Code";
                // Rec."Bill-to County" := CustRec."Bill County"; // YF 18 Nov 2021 // Bug Fix
                Rec."Bill-to County" := CopyStr(CustRec."Bill County", 1, 30); // YF 18 Nov 2021 // Bug Fix
                Rec."Bill-to Post Code" := CustRec."Bill Post Code";
            end;
            //DX        06 Oct 2021
        end;

        // Get Sales Setup
        SSSetup.Reset;
        SSSetup.Get;
        if SSSetup."Order Taken by To Created" = true then begin
            Rec.Validate("Order Taken By", UserId);
        end;

        //DX        08 Aug 2021
        if Rec."Logistics Service" = true then begin
            if SSSetup."Def. LS Location Code" <> '' then begin
                Rec.Validate("Location Code", SSsetup."Def. LS Location Code");
            end;
        end;
        //DX        08 Aug 2021        

        if Rec."Document Type" <> Rec."Document Type"::"Blanket Order" then begin
            // Handle LS User Group Conditions
            // YF 2024-10-11 // BC25 Upgrade
            if SSSetup."Def. LS User Group" <> '' then begin
                AccessControlRec.Reset;
                AccessControlRec.SetRange("Role ID", SSSetup."Def. LS User Group");
                AccessControlRec.SetRange("Company Name", CompanyName);
                AccessControlRec.SetRange("User Security ID", UserSecurityId());
                // AccessControlRec.SetRange("User Name", UserId);

                if AccessControlRec.FindFirst() then begin
                    Rec."Logistics Service" := true;
                    if SSSetup."Def. LS Location Code" <> '' then begin
                        Rec.Validate("Location Code", SSsetup."Def. LS Location Code");
                    end;
                end;
            end;
            /*
            if SSSetup."Def. LS User Group" <> '' then begin
                UserGroupMemberRec.Reset;
                UserGroupMemberRec.SetRange("User Group Code", SSSetup."Def. LS User Group");
                UserGroupMemberRec.SetRange("User Security ID", UserSecurityId());
                UserGroupMemberRec.SetRange("Company Name", CompanyName);
                if UserGroupMemberRec.FindFirst() then begin
                    Rec."Logistics Service" := true;
                    if SSSetup."Def. LS Location Code" <> '' then begin
                        Rec.Validate("Location Code", SSsetup."Def. LS Location Code");
                    end;
                end;
            end;
            */
            // YF 2024-10-11 // BC25 Upgrade
        end;

        // Rec.Modify(true);

    end;
    // YF 21 Sept 2021 Global Table Function to Handle Instructions and other details


    // YF 21 Sept 2021 // Disable for now to let page have control instead
    /*
    trigger OnAfterInsert()
    var
        CustRec: Record customer;
    begin
        CustRec.reset;
        CustRec.SetRange("No.", "Sell-to Customer No.");
        if CustRec.FindFirst() then begin
            if CustRec."Logistics Service" = true then begin
                Rec."Logistics Service" := true
            end else begin
                rec."Logistics Service" := false;
            end;
            "Customer Instructions" := CustRec."Customer Instructions";
            "Delivery Instructions" := CustRec."Delivery Instructions";
            "Picking Instructions" := CustRec."Picking Instructions";
            //DX        17 Aug 2021
            "Delivery Charge" := CustRec."Delivery Charge";
            "Delivery Zone" := CustRec."Delivery Zone";
            "Sales Area" := CustRec."Sales Area";
            //DX        17 Aug 2021
            //DX        31 Aug 2021
            "Priority Picking" := CustRec."Priority Picking";
            "Chain Pharmacy" := CustRec."Chain Pharmacy";
            //DX        31 Aug 2021
        end;
    end;
    */
    // YF 21 Sept 2021 // Disable for now to let page have control instead
}