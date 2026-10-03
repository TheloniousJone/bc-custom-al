table 55065 "Pixel Squad Setup"
{
    fields
    {
        field(1; "Primary Key"; Integer)
        {
        }
        field(2; Url; Text[2048])
        {
            Caption = 'Url';
        }
        field(3; Username; Text[2048])
        {
            Caption = 'Username';
        }
        field(4; Password; Text[2048])
        {
            Caption = 'Password';
            ExtendedDatatype = Masked;
        }

    }

    keys
    {
        key(PK; "Primary Key")
        {
        }
    }
}
