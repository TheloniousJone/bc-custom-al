table 50000 "Temp Table"
{
    DataClassification = ToBeClassified;


    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;

        }
        //Text - Start
        field(11; "Text1"; Text[200])
        {

        }
        field(12; "Text2"; Text[200])
        {

        }
        field(13; "Text3"; Text[200])
        {

        }
        field(14; "Text4"; Text[200])
        {

        }
        field(15; "Text5"; Text[200])
        {

        }
        field(16; "Text6"; Text[200])
        {

        }
        field(17; "Text7"; Text[200])
        {

        }
        field(18; "Text8"; Text[200])
        {

        }
        //Text - End

        //Code - Start
        field(21; "Code1"; Code[80])
        {

        }
        field(22; "Code2"; Code[80])
        {

        }
        field(23; "Code3"; Code[80])
        {

        }
        field(24; "Code4"; Code[80])
        {

        }
        field(25; "Code5"; Code[80])
        {

        }
        field(26; "Code6"; Code[80])
        {

        }
        field(27; "Code7"; Code[80])
        {

        }
        field(28; "Code8"; Code[80])
        {

        }
        //Code -End

        //Decimal - Start
        field(31; "Decimal1"; Decimal)
        {

        }
        field(32; "Decimal2"; Decimal)
        {

        }
        field(33; "Decimal3"; Decimal)
        {

        }
        field(34; "Decimal4"; Decimal)
        {

        }
        field(35; "Decimal5"; Decimal)
        {

        }
        field(36; "Decimal6"; Decimal)
        {

        }
        field(37; "Decimal7"; Decimal)
        {

        }
        field(38; "Decimal8"; Decimal)
        {

        }
        field(39; "Decimal9"; Decimal)
        {

        }
        field(40; "Decimal10"; Decimal)
        {

        }
        field(81; "Decimal11"; Decimal)
        {

        }
        field(82; "Decimal12"; Decimal)
        {

        }
        field(83; "Decimal13"; Decimal)
        {

        }
        field(84; "Decimal14"; Decimal)
        {

        }
        field(85; "Decimal15"; Decimal)
        {

        }
        field(86; "Decimal16"; Decimal)
        {

        }
        field(87; "Decimal17"; Decimal)
        {

        }
        field(88; "Decimal18"; Decimal)
        {

        }
        //Decimal - End

        //Integer - Start
        field(41; "Integer1"; Integer)
        {

        }
        field(42; "Integer2"; Integer)
        {

        }
        field(43; "Integer3"; Integer)
        {

        }
        field(44; "Integer4"; Integer)
        {

        }
        field(45; "Integer5"; Integer)
        {

        }
        field(46; "Integer6"; Integer)
        {

        }
        field(47; "Integer7"; Integer)
        {

        }
        field(48; "Integer8"; Integer)
        {

        }
        //Integer - End

        //Boolean - Start
        field(51; "Boolean1"; Boolean)
        {

        }
        field(52; "Boolean2"; Boolean)
        {

        }
        field(53; "Boolean3"; Boolean)
        {

        }
        field(54; "Boolean4"; Boolean)
        {

        }
        field(55; "Boolean5"; Boolean)
        {

        }
        field(56; "Boolean6"; Boolean)
        {

        }
        field(57; "Boolean7"; Boolean)
        {

        }
        field(58; "Boolean8"; Boolean)
        {

        }
        //Boolean - End

        //GUID - Start
        field(61; "GUID1"; GUID)
        {

        }
        field(62; "GUID2"; GUID)
        {

        }
        field(63; "GUID3"; GUID)
        {

        }
        field(64; "GUID4"; GUID)
        {

        }
        field(65; "GUID5"; GUID)
        {

        }
        field(66; "GUID6"; GUID)
        {

        }
        field(67; "GUID7"; GUID)
        {

        }
        field(68; "GUID8"; GUID)
        {

        }
        //GUID - End

        //Date - Start
        field(71; Date1; Date)
        { }
        field(72; Date2; Date)
        { }
        field(73; Date3; Date)
        { }
        field(74; Date4; Date)
        { }
        field(75; Date5; Date)
        { }
        field(76; Date6; Date)
        { }
        field(77; Date7; Date)
        { }
        field(78; Date8; Date)
        { }
        //Date - End
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    var


    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}