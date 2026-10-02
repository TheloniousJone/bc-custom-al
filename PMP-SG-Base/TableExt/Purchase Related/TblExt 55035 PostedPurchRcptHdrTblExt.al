tableextension 55035 PostedPurchRcptHdrTblExt extends "Purch. Rcpt. Header"
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