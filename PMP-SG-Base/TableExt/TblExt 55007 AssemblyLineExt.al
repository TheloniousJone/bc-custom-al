tableextension 55007 AssemblyLineExt extends "Assembly Line"
{
    fields
    {
        // Add changes to table fields here
        field(55000; "QC Verified"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}