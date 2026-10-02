tableextension 80160 CheckingHeader3pl extends "Checking Header"
{
    fields
    {
        field(80130; "I9G_NovemCustomerName"; Text[250])
        {
            Caption = 'Sell-to Customer Name';
            Editable = false;
        }
        field(80131; "I9G_NovemCustomerAddress"; Text[250])
        {
            Caption = 'Ship-to Customer Address';
            Editable = false;
        }
        field(80132; "I9G_NovemCustomerAddress2"; Text[250])
        {
            Caption = 'Ship-to Customer Address 2';
            Editable = false;
        }
        field(80133; "I9G_NovemCustomerAddress3"; Text[250])
        {
            Caption = 'Ship-to Customer Address 3';
            Editable = false;
        }
        field(80134; "I9G_NovemCustomerOpsHr"; Text[250])
        {
            Caption = 'Working Hours';
            Editable = false;
        }
        field(80135; "I9G_NovemCustomerDelInstr"; Text[500])
        {
            Caption = 'Delivery Instruction';
            Editable = false;
        }
        field(80136; "I9G_NovemShipToCustomerName"; Text[250])
        {
            Caption = 'Ship-to Customer Name';
            Editable = false;
        }
        field(80137; "I9G_NovemShipToCustomerName2"; Text[250])
        {
            Caption = 'Ship-to Customer Name 2';
            Editable = false;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}