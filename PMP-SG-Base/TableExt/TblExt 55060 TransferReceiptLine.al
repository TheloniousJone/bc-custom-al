tableextension 55060 TransferReceiptLine extends "Transfer Receipt Line"
{
    fields
    {
        field(55000; "Line Remarks"; Text[500])
        {
            Caption = 'Line Remarks';
            DataClassification = ToBeClassified;
        }
        field(55001; "No. of Carton"; decimal)
        {
            Caption = 'No. of Carton';
            DataClassification = ToBeClassified;
        }
        //LK281123
        field(55002; "I9G QC/QA Comments"; Text[100])
        {
            Caption = 'QC/QA Comments';
        }
        //LK281123
    }
}
