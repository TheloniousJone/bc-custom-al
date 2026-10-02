tableextension 55037 ContactExt extends Contact
{
    fields
    {

        field(55000; "POM Role"; Option)
        {
            Caption = 'Role';
            DataClassification = ToBeClassified;
            OptionMembers = Finance,Purchaser,Doctor,Pharmacist,Admin;
            //ObsoleteState = Pending;
            ObsoleteState = Removed;
        }

        field(55057; "POM Role V2"; Option)
        {
            Caption = 'Role';
            DataClassification = ToBeClassified;
            OptionMembers = Finance,Purchaser,Doctor,Pharmacist,Admin;
        }
        field(55058; "MCR Number"; text[20])
        {
            Caption = 'MCR Number';
            DataClassification = ToBeClassified;

        }
    }
}
