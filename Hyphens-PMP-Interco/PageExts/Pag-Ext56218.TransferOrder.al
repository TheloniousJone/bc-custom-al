pageextension 56218 TransferOrder extends "Transfer Order"
{
    layout
    {
        addafter("Direct Transfer")
        {
            field("Interco Order No"; Rec."Interco Order No")
            {
                ApplicationArea = all;
            }
        }
    }

}
