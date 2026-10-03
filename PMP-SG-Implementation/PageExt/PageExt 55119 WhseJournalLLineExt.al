pageextension 55119 WhseJournalLine extends "Whse. Item Journal"
{
    layout
    {
        //RL    12 Jan 2022
        addafter(Description)
        {
            field(Remarks; Rec.Remarks)
            {
                ApplicationArea = All;
            }
        }
        //RL    12 Jan 2022
    }
}