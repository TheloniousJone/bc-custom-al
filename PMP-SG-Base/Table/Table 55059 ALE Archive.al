table 55059 "ALE Archive"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(5; Basket; Code[20])
        {
            DataClassification = ToBeClassified;
            // TableRelation = Basket."No.";
        }
        field(6; "Priority No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Doc. No.';
        }
        field(12; "Trip Doc No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Picking Doc No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        //DX        11 Jun 2021
        field(22; "Shipment Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Pick By Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        //DX        11 Jun 2021
        field(30; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'No.';
        }
        field(40; "Customer Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Name';
        }
        field(50; Status; Option)
        {
            DataClassification = ToBeClassified;
            //OptionMembers = Open,Picking,Checking,Delivering,Completed;
            OptionMembers = Open,Processing,Picking,"Pending Checking",Checking,"Pending Delivery","Delivery In Progress",Delivering,Delivered,Invoiced,Completed;
        }
        field(60; "Start Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Caption = 'Picking Start Time';
        }
        field(70; "End Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Caption = 'Picking End Time';
        }
        field(80; "Picker"; Code[20])
        {
            DataClassification = ToBeClassified;
            // TableRelation = "Warehouse Employee"."User ID";
        }
        field(90; "Priority Picking"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(100; "Checking Doc No."; code[20])
        {
            DataClassification = ToBeClassified;
            // TableRelation = "Checking Header"."No.";
        }
        field(110; "Check Start Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(120; "Check End Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(130; "Driver Doc No."; code[20])
        {
            DataClassification = ToBeClassified;
            // TableRelation = "Driver Shipping Header"."No.";
        }
        field(140; "Driver Start Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(150; "Driver End Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(160; "Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        //DX            09 jULY 2021
        field(170; "Pick Type"; Option)
        {
            OptionMembers = "Non-Cold","Cold","Combined";
        }
        field(180; "2nd Basket Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            // TableRelation = Basket."No.";
        }

        // DX          09 jULY 2021
        //DX        18 July 2021
        field(185; "Checker ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(190; "2nd Checker ID"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        //DX        18 July 2021
        //DX        22 Aug 2021
        field(200; "Chain Pharmacy"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(210; "Controlled Drug"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(220; "Wellaway"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //DX        22 Aug 2021
        //DX        21 Sept 2021
        field(230; "On Hold"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //DX        21 Sept 2021

        // YF 24 Mar 2025
        field(280; I9G_STBio; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'ST Bio';
        }
        // YF 24 Mar 2025
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

}