pageextension 50035 HPPLGenLedgerEntriesExt extends "General Ledger Entries"
{
    // YF 14 Oct 2024
    /*
    trigger OnOpenPage()
    var
        LimitedAccessQuery: Query "Limited Group List Query";
        LimitedAccessFilterString: Text;
    begin
        // filtering for HPPL Limited Access
        Clear(LimitedAccessQuery);
        Clear(LimitedAccessFilterString);

        LimitedAccessQuery.SetRange(User_Name_Filter, UserId);
        LimitedAccessQuery.SetRange(HPPL_Limit_Access_Filter, true);
        LimitedAccessQuery.Open();
        while LimitedAccessQuery.Read() do begin
            LimitedAccessFilterString += LimitedAccessQuery.Group_Code + '|';
        end;

        if (StrLen(LimitedAccessFilterString) = LimitedAccessFilterString.LastIndexOf('|')) And (StrLen(LimitedAccessFilterString) > 0) then begin
            LimitedAccessFilterString := CopyStr(LimitedAccessFilterString, 1, StrLen(LimitedAccessFilterString) - 1);
        end;

        if StrLen(LimitedAccessFilterString) > 0 then begin
            Rec.SetFilter("Shortcut Dimension 3 Code", LimitedAccessFilterString);
        end;
        // filtering for HPPL Limited Access
    end;
    */
    // YF 14 Oct 2024
}
