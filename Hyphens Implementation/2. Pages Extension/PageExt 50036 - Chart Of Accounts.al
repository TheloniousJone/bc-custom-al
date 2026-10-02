pageextension 50036 HPPLCOAExt extends "Chart of Accounts"
{

    actions
    {
        addafter(SetDimensionFilter)
        {
            action("Test - Generate Dimension Set Filter")
            {
                ApplicationArea = All;
                Image = TestReport;
                Visible = false;

                trigger OnAction()
                var
                    TempDimensionSetIDFilterLine: Record "Dimension Set ID Filter Line" temporary;
                    DimensionMgt: Codeunit DimensionManagement;
                    DimFilter: Text;
                begin
                    Clear(TempDimensionSetIDFilterLine);
                    Clear(DimensionMgt);
                    Clear(DimFilter);

                    TempDimensionSetIDFilterLine.Code := '';
                    TempDimensionSetIDFilterLine."Line No." := 1;
                    TempDimensionSetIDFilterLine."Dimension Code" := 'BUSINESS UNITS';
                    TempDimensionSetIDFilterLine.SetDimensionValueFilter('HVN');
                    // TempDimensionSetIDFilterLine.Insert();
                    // HPIL

                    TempDimensionSetIDFilterLine.Reset();
                    if not TempDimensionSetIDFilterLine.IsEmpty() then begin

                        TempDimensionSetIDFilterLine.Reset();
                        TempDimensionSetIDFilterLine.SetRange(Code, '');
                        TempDimensionSetIDFilterLine.SetRange("Line No.", 1);
                        if TempDimensionSetIDFilterLine.FindSet then
                            repeat
                                DimensionMgt.GetDimSetIDsForFilter(TempDimensionSetIDFilterLine."Dimension Code",
                                TempDimensionSetIDFilterLine.GetDimensionValueFilter(
                                    TempDimensionSetIDFilterLine.Code, TempDimensionSetIDFilterLine."Dimension Code"));
                            until TempDimensionSetIDFilterLine.Next() = 0;

                        DimFilter := DimensionMgt.GetDimSetFilter;

                        if DimFilter = '' then
                            DimFilter := '0&<>0';

                        Message(DimFilter);
                    end

                end;
            }
        }
    }

    // YF 14 Oct 2024
    /*
    trigger OnOpenPage()
    var
        // LimitedAccessQuery: Query "Limited Group List Query"; 
        LimitedAccessFilterString: Text[2048];
        TempDimensionSetIDFilterLine: Record "Dimension Set ID Filter Line" temporary;
        DimensionMgt: Codeunit DimensionManagement;
        DimFilter: Text[1024];
    begin
        // filtering for HPPL Limited Access
        Clear(LimitedAccessQuery); 
        Clear(LimitedAccessFilterString);
        Clear(TempDimensionSetIDFilterLine);
        Clear(DimFilter);

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
            TempDimensionSetIDFilterLine.Code := '';
            TempDimensionSetIDFilterLine."Line No." := 1;
            TempDimensionSetIDFilterLine."Dimension Code" := 'BUSINESS UNITS';
            TempDimensionSetIDFilterLine.SetDimensionValueFilter(LimitedAccessFilterString);

            TempDimensionSetIDFilterLine.Reset();
            if not TempDimensionSetIDFilterLine.IsEmpty() then begin

                TempDimensionSetIDFilterLine.Reset();
                TempDimensionSetIDFilterLine.SetRange(Code, '');
                TempDimensionSetIDFilterLine.SetRange("Line No.", 1);
                if TempDimensionSetIDFilterLine.FindSet then
                    repeat
                        DimensionMgt.GetDimSetIDsForFilter(TempDimensionSetIDFilterLine."Dimension Code",
                        TempDimensionSetIDFilterLine.GetDimensionValueFilter(
                            TempDimensionSetIDFilterLine.Code, TempDimensionSetIDFilterLine."Dimension Code"));
                    until TempDimensionSetIDFilterLine.Next() = 0;

                DimFilter := DimensionMgt.GetDimSetFilter;

                if DimFilter = '' then
                    DimFilter := '0&<>0';

                Rec.SetFilter("Dimension Set ID Filter", DimFilter);
            end;
        end;
        // filtering for HPPL Limited Access
    end;
    */
    // YF 14 Oct 2024
}
