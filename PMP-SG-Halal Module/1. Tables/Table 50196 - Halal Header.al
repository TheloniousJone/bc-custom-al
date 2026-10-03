table 50196 "Halal Certificate"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;

        }
        field(2; Name; Code[100])
        {
            NotBlank = true;
            trigger OnValidate()
            begin
                //TestField(Name);
            end;
        }
        field(3; "Country of Origin"; Code[20])
        {

        }
        field(4; "Expiration Date"; Date)
        {
            // trigger OnValidate()
            // begin
            //     if ("Expiration Date" - Today) + 1 = 15 then begin
            //         SendEmail(Name, 15, "Expiration Date");
            //     end;
            //     if ("Expiration Date" - Today) + 1 = 30 then begin
            //         SendEmail(Name, 30, "Expiration Date");
            //     end;
            //     if ("Expiration Date" - Today) + 1 = 60 then begin
            //         SendEmail(Name, 60, "Expiration Date");
            //     end;
            // end;
        }
        field(5; Description; Text[100])//250
        {

        }
        field(6; "Authorized Cert Body"; Code[100])
        {
            TableRelation = "Halal Certification Bodies";
        }
        field(7; "Halal Certificate Logo"; Blob)
        {
            Subtype = Bitmap;
        }
        field(8; "Expired"; boolean)
        {
            trigger OnValidate()
            begin
                if Today > "Expiration Date" then begin
                    Expired := true;
                end;
            end;
        }
        //KM20200804 - Start
        field(9; "PSS/PL"; Boolean)
        {
            trigger OnValidate()
            begin
                if "PSS/PL" = true then begin
                    Expired := false;
                    Modify();
                end;
            end;
        }
        //KM20200804 - End
    }

    keys
    {
        key(PK; Name)
        {
            //Clustered = true;
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

    procedure SendEmail(Halal: Code[100]; Day: Integer; ExpiryDate: Date)
    var
        HalalSetup: Record "Halal Setup";
        CompInfo: Record "Company Information";//KM
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        ToList: List of [Text];
        CCList: List of [Text];
        BCCList: List of [Text];
        Body: TextBuilder;
        Subject: Text;
    begin
        // SMTP Mail Setup / SMTP Mail (obsolete since BC 17) replaced by the Email module.
        // Sender is the email account assigned to the Default scenario in "Email Accounts".
        HalalSetup.Get;
        CompInfo.Get;

        //HalalSetup.TestField("Sender Address");
        HalalSetup.TestField("To Address");
        ToList := HalalSetup."To Address".Split(';');
        if HalalSetup."CC Adress" <> '' then
            CCList := HalalSetup."CC Adress".Split(';');

        Subject := 'Halal Certificate: ' + Halal + ' will expired in ' + Format(Day) + 'days';

        Body.Append('<b>Topic:</b>');
        Body.Append('<br><br>');
        Body.Append('<br><br>');
        Body.Append('------------------------------------------');
        Body.Append('<br><br>');
        Body.Append('<br><br>');
        Body.Append('Halal Certificate: ' + Halal + ' will expired in ' + Format(Day) + ' days.');
        Body.Append('<br><br>');
        Body.Append('Expiration Date : ' + Format("Expiration Date", 0, '<Day,2>-<Month,2>-<Year4>'));
        Body.Append('<br><br>');
        Body.Append('Please refer to Halal Certification Lists for more details. ');
        Body.Append('<br><br>');
        Body.Append('<br><br>');
        Body.Append('------------------------------------------');

        EmailMessage.Create(ToList, Subject, Body.ToText(), true, CCList, BCCList);
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
    end;

}