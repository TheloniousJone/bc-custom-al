tableextension 52004 VendorExt2 extends Vendor
{
    fields
    {
        // Add changes to table fields here
        field(52000; "Bank Payment Type"; Code[3])
        {
            TableRelation = "DBS Product Type";
            DataClassification = ToBeClassified;
        }
       
    }

}