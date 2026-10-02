pageextension 55110 PostedAssemblyOrderExt extends "Posted Assembly Order"
{
    layout
    {
        // Add changes to page layout here
        addlast(content)
        {
            group(Additional)
            {
                // YF 13 Dec 2021
                field("Packing Instructions"; Rec."Packing Instructions")
                {
                    ApplicationArea = All;
                }
                // YF 13 Dec 2021
            }
        }

    }

    actions
    {
        // Add changes to page actions here
    }

}