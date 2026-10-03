pageextension 56003 WHTripCardExt extends "WH Trip Card"
{
    layout
    {
        // Add changes to page layout here

        /*
        modify("Basket Code")
        {
            ApplicationArea = All;

            trigger OnAfterValidate()
            var
                canRunLEDTrigger: Boolean;
                recWHTripLine: Record "WH Trip Line";
                recWHActHeader: Record "Warehouse Activity Header";
                recWHActLine: Record "Warehouse Activity Line";
                Picker: Record Picker;
                IntegrationCU: Codeunit "EPaper Integrations";
                BinCodeParameter: Text;
            begin
                // validate trip time for process trigger
                canRunLEDTrigger := true;
                if StrLen(Rec.Picker) = 0 then
                    canRunLEDTrigger := false
                else begin
                    if Rec."Trip Start" = 0DT then
                        canRunLEDTrigger := false
                    else begin
                        if Rec."Trip End" <> 0DT then
                            canRunLEDTrigger := false;
                    end;
                end;

                // canRunLEDTrigger := false; // override 

                if canRunLEDTrigger then begin
                    // run process to turn on led
                    BinCodeParameter := '';

                    // 1. Look for list of Pick Doc No in WH Trip Line
                    recWHTripLine.Reset;
                    recWHTripLine.SetRange("Doc No.", Rec."No.");
                    recWHTripLine.SetFilter("Pick Doc No.", '<>%1', '');
                    if recWHTripLine.FindSet() then
                        repeat
                            // 2. For each Pick Doc No (Whse Act. Header) go thru the Whse Act. Lines to capture bin code for Take Action
                            recWHActHeader.Reset;
                            recWHActHeader.SetRange("No.", recWHTripLine."Pick Doc No.");
                            if recWHActHeader.FindSet() then
                                repeat
                                    recWHActLine.Reset();
                                    recWHActLine.SetRange("No.", recWHActHeader."No.");
                                    recWHActLine.SetRange("Activity Type", recWHActLine."Activity Type"::Pick);
                                    recWHActLine.SetRange("Action Type", recWHActLine."Action Type"::Take);
                                    if recWHActLine.FindSet() then
                                        repeat
                                            // Generate Bin Code Parameter Here
                                            if StrLen(recWHActLine."Bin Code") > 0 then begin
                                                BinCodeParameter := BinCodeParameter + recWHActLine."Bin Code" + ',';
                                            end;
                                        until recWHActLine.Next() = 0;
                                until recWHActHeader.Next() = 0;
                        until recWHTripLine.Next() = 0;

                    // 3. Trigger API call to turn on LED
                    Picker.Reset;
                    Picker.SetRange("User ID", Rec.Picker);
                    if Picker.Find('-') then begin
                        if StrLen(BinCodeParameter) > 0 then begin
                            BinCodeParameter := CopyStr(BinCodeParameter, 1, StrLen(BinCodeParameter) - 1);
                            IntegrationCU.ProcessSwitchOnETag(BinCodeParameter, Picker."E Tag ID");
                            if UserId = 'BCADMIN' then
                                Message('[DEBUG] LED ON Function Triggered for Shelf ' + BinCodeParameter + ' Color ' + Format(Picker."E Tag ID")); // Debug Message
                        end;
                    end;
                end;

            end;

        }
        */
    }


    actions
    {
        // Add changes to page actions here
        modify("Get Pick List")
        {
            ApplicationArea = All;

            trigger OnAfterAction()
            var
                canRunLEDTrigger: Boolean;
                recWHTripLine: Record "WH Trip Line";
                recWHActHeader: Record "Warehouse Activity Header";
                recWHActLine: Record "Warehouse Activity Line";
                Picker: Record Picker;
                IntegrationCU: Codeunit "EPaper Integrations";
                BinCodeParameter: Text;
                EtagSetup: Record "EPaper Integration Setup";
            begin
                // validate trip time for process trigger
                canRunLEDTrigger := true;
                if StrLen(Rec.Picker) = 0 then
                    canRunLEDTrigger := false
                else begin
                    if Rec."Trip Start" = 0DT then
                        canRunLEDTrigger := false
                    else begin
                        if Rec."Trip End" <> 0DT then
                            canRunLEDTrigger := false;
                    end;
                end;

                // canRunLEDTrigger := false; // override 

                if canRunLEDTrigger then begin
                    // run process to turn on led
                    BinCodeParameter := '';

                    // 1. Look for list of Pick Doc No in WH Trip Line
                    recWHTripLine.Reset;
                    recWHTripLine.SetLoadFields("Doc No.", "Pick Doc No.");      //DX        03 May 2023
                    recWHTripLine.SetRange("Doc No.", Rec."No.");
                    recWHTripLine.SetFilter("Pick Doc No.", '<>%1', '');
                    if recWHTripLine.FindSet() then
                        repeat
                            // 2. For each Pick Doc No (Whse Act. Header) go thru the Whse Act. Lines to capture bin code for Take Action
                            recWHActHeader.Reset;
                            recWHActHeader.SetLoadFields("No.");        //DX        03 May 2023
                            recWHActHeader.SetRange("No.", recWHTripLine."Pick Doc No.");
                            if recWHActHeader.FindSet() then
                                repeat
                                    recWHActLine.Reset();
                                    recWHActLine.SetLoadFields("No.", "Action Type", "Activity Type", "Bin Code");     //DX        03 May 2023
                                    recWHActLine.SetRange("No.", recWHActHeader."No.");
                                    recWHActLine.SetRange("Activity Type", recWHActLine."Activity Type"::Pick);
                                    recWHActLine.SetRange("Action Type", recWHActLine."Action Type"::Take);
                                    if recWHActLine.FindSet() then
                                        repeat
                                            // Generate Bin Code Parameter Here
                                            if StrLen(recWHActLine."Bin Code") > 0 then begin
                                                BinCodeParameter := BinCodeParameter + recWHActLine."Bin Code" + ',';
                                            end;
                                        until recWHActLine.Next() = 0;
                                until recWHActHeader.Next() = 0;
                        until recWHTripLine.Next() = 0;

                    // 3. Trigger API call to turn on LED
                    Picker.Reset;
                    Picker.SetLoadFields("User ID", "E Tag ID");        //DX        03 May 2023
                    Picker.SetRange("User ID", Rec.Picker);
                    if Picker.Find('-') then begin
                        if StrLen(BinCodeParameter) > 0 then begin
                            BinCodeParameter := CopyStr(BinCodeParameter, 1, StrLen(BinCodeParameter) - 1);
                            if EtagSetup."Enable Etag LED on Picklist" = true then
                                IntegrationCU.ProcessSwitchOnETag(BinCodeParameter, Picker."E Tag ID"); //Comment this line to turn off integration
                            if UserId = 'BCADMIN' then
                                Message('[DEBUG] LED ON Function Triggered for Shelf ' + BinCodeParameter + ' Color ' + Format(Picker."E Tag ID")); // Debug Message
                        end;
                    end;
                end;

            end;

        }
    }
}

