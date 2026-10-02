table 55002 "Assignment Ledger Entry"
{
    //DX        29/04/21 : To tabulate all warehouse lists generated into a single table source
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(5; Basket; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Basket."No.";
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
            TableRelation = "Warehouse Employee"."User ID";
        }
        field(90; "Priority Picking"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(100; "Checking Doc No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Checking Header"."No.";
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
            TableRelation = "Driver Shipping Header"."No.";
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
            TableRelation = Basket."No.";
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
        field(240; "No. of Lines"; Integer)
        {
            CalcFormula = Count("Warehouse Activity Line" WHERE("No." = FIELD("Picking Doc No.")));
            Caption = 'No. of Lines';
            Editable = false;
            FieldClass = FlowField;
        }

        // pk 08112023
        field(250; "Wellaway Picks"; Boolean)
        {
            Caption = 'Wellaway Picks';
            Editable = false;
        }
        // pk 08112023
        field(260; "Picker Error"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PickerChecker Error".Code;
        }
        field(270; "Checker Error"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PickerChecker Error".Code;
        }

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
        //DX        30 May 2023
        key(Key2; "Picking Doc No.")
        {

        }
        key(key3; "Picking Doc No.", "Invoice No.")
        {

        }
        key(key4; "Document No.", Status)
        {

        }
        key(key5; "Checking Doc No.")
        {

        }
        key(key6; Basket, Status, "Picking Doc No.")
        {

        }
        key(key7; "Picking Doc No.", Status)
        {

        }
        key(key8; "Invoice No.")
        {

        }
        key(key9; Status)
        {


        }
        //DX        08 Jun 2023 New keys
        key(key10; Status, Picker, "Priority Picking")
        {

        }
        key(key11; Status, Picker, "Priority Picking", "On Hold")
        {
            IncludedFields = "Pick By Date", "Chain Pharmacy", "Controlled Drug", Wellaway; //DX    13 Jun 2023
        }
        key(key12; Status, Picker, "Priority Picking", "Chain Pharmacy", "Controlled Drug", "On Hold")
        {

        }
        key(key13; Status, Picker, "On Hold")
        {
            IncludedFields = "Pick By Date", "Priority Picking", "Chain Pharmacy", "Controlled Drug", Wellaway;   //DX        13 Jun 2023
        }
        key(key14; Status, Picker, "Controlled Drug", "On Hold")
        {

        }
        //DX        08 Jun 2023 New keys
        //DX        13 Jun 2023 New keys
        key(key15; Status, "Controlled Drug")
        {

        }
        key(key16; Status, "Chain Pharmacy", "Controlled Drug")
        {

        }
        //DX        13 Jun 2023 New keys

        //DX        30 May 2023
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;



}