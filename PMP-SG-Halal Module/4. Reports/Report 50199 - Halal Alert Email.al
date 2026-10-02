report 50199 "Alert Expiration Email - Halal"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Halal; "Halal Certificate")
        {
            //DataItemTableView = sorting(Number);
            DataItemTableView = sorting(Name);


            trigger OnPreDataItem()
            begin
                SetRange("Expired", false);
                SetRange("PSS/PL", false);
            end;

            trigger OnAfterGetRecord()
            begin
                // Halal.Validate("Expiration Date");
                if "Expiration Date" = 0D then begin    //I9 RL 200730
                    currreport.skip;    //I9 RL 200730
                end;
                // if ("Expiration Date" - Today) + 1 = 15 then begin
                //     SendEmail(Name, 15, "Expiration Date");
                // end;
                // if ("Expiration Date" - Today) + 1 = 30 then begin
                //     SendEmail(Name, 30, "Expiration Date");
                // end;
                if ("Expiration Date" - Today) + 1 <= 60 then begin
                    SendEmail(Name, ("Expiration Date" - Today) + 1, "Expiration Date");
                end;
                // SendEmail(Name, 15, "Expiration Date");

            end;

            trigger OnPostDataItem()

            var
                Expired: Record "Halal Certificate"; //I9 RL 200730

            begin
                Expired.Reset();
                Expired.SetFilter("Expiration Date", '<%1', Today);
                Expired.SetRange(Expired.Expired, False);

                if Expired.FindSet() then begin
                    repeat
                        Expired.Expired := true;
                        Expired.Modify();
                    until Expired.Next() = 0;
                end;
                //I9 RL 200730
                Commit();
            end;
        }
    }
    var
}