tableextension 55005 SalesHeaderArchiveExt extends "Sales Header Archive"
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
        //DX        31 Aug 2021
        field(55028; "Chain Pharmacy"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(55029; "Exported"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(55030; "Return Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Checker to verify","Checker verified","Return Goods In Warehouse","CSO Request for Collection","Collection Requested from Driver","QC to verify","QC verified";
        }

        field(55031; "LS Account"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "LS Account".Code;
            Caption = 'LS Account';
        }

        field(55032; "Branch/Subsidiary"; Text[250])
        {
            DataClassification = ToBeClassified;
        }

        field(55033; "Order Taken By"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

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
        field(55085; "Customer Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Customer Group";
        }
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

}