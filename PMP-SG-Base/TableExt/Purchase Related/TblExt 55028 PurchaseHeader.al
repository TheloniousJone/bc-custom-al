tableextension 55028 PurchaseHeaderTblExt extends "Purchase Header"
{

    fields
    {
        field(55000; "Created From Req. Wksht."; Boolean)
        {
            Caption = 'Created from Requsition Worksheet';
        }

        //DX        15 Aug 2021 For #issue 110
        field(55013; ">5K"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(55014; ">300K"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(55015; ">6 Mth Inventory"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //DX        15 Aug 2021
        //DX        31 Aug 2021
        field(55016; "Logistics Service"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //DX        31 Aug 2021

        field(55017; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }

        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            var
                VendorRec: Record Vendor;
            begin
                // update shipping agent code
                if VendorRec.Get("Buy-from Vendor No.") then
                    Rec."Shipping Agent Code" := VendorRec."Shipping Agent Code";
                Rec."Ship From Country" := VendorRec."Ship From Country";
            end;
        }

        field(55018; "Internal Remarks"; Text[500])
        {
            DataClassification = ToBeClassified;
        }

        // YF 14 Feb 2022 // Additional fields for PO if created from Assembly Order
        field(55019; "Is From Assembly Order"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Is From Assembly Order';
        }

        field(55020; "AO Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Assembled Item No.';
        }

        field(55021; "AO Item Descr"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Assembled Item Description';
        }

        field(55022; "AO Item Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Assembled Item Qty';
        }

        field(55023; "AO Item UOM"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Assembled Item UOM';
        }

        field(55024; "AO Item Batch"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Assembled Item Batch';
        }

        field(55025; "AO Item Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Assembled Item Expiry Date';
        }

        field(55026; "AO Item Packing Instruction"; Text[500])
        {
            DataClassification = ToBeClassified;
            Caption = 'Assembled Item Packing Instruction';
        }
        field(55027; "AO No."; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Assembly Order No.';
        }
        // YF 14 Feb 2022 // Additional fields for PO if created from Assembly Order

        // YF 03 Mar 2022
        field(55028; "Country of Purchase Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Country of Purchase';
            TableRelation = "Country/Region".Code;
        }
        // YF 03 Mar 2022
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
        field(55076; "Ship From Country"; Code[10])
        {
            TableRelation = "Country/Region";
            DataClassification = ToBeClassified;
        }
        field(55077; "Special Instructions"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        // YF 02 Mar 2025
        field(55078; "Approval Required"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(55079; ">3 Mth Inventory"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        // YF 02 Mar 2025
    }

}