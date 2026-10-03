tableextension 50019 HyphensPostedPurchInvHdrTblExt extends "Purch. Inv. Header"
{

    fields
    {
        field(50000; "Template Code"; Code[20])
        {
            Caption = 'Template Code';
        }

        field(50001; "Shelf Life Requirement"; Text[500])
        {
            Caption = 'Shelf Life Requirement';
        }

        field(50002; "Marking Requirement"; Text[500])
        {
            Caption = 'Marking Requirement';
        }

        field(50003; "Packing Requirement"; Text[500])
        {
            Caption = 'Packing Requirement';
        }

        field(50004; "Document Requirement"; Text[500])
        {
            Caption = 'Document Requirement';
        }
        field(50005; Remarks; text[500])
        {
            Caption = 'Remarks';
        }
        field(50006; "Shipment Remarks"; Text[250])
        {
            Caption = 'Shipment Remarks';
        }
        field(50007; "Actual ETD"; Date)
        {
            Caption = 'Actual ETD';
        }
        field(50008; "Actual ETA-Port"; Date)
        {
            Caption = 'Actual ETA-Port';
        }
        field(50009; "Shipment Temperature Status"; Code[20])
        {
            Caption = 'Shipment Temperature Status';
            TableRelation = "Shipment Temperature Status";
        }
        field(50010; "Freight Forwarder"; Code[20])
        {
            Caption = 'Freight Forwarder';
            TableRelation = Vendor;
        }
        field(50011; "Freight Forwarder Invoice No."; Text[50])
        {
            Caption = 'Freight Forwarder Invoice No.';
        }
    }

}