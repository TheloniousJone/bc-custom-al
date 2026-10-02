tableextension 50199 Item extends Item
{
    fields
    {
        // Add changes to table fields here
        field(50198; "Halal"; Boolean)
        {
            /*trigger OnValidate()
            begin 
                if "Halal Certification" <> '' then begin
                    "Halal" := true;
                end;
            end;*/
        }
        field(50199; "Halal Certification"; Code[100])
        {
            TableRelation = "Halal Certificate";
        }
    }

    var

}