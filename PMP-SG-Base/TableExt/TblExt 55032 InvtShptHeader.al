tableextension 55032 TblExtInvtShptHeader extends "Invt. Shipment Header"
{
    fields
    {
        field(55000; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            // TableRelation = Customer;
        }
        field(55001; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            DataClassification = ToBeClassified;
        }
        field(55002; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
        }
        // 55001 - Reserved for Bin Code (See Invt. Document Header (5850))

        // 55002 - Reserved for Gen. Prod. Posting Group (See Invt. Document Header (5850))
    }
}
