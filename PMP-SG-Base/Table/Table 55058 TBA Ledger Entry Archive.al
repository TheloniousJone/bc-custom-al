table 55058 "TBA Ledger Entry Archive"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }

        field(10; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(20; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(25; "Item Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(30; "Entry Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Sale,Delivery,"Pending Delivery",Adjustment;
        }

        field(40; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(50; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(60; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(70; "Customer Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(80; "Unit Of Measure Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }

        field(90; Remarks; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(100; "Apply To Doc No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(110; "Remaining Qty"; Decimal)
        {
            // FieldClass = FlowField;
            // CalcFormula = sum("TBA Ledger Entry".Quantity where("Apply To Doc No." = field("Document No."), "Item No." = field("Item No."), "Customer No." = field("Customer No.")));
        }

        field(120; "Bin Remarks"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(130; "Batch No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }

        field(140; "Expiration Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(150; "Cage No."; Code[20])
        {
            //For tracking of the TBA ledger on which cage after it has been placed at cage.
            DataClassification = ToBeClassified;
        }

        field(160; "Shipping Packages"; Integer)
        {
            //To indicate how many packages are prepared for this TBA shipment line.
            DataClassification = ToBeClassified;
        }

        field(170; "Assigned To Driver Card"; boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(180; "TBA Printed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(190; "Sales Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(200; "Delivery Charge"; Code[20])
        {
            DataClassification = ToBeClassified;
            // TableRelation = "Delivery Charge"."Delivery Charge";
        }

    }

    keys
    {
        key(Primary; "Entry No.")
        {
            Clustered = true;
        }

    }

    /*
    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", "Entry Type", "Customer Name", "Sales Order No.", "Document No.", "Apply To Doc No.", "Item No.") { }
    }
    */
}