tableextension 50020 HyphensPostedPurchCrMemoHdr extends "Purch. Cr. Memo Hdr."
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
    }

}