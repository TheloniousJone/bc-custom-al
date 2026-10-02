codeunit 69000 "VersaFleet Integrations"
{
    Permissions = tabledata "Sales Invoice Header" = rimd, tabledata "Sales Invoice Line" = rimd, tabledata "Sales Header" = rimd, tabledata "Sales Line" = rimd;

    // Insert/Update Staging Delivery Task Header and Lines Tables
    procedure InsertOrUpdateStagingInvoiceRecords(var SIHRec: Record "Sales Invoice Header")
    var
        SILRec: Record "Sales Invoice Line";
        VFStagingHeader: Record "Staging VF Task Header";
        VFStagingLine: Record "Staging VF Task Line";
        NewRecord: Boolean;
        UpdateRecord: Boolean;
        HasActiveTask: Boolean;
        UpdateRecEntryNo: Integer;
        LineNo: Integer;
        VSSetup: Record "VersaFleet Integration Setup";
        TotalAmount: Decimal;
        CountryRec: Record "Country/Region";
        CountryName: Text[50];
    begin
        VSSetup.Get;

        // SIHRec.SetFilter("Order Status", '<>%1|<>%2', SIHRec."Order Status"::"Delivery In Progress", SIHRec."Order Status"::Delivered); // YF 15 Mar 2022
        // SIHRec.SetFilter("Order Status", '=%1', SIHRec."Order Status"::"Pending Delivery"); // YF 15 Mar 2022
        SIHRec.SetFilter("Order Status", '=%1|%2', SIHRec."Order Status"::"Pending Delivery", SIHRec."Order Status"::"Delivery In Progress"); //RL 29 Apr 2022
        if SIHRec.FindSet() then
            repeat
                if IsAllowedDocNo(SIHRec."No.") then begin
                    NewRecord := false;
                    UpdateRecord := false;
                    HasActiveTask := false;
                    UpdateRecEntryNo := 0;
                    CountryName := '';

                    // if (SIHRec."Ship-to Country/Region Code" = '') Or (SIHRec."Ship-to Country/Region Code" = 'SGP') then // YF 14 Sep 2022
                    if SIHRec."Ship-to Country/Region Code" in ['', 'SGP', 'SG'] then  // YF 14 Sep 2022
                        CountryName := 'Singapore'
                    else begin
                        //DX        15 May 2025 Performance tuning
                        CountryRec.reset;
                        CountryRec.SetLoadFields(Name);
                        //DX        15 May 2025 Performance tuning
                        if CountryRec.Get(SIHRec."Ship-to Country/Region Code") then
                            CountryName := CountryRec.Name;
                    end;


                    VFStagingHeader.Reset;
                    //DX        15 May 2025 Performance tuning
                    VFStagingHeader.SetCurrentKey("Sales Invoice No.", "Source Document Type");
                    VFStagingHeader.SetLoadFields("Sales Invoice No.", Closed, Created, "Entry No.", "Source Document Type");
                    //DX        15 May 2025 Performance tuning
                    if IsNovemCust(SIHRec) then begin   //DX        29 Oct 2025 
                        VFStagingHeader.SetRange("Sales Invoice No.", GetNovemInvNo(SIHRec));
                    end else begin
                        VFStagingHeader.SetRange("Sales Invoice No.", SIHRec."No.");
                    end;

                    VFStagingHeader.SetFilter("Source Document Type", '%1|%2', VFStagingHeader."Source Document Type"::" ", VFStagingHeader."Source Document Type"::"Posted Sales Invoice"); // YF 25 Jul 2022
                    if VFStagingHeader.FindSet() then
                        repeat
                            if VFStagingHeader.Created then begin
                                if VFStagingHeader.Closed then begin
                                    NewRecord := true;
                                    UpdateRecord := false;
                                end
                                else begin
                                    // active delivery task
                                    NewRecord := false;
                                    UpdateRecord := false;
                                    HasActiveTask := true;
                                end;
                            end
                            else begin
                                NewRecord := false;
                                UpdateRecord := true;
                                UpdateRecEntryNo := VFStagingHeader."Entry No.";
                            end;
                        until VFStagingHeader.Next() = 0
                    else begin
                        NewRecord := true;
                        UpdateRecord := false;
                    end;

                    if Not HasActiveTask then begin
                        if NewRecord then begin
                            VFStagingHeader.Init();
                            VFStagingHeader."Entry No." := 0;
                            if IsNovemCust(SIHRec) then begin
                                VFStagingHeader."Sales Invoice No." := GetNovemInvNo(SIHRec);
                                VFStagingHeader."Tracking ID" := GetNovemInvNo(SIHRec)
                            end else begin
                                VFStagingHeader."Sales Invoice No." := SIHRec."No.";
                                VFStagingHeader."Tracking ID" := SIHRec."No."; // YF 23 Mar 2022
                            end;

                            VFStagingHeader."Posting Date" := SIHRec."Posting Date";
                            // VFStagingHeader."Tracking ID" := SIHRec."Package Tracking No.";

                            VFStagingHeader."Total Price" := SIHRec."Amount Including VAT";
                            VFStagingHeader."Time From Text" := Format(SIHRec."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>') + 'T00:00:00.000+08:00'; // "time_from": "2021-11-16T00:00:00.000+08:00",
                            VFStagingHeader."Time To Text" := Format(SIHRec."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>') + 'T23:59:59.999+08:00'; // "time_to": "2021-11-16T23:59:59.999+08:00",
                            VFStagingHeader."Time Type" := 'all_day';
                            VFStagingHeader.COD := SIHRec."Amount Including VAT";//RL 20 Apr 2022 - change from 0 to amount

                            // VFStagingHeader.Remarks := SIHRec."Customer Instructions" + ' / ' + SIHRec."Delivery Instructions"; // YF 08 Mar 2022
                            // VFStagingHeader.Remarks := SIHRec."Delivery Instructions" + ' - ' + SIHRec."Delivery Charge"; // YF 08 Mar 2022, RL 06 April 2022 - add delivery charge after instruction. // YF 27 Jun 2022
                            VFStagingHeader.Remarks := SIHRec."Delivery Instructions"; // YF 27 Jun 2022
                            VFStagingHeader."Source Delivery Charge" := SIHRec."Delivery Charge"; // YF 27 Jun 2022

                            VFStagingHeader."Service Time" := VSSetup."Default Task Service Time";
                            // VFStagingHeader."Delivery Address Name" := SIHRec."Ship-to Name";
                            if IsNovemCust(SIHRec) then begin   //Fix to novem
                                VFStagingHeader."Delivery Address Name" := SIHRec.I9G_CustVendName; //RL    25 Mar 2022 - Swap delivery address name and contact name
                                VFStagingHeader."Delivery Address Line 1" := copystr(SIHRec.I9G_NovemShipToAddress, 1, 100);
                                VFStagingHeader."Delivery Address Line 2" := copystr(SIHRec.I9G_NovemShipToAddress2, 1, 100);
                                VFStagingHeader."Delivery Address City" := copystr(SIHRec.I9G_NovemShipToAddress3, 1, 50);
                                VFStagingHeader."Delivery Address Zip" := '';       //Novem post code is at address 3
                                VFStagingHeader."Delivery Address Contact No." := GetNovemPhone(SIHRec);
                                VFStagingHeader."Delivery Address Contact Name" := GetNovemName(SIHRec);
                                VFStagingHeader."Delivery Address Email" := '';
                                VFStagingHeader."Customer No." := SIHRec.I9G_CustVendCode;
                            end else begin
                                VFStagingHeader."Delivery Address Name" := SIHRec."Ship-to Contact"; //RL    25 Mar 2022 - Swap delivery address name and contact name
                                VFStagingHeader."Delivery Address Line 1" := SIHRec."Ship-to Address";
                                VFStagingHeader."Delivery Address Line 2" := SIHRec."Ship-to Address 2";
                                VFStagingHeader."Delivery Address City" := SIHRec."Ship-to City";
                                VFStagingHeader."Delivery Address Zip" := SIHRec."Ship-to Post Code";
                                VFStagingHeader."Delivery Address Contact No." := SIHRec."Sell-to Phone No.";
                                VFStagingHeader."Delivery Address Contact Name" := SIHRec."Ship-to Name";
                                VFStagingHeader."Delivery Address Email" := SIHRec."Sell-to E-Mail";
                                VFStagingHeader."Customer No." := SIHRec."Sell-to Customer No.";
                            end;

                            VFStagingHeader."Delivery Address Country" := CountryName;
                            // VFStagingHeader."Delivery Address Contact Name" := SIHRec."Ship-to Contact";

                            VFStagingHeader."Driver Tag" := SIHRec."Delivery Zone";
                            VFStagingHeader."Vehicle Tag" := SIHRec."Delivery Zone";
                            VFStagingHeader."Created Timestamp" := CurrentDateTime;

                            VFStagingHeader."Source Document Type" := VFStagingHeader."Source Document Type"::"Posted Sales Invoice"; // YF 21 Jul 2022
                            VFStagingHeader."Customer Group" := SIHRec."Customer Group";


                            TotalAmount := 0;

                            if VFStagingHeader.Insert(true) then begin
                                LineNo := 1;

                                SILRec.Reset;
                                //DX        15 May 2025 Performance tuning
                                SILRec.SetCurrentKey("Document No.", "Line No.");
                                SILRec.SetLoadFields(Type, "Document No.", "Line No.", Description, "No.", Quantity, "Unit of Measure Code", "Inv. Discount Amount");
                                //DX        15 May 2025 Performance tuning
                                SILRec.SetRange("Document No.", SIHRec."No.");
                                SILRec.SetRange(Type, SILRec.Type::Item);
                                if SILRec.FindSet() then
                                    repeat
                                        VFStagingLine.Init();
                                        VFStagingLine."Parent Entry No." := VFStagingHeader."Entry No.";
                                        VFStagingLine."Line No." := LineNo;
                                        VFStagingLine."Sales Invoice No." := SILRec."Document No.";
                                        VFStagingLine."Sales Invoice Line No." := SILRec."Line No.";
                                        VFStagingLine."Item No." := SILRec."No.";
                                        VFStagingLine."Item Description" := SILRec.Description;
                                        VFStagingLine.Qty := SILRec.Quantity;
                                        VFStagingLine.UOM := SILRec."Unit of Measure Code";
                                        // VFStagingLine."Item Check Method" := 'manual';
                                        // VFStagingLine."Item Unload Check Method" := 'manual';
                                        VFStagingLine."Item Check Method" := Format(VSSetup."Item Check Method");
                                        VFStagingLine."Item Unload Check Method" := Format(Format(VSSetup."Item Unload Check Method"));
                                        VFStagingLine."Created Timestamp" := CurrentDateTime;

                                        TotalAmount += SILRec."Line Amount" - SILRec."Inv. Discount Amount"; // Line amount (with line discount) offset invoice discount for total

                                        if VFStagingLine.Insert() then
                                            LineNo += 1;
                                    until SILRec.Next() = 0;

                                VFStagingHeader."Total Price" := TotalAmount;
                                // VFStagingHeader."Tracking ID" := Format(CurrentDateTime, 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>') + Format(VFStagingHeader."Entry No."); // YF 23 Mar 2022
                                VFStagingHeader.Modify();
                            end;
                        end;

                        if VFStagingHeader.Get(UpdateRecEntryNo) And UpdateRecord then begin
                            if IsNovemCust(SIHRec) then begin
                                VFStagingHeader."Sales Invoice No." := GetNovemInvNo(SIHRec);
                                VFStagingHeader."Tracking ID" := GetNovemInvNo(SIHRec); //27 Nov 2025
                            end else begin
                                VFStagingHeader."Sales Invoice No." := SIHRec."No.";
                                VFStagingHeader."Tracking ID" := SIHRec."No."; // YF 23 Mar 2022
                            end;

                            VFStagingHeader."Posting Date" := SIHRec."Posting Date";
                            // VFStagingHeader."Tracking ID" := SIHRec."Package Tracking No.";

                            VFStagingHeader."Total Price" := SIHRec."Amount Including VAT";
                            VFStagingHeader."Time From Text" := Format(SIHRec."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>') + 'T00:00:00.000+08:00'; // "time_from": "2021-11-16T00:00:00.000+08:00",
                            VFStagingHeader."Time To Text" := Format(SIHRec."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>') + 'T23:59:59.999+08:00'; // "time_to": "2021-11-16T23:59:59.999+08:00",
                            VFStagingHeader."Time Type" := 'all_day';
                            VFStagingHeader.COD := SIHRec."Amount Including VAT";//RL 20 Apr 2022 - change from 0 to amount

                            // VFStagingHeader.Remarks := SIHRec."Customer Instructions" + ' / ' + SIHRec."Delivery Instructions"; // YF 08 Mar 2022
                            VFStagingHeader.Remarks := SIHRec."Delivery Instructions"; // YF 08 Mar 2022
                            VFStagingHeader."Source Delivery Charge" := SIHRec."Delivery Charge"; // YF 27 Jun 2022

                            VFStagingHeader."Service Time" := VSSetup."Default Task Service Time";
                            // VFStagingHeader."Delivery Address Name" := SIHRec."Ship-to Name";
                            if IsNovemCust(SIHRec) then begin   //Fix to novem
                                VFStagingHeader."Delivery Address Name" := SIHRec.I9G_CustVendName; //RL    25 Mar 2022 - Swap delivery address name and contact name
                                VFStagingHeader."Delivery Address Line 1" := copystr(SIHRec.I9G_NovemShipToAddress, 1, 100);
                                VFStagingHeader."Delivery Address Line 2" := copystr(SIHRec.I9G_NovemShipToAddress2, 1, 100);
                                VFStagingHeader."Delivery Address City" := copystr(SIHRec.I9G_NovemShipToAddress3, 1, 50);
                                VFStagingHeader."Delivery Address Zip" := '';       //Novem post code is at address 3
                                VFStagingHeader."Delivery Address Contact No." := GetNovemPhone(SIHRec);
                                VFStagingHeader."Delivery Address Contact Name" := GetNovemName(SIHRec);
                                VFStagingHeader."Delivery Address Email" := '';
                                VFStagingHeader."Customer No." := SIHRec.I9G_CustVendCode;
                            end else begin
                                VFStagingHeader."Delivery Address Name" := SIHRec."Ship-to Contact"; //RL    25 Mar 2022 - Swap delivery address name and contact name
                                VFStagingHeader."Delivery Address Line 1" := SIHRec."Ship-to Address";
                                VFStagingHeader."Delivery Address Line 2" := SIHRec."Ship-to Address 2";
                                VFStagingHeader."Delivery Address City" := SIHRec."Ship-to City";
                                VFStagingHeader."Delivery Address Zip" := SIHRec."Ship-to Post Code";
                                VFStagingHeader."Delivery Address Contact No." := SIHRec."Sell-to Phone No.";
                                VFStagingHeader."Delivery Address Contact Name" := SIHRec."Ship-to Name";
                                VFStagingHeader."Delivery Address Email" := SIHRec."Sell-to E-Mail";
                                VFStagingHeader."Customer No." := SIHRec."Sell-to Customer No.";
                            end;
                            VFStagingHeader."Delivery Address Country" := CountryName;
                            // VFStagingHeader."Delivery Address Contact Name" := SIHRec."Ship-to Contact";
                            VFStagingHeader."Driver Tag" := SIHRec."Delivery Zone";
                            VFStagingHeader."Vehicle Tag" := SIHRec."Delivery Zone";
                            VFStagingHeader."Process Remarks" := 'Record updated';
                            VFStagingHeader.Error := false;
                            VFStagingHeader."Updated Timestamp" := CurrentDateTime;

                            VFStagingHeader."Customer Group" := SIHRec."Customer Group";


                            VFStagingHeader."Source Document Type" := VFStagingHeader."Source Document Type"::"Posted Sales Invoice"; // YF 21 Jul 2022

                            TotalAmount := 0;

                            if VFStagingHeader.Modify() then begin
                                VFStagingLine.Reset;
                                VFStagingLine.SetRange("Parent Entry No.", UpdateRecEntryNo);
                                VFStagingLine.SetRange("Sales Invoice No.", VFStagingHeader."Sales Invoice No.");
                                // YF 10 Aug 2022 // To avoid unnecessary table lock
                                if not VFStagingLine.IsEmpty then
                                    VFStagingLine.DeleteAll();
                                // YF 10 Aug 2022 // To avoid unnecessary table lock

                                LineNo := 1;

                                SILRec.Reset;
                                //DX        15 May 2025 Performance tuning
                                SILRec.SetCurrentKey("Document No.", "Line No.");
                                SILRec.SetLoadFields("Document No.", "Line No.", Type, "No.", Description, Quantity, "Unit of Measure Code", "Inv. Discount Amount");
                                //DX        15 May 2025 Performance tuning
                                SILRec.SetRange("Document No.", SIHRec."No.");
                                SILRec.SetRange(Type, SILRec.Type::Item);
                                if SILRec.FindSet() then
                                    repeat
                                        VFStagingLine.Init();
                                        VFStagingLine."Parent Entry No." := VFStagingHeader."Entry No.";
                                        VFStagingLine."Line No." := LineNo;
                                        VFStagingLine."Sales Invoice No." := SILRec."Document No.";
                                        VFStagingLine."Sales Invoice Line No." := SILRec."Line No.";
                                        VFStagingLine."Item No." := SILRec."No.";
                                        VFStagingLine."Item Description" := SILRec.Description;
                                        VFStagingLine.Qty := SILRec.Quantity;
                                        VFStagingLine.UOM := SILRec."Unit of Measure Code";
                                        // VFStagingLine."Item Check Method" := 'manual';
                                        // VFStagingLine."Item Unload Check Method" := 'manual';
                                        VFStagingLine."Item Check Method" := Format(VSSetup."Item Check Method");
                                        VFStagingLine."Item Unload Check Method" := Format(Format(VSSetup."Item Unload Check Method"));
                                        VFStagingLine."Created Timestamp" := CurrentDateTime;

                                        TotalAmount += SILRec."Line Amount" - SILRec."Inv. Discount Amount"; // Line amount (with line discount) offset invoice discount for total

                                        if VFStagingLine.Insert() then
                                            LineNo += 1;
                                    until SILRec.Next() = 0;
                            end;

                            VFStagingHeader."Total Price" := TotalAmount;
                            // VFStagingHeader."Tracking ID" := Format(CurrentDateTime, 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>') + Format(VFStagingHeader."Entry No."); // YF 23 Mar 2022
                            VFStagingHeader.Modify();

                        end;
                    end;

                end;

            until SIHRec.Next() = 0;
        Message('Delivery Queue submitted');

    end;

    //////////
    procedure InsertOrUpdateSalesReturnOrderToStagingInvoiceRecords(var SHRec: Record "Sales Header")
    var
        SLRec: Record "Sales Line";
        VFStagingHeader: Record "Staging VF Task Header";
        VFStagingLine: Record "Staging VF Task Line";
        NewRecord: Boolean;
        UpdateRecord: Boolean;
        HasActiveTask: Boolean;
        UpdateRecEntryNo: Integer;
        LineNo: Integer;
        VSSetup: Record "VersaFleet Integration Setup";
        TotalAmount: Decimal;
        CountryRec: Record "Country/Region";
        CountryName: Text[50];
    begin
        VSSetup.Get;

        // SIHRec.SetFilter("Order Status", '<>%1|<>%2', SIHRec."Order Status"::"Delivery In Progress", SIHRec."Order Status"::Delivered); // YF 15 Mar 2022
        // SIHRec.SetFilter("Order Status", '=%1', SIHRec."Order Status"::"Pending Delivery"); // YF 15 Mar 2022
        SHRec.SetFilter("Document Type", '=%1', SHRec."Document Type"::"Return Order");
        SHRec.SetFilter("Order Status", '=%1', SHRec."Order Status"::Open);
        if SHRec.FindSet() then
            repeat
                if IsAllowedDocNo(SHRec."No.") then begin
                    NewRecord := false;
                    UpdateRecord := false;
                    HasActiveTask := false;
                    UpdateRecEntryNo := 0;
                    CountryName := '';

                    // if (SIHRec."Ship-to Country/Region Code" = '') Or (SIHRec."Ship-to Country/Region Code" = 'SGP') then // YF 14 Sep 2022
                    // if SHRec."Ship-to Country/Region Code" in ['', 'SGP', 'SG'] then
                    if SHRec."Sell-to County" in ['', 'SGP', 'SG'] then
                        CountryName := 'Singapore'
                    else begin
                        //DX        15 May 2025 Performance tuning
                        CountryRec.reset;
                        CountryRec.SetLoadFields(Name);
                        //DX        15 May 2025 Performance tuning
                        if CountryRec.Get(SHRec."Sell-to County") then
                            CountryName := CountryRec.Name;
                    end;


                    VFStagingHeader.Reset;
                    //DX        15 May 2025 Performance tuning
                    VFStagingHeader.SetCurrentKey("Sales Invoice No.", "Source Document Type");
                    VFStagingHeader.SetLoadFields("Sales Invoice No.", "Source Document Type", created, Closed);
                    //DX        15 May 2025 Performance tuning

                    VFStagingHeader.SetRange("Sales Invoice No.", SHRec."No.");
                    VFStagingHeader.SetFilter("Source Document Type", '%1|%2', VFStagingHeader."Source Document Type"::" ", VFStagingHeader."Source Document Type"::"Posted Sales Invoice"); // YF 25 Jul 2022
                    if VFStagingHeader.FindSet() then
                        repeat
                            if VFStagingHeader.Created then begin
                                if VFStagingHeader.Closed then begin
                                    NewRecord := true;
                                    UpdateRecord := false;
                                end
                                else begin
                                    // active delivery task
                                    NewRecord := false;
                                    UpdateRecord := false;
                                    HasActiveTask := true;
                                end;
                            end
                            else begin
                                NewRecord := false;
                                UpdateRecord := true;
                                UpdateRecEntryNo := VFStagingHeader."Entry No.";
                            end;
                        until VFStagingHeader.Next() = 0
                    else begin
                        NewRecord := true;
                        UpdateRecord := false;
                    end;

                    if Not HasActiveTask then begin
                        if NewRecord then begin
                            VFStagingHeader.Init();
                            VFStagingHeader."Entry No." := 0;
                            VFStagingHeader."Sales Invoice No." := SHRec."No.";
                            VFStagingHeader."Posting Date" := SHRec."Posting Date";
                            // VFStagingHeader."Tracking ID" := SIHRec."Package Tracking No.";
                            VFStagingHeader."Tracking ID" := SHRec."No."; // YF 23 Mar 2022
                            VFStagingHeader."Total Price" := SHRec."Amount Including VAT";
                            VFStagingHeader."Time From Text" := Format(SHRec."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>') + 'T00:00:00.000+08:00'; // "time_from": "2021-11-16T00:00:00.000+08:00",
                            VFStagingHeader."Time To Text" := Format(SHRec."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>') + 'T23:59:59.999+08:00'; // "time_to": "2021-11-16T23:59:59.999+08:00",
                            VFStagingHeader."Time Type" := 'all_day';
                            VFStagingHeader.COD := SHRec."Amount Including VAT";//RL 20 Apr 2022 - change from 0 to amount

                            // VFStagingHeader.Remarks := SIHRec."Customer Instructions" + ' / ' + SIHRec."Delivery Instructions"; // YF 08 Mar 2022
                            // VFStagingHeader.Remarks := SIHRec."Delivery Instructions" + ' - ' + SIHRec."Delivery Charge"; // YF 08 Mar 2022, RL 06 April 2022 - add delivery charge after instruction. // YF 27 Jun 2022
                            VFStagingHeader.Remarks := SHRec."Delivery Instructions"; // YF 27 Jun 2022
                            VFStagingHeader."Source Delivery Charge" := SHRec."Delivery Charge"; // YF 27 Jun 2022

                            VFStagingHeader."Service Time" := VSSetup."Default Task Service Time";
                            // VFStagingHeader."Delivery Address Name" := SIHRec."Ship-to Name";
                            // VFStagingHeader."Delivery Address Name" := SHRec."Ship-to Contact"; 
                            // VFStagingHeader."Delivery Address Line 1" := SHRec."Ship-to Address";
                            // VFStagingHeader."Delivery Address Line 2" := SHRec."Ship-to Address 2";
                            // VFStagingHeader."Delivery Address City" := SHRec."Ship-to City";
                            // VFStagingHeader."Delivery Address Country" := CountryName;
                            // VFStagingHeader."Delivery Address Zip" := SHRec."Ship-to Post Code";

                            VFStagingHeader."Delivery Address Name" := SHRec."Sell-to Contact";
                            VFStagingHeader."Delivery Address Line 1" := SHRec."Sell-to Address";
                            VFStagingHeader."Delivery Address Line 2" := SHRec."Sell-to Address 2";
                            VFStagingHeader."Delivery Address City" := SHRec."Sell-to City";
                            VFStagingHeader."Delivery Address Country" := CountryName;
                            VFStagingHeader."Delivery Address Zip" := SHRec."Sell-to Post Code";
                            VFStagingHeader."Delivery Address Email" := SHRec."Sell-to E-Mail";
                            VFStagingHeader."Delivery Address Contact No." := SHRec."Sell-to Phone No.";
                            // VFStagingHeader."Delivery Address Contact Name" := SIHRec."Ship-to Contact";
                            VFStagingHeader."Delivery Address Contact Name" := SHRec."Sell-to Customer Name";
                            VFStagingHeader."Driver Tag" := SHRec."Delivery Zone";
                            VFStagingHeader."Vehicle Tag" := SHRec."Delivery Zone";
                            VFStagingHeader."Created Timestamp" := CurrentDateTime;

                            VFStagingHeader."Customer Group" := SHRec."Customer Group";
                            VFStagingHeader."Customer No." := SHRec."Sell-to Customer No.";

                            VFStagingHeader."Source Document Type" := VFStagingHeader."Source Document Type"::"Sales Return Order"; // YF 21 Jul 2022

                            TotalAmount := 0;

                            if VFStagingHeader.Insert(true) then begin
                                LineNo := 1;

                                SLRec.Reset;
                                SLRec.SetRange("Document No.", SHRec."No.");
                                SLRec.SetRange(Type, SLRec.Type::Item);
                                if SLRec.FindSet() then
                                    repeat
                                        VFStagingLine.Init();
                                        VFStagingLine."Parent Entry No." := VFStagingHeader."Entry No.";
                                        VFStagingLine."Line No." := LineNo;
                                        VFStagingLine."Sales Invoice No." := SLRec."Document No.";
                                        VFStagingLine."Sales Invoice Line No." := SLRec."Line No.";
                                        VFStagingLine."Item No." := SLRec."No.";
                                        VFStagingLine."Item Description" := SLRec.Description;
                                        VFStagingLine.Qty := SLRec.Quantity;
                                        VFStagingLine.UOM := SLRec."Unit of Measure Code";
                                        // VFStagingLine."Item Check Method" := 'manual';
                                        // VFStagingLine."Item Unload Check Method" := 'manual';
                                        VFStagingLine."Item Check Method" := Format(VSSetup."Item Check Method");
                                        VFStagingLine."Item Unload Check Method" := Format(Format(VSSetup."Item Unload Check Method"));
                                        VFStagingLine."Created Timestamp" := CurrentDateTime;
                                        VFStagingLine."Line Discount Amount" := SLRec."Line Discount Amount"; //PK020424
                                        VFStagingLine."Inv. Discount Amount" := SLRec."Inv. Discount Amount"; //PK020424

                                        TotalAmount += SLRec."Line Amount" - SLRec."Inv. Discount Amount"; // Line amount (with line discount) offset invoice discount for total

                                        if VFStagingLine.Insert() then
                                            LineNo += 1;
                                    until SLRec.Next() = 0;

                                VFStagingHeader."Total Price" := TotalAmount;
                                // VFStagingHeader."Tracking ID" := Format(CurrentDateTime, 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>') + Format(VFStagingHeader."Entry No."); // YF 23 Mar 2022
                                VFStagingHeader.Modify();
                            end;
                        end;

                        if VFStagingHeader.Get(UpdateRecEntryNo) And UpdateRecord then begin
                            VFStagingHeader."Sales Invoice No." := SHRec."No.";
                            VFStagingHeader."Posting Date" := SHRec."Posting Date";
                            // VFStagingHeader."Tracking ID" := SIHRec."Package Tracking No.";
                            VFStagingHeader."Tracking ID" := SHRec."No."; // YF 23 Mar 2022
                            VFStagingHeader."Total Price" := SHRec."Amount Including VAT";
                            VFStagingHeader."Time From Text" := Format(SHRec."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>') + 'T00:00:00.000+08:00'; // "time_from": "2021-11-16T00:00:00.000+08:00",
                            VFStagingHeader."Time To Text" := Format(SHRec."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>') + 'T23:59:59.999+08:00'; // "time_to": "2021-11-16T23:59:59.999+08:00",
                            VFStagingHeader."Time Type" := 'all_day';
                            VFStagingHeader.COD := SHRec."Amount Including VAT";//RL 20 Apr 2022 - change from 0 to amount

                            // VFStagingHeader.Remarks := SIHRec."Customer Instructions" + ' / ' + SIHRec."Delivery Instructions"; // YF 08 Mar 2022
                            VFStagingHeader.Remarks := SHRec."Delivery Instructions"; // YF 08 Mar 2022
                            VFStagingHeader."Source Delivery Charge" := SHRec."Delivery Charge"; // YF 27 Jun 2022

                            VFStagingHeader."Service Time" := VSSetup."Default Task Service Time";
                            // VFStagingHeader."Delivery Address Name" := SIHRec."Ship-to Name";

                            // VFStagingHeader."Delivery Address Name" := SHRec."Ship-to Contact"; //RL    25 Mar 2022 - Swap delivery address name and contact name
                            // VFStagingHeader."Delivery Address Line 1" := SHRec."Ship-to Address";
                            // VFStagingHeader."Delivery Address Line 2" := SHRec."Ship-to Address 2";
                            // VFStagingHeader."Delivery Address City" := SHRec."Ship-to City";
                            // VFStagingHeader."Delivery Address Country" := CountryName;
                            // VFStagingHeader."Delivery Address Zip" := SHRec."Ship-to Post Code";
                            // VFStagingHeader."Delivery Address Email" := SHRec."Sell-to E-Mail";
                            // VFStagingHeader."Delivery Address Contact No." := SHRec."Sell-to Phone No.";

                            VFStagingHeader."Delivery Address Name" := SHRec."Sell-to Contact";
                            VFStagingHeader."Delivery Address Line 1" := SHRec."Sell-to Address";
                            VFStagingHeader."Delivery Address Line 2" := SHRec."Sell-to Address 2";
                            VFStagingHeader."Delivery Address City" := SHRec."Sell-to City";
                            VFStagingHeader."Delivery Address Country" := CountryName;
                            VFStagingHeader."Delivery Address Zip" := SHRec."Sell-to Post Code";
                            VFStagingHeader."Delivery Address Email" := SHRec."Sell-to E-Mail";
                            VFStagingHeader."Delivery Address Contact No." := SHRec."Sell-to Phone No.";

                            // VFStagingHeader."Delivery Address Contact Name" := SIHRec."Ship-to Contact";
                            VFStagingHeader."Delivery Address Contact Name" := SHRec."Sell-to Customer Name";
                            VFStagingHeader."Driver Tag" := SHRec."Delivery Zone";
                            VFStagingHeader."Vehicle Tag" := SHRec."Delivery Zone";
                            VFStagingHeader."Process Remarks" := 'Record updated';
                            VFStagingHeader.Error := false;
                            VFStagingHeader."Updated Timestamp" := CurrentDateTime;

                            VFStagingHeader."Customer Group" := SHRec."Customer Group";
                            VFStagingHeader."Customer No." := SHRec."Sell-to Customer No.";

                            VFStagingHeader."Source Document Type" := VFStagingHeader."Source Document Type"::"Sales Return Order"; // YF 21 Jul 2022

                            TotalAmount := 0;

                            if VFStagingHeader.Modify() then begin
                                VFStagingLine.Reset;
                                VFStagingLine.SetRange("Parent Entry No.", UpdateRecEntryNo);
                                VFStagingLine.SetRange("Sales Invoice No.", VFStagingHeader."Sales Invoice No.");
                                // YF 10 Aug 2022 // To avoid unnecessary table lock
                                if not VFStagingLine.IsEmpty then
                                    VFStagingLine.DeleteAll();
                                // YF 10 Aug 2022 // To avoid unnecessary table lock

                                LineNo := 1;

                                SLRec.Reset;
                                //DX        15 May 2025 Performance tuning
                                SLRec.SetCurrentKey("Document No.", Type);
                                SLRec.SetLoadFields("Document No.", Type, "Line No.", "No.", Description, Quantity, "Unit of Measure Code", "Line Discount Amount", "Inv. Discount Amount");
                                //DX        15 May 2025 Performance tuning
                                SLRec.SetRange("Document No.", SHRec."No.");
                                SLRec.SetRange(Type, SLRec.Type::Item);
                                if SLRec.FindSet() then
                                    repeat
                                        VFStagingLine.Init();
                                        VFStagingLine."Parent Entry No." := VFStagingHeader."Entry No.";
                                        VFStagingLine."Line No." := LineNo;
                                        VFStagingLine."Sales Invoice No." := SLRec."Document No.";
                                        VFStagingLine."Sales Invoice Line No." := SLRec."Line No.";
                                        VFStagingLine."Item No." := SLRec."No.";
                                        VFStagingLine."Item Description" := SLRec.Description;
                                        VFStagingLine.Qty := SLRec.Quantity;
                                        VFStagingLine.UOM := SLRec."Unit of Measure Code";
                                        // VFStagingLine."Item Check Method" := 'manual';
                                        // VFStagingLine."Item Unload Check Method" := 'manual';
                                        VFStagingLine."Item Check Method" := Format(VSSetup."Item Check Method");
                                        VFStagingLine."Item Unload Check Method" := Format(Format(VSSetup."Item Unload Check Method"));
                                        VFStagingLine."Created Timestamp" := CurrentDateTime;
                                        VFStagingLine."Line Discount Amount" := SLRec."Line Discount Amount"; //PK020424
                                        VFStagingLine."Inv. Discount Amount" := SLRec."Inv. Discount Amount"; //PK020424

                                        TotalAmount += SLRec."Line Amount" - SLRec."Inv. Discount Amount"; // Line amount (with line discount) offset invoice discount for total

                                        if VFStagingLine.Insert() then
                                            LineNo += 1;
                                    until SLRec.Next() = 0;
                            end;

                            VFStagingHeader."Total Price" := TotalAmount;
                            // VFStagingHeader."Tracking ID" := Format(CurrentDateTime, 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>') + Format(VFStagingHeader."Entry No."); // YF 23 Mar 2022
                            VFStagingHeader.Modify();

                        end;
                    end;
                end;


            until SHRec.Next() = 0;

        Message('Delivery Queue submitted');

    end;

    //////

    procedure InsertOrUpdateStagingInvoiceRecords(var SIHRec: Record "Sales Invoice Header"; Silent: Boolean): Integer
    var
        SILRec: Record "Sales Invoice Line";
        VFStagingHeader: Record "Staging VF Task Header";
        VFStagingLine: Record "Staging VF Task Line";
        NewRecord: Boolean;
        UpdateRecord: Boolean;
        HasActiveTask: Boolean;
        UpdateRecEntryNo: Integer;
        LineNo: Integer;
        VSSetup: Record "VersaFleet Integration Setup";
        TotalAmount: Decimal;
        CountryRec: Record "Country/Region";
        CountryName: Text[50];
        EntryNo: Integer;
    begin

        EntryNo := 0;
        VSSetup.Get;

        SIHRec.SetFilter("Order Status", '<>%1|%2', SIHRec."Order Status"::"Delivery In Progress", SIHRec."Order Status"::Delivered);

        if SIHRec.FindSet() then
            repeat
                if IsAllowedDocNo(SIHRec."No.") then begin
                    NewRecord := false;
                    UpdateRecord := false;
                    HasActiveTask := false;
                    UpdateRecEntryNo := 0;
                    CountryName := '';

                    // if (SIHRec."Ship-to Country/Region Code" = '') Or (SIHRec."Ship-to Country/Region Code" = 'SGP') then // YF 14 Sep 2022
                    if SIHRec."Ship-to Country/Region Code" in ['', 'SGP', 'SG'] then // YF 14 Sep 2022
                        CountryName := 'Singapore'
                    else begin
                        if CountryRec.Get(SIHRec."Ship-to Country/Region Code") then
                            CountryName := CountryRec.Name;
                    end;


                    VFStagingHeader.Reset;
                    //DX        15 May 2025 Performance tuning
                    VFStagingHeader.SetCurrentKey("Sales Invoice No.");
                    VFStagingHeader.SetLoadFields("Sales Invoice No.", Created, Closed);
                    //DX        15 May 2025 Performance tuning
                    if IsNovemCust(SIHRec) then begin   //DX        29 Oct 2025 
                        VFStagingHeader.SetRange("Sales Invoice No.", GetNovemInvNo(SIHRec));
                    end else begin
                        VFStagingHeader.SetRange("Sales Invoice No.", SIHRec."No.");
                    end;
                    //VFStagingHeader.SetRange("Sales Invoice No.", SIHRec."No.");
                    if VFStagingHeader.FindSet() then
                        repeat
                            if VFStagingHeader.Created then begin
                                if VFStagingHeader.Closed then begin
                                    NewRecord := true;
                                    UpdateRecord := false;
                                end
                                else begin
                                    // active delivery task
                                    NewRecord := false;
                                    UpdateRecord := false;
                                    HasActiveTask := true;
                                end;
                            end
                            else begin
                                NewRecord := false;
                                UpdateRecord := true;
                                UpdateRecEntryNo := VFStagingHeader."Entry No.";
                            end;
                        until VFStagingHeader.Next() = 0
                    else begin
                        NewRecord := true;
                        UpdateRecord := false;
                    end;

                    if Not HasActiveTask then begin
                        if NewRecord then begin
                            VFStagingHeader.Init();
                            VFStagingHeader."Entry No." := 0;
                            if IsNovemCust(SIHRec) then begin
                                VFStagingHeader."Sales Invoice No." := GetNovemInvNo(SIHRec);
                                VFStagingHeader."Tracking ID" := GetNovemInvNo(SIHRec)
                            end else begin
                                VFStagingHeader."Sales Invoice No." := SIHRec."No.";
                                VFStagingHeader."Tracking ID" := SIHRec."No."; // YF 23 Mar 2022
                            end;

                            VFStagingHeader."Posting Date" := SIHRec."Posting Date";
                            // VFStagingHeader."Tracking ID" := SIHRec."Package Tracking No.";

                            VFStagingHeader."Total Price" := SIHRec."Amount Including VAT";
                            VFStagingHeader."Time From Text" := Format(SIHRec."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>') + 'T00:00:00.000+08:00'; // "time_from": "2021-11-16T00:00:00.000+08:00",
                            VFStagingHeader."Time To Text" := Format(SIHRec."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>') + 'T23:59:59.999+08:00'; // "time_to": "2021-11-16T23:59:59.999+08:00",
                            VFStagingHeader."Time Type" := 'all_day';
                            VFStagingHeader.COD := SIHRec."Amount Including VAT";//RL 20 Apr 2022 - change from 0 to amount

                            // VFStagingHeader.Remarks := SIHRec."Customer Instructions" + ' / ' + SIHRec."Delivery Instructions"; // YF 08 Mar 2022
                            VFStagingHeader.Remarks := SIHRec."Delivery Instructions"; // YF 08 Mar 2022
                            VFStagingHeader."Source Delivery Charge" := SIHRec."Delivery Charge"; // YF 27 Jun 2022

                            VFStagingHeader."Service Time" := VSSetup."Default Task Service Time";
                            // VFStagingHeader."Delivery Address Name" := SIHRec."Ship-to Name";
                            if IsNovemCust(SIHRec) then begin   //Fix to novem
                                VFStagingHeader."Delivery Address Name" := SIHRec.I9G_CustVendName; //RL    25 Mar 2022 - Swap delivery address name and contact name
                                VFStagingHeader."Delivery Address Line 1" := copystr(SIHRec.I9G_NovemShipToAddress, 1, 100);
                                VFStagingHeader."Delivery Address Line 2" := copystr(SIHRec.I9G_NovemShipToAddress2, 1, 100);
                                VFStagingHeader."Delivery Address City" := copystr(SIHRec.I9G_NovemShipToAddress3, 1, 50);
                                VFStagingHeader."Delivery Address Zip" := '';       //Novem post code is at address 3
                                VFStagingHeader."Delivery Address Contact No." := GetNovemPhone(SIHRec);
                                VFStagingHeader."Delivery Address Contact Name" := GetNovemName(SIHRec);
                                VFStagingHeader."Delivery Address Email" := '';
                                VFStagingHeader."Customer No." := SIHRec.I9G_CustVendCode;
                            end else begin
                                VFStagingHeader."Delivery Address Name" := SIHRec."Ship-to Contact"; //RL    25 Mar 2022 - Swap delivery address name and contact name
                                VFStagingHeader."Delivery Address Line 1" := SIHRec."Ship-to Address";
                                VFStagingHeader."Delivery Address Line 2" := SIHRec."Ship-to Address 2";
                                VFStagingHeader."Delivery Address City" := SIHRec."Ship-to City";
                                VFStagingHeader."Delivery Address Zip" := SIHRec."Ship-to Post Code";
                                VFStagingHeader."Delivery Address Contact No." := SIHRec."Sell-to Phone No.";
                                VFStagingHeader."Delivery Address Contact Name" := SIHRec."Ship-to Name";
                                VFStagingHeader."Delivery Address Email" := SIHRec."Sell-to E-Mail";
                                VFStagingHeader."Customer No." := SIHRec."Sell-to Customer No.";
                            end;
                            VFStagingHeader."Delivery Address Country" := CountryName;

                            // VFStagingHeader."Delivery Address Contact Name" := SIHRec."Ship-to Contact";
                            VFStagingHeader."Driver Tag" := SIHRec."Delivery Zone";
                            VFStagingHeader."Vehicle Tag" := SIHRec."Delivery Zone";
                            VFStagingHeader."Created Timestamp" := CurrentDateTime;

                            VFStagingHeader."Customer Group" := SIHRec."Customer Group";


                            VFStagingHeader."Source Document Type" := VFStagingHeader."Source Document Type"::"Posted Sales Invoice"; // YF 21 Jul 2022

                            TotalAmount := 0;

                            if VFStagingHeader.Insert(true) then begin
                                LineNo := 1;

                                SILRec.Reset;
                                //DX        15 May 2025 Performance tuning
                                SILRec.SetCurrentKey("Document No.", Type);
                                SILRec.SetLoadFields("Document No.", Type, "Line No.", "No.", Description, Quantity, "Unit of Measure Code", "Inv. Discount Amount");
                                //DX        15 May 2025 Performance tuning
                                SILRec.SetRange("Document No.", SIHRec."No.");
                                SILRec.SetRange(Type, SILRec.Type::Item);
                                if SILRec.FindSet() then
                                    repeat
                                        VFStagingLine.Init();
                                        VFStagingLine."Parent Entry No." := VFStagingHeader."Entry No.";
                                        VFStagingLine."Line No." := LineNo;
                                        VFStagingLine."Sales Invoice No." := SILRec."Document No.";
                                        VFStagingLine."Sales Invoice Line No." := SILRec."Line No.";
                                        VFStagingLine."Item No." := SILRec."No.";
                                        VFStagingLine."Item Description" := SILRec.Description;
                                        VFStagingLine.Qty := SILRec.Quantity;
                                        VFStagingLine.UOM := SILRec."Unit of Measure Code";
                                        // VFStagingLine."Item Check Method" := 'manual';
                                        // VFStagingLine."Item Unload Check Method" := 'manual';
                                        VFStagingLine."Item Check Method" := Format(VSSetup."Item Check Method");
                                        VFStagingLine."Item Unload Check Method" := Format(Format(VSSetup."Item Unload Check Method"));
                                        VFStagingLine."Created Timestamp" := CurrentDateTime;

                                        TotalAmount += SILRec."Line Amount" - SILRec."Inv. Discount Amount"; // Line amount (with line discount) offset invoice discount for total

                                        if VFStagingLine.Insert() then
                                            LineNo += 1;
                                    until SILRec.Next() = 0;

                                VFStagingHeader."Total Price" := TotalAmount;
                                // VFStagingHeader."Tracking ID" := Format(CurrentDateTime, 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>') + Format(VFStagingHeader."Entry No."); // YF 23 Mar 2022
                                VFStagingHeader.Modify();
                            end;
                        end;

                        if VFStagingHeader.Get(UpdateRecEntryNo) And UpdateRecord then begin
                            if IsNovemCust(SIHRec) then
                                VFStagingHeader."Sales Invoice No." := GetNovemInvNo(SIHRec)
                            else
                                VFStagingHeader."Sales Invoice No." := SIHRec."No.";
                            VFStagingHeader."Posting Date" := SIHRec."Posting Date";
                            // VFStagingHeader."Tracking ID" := SIHRec."Package Tracking No.";
                            VFStagingHeader."Tracking ID" := SIHRec."No."; // YF 23 Mar 2022
                            VFStagingHeader."Total Price" := SIHRec."Amount Including VAT";
                            VFStagingHeader."Time From Text" := Format(SIHRec."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>') + 'T00:00:00.000+08:00'; // "time_from": "2021-11-16T00:00:00.000+08:00",
                            VFStagingHeader."Time To Text" := Format(SIHRec."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>') + 'T23:59:59.999+08:00'; // "time_to": "2021-11-16T23:59:59.999+08:00",
                            VFStagingHeader."Time Type" := 'all_day';
                            VFStagingHeader.COD := SIHRec."Amount Including VAT"; //RL 20 Apr 2022 - change from 0 to amount

                            // VFStagingHeader.Remarks := SIHRec."Customer Instructions" + ' / ' + SIHRec."Delivery Instructions"; // YF 08 Mar 2022
                            VFStagingHeader.Remarks := SIHRec."Delivery Instructions"; // YF 08 Mar 2022
                            VFStagingHeader."Source Delivery Charge" := SIHRec."Delivery Charge"; // YF 27 Jun 2022

                            VFStagingHeader."Service Time" := VSSetup."Default Task Service Time";
                            // VFStagingHeader."Delivery Address Name" := SIHRec."Ship-to Name";
                            if IsNovemCust(SIHRec) then begin   //Fix to novem
                                VFStagingHeader."Delivery Address Name" := SIHRec.I9G_CustVendName; //RL    25 Mar 2022 - Swap delivery address name and contact name
                                VFStagingHeader."Delivery Address Line 1" := copystr(SIHRec.I9G_NovemShipToAddress, 1, 100);
                                VFStagingHeader."Delivery Address Line 2" := copystr(SIHRec.I9G_NovemShipToAddress2, 1, 100);
                                VFStagingHeader."Delivery Address City" := copystr(SIHRec.I9G_NovemShipToAddress3, 1, 50);
                                VFStagingHeader."Delivery Address Zip" := '';       //Novem post code is at address 3
                                VFStagingHeader."Delivery Address Contact No." := GetNovemPhone(SIHRec);
                                VFStagingHeader."Delivery Address Contact Name" := GetNovemName(SIHRec);
                                VFStagingHeader."Delivery Address Email" := '';
                                VFStagingHeader."Customer No." := SIHRec.I9G_CustVendCode;
                            end else begin
                                VFStagingHeader."Delivery Address Name" := SIHRec."Ship-to Contact"; //RL    25 Mar 2022 - Swap delivery address name and contact name
                                VFStagingHeader."Delivery Address Line 1" := SIHRec."Ship-to Address";
                                VFStagingHeader."Delivery Address Line 2" := SIHRec."Ship-to Address 2";
                                VFStagingHeader."Delivery Address City" := SIHRec."Ship-to City";
                                VFStagingHeader."Delivery Address Zip" := SIHRec."Ship-to Post Code";
                                VFStagingHeader."Delivery Address Contact No." := SIHRec."Sell-to Phone No.";
                                VFStagingHeader."Delivery Address Contact Name" := SIHRec."Ship-to Name";
                                VFStagingHeader."Delivery Address Email" := SIHRec."Sell-to E-Mail";
                                VFStagingHeader."Customer No." := SIHRec."Sell-to Customer No.";
                            end;

                            VFStagingHeader."Delivery Address Country" := CountryName;
                            // VFStagingHeader."Delivery Address Contact Name" := SIHRec."Ship-to Contact";
                            VFStagingHeader."Driver Tag" := SIHRec."Delivery Zone";
                            VFStagingHeader."Vehicle Tag" := SIHRec."Delivery Zone";
                            VFStagingHeader."Process Remarks" := 'Record updated';
                            VFStagingHeader.Error := false;
                            VFStagingHeader."Updated Timestamp" := CurrentDateTime;

                            VFStagingHeader."Customer Group" := SIHRec."Customer Group";


                            VFStagingHeader."Source Document Type" := VFStagingHeader."Source Document Type"::"Posted Sales Invoice"; // YF 21 Jul 2022

                            TotalAmount := 0;

                            if VFStagingHeader.Modify() then begin
                                VFStagingLine.Reset;
                                VFStagingLine.SetRange("Parent Entry No.", UpdateRecEntryNo);
                                VFStagingLine.SetRange("Sales Invoice No.", VFStagingHeader."Sales Invoice No.");
                                // YF 10 Aug 2022 // To avoid unnecessary table lock
                                if not VFStagingLine.IsEmpty then
                                    VFStagingLine.DeleteAll();
                                // YF 10 Aug 2022 // To avoid unnecessary table lock

                                LineNo := 1;

                                SILRec.Reset;
                                //DX        15 May 2025 Performance tuning
                                SILRec.SetCurrentKey("Document No.", Type);
                                SILRec.SetLoadFields("Document No.", Type, "Line No.", "No.", Description, "Unit of Measure Code", Quantity, "Inv. Discount Amount", "Line Discount Amount");
                                //DX        15 May 2025 Performance tuning
                                SILRec.SetRange("Document No.", SIHRec."No.");
                                SILRec.SetRange(Type, SILRec.Type::Item);
                                if SILRec.FindSet() then
                                    repeat
                                        VFStagingLine.Init();
                                        VFStagingLine."Parent Entry No." := VFStagingHeader."Entry No.";
                                        VFStagingLine."Line No." := LineNo;
                                        VFStagingLine."Sales Invoice No." := SILRec."Document No.";
                                        VFStagingLine."Sales Invoice Line No." := SILRec."Line No.";
                                        VFStagingLine."Item No." := SILRec."No.";
                                        VFStagingLine."Item Description" := SILRec.Description;
                                        VFStagingLine.Qty := SILRec.Quantity;
                                        VFStagingLine.UOM := SILRec."Unit of Measure Code";
                                        // VFStagingLine."Item Check Method" := 'manual';
                                        // VFStagingLine."Item Unload Check Method" := 'manual';
                                        VFStagingLine."Item Check Method" := Format(VSSetup."Item Check Method");
                                        VFStagingLine."Item Unload Check Method" := Format(Format(VSSetup."Item Unload Check Method"));
                                        VFStagingLine."Created Timestamp" := CurrentDateTime;

                                        TotalAmount += SILRec."Line Amount" - SILRec."Inv. Discount Amount"; // Line amount (with line discount) offset invoice discount for total

                                        if VFStagingLine.Insert() then
                                            LineNo += 1;
                                    until SILRec.Next() = 0;
                            end;

                            VFStagingHeader."Total Price" := TotalAmount;
                            // VFStagingHeader."Tracking ID" := Format(CurrentDateTime, 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>') + Format(VFStagingHeader."Entry No."); // YF 23 Mar 2022
                            VFStagingHeader.Modify();

                        end;
                    end;

                    EntryNo := VFStagingHeader."Entry No.";
                end;


            until SIHRec.Next() = 0;

        if Not Silent then
            Message('Delivery Queue submitted');

        exit(EntryNo);
    end;

    procedure InsertOrUpdateStagingTransferRecords(var TransferShipmentHeader: Record "Transfer Shipment Header")
    var
        TLRec: Record "Transfer Line";
        VFStagingHeader: Record "Staging VF Task Header";
        VFStagingLine: Record "Staging VF Task Line";
        NewRecord: Boolean;
        UpdateRecord: Boolean;
        HasActiveTask: Boolean;
        UpdateRecEntryNo: Integer;
        LineNo: Integer;
        VSSetup: Record "VersaFleet Integration Setup";
        //TotalAmount: Decimal;
        CountryRec: Record "Country/Region";
        CountryName: Text[50];
    begin
        VSSetup.Get;

        // SIHRec.SetFilter("Order Status", '<>%1|<>%2', SIHRec."Order Status"::"Delivery In Progress", SIHRec."Order Status"::Delivered); // YF 15 Mar 2022
        // SIHRec.SetFilter("Order Status", '=%1', SIHRec."Order Status"::"Pending Delivery"); // YF 15 Mar 2022
        //SIHRec.SetFilter("Order Status", '=%1|%2', SIHRec."Order Status"::"Pending Delivery", SIHRec."Order Status"::"Delivery In Progress"); //RL 29 Apr 2022
        TransferShipmentHeader.SetFilter("Transfer-to Code", '%1|%2', 'SAMPLE', 'CONSGT');
        if TransferShipmentHeader.FindSet() then
            repeat
                if IsAllowedDocNo(TransferShipmentHeader."No.") then begin
                    NewRecord := false;
                    UpdateRecord := false;
                    HasActiveTask := false;
                    UpdateRecEntryNo := 0;
                    CountryName := '';

                    // if (SIHRec."Ship-to Country/Region Code" = '') Or (SIHRec."Ship-to Country/Region Code" = 'SGP') then // YF 14 Sep 2022
                    if TransferShipmentHeader."Trsf.-to Country/Region Code" in ['', 'SGP', 'SG'] then  // YF 14 Sep 2022
                        CountryName := 'Singapore'
                    else begin
                        //DX        15 May 2025 Performance tuning
                        CountryRec.reset;
                        CountryRec.SetLoadFields(Name);
                        //DX        15 May 2025 Performance tuning
                        if CountryRec.Get(TransferShipmentHeader."Trsf.-to Country/Region Code") then
                            CountryName := CountryRec.Name;
                    end;


                    VFStagingHeader.Reset;
                    //DX        15 May 2025 Performance tuning
                    VFStagingHeader.SetCurrentKey("Sales Invoice No.", "Source Document Type");
                    VFStagingHeader.SetLoadFields("Sales Invoice No.", "Source Document Type", Created, Closed);
                    //DX        15 May 2025 Performance tuning
                    VFStagingHeader.SetRange("Sales Invoice No.", TransferShipmentHeader."No.");
                    VFStagingHeader.SetFilter("Source Document Type", '%1', VFStagingHeader."Source Document Type"::"Transfer Shipment");
                    if VFStagingHeader.FindSet() then
                        repeat
                            if VFStagingHeader.Created then begin
                                if VFStagingHeader.Closed then begin
                                    NewRecord := true;
                                    UpdateRecord := false;
                                end
                                else begin
                                    // active delivery task
                                    NewRecord := false;
                                    UpdateRecord := false;
                                    HasActiveTask := true;
                                end;
                            end
                            else begin
                                NewRecord := false;
                                UpdateRecord := true;
                                UpdateRecEntryNo := VFStagingHeader."Entry No.";
                            end;
                        until VFStagingHeader.Next() = 0
                    else begin
                        NewRecord := true;
                        UpdateRecord := false;
                    end;

                    if Not HasActiveTask then begin
                        if NewRecord then begin
                            VFStagingHeader.Init();
                            VFStagingHeader."Entry No." := 0;
                            VFStagingHeader."Sales Invoice No." := TransferShipmentHeader."No.";
                            VFStagingHeader."Posting Date" := TransferShipmentHeader."Posting Date";
                            // VFStagingHeader."Tracking ID" := SIHRec."Package Tracking No.";
                            VFStagingHeader."Tracking ID" := TransferShipmentHeader."No."; // YF 23 Mar 2022
                                                                                           //VFStagingHeader."Total Price" := SIHRec."Amount Including VAT";
                            VFStagingHeader."Time From Text" := Format(TransferShipmentHeader."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>') + 'T00:00:00.000+08:00'; // "time_from": "2021-11-16T00:00:00.000+08:00",
                            VFStagingHeader."Time To Text" := Format(TransferShipmentHeader."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>') + 'T23:59:59.999+08:00'; // "time_to": "2021-11-16T23:59:59.999+08:00",
                            VFStagingHeader."Time Type" := 'all_day';
                            //VFStagingHeader.COD := SIHRec."Amount Including VAT";//RL 20 Apr 2022 - change from 0 to amount

                            // VFStagingHeader.Remarks := SIHRec."Customer Instructions" + ' / ' + SIHRec."Delivery Instructions"; // YF 08 Mar 2022
                            // VFStagingHeader.Remarks := SIHRec."Delivery Instructions" + ' - ' + SIHRec."Delivery Charge"; // YF 08 Mar 2022, RL 06 April 2022 - add delivery charge after instruction. // YF 27 Jun 2022
                            //VFStagingHeader.Remarks := SIHRec."Delivery Instructions"; // YF 27 Jun 2022
                            //VFStagingHeader."Source Delivery Charge" := SIHRec."Delivery Charge"; // YF 27 Jun 2022

                            VFStagingHeader."Service Time" := VSSetup."Default Task Service Time";
                            // VFStagingHeader."Delivery Address Name" := SIHRec."Ship-to Name";
                            VFStagingHeader."Delivery Address Name" := TransferShipmentHeader."Transfer-to Contact";
                            VFStagingHeader."Delivery Address Line 1" := TransferShipmentHeader."Transfer-to Address";
                            VFStagingHeader."Delivery Address Line 2" := TransferShipmentHeader."Transfer-to Address 2";
                            VFStagingHeader."Delivery Address City" := TransferShipmentHeader."Transfer-to City";
                            VFStagingHeader."Delivery Address Country" := CountryName;
                            VFStagingHeader."Delivery Address Zip" := TransferShipmentHeader."Transfer-to Post Code";
                            //VFStagingHeader."Delivery Address Email" := SIHRec."Sell-to E-Mail";
                            //VFStagingHeader."Delivery Address Contact No." := SIHRec."Sell-to Phone No.";
                            // VFStagingHeader."Delivery Address Contact Name" := SIHRec."Ship-to Contact";
                            VFStagingHeader."Delivery Address Contact Name" := TransferShipmentHeader."Transfer-to Name";
                            //VFStagingHeader."Driver Tag" := SIHRec."Delivery Zone";
                            //VFStagingHeader."Vehicle Tag" := SIHRec."Delivery Zone";
                            VFStagingHeader."Created Timestamp" := CurrentDateTime;

                            VFStagingHeader."Source Document Type" := VFStagingHeader."Source Document Type"::"Transfer Shipment";

                            VFStagingHeader."Driver Tag" := TransferShipmentHeader.I9G_DriverCode;
                            VFStagingHeader."Vehicle Tag" := TransferShipmentHeader.I9G_DriverCode;
                            VFStagingHeader."Source Delivery Charge" := TransferShipmentHeader.I9G_DeliveryChargeCode;

                            //TotalAmount := 0;

                            if VFStagingHeader.Insert(true) then begin
                                LineNo := 1;

                                TLRec.Reset;
                                //DX        15 May 2025 Performance tuning
                                TLRec.SetCurrentKey("Document No.");
                                TLRec.SetLoadFields("Document No.", "Line No.", "Item No.", Description, Quantity, "Unit of Measure Code");
                                //DX        15 May 2025 Performance tuning
                                TLRec.SetRange("Document No.", TransferShipmentHeader."No.");
                                if TLRec.FindSet() then
                                    repeat
                                        VFStagingLine.Init();
                                        VFStagingLine."Parent Entry No." := VFStagingHeader."Entry No.";
                                        VFStagingLine."Line No." := LineNo;
                                        VFStagingLine."Sales Invoice No." := TLRec."Document No.";
                                        VFStagingLine."Sales Invoice Line No." := TLRec."Line No.";
                                        VFStagingLine."Item No." := TLRec."Item No.";
                                        VFStagingLine."Item Description" := TLRec.Description;
                                        VFStagingLine.Qty := TLRec.Quantity;
                                        VFStagingLine.UOM := TLRec."Unit of Measure Code";
                                        // VFStagingLine."Item Check Method" := 'manual';
                                        // VFStagingLine."Item Unload Check Method" := 'manual';
                                        VFStagingLine."Item Check Method" := Format(VSSetup."Item Check Method");
                                        VFStagingLine."Item Unload Check Method" := Format(Format(VSSetup."Item Unload Check Method"));
                                        VFStagingLine."Created Timestamp" := CurrentDateTime;

                                        //TotalAmount += SILRec."Line Amount" - SILRec."Inv. Discount Amount"; // Line amount (with line discount) offset invoice discount for total

                                        if VFStagingLine.Insert() then
                                            LineNo += 1;
                                    until TLRec.Next() = 0;

                                //VFStagingHeader."Total Price" := TotalAmount;
                                // VFStagingHeader."Tracking ID" := Format(CurrentDateTime, 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>') + Format(VFStagingHeader."Entry No."); // YF 23 Mar 2022
                                VFStagingHeader.Modify();
                            end;
                        end;

                        if VFStagingHeader.Get(UpdateRecEntryNo) And UpdateRecord then begin
                            VFStagingHeader."Sales Invoice No." := TransferShipmentHeader."No.";
                            VFStagingHeader."Posting Date" := TransferShipmentHeader."Posting Date";
                            // VFStagingHeader."Tracking ID" := SIHRec."Package Tracking No.";
                            VFStagingHeader."Tracking ID" := TransferShipmentHeader."No."; // YF 23 Mar 2022
                                                                                           //VFStagingHeader."Total Price" := SIHRec."Amount Including VAT";
                            VFStagingHeader."Time From Text" := Format(TransferShipmentHeader."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>') + 'T00:00:00.000+08:00'; // "time_from": "2021-11-16T00:00:00.000+08:00",
                            VFStagingHeader."Time To Text" := Format(TransferShipmentHeader."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>') + 'T23:59:59.999+08:00'; // "time_to": "2021-11-16T23:59:59.999+08:00",
                            VFStagingHeader."Time Type" := 'all_day';
                            //VFStagingHeader.COD := SIHRec."Amount Including VAT";//RL 20 Apr 2022 - change from 0 to amount

                            // VFStagingHeader.Remarks := SIHRec."Customer Instructions" + ' / ' + SIHRec."Delivery Instructions"; // YF 08 Mar 2022
                            //VFStagingHeader.Remarks := SIHRec."Delivery Instructions"; // YF 08 Mar 2022
                            //VFStagingHeader."Source Delivery Charge" := SIHRec."Delivery Charge"; // YF 27 Jun 2022

                            VFStagingHeader."Service Time" := VSSetup."Default Task Service Time";
                            // VFStagingHeader."Delivery Address Name" := SIHRec."Ship-to Name";
                            VFStagingHeader."Delivery Address Name" := TransferShipmentHeader."Transfer-to Contact";
                            VFStagingHeader."Delivery Address Line 1" := TransferShipmentHeader."Transfer-to Address";
                            VFStagingHeader."Delivery Address Line 2" := TransferShipmentHeader."Transfer-to Address 2";
                            VFStagingHeader."Delivery Address City" := TransferShipmentHeader."Transfer-to City";
                            VFStagingHeader."Delivery Address Country" := CountryName;
                            VFStagingHeader."Delivery Address Zip" := TransferShipmentHeader."Transfer-to Post Code";
                            //VFStagingHeader."Delivery Address Email" := SIHRec."Sell-to E-Mail";
                            //VFStagingHeader."Delivery Address Contact No." := SIHRec."Sell-to Phone No.";
                            // VFStagingHeader."Delivery Address Contact Name" := SIHRec."Ship-to Contact";
                            VFStagingHeader."Delivery Address Contact Name" := TransferShipmentHeader."Transfer-to Name";
                            //VFStagingHeader."Driver Tag" := SIHRec."Delivery Zone";
                            //VFStagingHeader."Vehicle Tag" := SIHRec."Delivery Zone";
                            VFStagingHeader."Process Remarks" := 'Record updated';
                            VFStagingHeader.Error := false;
                            VFStagingHeader."Updated Timestamp" := CurrentDateTime;

                            VFStagingHeader."Source Document Type" := VFStagingHeader."Source Document Type"::"Posted Sales Invoice"; // YF 21 Jul 2022

                            //TotalAmount := 0;

                            if VFStagingHeader.Modify() then begin
                                VFStagingLine.Reset;
                                VFStagingLine.SetRange("Parent Entry No.", UpdateRecEntryNo);
                                VFStagingLine.SetRange("Sales Invoice No.", VFStagingHeader."Sales Invoice No.");
                                // YF 10 Aug 2022 // To avoid unnecessary table lock
                                if not VFStagingLine.IsEmpty then
                                    VFStagingLine.DeleteAll();
                                // YF 10 Aug 2022 // To avoid unnecessary table lock

                                LineNo := 1;

                                TLRec.Reset;
                                //DX        15 May 2025 Performance tuning
                                TLRec.SetCurrentKey("Document No.");
                                TLRec.SetLoadFields("Document No.", "Line No.", "Item No.", Description, Quantity, "Unit of Measure Code");
                                //DX        15 May 2025 Performance tuning
                                TLRec.SetRange("Document No.", TransferShipmentHeader."No.");
                                if TLRec.FindSet() then
                                    repeat
                                        VFStagingLine.Init();
                                        VFStagingLine."Parent Entry No." := VFStagingHeader."Entry No.";
                                        VFStagingLine."Line No." := LineNo;
                                        VFStagingLine."Sales Invoice No." := TLRec."Document No.";
                                        VFStagingLine."Sales Invoice Line No." := TLRec."Line No.";
                                        VFStagingLine."Item No." := TLRec."Item No.";
                                        VFStagingLine."Item Description" := TLRec.Description;
                                        VFStagingLine.Qty := TLRec.Quantity;
                                        VFStagingLine.UOM := TLRec."Unit of Measure Code";
                                        // VFStagingLine."Item Check Method" := 'manual';
                                        // VFStagingLine."Item Unload Check Method" := 'manual';
                                        VFStagingLine."Item Check Method" := Format(VSSetup."Item Check Method");
                                        VFStagingLine."Item Unload Check Method" := Format(Format(VSSetup."Item Unload Check Method"));
                                        VFStagingLine."Created Timestamp" := CurrentDateTime;

                                        //TotalAmount += SILRec."Line Amount" - SILRec."Inv. Discount Amount"; // Line amount (with line discount) offset invoice discount for total

                                        if VFStagingLine.Insert() then
                                            LineNo += 1;
                                    until TLRec.Next() = 0;
                            end;

                            //VFStagingHeader."Total Price" := TotalAmount;
                            // VFStagingHeader."Tracking ID" := Format(CurrentDateTime, 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>') + Format(VFStagingHeader."Entry No."); // YF 23 Mar 2022
                            VFStagingHeader.Modify();

                        end;
                    end;
                end;


            until TransferShipmentHeader.Next() = 0;

        Message('Delivery Queue submitted');
    end;

    procedure CheckDeliveryJobExist(PostingDate: Date; var JobID: Integer; var ProcessMessages: Text[150]; var HasError: Boolean): Boolean;
    var
        VersaFleetSetup: Record "VersaFleet Integration Setup";
        APIAddress: Text[500];
        DeliveryJobId: Integer;
        JobJsonArray: JsonArray;
        JobJsonObj: JsonObject;
        JobJsonToken: JsonToken;
        JobJsonChildToken: JsonToken;
        PostDateText: Text[30];
    begin
        // https://api.versafleet.co/api/customers/<custid>?client_id=<clientid>&client_secret=<clientkey>

        if PostingDate = 0D then begin
            ProcessMessages := 'Invalid Posting Date Parameter';
            HasError := true;
            exit(false);
        end
        else
            PostDateText := Format(PostingDate, 0, '<Year4>-<Month,2>-<Day,2>');

        ClearObjects();
        if Not VersaFleetSetup.Get then begin
            ProcessMessages := 'Integration Setup not done';
            HasError := true;
            exit(false);
        end;

        APIAddress := VersaFleetSetup."API Parent URL" + 'v2/jobs'
                        + '?client_id=' + VersaFleetSetup."Client ID"
                        + '&client_secret=' + VersaFleetSetup."Client Secret"
                        + '&date=' + PostDateText
                        // + '&date=2021-11-16'
                        + '&archived=false';

        // apiRequestQuery := '';
        // _httpContent.WriteFrom(apiRequestQuery); // add the payload
        // _httpContent.GetHeaders(contentHeaders); // retrieve content headers associated with content
        // contentHeaders.Clear();
        // contentHeaders.Add('Content-Type', 'application/json');
        // Request.Content := _httpContent;
        // Request.SetRequestUri(APIAddress);
        // Request.Method := 'GET';

        if Not Client.Get(APIAddress, Response) then begin
            ProcessMessages := '1 API call failed to send';
            HasError := true;
            exit(false);
        end;

        If Not Response.IsSuccessStatusCode() then begin
            if Response.HttpStatusCode() = 404 then
                ProcessMessages := 'Record not found' // to send message to trigger insert
            else
                ProcessMessages := '1 Web service returned error: ' + 'Status code: ' + Format(Response.HttpStatusCode()) + ' ' + 'Description: ' + Format(Response.ReasonPhrase());

            HasError := true;
            exit(false);
            /*
            Message('Web service returned error:\\' +
                'Status code: %1\' +
                'Description: %2',
                Response.HttpStatusCode(),
                Response.ReasonPhrase());
            */
        end
        else begin
            Response.Content().ReadAs(ResponseText); // Read response content as json

            if StrLen(ResponseText) > 0 then begin
                _jsonToken.ReadFrom(ResponseText);
                if _jsonToken.IsObject then begin
                    jsonObj := _jsonToken.AsObject();
                    if jsonObj.Get('jobs', JobJsonToken) then begin
                        if JobJsonToken.IsArray then begin
                            JobJsonArray := JobJsonToken.AsArray();
                            if JobJsonArray.Count > 0 then begin
                                if JobJsonArray.Get(0, JobJsonChildToken) then begin
                                    if JobJsonChildToken.IsObject then begin
                                        JobJsonObj := JobJsonChildToken.AsObject();
                                        DeliveryJobId := GetJsonValueAsInteger(JobJsonObj, 'id');
                                        JobID := DeliveryJobId;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;

                if DeliveryJobId = 0 then begin
                    ProcessMessages := 'No Jobs Found';
                    HasError := false;
                    exit(false);
                end
                else begin
                    // ProcessMessages := 'Jobs Found ' + Format(DeliveryJobId);
                    ProcessMessages := '';
                    HasError := false;
                    exit(true);
                end;

            end
            else begin
                ProcessMessages := 'Empty response string';
                HasError := true;
                exit(false);
            end;

        end;

        exit(false);
    end;


    procedure CreateDeliveryJob(PostingDate: Date; var JobID: Integer; var ProcessMessages: Text[150]; var HasError: Boolean): Boolean;
    var
        VersaFleetSetup: Record "VersaFleet Integration Setup";
        APIAddress: Text[500];
        DeliveryJobId: Integer;
        DeliveryJobGUID: Text;
        DeliveryJobState: Text;
        TaskId: Integer;
        TaskGUID: Text;
        TaskState: Text;
        JobJsonArray: JsonArray;
        JobJsonObj: JsonObject;
        JobJsonToken: JsonToken;
        JobJsonChildToken: JsonToken;
        PostDateText: Text[30];
        TaskJsonObj: JsonObject;
        TaskJsonToken: JsonToken;

    begin
        // https://api.versafleet.co/api/customers?client_id=<clientid>&client_secret=<clientkey>

        if PostingDate = 0D then begin
            ProcessMessages := 'Invalid Posting Date Parameter';
            HasError := true;
            exit(false);
        end
        else
            PostDateText := Format(PostingDate, 0, '<Year4>-<Month,2>-<Day,2>');

        ClearObjects();
        if Not VersaFleetSetup.Get then begin
            ProcessMessages := 'Integration Setup not done';
            HasError := true;
            exit(false);
        end;

        APIAddress := VersaFleetSetup."API Parent URL" + 'v2/jobs'
                        + '?client_id=' + VersaFleetSetup."Client ID"
                        + '&client_secret=' + VersaFleetSetup."Client Secret";

        apiRequestQuery := '{';
        apiRequestQuery += '    "job": {';
        apiRequestQuery += '        "job_type": "delivery",';
        apiRequestQuery += '        "remarks": "Created by BC",';
        apiRequestQuery += '        "customer_id": ' + Format(VersaFleetSetup."PMP VersaFleet Customer ID") + ','; // #DevNotes: consider switch from text to integer?
        apiRequestQuery += '        "base_task_attributes": {';
        apiRequestQuery += '            "time_from": "' + PostDateText + 'T00:00:00.000+08:00' + '",';
        apiRequestQuery += '            "time_to": "' + PostDateText + 'T23:59:59.999+08:00' + '",';
        apiRequestQuery += '            "time_type": "all_day",';
        apiRequestQuery += '            "time_window_id": null,';
        apiRequestQuery += '            "service_time": ' + Format(VersaFleetSetup."Default Job Service Time") + ',';
        apiRequestQuery += '            "address_attributes": {';
        apiRequestQuery += '                "name": "' + VersaFleetSetup."PMP-WH Name" + '",';
        apiRequestQuery += '                "zip": ' + VersaFleetSetup."PMP-WH Post Code/Zip" + ',';
        apiRequestQuery += '                "line_1": "' + VersaFleetSetup."PMP-WH Address" + '",';
        apiRequestQuery += '                "line_2": "' + VersaFleetSetup."PMP-WH Address 2" + '",';
        apiRequestQuery += '                "country": "' + VersaFleetSetup."PMP-WH Country" + '",';
        apiRequestQuery += '                "city": "' + VersaFleetSetup."PMP-WH City" + '",';
        apiRequestQuery += '                "email": "' + VersaFleetSetup."PMP-WH E-Mail" + '",';
        apiRequestQuery += '                "contact_person": "' + VersaFleetSetup."PMP-WH Contact Person" + '",';
        apiRequestQuery += '                "contact_number": "' + VersaFleetSetup."PMP-WH Contact Number" + '"';
        apiRequestQuery += '            }';
        apiRequestQuery += '        }';
        apiRequestQuery += '    }';
        apiRequestQuery += '}';

        _httpContent.WriteFrom(apiRequestQuery); // add the payload
        _httpContent.GetHeaders(contentHeaders); // retrieve content headers associated with content
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/json');

        // Request.Content := _httpContent;
        // Request.SetRequestUri(APIAddress);
        // Request.Method := 'POST';

        // Message(APIAddress);
        // Message(apiRequestQuery);

        if Not Client.Post(APIAddress, _httpContent, Response) then begin
            ProcessMessages := '2 API call failed to send';
            HasError := true;
            exit(false);
        end;

        If Not Response.IsSuccessStatusCode() then begin
            ProcessMessages := '2 Web service returned error: ' + 'Status code: ' + Format(Response.HttpStatusCode()) + ' ' + 'Description: ' + Format(Response.ReasonPhrase());
            HasError := true;
            exit(false);
            /*
            Message('Web service returned error:\\' +
                'Status code: %1\' +
                'Description: %2',
                Response.HttpStatusCode(),
                Response.ReasonPhrase());
            */
        end
        else begin
            Response.Content().ReadAs(ResponseText); // Read response content as json

            if StrLen(ResponseText) > 0 then begin
                _jsonToken.ReadFrom(ResponseText);
                if _jsonToken.IsObject then begin
                    jsonObj := _jsonToken.AsObject();
                    if jsonObj.Get('job', JobJsonToken) then begin
                        if JobJsonToken.IsObject then begin
                            JobJsonObj := JobJsonToken.AsObject();
                            DeliveryJobId := GetJsonValueAsInteger(JobJsonObj, 'id');
                            JobID := DeliveryJobId;
                            DeliveryJobGUID := GetJsonValueAsText(JobJsonObj, 'guid'); // Job GUID
                            DeliveryJobState := GetJsonValueAsText(JobJsonObj, 'state'); // Job State

                            if JobJsonObj.Get('base_task', TaskJsonToken) then begin
                                if TaskJsonToken.IsObject then begin
                                    TaskJsonObj := TaskJsonToken.AsObject();
                                    TaskId := GetJsonValueAsInteger(TaskJsonObj, 'id');
                                    TaskGUID := GetJsonValueAsText(TaskJsonObj, 'guid');
                                    TaskState := GetJsonValueAsText(TaskJsonObj, 'state');
                                end;
                            end;
                        end;
                    end;
                end;

                if DeliveryJobId = 0 then begin
                    ProcessMessages := 'No Jobs Found';
                    HasError := false;
                    exit(false);
                end
                else begin
                    // ProcessMessages := 'Jobs Found ' + Format(DeliveryJobId);
                    InsertDeliveryJobEntry(PostDateText, DeliveryJobId, DeliveryJobGUID, DeliveryJobState, TaskId, TaskGUID, TaskState); // Insert Job Created Tracking Entry for logging
                    ProcessMessages := '';
                    HasError := false;
                    exit(true);
                end;
            end
            else begin
                ProcessMessages := 'Empty response string';
                HasError := true;
                exit(false);
            end;

        end;

        exit(false);
    end;


    local procedure InsertDeliveryJobEntry(PostDateText: Text; JobID: Integer; JobGUID: Text; JobState: Text; TaskID: Integer; TaskGUID: Text; TaskState: Text)
    var
        DeliveryJobRec: Record "VF Job Tracking";
        BaseTimeFromText: Text;
        BaseTimeToText: Text;
        VersaFleetSetup: Record "VersaFleet Integration Setup";
    begin
        VersaFleetSetup.Get;

        // Massage Base Time Data
        BaseTimeFromText := PostDateText + 'T00:00:00.000+08:00';
        BaseTimeToText := PostDateText + 'T23:59:59.999+08:00';

        // Retire older records if any
        DeliveryJobRec.Reset;
        DeliveryJobRec.SetFilter("Base Task Time From Text", BaseTimeFromText);
        DeliveryJobRec.SetFilter("Base Task Time To Text", BaseTimeToText);
        DeliveryJobRec.ModifyAll("VF Job Archived", true);

        // Insert new record
        DeliveryJobRec.Reset;
        DeliveryJobRec.Init();
        DeliveryJobRec."Entry No." := 0;
        DeliveryJobRec."Job Type" := 'delivery';
        DeliveryJobRec.Remarks := 'Created By BC';
        Evaluate(DeliveryJobRec."Customer ID", VersaFleetSetup."PMP VersaFleet Customer ID");
        DeliveryJobRec."Base Task Time From Text" := BaseTimeFromText;
        DeliveryJobRec."Base Task Time To Text" := BaseTimeToText;
        DeliveryJobRec."Base Task Time Type" := 'all_day';
        DeliveryJobRec."Base Task Service Time" := VersaFleetSetup."Default Task Service Time";
        DeliveryJobRec."Base Job Service Time" := VersaFleetSetup."Default Job Service Time";
        DeliveryJobRec."PMP VersaFleet Customer ID" := VersaFleetSetup."PMP VersaFleet Customer ID";
        DeliveryJobRec."PMP-WH Name" := VersaFleetSetup."PMP-WH Name";
        DeliveryJobRec."PMP-WH Address" := '';
        DeliveryJobRec."PMP-WH Address 2" := '';
        DeliveryJobRec."PMP-WH City" := '';
        DeliveryJobRec."PMP-WH Country" := '';
        DeliveryJobRec."PMP-WH Post Code/Zip" := '';
        DeliveryJobRec."PMP-WH E-Mail" := '';
        DeliveryJobRec."PMP-WH Contact Person" := '';
        DeliveryJobRec."PMP-WH Contact Number" := '';
        DeliveryJobRec."VF Job ID" := JobID;
        DeliveryJobRec."VF Job GUID" := '';
        DeliveryJobRec."VF Job State" := '';
        DeliveryJobRec."VF Job Archived" := false;
        DeliveryJobRec."VF Task ID" := 0;
        DeliveryJobRec."VF Task GUID" := '';
        DeliveryJobRec."VF Task State" := '';
        DeliveryJobRec.Insert(false);
    end;


    // Check Versafleet is tracking number exists
    procedure CheckVFTrackingIDExists(var TrackingIDParameter: Text[50]; var ProcessMessages: Text[150]; var HasError: Boolean; var TaskIDPara: Integer): Boolean // YF 13 Jun 2022
    var
        VersaFleetSetup: Record "VersaFleet Integration Setup";
        APIAddress: Text[500];
        TaskId: Integer;
        TaskJsonArray: JsonArray;
        TaskJsonObj: JsonObject;
        TaskJsonToken: JsonToken;
        TaskJsonChildToken: JsonToken;
    begin
        TaskId := 0;

        Sleep(1000); // slow down execution for trigger via UI // seems to fast for VF to handle at this point

        ClearObjects();
        if Not VersaFleetSetup.Get then begin
            ProcessMessages := 'Integration Setup not done';
            HasError := true;
            exit(false);
        end;

        APIAddress := VersaFleetSetup."API Parent URL" + 'tasks/' + TrackingIDParameter + '/track'
                        + '?client_id=' + VersaFleetSetup."Client ID"
                        + '&client_secret=' + VersaFleetSetup."Client Secret";

        if Not Client.Post(APIAddress, _httpContent, Response) then begin
            ProcessMessages := '4 API call failed to send ' + TrackingIDParameter;
            HasError := true;
            exit(false);
        end;

        If Not Response.IsSuccessStatusCode() then begin
            ProcessMessages := '4 Web service returned error: ' + 'Status code: ' + Format(Response.HttpStatusCode()) + ' ' + 'Description: ' + Format(Response.ReasonPhrase());
            // HasError := true;
            // exit(false);
            // probably not found
            HasError := false;
            exit(false);
        end
        else begin
            Response.Content().ReadAs(ResponseText); // Read response content as json

            if StrLen(ResponseText) > 0 then begin
                _jsonToken.ReadFrom(ResponseText);
                if _jsonToken.IsObject then begin
                    jsonObj := _jsonToken.AsObject();
                    if jsonObj.Get('task', TaskJsonToken) then begin
                        if TaskJsonToken.IsObject then begin
                            TaskJsonObj := TaskJsonToken.AsObject();
                            TaskId := GetJsonValueAsInteger(TaskJsonObj, 'id');
                            TaskIDPara := TaskId; // YF 13 Jun 2022
                        end;
                    end;
                end;

                if TaskId = 0 then begin
                    // ProcessMessages := 'No Task Found';
                    HasError := false;
                    exit(false);
                end
                else begin
                    // ProcessMessages := 'Jobs Found ' + Format(DeliveryJobId);
                    ProcessMessages := '';
                    HasError := false;
                    exit(true);
                end;
            end
            else begin
                ProcessMessages := 'Empty response string';
                HasError := true;
                exit(false);
            end;

        end;

        exit(false);
    end;

    /*
    procedure CheckTaskTrackingStatus(var TaskID: Integer; var VFStageHeader: Record "Staging VF Task Header"; var ProcessMessages: Text[150]; var HasError: Boolean): Boolean;
    var
        VersaFleetSetup: Record "VersaFleet Integration Setup";
        APIAddress: Text[500];

        TCHJsonArray: JsonArray;
        TCHJsonObj: JsonObject;
        TCHJsonToken: JsonToken;
        TCHJsonChildToken: JsonToken;

        TaskState: Text;
        TaskPartialSuccess: Boolean;
        TaskLatestFailReason: Text;
        TaskDriverNotes: Text;

        LICJsonArray: JsonArray;
        LICJsonObj: JsonObject;
        LICJsonToken: JsonToken;
        LICJsonChildToken: JsonToken;

        VFStagingLineRec: Record "Staging VF Task Line";
        LineActualQty: Decimal;
        LineReason: Text;
        LineItemId: Integer;

        SalesInvHdrRec: Record "Sales Invoice Header";

    begin
        ClearObjects();
        if Not VersaFleetSetup.Get then begin
            ProcessMessages := 'Integration Setup not done';
            HasError := true;
            exit(false);
        end;

        APIAddress := VersaFleetSetup."API Parent URL" + 'tasks/' + Format(TaskID, 0, 1) + '/task_completion_histories'
                        + '?client_id=' + VersaFleetSetup."Client ID"
                        + '&client_secret=' + VersaFleetSetup."Client Secret";

        if Not Client.Get(APIAddress, Response) then begin
            ProcessMessages := '5 API call failed to send';
            HasError := true;
            exit(false);
        end;

        If Not Response.IsSuccessStatusCode() then begin
            ProcessMessages := '5 Web service returned error: ' + 'Status code: ' + Format(Response.HttpStatusCode()) + ' ' + 'Description: ' + Format(Response.ReasonPhrase());
            HasError := true;
            exit(false);
        end
        else begin
            Response.Content().ReadAs(ResponseText); // Read response content as json

            if StrLen(ResponseText) > 0 then begin
                _jsonToken.ReadFrom(ResponseText);
                if _jsonToken.IsObject then begin
                    jsonObj := _jsonToken.AsObject();
                    if jsonObj.Get('task_completion_histories', TCHJsonToken) then begin
                        if TCHJsonToken.IsArray then begin
                            TCHJsonArray := TCHJsonToken.AsArray();
                            if TCHJsonArray.Count > 0 then begin
                                if TCHJsonArray.Get(0, TCHJsonChildToken) then begin
                                    if TCHJsonChildToken.IsObject then begin
                                        TCHJsonObj := TCHJsonChildToken.AsObject();
                                        TaskState := GetJsonValueAsText(TCHJsonObj, 'state');
                                        TaskPartialSuccess := GetJsonValueAsBoolean(TCHJsonObj, 'is_partial_success');
                                        TaskLatestFailReason := ''; // use Task API and field VF Task State Updated if required
                                        TaskDriverNotes := GetJsonValueAsText(TCHJsonObj, 'notes');

                                        // update header records
                                        VFStageHeader."VF Task State" := TaskState;
                                        VFStageHeader."VF Is Partial Success" := TaskPartialSuccess;
                                        VFStageHeader."VF Driver Notes" := TaskDriverNotes;
                                        VFStageHeader.Modify();

                                        // if collected change to delivery in progress
                                        // if successful change to completed
                                        if SalesInvHdrRec.Get(VFStageHeader."Sales Invoice No.") then begin
                                            if TaskState = 'collected' then
                                                SalesInvHdrRec."Order Status" := SalesInvHdrRec."Order Status"::"Delivery In Progress";

                                            if TaskState = 'successful' then
                                                SalesInvHdrRec."Order Status" := SalesInvHdrRec."Order Status"::Completed;

                                            SalesInvHdrRec.Modify(false);
                                        end;

                                        if TCHJsonObj.Get('line_item_completions', LICJsonToken) then begin
                                            if LICJsonToken.IsArray then begin
                                                LICJsonArray := LICJsonToken.AsArray();
                                                foreach LICJsonChildToken in LICJsonArray do begin
                                                    if LICJsonChildToken.IsObject then begin
                                                        LICJsonObj := LICJsonChildToken.AsObject();
                                                        LineItemId := GetJsonValueAsInteger(LICJsonObj, 'measurement_id');
                                                        LineActualQty := GetJsonValueAsDecimal(LICJsonObj, 'actual_quantity');
                                                        LineReason := GetJsonValueAsText(LICJsonObj, 'reason');

                                                        // update line staging records
                                                        VFStagingLineRec.Reset;
                                                        VFStagingLineRec.SetRange("VF Task ID", TaskID);
                                                        VFStagingLineRec.SetRange("VF Task Item ID", LineItemId);
                                                        if VFStagingLineRec.FindFirst() then begin
                                                            VFStagingLineRec."VF Actual Qty Processed" := LineActualQty;
                                                            VFStagingLineRec."VF Driver Reason" := LineReason;
                                                            VFStagingLineRec.Modify();
                                                        end;
                                                    end;
                                                end;
                                            end;
                                        end;

                                    end;

                                    exit(true);

                                end;
                            end;
                        end;
                    end;
                end;

            end
            else begin
                ProcessMessages := 'Empty response string';
                HasError := true;
                exit(false);
            end;

        end;

        exit(false);
    end;
    */

    procedure UpdateHeaderErrorState(var StagingHeader: Record "Staging VF Task Header"; ProcessRemarks: Text[150])
    begin
        // YF 10 Mar 2022 // Bypass for valid tracking id exits
        if (StagingHeader."VF Task ID" <> 0) And (ProcessRemarks = 'Tracking ID exists in VF') then begin
            StagingHeader.Created := true;
            StagingHeader.Error := false;
            StagingHeader."Process Remarks" := '';
        end
        else begin
            StagingHeader.Error := true;
            StagingHeader."Process Remarks" := ProcessRemarks;
        end;

        // YF 10 Mar 2022 // Bypass for valid tracking id exits

        StagingHeader.Modify(false);
    end;


    // GetJsonValue is use to get the value format and helpful to convert in any data type 
    procedure GetJsonValue(var json_Object: JsonObject; Property: Text; var json_Value: JsonValue): Boolean
    var
        json_Token: JsonToken;
    begin
        if not json_Object.Get(Property, json_Token) then
            exit;
        json_Value := json_Token.AsValue();
        exit(true);
    end;

    // Work for Text Response
    procedure GetJsonValueAsText(var json_Object: JsonObject; Property: Text) Value: Text
    var
        json_Value: JsonValue;
    begin
        if not GetJsonValue(json_Object, Property, json_Value) then
            exit;

        // YF 10 Jun 2022
        if json_Value.IsNull then
            Value := ''
        else
            Value := json_Value.AsText;
        // YF 10 Jun 2022
    end;

    procedure GetJsonValueAsBoolean(var json_Object: JsonObject; Property: Text) Value: Boolean
    var
        json_Value: JsonValue;
    begin
        if not GetJsonValue(json_Object, Property, json_Value) then
            exit;
        Value := json_Value.AsBoolean();
    end;

    procedure GetJsonValueAsInteger(var json_Object: JsonObject; Property: Text) Value: Integer
    var
        json_Value: JsonValue;
    begin
        if not GetJsonValue(json_Object, Property, json_Value) then
            exit;
        Value := json_Value.AsInteger();
    end;

    procedure GetJsonValueAsDecimal(var json_Object: JsonObject; Property: Text) Value: Decimal
    var
        json_Value: JsonValue;
    begin
        if not GetJsonValue(json_Object, Property, json_Value) then
            exit;
        Value := json_Value.AsDecimal();
    end;

    procedure GetJsonToken(json_Object: JsonObject; tokenKey: Text) json_Token: JsonToken;
    begin
        if not json_Object.Get(tokenKey, json_Token) then
            Error('Token not found with key %1', tokenKey);
    end;

    // YF 08 Mar 2022
    local procedure ReplaceString(String: Text; FindWhat: Text; ReplaceWith: Text) NewString: Text
    var
        FindPos: Integer;
    begin
        FindPos := STRPOS(String, FindWhat);
        WHILE FindPos > 0 DO BEGIN
            NewString += DELSTR(String, FindPos) + ReplaceWith;
            String := COPYSTR(String, FindPos + STRLEN(FindWhat));
            FindPos := STRPOS(String, FindWhat);
        END;
        NewString += String;
    end;

    local procedure ClearSpecialCharacters(InputText: Text) OutputText: Text
    var
        RemoveChar: Char;
    begin
        /*
        RemoveChar := '-';
        OutputText := DelChr(InputText, '=', RemoveChar);
        RemoveChar := ',';
        OutputText := DelChr(OutputText, '=', RemoveChar);
        RemoveChar := ' ';
        OutputText := DelChr(OutputText, '=', RemoveChar);
        */
        RemoveChar := 13;
        OutputText := DelChr(InputText, '=', RemoveChar);
        RemoveChar := 10;
        OutputText := DelChr(InputText, '=', RemoveChar);

    end;

    local procedure SanitizeJSONText(InputText: Text) OutputText: Text
    var
        CRLF: Text;
        CharCR: Char;
        CharLF: Char;
        CR: Text;
        LF: Text;
    begin
        CharCR := 13;
        CharLF := 10;
        CRLF := FORMAT(CharCR) + FORMAT(CharLF);
        CR := Format(CharCR);
        LF := Format(CharLF);

        OutputText := InputText;

        OutputText := ReplaceString(OutputText, '\', '/');
        OutputText := ReplaceString(OutputText, '"', ' ');

        /*
            Form feed is replaced with \f
            Newline is replaced with \n
            Carriage return is replaced with \r
        */

        // OutputText := ReplaceString(OutputText, CR, '\r');
        // OutputText := ReplaceString(OutputText, LF, '\n');

        OutputText := ReplaceString(OutputText, CR, ' ');
        OutputText := ReplaceString(OutputText, LF, ' ');

        OutputText := ClearSpecialCharacters(OutputText);
    end;
    // YF 08 Mar 2022

    // YF 09 Mar 2022
    // procedure CreateNewTaskForJobV2(var StagingID: Integer; var JobID: Integer; var TaskIDParameter: Integer; var ProcessMessages: Text[150]; var HasError: Boolean): Boolean; // YF 14 Sep 2022
    procedure CreateNewTaskForJobV2(var StagingID: Integer; var JobID: Integer; var TaskIDParameter: Integer; var ProcessMessages: Text[150]; var VResponseText: Text; var HasError: Boolean): Boolean; // YF 14 Sep 2022
    var
        VersaFleetSetup: Record "VersaFleet Integration Setup";
        APIAddress: Text[500];
        TaskId: Integer;
        TaskGUID: Text;
        TaskState: Text;

        ItemJsonArray: JsonArray;
        ItemJsonObj: JsonObject;
        ItemJsonToken: JsonToken;
        ItemJsonChildToken: JsonToken;
        ItemId: Integer;
        ItemCode: Code[20];

        PostDateText: Text[30];
        TaskJsonObj: JsonObject;
        TaskJsonToken: JsonToken;

        VFStagingHeaderRec: Record "Staging VF Task Header";
        VFStagingHeaderModRec: Record "Staging VF Task Header"; // YF 13 Jun 2022
        VFStagingLineRec: Record "Staging VF Task Line";
        TotalTaskItemLines: Integer;
        CountTaskItemLines: Integer;
        BaseTimeFromText: Text;
        BaseTimeToText: Text;

        TempProcessMsg: Text[150];
        TempHasError: Boolean;

        VTextBuilder: TextBuilder;
        VResponseHTTPContent: HttpContent; // YF 15 Mar 2022
        VResponseInStream: InStream;

        // YF 21 Feb 2023
        PSIRec: Record "Sales Invoice Header";
        CustRec: Record Customer;
        WorkingHours: Text;
    // YF 21 Feb 2023

    begin
        // https://api.versafleet.co/api/customers?client_id=<clientid>&client_secret=<clientkey>

        TotalTaskItemLines := 0;
        CountTaskItemLines := 0;

        ClearObjects();
        if Not VersaFleetSetup.Get then begin
            ProcessMessages := 'Integration Setup not done';
            HasError := true;
            exit(false);
        end;

        if StagingID = 0 then begin
            ProcessMessages := 'Invalid Staging Entry No. Parameter';
            HasError := true;
            exit(false);
        end
        else begin
            VFStagingHeaderRec.Reset;
            if Not VFStagingHeaderRec.Get(StagingID) then begin
                ProcessMessages := 'Staging Header Record not found';
                HasError := true;
                exit(false);
            end
            else begin
                PostDateText := Format(VFStagingHeaderRec."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>');
                BaseTimeFromText := PostDateText + 'T00:00:00.000+08:00';
                BaseTimeToText := PostDateText + 'T23:59:59.999+08:00';

                VFStagingLineRec.Reset;
                VFStagingLineRec.SetRange("Parent Entry No.", VFStagingHeaderRec."Entry No.");
                TotalTaskItemLines := VFStagingLineRec.Count;
            end;
        end;

        // Check if tracking number exists in Versafleet (because of potential silent failure)
        if CheckVFTrackingIDExists(VFStagingHeaderRec."Tracking ID", TempProcessMsg, TempHasError, TaskIDParameter) then begin // YF 13 Jun 2022
            ProcessMessages := 'Tracking ID exists in VF';
            HasError := true;
            exit(false);
        end
        else begin
            if TempHasError then begin
                ProcessMessages := TempProcessMsg;
                HasError := TempHasError;
                exit(false);
            end;
        end;

        APIAddress := VersaFleetSetup."API Parent URL" + 'tasks'
                        + '?client_id=' + VersaFleetSetup."Client ID"
                        + '&client_secret=' + VersaFleetSetup."Client Secret";

        VTextBuilder.Clear();
        VTextBuilder.Append('{');
        VTextBuilder.Append('    "task_attributes": {');
        VTextBuilder.Append('        "job_id": ' + Format(JobID, 0, 1) + ',');
        VTextBuilder.Append('        "price": ' + Format(VFStagingHeaderRec."Total Price", 0, 1) + ',');
        VTextBuilder.Append('        "invoice_number": "' + VFStagingHeaderRec."Sales Invoice No." + '",');
        VTextBuilder.Append('        "tracking_id": "' + VFStagingHeaderRec."Tracking ID" + '",');
        VTextBuilder.Append('        "time_from": "' + PostDateText + 'T00:00:00.000+08:00' + '",');
        VTextBuilder.Append('        "time_to": "' + PostDateText + 'T23:59:59.999+08:00' + '",');
        VTextBuilder.Append('        "time_type": "all_day",');
        VTextBuilder.Append('        "time_window_id": null,');
        VTextBuilder.Append('        "expected_cod": 0,');
        VTextBuilder.Append('        "remarks": "' + SanitizeJSONText(VFStagingHeaderRec.Remarks) + '",');
        VTextBuilder.Append('        "service_time": ' + Format(VersaFleetSetup."Default Task Service Time", 0, 1) + ',');
        VTextBuilder.Append('        "address_attributes": {');
        VTextBuilder.Append('            "name": "' + VFStagingHeaderRec."Delivery Address Name" + '",');
        VTextBuilder.Append('            "zip": "' + VFStagingHeaderRec."Delivery Address Zip" + '",');
        VTextBuilder.Append('            "line_1": "' + VFStagingHeaderRec."Delivery Address Line 1" + '",');
        VTextBuilder.Append('            "line_2": "' + VFStagingHeaderRec."Delivery Address Line 2" + '",');
        VTextBuilder.Append('            "country": "' + VFStagingHeaderRec."Delivery Address Country" + '",');
        VTextBuilder.Append('            "city": "' + VFStagingHeaderRec."Delivery Address City" + '",');
        VTextBuilder.Append('            "email": "' + VFStagingHeaderRec."Delivery Address Email" + '",');
        VTextBuilder.Append('            "contact_person": "' + VFStagingHeaderRec."Delivery Address Contact Name" + '",');
        VTextBuilder.Append('            "contact_number": "' + VFStagingHeaderRec."Delivery Address Contact No." + '" ');
        VTextBuilder.Append('        },');
        VTextBuilder.Append('        "measurements_attributes": [');

        VFStagingLineRec.Reset;
        VFStagingLineRec.SetRange("Parent Entry No.", VFStagingHeaderRec."Entry No.");
        if VFStagingLineRec.FindSet() then
            repeat

                VTextBuilder.Append('            {');
                VTextBuilder.Append('                "quantity": ' + Format(VFStagingLineRec.Qty, 0, 1) + ',');
                VTextBuilder.Append('                "quantity_unit": "' + VFStagingLineRec.UOM + '",');
                VTextBuilder.Append('                "description": "' + SanitizeJSONText(VFStagingLineRec."Item Description") + '",');
                VTextBuilder.Append('                "custom_item_id": "' + VFStagingLineRec."Item No." + '",');
                VTextBuilder.Append('                "custom_item_check_method": "' + Format(VersaFleetSetup."Item Check Method") + '",');
                VTextBuilder.Append('                "custom_item_unload_check_method": "' + Format(VersaFleetSetup."Item Unload Check Method") + '" ');

                CountTaskItemLines += 1;

                if CountTaskItemLines = TotalTaskItemLines then
                    VTextBuilder.Append('            }')
                else
                    VTextBuilder.Append('            },');

            until VFStagingLineRec.Next() = 0;

        VTextBuilder.Append('        ],');

        // YF 27 Jun 2022
        VTextBuilder.Append('        "custom_field_group_id": ' + Format(VersaFleetSetup."Delivery Charge Field Group ID") + ',');
        VTextBuilder.Append('        "custom_fields_attributes": [');
        VTextBuilder.Append('        {');
        VTextBuilder.Append('            "custom_field_description_id": ' + Format(VersaFleetSetup."Delivery Charge Field Descr ID") + ',');
        VTextBuilder.Append('            "value": "' + VFStagingHeaderRec."Source Delivery Charge" + '" ');
        // YF 21 Feb 2023
        VTextBuilder.Append('        },');
        VTextBuilder.Append('        {');
        VTextBuilder.Append('            "custom_field_description_id": ' + Format(VersaFleetSetup."Operating Hours Field Descr ID") + ',');

        WorkingHours := '';
        PSIRec.Reset;
        PSIRec.SetCurrentKey("No.");
        PSIRec.SetLoadFields("No.", "Sell-to Customer No.");
        PSIRec.SetRange("No.", VFStagingHeaderRec."Sales Invoice No.");
        if PSIRec.FindFirst() then begin
            CustRec.Reset;
            CustRec.SetLoadFields("No.", "Working Hours");
            CustRec.SetRange("No.", PSIRec."Sell-to Customer No.");
            if CustRec.FindFirst() then
                WorkingHours := SanitizeJSONText(CustRec."Working Hours");
        end;

        VTextBuilder.Append('            "value": "' + WorkingHours + '" ');
        // YF 21 Feb 2023
        VTextBuilder.Append('        }');
        VTextBuilder.Append('        ],');
        // YF 27 Jun 2022

        VTextBuilder.Append('        "tag_list": [');
        VTextBuilder.Append('            "' + VFStagingHeaderRec."Driver Tag" + '",');
        VTextBuilder.Append('            "' + VFStagingHeaderRec."Vehicle Tag" + '" ');
        VTextBuilder.Append('        ],');
        VTextBuilder.Append('        "driver_skill_list": [');
        VTextBuilder.Append('            "' + VFStagingHeaderRec."Driver Tag" + '" ');
        VTextBuilder.Append('        ]');

        VTextBuilder.Append('    }');
        VTextBuilder.Append('}');

        // _httpContent.WriteFrom(apiRequestQuery); // add the payload
        _httpContent.WriteFrom(VTextBuilder.ToText()); // add the payload
        _httpContent.GetHeaders(contentHeaders); // retrieve content headers associated with content
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/json');

        // Request.Content := _httpContent;
        // Request.SetRequestUri(APIAddress);
        // Request.Method := 'POST';

        // Error('apirequest ' + VTextBuilder.ToText());

        if Not Client.Post(APIAddress, _httpContent, Response) then begin
            ProcessMessages := '3 API call failed to send';
            HasError := true;
            exit(false);
        end;

        If Not Response.IsSuccessStatusCode() then begin
            ProcessMessages := '3V2 Web service returned error: ' + 'Status code: ' + Format(Response.HttpStatusCode()) + ' ' + 'Description: ' + Format(Response.ReasonPhrase());
            HasError := true;

            // YF 14 Sep 2022
            VResponseText := '';
            if VersaFleetSetup."Debug Mode" then begin
                // Capture Error Response Message up to 2048 characters

                VResponseHTTPContent.Clear();
                Clear(VResponseInStream);
                VResponseHTTPContent := Response.Content;
                if VResponseHTTPContent.ReadAs(VResponseText) then begin
                    VResponseText := CopyStr(VResponseText, 1, 2048);
                end
                else
                    VResponseText := 'Response Text Stream Error';
            end;
            // YF 14 Sep 2022

            exit(false);
            /*
            Message('Web service returned error:\\' +
                'Status code: %1\' +
                'Description: %2',
                Response.HttpStatusCode(),
                Response.ReasonPhrase());
            */
        end
        else begin

            // YF 15 Mar 2022
            VResponseHTTPContent.Clear();
            Clear(VResponseInStream);
            VResponseHTTPContent := Response.Content;
            Clear(_jsonToken);

            if VResponseHTTPContent.ReadAs(VResponseInStream) then begin
                if _jsonToken.ReadFrom(VResponseInStream) then begin
                    if _jsonToken.IsObject then begin
                        jsonObj := _jsonToken.AsObject();
                        if jsonObj.Get('task', TaskJsonToken) then begin
                            if TaskJsonToken.IsObject then begin
                                TaskJsonObj := TaskJsonToken.AsObject();
                                TaskId := GetJsonValueAsInteger(TaskJsonObj, 'id');
                                TaskIDParameter := TaskId;
                                TaskGUID := GetJsonValueAsText(TaskJsonObj, 'guid'); // Task GUID
                                TaskState := GetJsonValueAsText(TaskJsonObj, 'state'); // Task State

                                // YF 13 Jun 2022
                                /*
                                VFStagingHeaderModRec.Reset;
                                VFStagingHeaderModRec.SetRange("Entry No.", StagingID);
                                VFStagingHeaderModRec.SetRange("VF Task ID", 0);
                                if VFStagingHeaderModRec.FindFirst() then begin
                                    VFStagingHeaderModRec."VF Task ID" := TaskId;
                                    VFStagingHeaderModRec."VF Task GUID" := TaskGUID;
                                    // VFStagingHeaderModRec."VF Task State" := TaskState;
                                    VFStagingHeaderModRec.Modify();
                                end;
                                */
                                // YF 13 Jun 2022    

                                // required to update 
                                // 1. line id
                                // 2. line task id

                                if TaskJsonObj.Get('measurements', ItemJsonToken) then begin
                                    if ItemJsonToken.IsArray then begin
                                        ItemJsonArray := ItemJsonToken.AsArray();
                                        foreach ItemJsonChildToken in ItemJsonArray do begin
                                            if ItemJsonChildToken.IsObject then begin
                                                ItemJsonObj := ItemJsonChildToken.AsObject();
                                                ItemId := GetJsonValueAsInteger(ItemJsonObj, 'id');
                                                ItemCode := GetJsonValueAsText(ItemJsonObj, 'custom_item_id');

                                                // update line staging records
                                                VFStagingLineRec.Reset;
                                                VFStagingLineRec.SetRange("Parent Entry No.", StagingID);
                                                VFStagingLineRec.SetRange("Item No.", ItemCode);
                                                if VFStagingLineRec.FindFirst() then begin
                                                    VFStagingLineRec."VF Task ID" := TaskId;
                                                    VFStagingLineRec."VF Task Item ID" := ItemId;
                                                    VFStagingLineRec.Modify();
                                                end;
                                            end;
                                        end;
                                    end;
                                end;

                            end;
                        end;
                    end;

                    if TaskId = 0 then begin
                        ProcessMessages := 'No Task Found';
                        HasError := false;
                        exit(false);
                    end
                    else begin
                        // ProcessMessages := 'Jobs Found ' + Format(DeliveryJobId);
                        TaskIDParameter := TaskId;
                        ProcessMessages := '';
                        HasError := false;
                        exit(true);
                    end;
                end
                else begin
                    ProcessMessages := 'Json token instream failed';
                    HasError := false;
                    exit(false);
                end;
            end
            else begin
                ProcessMessages := 'Http response message instream failed';
                HasError := false;
                exit(false);
            end;

            /*
            Response.Content().ReadAs(ResponseText); // Read response content as json             

            if StrLen(ResponseText) > 0 then begin

                _jsonToken.ReadFrom(ResponseText);

                if _jsonToken.IsObject then begin
                    jsonObj := _jsonToken.AsObject();
                    if jsonObj.Get('task', TaskJsonToken) then begin
                        if TaskJsonToken.IsObject then begin
                            TaskJsonObj := TaskJsonToken.AsObject();
                            TaskId := GetJsonValueAsInteger(TaskJsonObj, 'id');
                            TaskIDParameter := TaskId;
                            TaskGUID := GetJsonValueAsText(TaskJsonObj, 'guid'); // Task GUID
                            TaskState := GetJsonValueAsText(TaskJsonObj, 'state'); // Task State

                            // required to update 
                            // 1. line id
                            // 2. line task id

                            if TaskJsonObj.Get('measurements', ItemJsonToken) then begin
                                if ItemJsonToken.IsArray then begin
                                    ItemJsonArray := ItemJsonToken.AsArray();
                                    foreach ItemJsonChildToken in ItemJsonArray do begin
                                        if ItemJsonChildToken.IsObject then begin
                                            ItemJsonObj := ItemJsonChildToken.AsObject();
                                            ItemId := GetJsonValueAsInteger(ItemJsonObj, 'id');
                                            ItemCode := GetJsonValueAsText(ItemJsonObj, 'custom_item_id');

                                            // update line staging records
                                            VFStagingLineRec.Reset;
                                            VFStagingLineRec.SetRange("Parent Entry No.", StagingID);
                                            VFStagingLineRec.SetRange("Item No.", ItemCode);
                                            if VFStagingLineRec.FindFirst() then begin
                                                VFStagingLineRec."VF Task ID" := TaskId;
                                                VFStagingLineRec."VF Task Item ID" := ItemId;
                                                VFStagingLineRec.Modify();
                                            end;
                                        end;
                                    end;
                                end;
                            end;

                        end;
                    end;
                end;

                if TaskId = 0 then begin
                    ProcessMessages := 'No Task Found';
                    HasError := false;
                    exit(false);
                end
                else begin
                    // ProcessMessages := 'Jobs Found ' + Format(DeliveryJobId);
                    TaskIDParameter := TaskId;
                    ProcessMessages := '';
                    HasError := false;
                    exit(true);
                end;
            end
            else begin
                ProcessMessages := 'Empty response string';
                HasError := true;
                exit(false);
            end;
            */
            // YF 15 Mar 2022

        end;

        exit(false);
    end;
    // YF 09 Mar 2022

    // YF 20 Jun 2022
    procedure GetTaskDataForDeliveryStatus(var TaskID: Integer; var VFStageHeader: Record "Staging VF Task Header"; var ProcessMessages: Text[150]; var HasError: Boolean): Boolean;
    var
        VersaFleetSetup: Record "VersaFleet Integration Setup";
        APIAddress: Text[500];

        TaskJsonToken: JsonToken;
        TaskJsonObj: JsonObject;
        TaskState: Text;
        TaskPartialSuccess: Boolean;
        TaskLatestFailReason: Text;
        TaskDriverNotes: Text;
        TaskDriverTag: Text;
        TaskDeliveredDateText: Text;
        TaskDeliveredDate: Date;
        TaskDeliveredDay: Integer;
        TaskDeliveredMonth: Integer;
        TaskDeliveredYear: Integer;

        TagJsonToken: JsonToken;
        TagJsonArray: JsonArray;
        TagJsonChildToken: JsonToken;
        TagJsonChildObj: JsonObject;

        // YF 27 Jun 2022
        CustomFieldsJsonToken: JsonToken;
        CustomFieldsJsonArray: JsonArray;
        CustomFieldsJsonChildToken: JsonToken;
        CustomFieldsJsonChildObj: JsonObject;
        CustomFieldsDescrID: Integer;
        CustomFieldsValue: Text;
        // YF 27 Jun 2022

        VFStagingLineRec: Record "Staging VF Task Line";
        SalesInvHdrRec: Record "Sales Invoice Header";
        SalesInvLineRec: Record "Sales Invoice Line";
        // KP 18 Oct 2023
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        // KP 18 Oct 2023

        // YF 03 Nov 2022
        TaskAssignmentJsonObj: JsonObject;
        // YF 03 Nov 2022

        TaskURL: Text;
        RecordLink: Record "Record Link";
        CustLedgerEntry: Record "Cust. Ledger Entry";

        LineNo: Integer;
        OrderQty: Decimal;
        FOCQty: Decimal;

        CountStagingLines: Integer; // YF 16 Jul 2024
        CountReturnLines: Integer; // YF 16 Jul 2024
        LineInvDiscPct: Decimal; // YF 16 Jul 2024
        InvDiscValue: Decimal; // YF 16 Jul 2024
        HasPartialReturn: Boolean; // YF 16 Jul 2024
    begin
        ClearObjects();



        if Not VersaFleetSetup.Get then begin
            ProcessMessages := 'Integration Setup not done';
            HasError := true;
            exit(false);
        end;

        APIAddress := VersaFleetSetup."API Parent URL" + 'tasks/' + Format(TaskID, 0, 1)
                        + '?client_id=' + VersaFleetSetup."Client ID"
                        + '&client_secret=' + VersaFleetSetup."Client Secret";

        if Not Client.Get(APIAddress, Response) then begin
            ProcessMessages := '6 API call failed to send';
            HasError := true;
            exit(false);
        end;

        If Not Response.IsSuccessStatusCode() then begin
            ProcessMessages := '6 Web service returned error: ' + 'Status code: ' + Format(Response.HttpStatusCode()) + ' ' + 'Description: ' + Format(Response.ReasonPhrase());
            HasError := true;
            exit(false);
        end
        else begin
            Response.Content().ReadAs(ResponseText); // Read response content as json

            if StrLen(ResponseText) > 0 then begin
                _jsonToken.ReadFrom(ResponseText);
                if _jsonToken.IsObject then begin
                    jsonObj := _jsonToken.AsObject();
                    if jsonObj.Get('task', TaskJsonToken) then begin
                        if TaskJsonToken.IsObject then begin
                            TaskJsonObj := TaskJsonToken.AsObject();
                            TaskId := GetJsonValueAsInteger(TaskJsonObj, 'id');
                            TaskState := GetJsonValueAsText(TaskJsonObj, 'state'); // Task State
                            TaskPartialSuccess := GetJsonValueAsBoolean(TaskJsonObj, 'is_partial_success');
                            TaskLatestFailReason := GetJsonValueAsText(TaskJsonObj, 'latest_failure_reason');
                            ; // use Task API and field VF Task State Updated if required
                            TaskDriverNotes := GetJsonValueAsText(TaskJsonObj, 'remarks');
                            TaskDeliveredDateText := GetJsonValueAsText(TaskJsonObj, 'last_completion_history_created_at');
                            TaskURL := GetJsonValueAsText(TaskJsonObj, 'epod_url');

                            TaskDeliveredDate := 0D;
                            TaskDeliveredDay := 0;
                            TaskDeliveredMonth := 0;
                            TaskDeliveredYear := 0;

                            if StrLen(TaskDeliveredDateText) > 10 then begin
                                if evaluate(TaskDeliveredDay, copystr(TaskDeliveredDateText, 9, 2)) then;
                                if evaluate(TaskDeliveredMonth, copystr(TaskDeliveredDateText, 6, 2)) then;
                                if evaluate(TaskDeliveredYear, copystr(TaskDeliveredDateText, 1, 4)) then;
                            end;

                            if (TaskDeliveredDay <> 0) And (TaskDeliveredMonth <> 0) And (TaskDeliveredYear <> 0) then
                                TaskDeliveredDate := DMY2Date(TaskDeliveredDay, TaskDeliveredMonth, TaskDeliveredYear);

                            // YF 27 Jun 2022
                            // Get Custom Fields Info
                            if TaskJsonObj.Get('custom_fields', CustomFieldsJsonToken) then begin
                                if CustomFieldsJsonToken.IsArray then begin
                                    CustomFieldsJsonArray := CustomFieldsJsonToken.AsArray();
                                    foreach CustomFieldsJsonChildToken in CustomFieldsJsonArray do begin
                                        if CustomFieldsJsonChildToken.IsObject then begin
                                            CustomFieldsJsonChildObj := CustomFieldsJsonChildToken.AsObject();
                                            CustomFieldsDescrID := GetJsonValueAsInteger(CustomFieldsJsonChildObj, 'custom_field_description_id');
                                            if CustomFieldsDescrID = VersaFleetSetup."Delivery Charge Field Descr ID" then
                                                CustomFieldsValue += GetJsonValueAsText(CustomFieldsJsonChildObj, 'value') + ' ';
                                        end;
                                    end;
                                end;
                            end;

                            CustomFieldsValue := CustomFieldsValue.Trim();
                            // YF 27 Jun 2022

                            // YF 03 Nov 2022
                            // Get Driver Tag Info
                            /*
                            if TaskJsonObj.Get('tags', TagJsonToken) then begin
                                if TagJsonToken.IsArray then begin
                                    TagJsonArray := TagJsonToken.AsArray();
                                    foreach TagJsonChildToken in TagJsonArray do begin
                                        if TagJsonChildToken.IsObject then begin
                                            TagJsonChildObj := TagJsonChildToken.AsObject();
                                            TaskDriverTag += GetJsonValueAsText(TagJsonChildObj, 'name') + ' ';
                                        end;
                                    end;
                                end;
                            end;
                            */

                            // Get Delivered Driver Tag Name
                            if TaskJsonObj.Get('task_assignment', TagJsonToken) then begin
                                if TagJsonToken.IsObject then begin
                                    TaskAssignmentJsonObj := TagJsonToken.AsObject();
                                    if TaskAssignmentJsonObj.Get('driver', TagJsonChildToken) then begin
                                        if TagJsonChildToken.IsObject then begin
                                            TagJsonChildObj := TagJsonChildToken.AsObject();
                                            TaskDriverTag += GetJsonValueAsText(TagJsonChildObj, 'name') + ' ';
                                        end;
                                    end;
                                end;
                            end;
                            // YF 03 Nov 2022

                            TaskDriverTag := TaskDriverTag.Trim();

                            // update header records
                            VFStageHeader."VF Task State" := TaskState;
                            VFStageHeader."VF Is Partial Success" := TaskPartialSuccess;
                            VFStageHeader."Delivered Remarks" := TaskDriverNotes;
                            VFStageHeader."Delivered Driver Tag" := TaskDriverTag;
                            VFStageHeader."Delivered Date Text" := TaskDeliveredDateText;
                            VFStageHeader."Delivered Date" := TaskDeliveredDate;
                            VFStageHeader."Latest Failure Reason" := TaskLatestFailReason;
                            // VFStageHeader."VF Driver Notes" := TaskDriverNotes;
                            VFStageHeader."Delivered Delivery Charge" := CustomFieldsValue; // YF 27 Jun 2022

                            // YF 05 Dec 2022
                            VFStageHeader."VF Task State Type" := VFStageHeader."VF Task State Type"::" ";

                            if TaskState = 'unassigned' then
                                VFStageHeader."VF Task State Type" := VFStageHeader."VF Task State Type"::unassigned;

                            if TaskState = 'assigned' then
                                VFStageHeader."VF Task State Type" := VFStageHeader."VF Task State Type"::assigned;

                            if TaskState = 'acknowledged' then
                                VFStageHeader."VF Task State Type" := VFStageHeader."VF Task State Type"::acknowledged;

                            if TaskState = 'started' then
                                VFStageHeader."VF Task State Type" := VFStageHeader."VF Task State Type"::started;

                            if TaskState = 'collected' then
                                VFStageHeader."VF Task State Type" := VFStageHeader."VF Task State Type"::collected;

                            if TaskState = 'arrived' then
                                VFStageHeader."VF Task State Type" := VFStageHeader."VF Task State Type"::arrived;

                            if TaskState = 'successful' then
                                VFStageHeader."VF Task State Type" := VFStageHeader."VF Task State Type"::successful;
                            // YF 05 Dec 2022

                            // KP 18 Oct 2023
                            UpdateDeliveredQuantity(TaskID, ProcessMessages, HasError);

                            if VFStageHeader."Source Document Type" = VFStageHeader."Source Document Type"::"Posted Sales Invoice" then begin
                                if VFStageHeader."Return Order Created" = false then begin

                                    // YF 16 Jul 2024
                                    HasPartialReturn := false;

                                    VFStagingLineRec.Reset();
                                    VFStagingLineRec.SetRange("Parent Entry No.", VFStageHeader."Entry No.");
                                    VFStagingLineRec.SetFilter(Qty, '<> 0'); // YF 05 Aug 2024
                                    CountStagingLines := VFStagingLineRec.Count;


                                    VFStagingLineRec.Reset();
                                    VFStagingLineRec.SetRange("Parent Entry No.", VFStageHeader."Entry No.");
                                    VFStagingLineRec.SetFilter("Qty. Returned", '<> 0');
                                    if VFStagingLineRec.FindSet() then
                                        repeat
                                            CountReturnLines := CountReturnLines + 1;

                                            if VFStagingLineRec.Qty <> VFStagingLineRec."Qty. Returned" then
                                                HasPartialReturn := true;

                                        until VFStagingLineRec.Next() = 0;
                                    // YF 16 Jul 2024

                                    VFStagingLineRec.Reset();
                                    VFStagingLineRec.SetRange("Parent Entry No.", VFStageHeader."Entry No.");
                                    VFStagingLineRec.SetFilter("Qty. Returned", '<> 0');

                                    if VFStagingLineRec.FindSet() then begin

                                        SalesInvHdrRec.Reset();
                                        SalesInvHdrRec.SetFilter("No.", '<>%1', 'LSINV*');
                                        if SalesInvHdrRec.Get(VFStageHeader."Sales Invoice No.") then begin
                                            Clear(SalesHeader);
                                            SalesHeader.Validate("Document Type", SalesHeader."Document Type"::"Return Order");
                                            SalesHeader."No." := '';
                                            SalesHeader.Insert(true);

                                            SalesHeader.Validate("Sell-to Customer No.", SalesInvHdrRec."Sell-to Customer No.");
                                            SalesHeader.Validate("Posting Date", SalesInvHdrRec."Posting Date");
                                            SalesHeader.Validate("Bill-to Customer No.", SalesInvHdrRec."Bill-to Customer No.");
                                            // SalesHeader.Validate("Applies-to Doc. No.", SalesInvHdrRec."Your Reference");
                                            SalesHeader.Validate("Your Reference", SalesInvHdrRec."No."); //RL 20231116 - change field to insert value
                                            SalesHeader.Modify(true);

                                            LineNo := 10000;

                                            repeat
                                                SalesInvLineRec.Reset();

                                                Clear(SalesLine);

                                                LineInvDiscPct := 0; // YF 16 Jul 2024
                                                InvDiscValue := 0; // YF 16 Jul 2024

                                                SalesLine.Validate("Document Type", SalesHeader."Document Type");
                                                SalesLine.Validate("Document No.", SalesHeader."No.");
                                                SalesLine.Validate("Line No.", LineNo);
                                                SalesLine.Insert(true);

                                                SalesLine.Validate(Type, SalesLine.Type::Item);
                                                SalesLine.Validate("No.", VFStagingLineRec."Item No.");
                                                SalesLine.Validate(Quantity, VFStagingLineRec."Qty. Returned");
                                                SalesLine.Validate("Unit of Measure Code", VFStagingLineRec.UOM);//LK24Sept2024 move to before insert price ++

                                                if SalesInvLineRec.Get(VFStagingLineRec."Sales Invoice No.", VFStagingLineRec."Sales Invoice Line No.") then begin
                                                    if VFStagingLineRec."Qty. Returned" <= SalesInvLineRec."Order Qty" then
                                                        SalesLine.Validate("Order Qty", VFStagingLineRec."Qty. Returned")
                                                    else begin
                                                        SalesLine.Validate("Order Qty", SalesInvLineRec."Order Qty");
                                                        SalesLine.Validate("FOC Qty", VFStagingLineRec."Qty. Returned" - SalesInvLineRec."Order Qty");
                                                    end;

                                                    SalesLine.Validate("Unit Price", SalesInvLineRec."Unit Price");
                                                    SalesLine.Validate("Selling Price", SalesInvLineRec."Selling Price");

                                                    LineInvDiscPct := SalesInvLineRec."Line Discount %"; // YF 16 Jul 2024
                                                    InvDiscValue := SalesInvLineRec."Inv. Discount Amount"; // YF 16 Jul 2024

                                                end else begin
                                                    SalesLine.Validate("Order Qty", VFStagingLineRec."Qty. Returned");
                                                end;

                                                //SalesLine.Validate("Unit of Measure Code", VFStagingLineRec.UOM);//LK24Sept2024 move to before insert price --
                                                SalesLine.Validate("I9G Driver Reason", VFStagingLineRec."VF Driver Reason");
                                                // SalesLine.Validate("Line Discount Amount", VFStagingLineRec."Line Discount Amount"); //PK020424 // YF 16 Jul 2024
                                                // SalesLine.Validate("Inv. Discount Amount", VFStagingLineRec."Inv. Discount Amount"); //PK020424 // YF 16 Jul 2024

                                                // YF 16 Jul 2024
                                                SalesLine.Validate("Line Discount %", LineInvDiscPct);
                                                if (CountStagingLines = CountReturnLines) And not HasPartialReturn then
                                                    SalesLine.Validate("Inv. Discount Amount", InvDiscValue);
                                                // YF 16 Jul 2024

                                                SalesLine.Modify(true);

                                                LineNo := LineNo + 10000;

                                            until VFStagingLineRec.Next() = 0;

                                            // YF 16 Jul 2024
                                            if (CountStagingLines = CountReturnLines) And not HasPartialReturn then begin
                                                SalesHeader.Validate("Invoice Discount Value", SalesInvHdrRec."Invoice Discount Value");
                                                SalesHeader.Modify(true);
                                            end;
                                            // YF 16 Jul 2024

                                            VFStageHeader."Return Order No." := SalesHeader."No.";
                                            VFStageHeader."Return Order Created" := true;
                                        end;
                                    end;
                                end;
                            end;
                            //KP 18 Oct 2023

                            VFStageHeader.Modify();

                            // if collected change to delivery in progress
                            // if successful change to completed
                            if SalesInvHdrRec.Get(VFStageHeader."Sales Invoice No.") then begin
                                if TaskState = 'collected' then
                                    SalesInvHdrRec."Order Status" := SalesInvHdrRec."Order Status"::"Delivery In Progress";

                                if TaskState = 'successful' then
                                    SalesInvHdrRec."Order Status" := SalesInvHdrRec."Order Status"::Completed;

                                SalesInvHdrRec.Modify(false);

                                if TaskURL <> '' then begin
                                    RecordLink.Reset();
                                    RecordLink.SetRange("Record ID", SalesInvHdrRec.RecordId);
                                    if RecordLink.FindFirst() then begin
                                        RecordLink.URL1 := TaskURL;
                                        RecordLink.Description := 'Proof Of Delivery';
                                        RecordLink.Modify();
                                    end else begin
                                        LastLinkID := 0;
                                        GetLastLinkID();

                                        LastLinkID += 1;
                                        RecordLink.Init();
                                        RecordLink."Link ID" := LastLinkID;
                                        RecordLink.Company := CompanyName;
                                        RecordLink.Type := RecordLink.Type::Link;
                                        RecordLink.Created := CurrentDateTime;
                                        RecordLink."User ID" := UserId;
                                        RecordLink."Record ID" := SalesInvHdrRec.RecordId;
                                        RecordLink.URL1 := TaskURL;
                                        RecordLink.Description := 'Proof Of Delivery';
                                        RecordLink.Insert();
                                    end;

                                    CustLedgerEntry.Reset();
                                    CustLedgerEntry.SetCurrentKey("Document Type", "Document No.");
                                    CustLedgerEntry.SetLoadFields("Document Type", "Document No.");
                                    CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Invoice);
                                    CustLedgerEntry.SetRange("Document No.", SalesInvHdrRec."No.");
                                    if CustLedgerEntry.FindFirst() then begin
                                        RecordLink.Reset();
                                        RecordLink.SetRange("Record ID", CustLedgerEntry.RecordId);
                                        if RecordLink.FindFirst() then begin
                                            RecordLink.URL1 := TaskURL;
                                            RecordLink.Description := 'Proof Of Delivery';
                                            RecordLink.Modify();
                                        end else begin
                                            LastLinkID := 0;
                                            GetLastLinkID();

                                            LastLinkID += 1;
                                            RecordLink.Init();
                                            RecordLink."Link ID" := LastLinkID;
                                            RecordLink.Company := CompanyName;
                                            RecordLink.Type := RecordLink.Type::Link;
                                            RecordLink.Created := CurrentDateTime;
                                            RecordLink."User ID" := UserId;
                                            RecordLink."Record ID" := CustLedgerEntry.RecordId;
                                            RecordLink.URL1 := TaskURL;
                                            RecordLink.Description := 'Proof Of Delivery';
                                            RecordLink.Insert();
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;

            end
            else begin
                ProcessMessages := 'Empty response string';
                HasError := true;
                exit(false);
            end;

        end;

        exit(false);


    end;
    // YF 20 Jun 2022

    local procedure UpdateDeliveredQuantity(TaskID: Integer; var ProcessMessages: Text[150]; var HasError: Boolean): Boolean
    var
        VersaFleetSetup: Record "VersaFleet Integration Setup";
        APIAddress: Text[500];

        TCHJsonArray: JsonArray;
        TCHJsonObj: JsonObject;
        TCHJsonToken: JsonToken;
        TCHJsonChildToken: JsonToken;

        LICJsonArray: JsonArray;
        LICJsonObj: JsonObject;
        LICJsonToken: JsonToken;
        LICJsonChildToken: JsonToken;

        LineActualQty: Decimal;
        LineReason: Text;
        LineItemId: Integer;
        LineHistoryId: Integer;

        VFStagingLineRec: Record "Staging VF Task Line";
    begin
        ClearObjects();
        if Not VersaFleetSetup.Get then begin
            ProcessMessages := 'Integration Setup not done';
            HasError := true;
            exit(false);
        end;

        APIAddress := VersaFleetSetup."API Parent URL" + 'tasks/' + Format(TaskID, 0, 1) + '/task_completion_histories'
            + '?client_id=' + VersaFleetSetup."Client ID"
            + '&client_secret=' + VersaFleetSetup."Client Secret";

        if Not Client.Get(APIAddress, Response) then begin
            ProcessMessages := '6 API call failed to send';
            HasError := true;
            exit(false);
        end;

        If Not Response.IsSuccessStatusCode() then begin
            ProcessMessages := '6 Web service returned error: ' + 'Status code: ' + Format(Response.HttpStatusCode()) + ' ' + 'Description: ' + Format(Response.ReasonPhrase());
            HasError := true;
            exit(false);
        end else begin
            Response.Content().ReadAs(ResponseText); // Read response content as json

            if StrLen(ResponseText) > 0 then begin
                _jsonToken.ReadFrom(ResponseText);
                if _jsonToken.IsObject then begin
                    jsonObj := _jsonToken.AsObject();
                    if jsonObj.Get('task_completion_histories', TCHJsonToken) then begin
                        if TCHJsonToken.IsArray then begin
                            TCHJsonArray := TCHJsonToken.AsArray();
                            if TCHJsonArray.Count > 0 then begin
                                if TCHJsonArray.Get(0, TCHJsonChildToken) then begin
                                    if TCHJsonChildToken.IsObject then begin
                                        TCHJsonObj := TCHJsonChildToken.AsObject();

                                        if TCHJsonObj.Get('line_item_completions', LICJsonToken) then begin
                                            if LICJsonToken.IsArray then begin
                                                LICJsonArray := LICJsonToken.AsArray();
                                                foreach LICJsonChildToken in LICJsonArray do begin
                                                    if LICJsonChildToken.IsObject then begin
                                                        LICJsonObj := LICJsonChildToken.AsObject();
                                                        LineItemId := GetJsonValueAsInteger(LICJsonObj, 'measurement_id');
                                                        LineActualQty := GetJsonValueAsDecimal(LICJsonObj, 'actual_quantity');
                                                        LineReason := GetJsonValueAsText(LICJsonObj, 'reason');
                                                        LineHistoryId := GetJsonValueAsInteger(LICJsonObj, 'task_completion_history_id');

                                                        VFStagingLineRec.Reset;
                                                        VFStagingLineRec.SetRange("VF Task ID", TaskID);
                                                        VFStagingLineRec.SetRange("VF Task Item ID", LineItemId);
                                                        if VFStagingLineRec.FindFirst() then begin
                                                            if VFStagingLineRec."VF Task Completion History ID" < LineHistoryId then begin
                                                                VFStagingLineRec."VF Actual Qty Processed" := LineActualQty;
                                                                VFStagingLineRec.Validate("Qty. Delivered", LineActualQty);
                                                                //VFStagingLineRec."Qty. Delivered" := LineActualQty;
                                                                //VFStagingLineRec."Qty. Returned" := VFStagingLineRec.Qty - LineActualQty;
                                                                VFStagingLineRec."VF Driver Reason" := LineReason;
                                                                VFStagingLineRec."VF Task Completion History ID" := LineHistoryId;
                                                                VFStagingLineRec.Modify();
                                                            end;
                                                        end;
                                                    end;
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;

                exit(true);
            end;
        end;
    end;

    procedure ClearObjects()
    begin
        Clear(Client);
        Clear(Response);
        // Clear(json);
        Clear(jsonObj);
        Clear(contentHeaders);
        Clear(Request);
        Clear(ResponseText);
        Clear(_jsonToken);
    end;

    // YF 22 Jul 2022
    // Insert/Update Staging Delivery Task Header and Lines Tables
    procedure InsertOrUpdateStagingInvoiceRecords(var TBARec: Record "TBA Ledger Entry")
    var
        VSSetup: Record "VersaFleet Integration Setup";
        VFStagingHeader: Record "Staging VF Task Header";
        VFStagingLine: Record "Staging VF Task Line";
        StagingHdrRecEntryNo: Integer;
        CustRec: Record Customer;
        CountryRec: Record "Country/Region";
        CountryName: Text[50];
        LineNo: Integer;

    begin
        VSSetup.Get;

        if TBARec.FindSet() then
            repeat
                // 1. Check if header exists in Staging and not synced
                // 1a. If yes, check if line exists in Staging. If exists modify, else insert
                // 1b. If no, insert new header and line
                // Note: Delivery Address get from customer

                VFStagingHeader.Reset();
                VFStagingHeader.SetRange("Sales Invoice No.", TBARec."Document No.");
                VFStagingHeader.SetRange("Source Document Type", VFStagingHeader."Source Document Type"::"TBA Ledger");
                // VFStagingHeader.SetRange(Created, false); //RL 30 Sep 2022 - Pending YF confirmation
                // VFStagingHeader.SetRange(Closed, false); //RL 30 Sep 2022

                if VFStagingHeader.FindFirst() then begin
                    // Don't need to insert header
                    // Insert Or Update Line required
                    VFStagingLine.Reset;
                    VFStagingLine.SetRange("Parent Entry No.", VFStagingHeader."Entry No.");
                    VFStagingLine.SetRange("Sales Invoice No.", TBARec."Document No.");
                    VFStagingLine.SetRange("Sales Invoice Line No.", TBARec."Entry No.");
                    if VFStagingLine.FindFirst() then begin
                        // update existing record
                        VFStagingLine."Item No." := TBARec."Item No.";
                        VFStagingLine."Item Description" := TBARec."Item Description";
                        VFStagingLine.Qty := Abs(TBARec.Quantity); // YF 02 Aug 2022
                        VFStagingLine.UOM := TBARec."Unit of Measure Code";
                        VFStagingLine."Item Check Method" := Format(VSSetup."Item Check Method");
                        VFStagingLine."Item Unload Check Method" := Format(Format(VSSetup."Item Unload Check Method"));
                        VFStagingLine."Created Timestamp" := CurrentDateTime;

                        if VFStagingLine.Modify() then;
                    end
                    else begin
                        // insert as new record
                        VFStagingLine.Reset;
                        VFStagingLine.SetRange("Parent Entry No.", VFStagingHeader."Entry No.");
                        VFStagingLine.SetCurrentKey("Line No.");
                        VFStagingLine.SetAscending("Line No.", true);
                        if VFStagingLine.FindLast() then
                            LineNo := VFStagingLine."Line No." + 1
                        else
                            LineNo := 1;

                        VFStagingLine.Reset;
                        VFStagingLine.Init();
                        VFStagingLine."Parent Entry No." := VFStagingHeader."Entry No.";
                        VFStagingLine."Line No." := LineNo;
                        VFStagingLine."Sales Invoice No." := TBARec."Document No.";
                        VFStagingLine."Sales Invoice Line No." := TBARec."Entry No.";
                        VFStagingLine."Item No." := TBARec."Item No.";
                        // VFStagingLine."Item Description" := TBARec."Item Description";
                        VFStagingLine."Item Description" := TBARec.Remarks;
                        VFStagingLine.Qty := Abs(TBARec.Quantity);  // YF 02 Aug 2022
                        VFStagingLine.UOM := TBARec."Unit of Measure Code";
                        VFStagingLine."Item Check Method" := Format(VSSetup."Item Check Method");
                        VFStagingLine."Item Unload Check Method" := Format(Format(VSSetup."Item Unload Check Method"));
                        VFStagingLine."Created Timestamp" := CurrentDateTime;

                        if VFStagingLine.Insert() then;
                    end;
                end
                else begin
                    // To insert header and line

                    if CustRec.Get(TBARec."Customer No.") then begin
                        // if (CustRec."Country/Region Code" = '') Or (CustRec."Country/Region Code" = 'SGP') then // YF 14 Sep 2022
                        if CustRec."Country/Region Code" in ['', 'SGP', 'SG'] then // YF 14 Sep 2022
                            CountryName := 'Singapore'
                        else begin
                            if CountryRec.Get(CustRec."Country/Region Code") then
                                CountryName := CountryRec.Name;
                        end;
                    end;

                    VFStagingHeader.Reset;

                    VFStagingHeader.Init();
                    VFStagingHeader."Entry No." := 0;
                    VFStagingHeader."Sales Invoice No." := TBARec."Document No.";
                    VFStagingHeader."Posting Date" := TBARec."Posting Date";
                    VFStagingHeader."Tracking ID" := TBARec."Document No.";
                    VFStagingHeader."Total Price" := 0;
                    VFStagingHeader."Time From Text" := Format(TBARec."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>') + 'T00:00:00.000+08:00'; // "time_from": "2021-11-16T00:00:00.000+08:00",
                    VFStagingHeader."Time To Text" := Format(TBARec."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>') + 'T23:59:59.999+08:00'; // "time_to": "2021-11-16T23:59:59.999+08:00",
                    VFStagingHeader."Time Type" := 'all_day';
                    VFStagingHeader.COD := 0;
                    // VFStagingHeader.Remarks := TBARec.Remarks;
                    VFStagingHeader.Remarks := CustRec."Delivery Instructions";
                    // VFStagingHeader."Source Delivery Charge" := TBARec."Delivery Charge";
                    VFStagingHeader."Source Delivery Charge" := CustRec."Delivery Charge";
                    VFStagingHeader."Service Time" := VSSetup."Default Task Service Time";

                    VFStagingHeader."Delivery Address Name" := CustRec.Contact; //RL 11112022 - switch name and contact name
                    VFStagingHeader."Delivery Address Line 1" := CustRec."Address";
                    VFStagingHeader."Delivery Address Line 2" := CustRec."Address 2";
                    VFStagingHeader."Delivery Address City" := CustRec."City";
                    VFStagingHeader."Delivery Address Country" := CountryName;
                    VFStagingHeader."Delivery Address Zip" := CustRec."Post Code";
                    VFStagingHeader."Delivery Address Email" := CustRec."E-Mail";
                    VFStagingHeader."Delivery Address Contact No." := CustRec."Phone No.";
                    VFStagingHeader."Delivery Address Contact Name" := CustRec."Name";//RL 11112022 - switch name and contact name

                    VFStagingHeader."Driver Tag" := CustRec."Delivery Zone";
                    VFStagingHeader."Vehicle Tag" := CustRec."Delivery Zone";
                    VFStagingHeader."Customer No." := CustRec."No.";
                    VFStagingHeader."Customer Group" := CustRec."Customer Group";

                    VFStagingHeader."Created Timestamp" := CurrentDateTime;

                    VFStagingHeader."Source Document Type" := VFStagingHeader."Source Document Type"::"TBA Ledger";

                    if VFStagingHeader.Insert(true) then begin

                        LineNo := 1;
                        VFStagingLine.Reset;
                        VFStagingLine.Init();
                        VFStagingLine."Parent Entry No." := VFStagingHeader."Entry No.";
                        VFStagingLine."Line No." := LineNo;
                        VFStagingLine."Sales Invoice No." := TBARec."Document No.";
                        VFStagingLine."Sales Invoice Line No." := TBARec."Entry No.";
                        VFStagingLine."Item No." := TBARec."Item No.";
                        VFStagingLine."Item Description" := TBARec."Item Description";
                        VFStagingLine.Qty := Abs(TBARec.Quantity); //  // YF 02 Aug 2022
                        VFStagingLine.UOM := TBARec."Unit of Measure Code";
                        VFStagingLine."Item Check Method" := Format(VSSetup."Item Check Method");
                        VFStagingLine."Item Unload Check Method" := Format(Format(VSSetup."Item Unload Check Method"));
                        VFStagingLine."Created Timestamp" := CurrentDateTime;

                        if VFStagingLine.Insert() then;

                    end;
                end;

            until TBARec.Next() = 0;

        Message('Delivery Queue submitted');

    end;
    // YF 22 Jul 2022

    // YF 25 Jul 2022
    // Insert/Update Staging Delivery Task Header and Lines Tables
    procedure InsertOrUpdateStagingInvoiceRecords(var DMCRec: Record "Delivery Misc Charges")
    var
        VSSetup: Record "VersaFleet Integration Setup";
        VFStagingHeader: Record "Staging VF Task Header";
        VFStagingLine: Record "Staging VF Task Line";
        StagingHdrRecEntryNo: Integer;
        CustRec: Record Customer;
        CountryRec: Record "Country/Region";
        CountryName: Text[50];
        LineNo: Integer;
        ItemRec: Record Item;

    begin
        VSSetup.Get;
        if ItemRec.Get(VSSetup."Def. Item for MDC") then;

        DMCRec.SetFilter("Customer No.", '<>%1', '');

        if DMCRec.FindSet() then
            repeat
                // 1. Check if header exists in Staging and not synced
                // 2. If yes, update else insert
                // Doc no and tracking id use 'MISCDEL-<Entry No.>'

                if CustRec.Get(DMCRec."Customer No.") then begin
                    // if (CustRec."Country/Region Code" = '') Or (CustRec."Country/Region Code" = 'SGP') then // YF 14 Sep 2022
                    if CustRec."Country/Region Code" in ['', 'SGP', 'SG'] then // YF 14 Sep 2022
                        CountryName := 'Singapore'
                    else begin
                        if CountryRec.Get(CustRec."Country/Region Code") then
                            CountryName := CountryRec.Name;
                    end;
                end;

                VFStagingHeader.Reset();
                VFStagingHeader.SetRange("Sales Invoice No.", 'MISCDEL-' + Format(DMCRec."Entry No."));
                VFStagingHeader.SetRange("Source Document Type", VFStagingHeader."Source Document Type"::"Misc. Delivery Charge");
                // VFStagingHeader.SetRange(Created, false); //RL 30 Sep 2022
                // VFStagingHeader.SetRange(Closed, false); //RL 30 Sep 2022

                if VFStagingHeader.FindFirst() then begin

                    // update existing record
                    VFStagingHeader."Posting Date" := DMCRec.Date;
                    VFStagingHeader."Tracking ID" := 'MISCDEL-' + Format(DMCRec."Entry No.");
                    VFStagingHeader."Total Price" := 0;
                    VFStagingHeader."Time From Text" := Format(DMCRec.Date, 0, '<Year4>-<Month,2>-<Day,2>') + 'T00:00:00.000+08:00'; // "time_from": "2021-11-16T00:00:00.000+08:00",
                    VFStagingHeader."Time To Text" := Format(DMCRec.Date, 0, '<Year4>-<Month,2>-<Day,2>') + 'T23:59:59.999+08:00'; // "time_to": "2021-11-16T23:59:59.999+08:00",
                    VFStagingHeader."Time Type" := 'all_day';
                    VFStagingHeader.COD := 0;
                    VFStagingHeader.Remarks := DMCRec.Instruction + ' ' + DMCRec."Opening Hours";
                    VFStagingHeader."Source Delivery Charge" := DMCRec."Delivery Charge";
                    VFStagingHeader."Service Time" := VSSetup."Default Task Service Time";

                    // YF 02 Aug 2022
                    /*
                    VFStagingHeader."Delivery Address Name" := CustRec."Name";
                    VFStagingHeader."Delivery Address Line 1" := DMCRec.Address;
                    VFStagingHeader."Delivery Address Line 2" := DMCRec.Branch;
                    VFStagingHeader."Delivery Address City" := '';
                    VFStagingHeader."Delivery Address Country" := '';
                    VFStagingHeader."Delivery Address Zip" := '';
                    VFStagingHeader."Delivery Address Email" := CustRec."E-Mail";
                    VFStagingHeader."Delivery Address Contact No." := CustRec."Phone No.";
                    VFStagingHeader."Delivery Address Contact Name" := CustRec.Contact;
                    */

                    VFStagingHeader."Delivery Address Name" := CustRec.Contact;//RL 11112022 - switch name and contact name
                    VFStagingHeader."Delivery Address Line 1" := CustRec."Address";
                    VFStagingHeader."Delivery Address Line 2" := CustRec."Address 2";
                    VFStagingHeader."Delivery Address City" := CustRec."City";
                    VFStagingHeader."Delivery Address Country" := CountryName;
                    VFStagingHeader."Delivery Address Zip" := CustRec."Post Code";
                    VFStagingHeader."Delivery Address Email" := CustRec."E-Mail";
                    VFStagingHeader."Delivery Address Contact No." := CustRec."Phone No.";
                    VFStagingHeader."Delivery Address Contact Name" := CustRec."Name";//RL 11112022 - switch name and contact name
                                                                                      // YF 02 Aug 2022
                    VFStagingHeader."Customer No." := CustRec."No.";
                    VFStagingHeader."Customer Group" := CustRec."Customer Group";

                    VFStagingHeader."Driver Tag" := DMCRec.Driver;
                    VFStagingHeader."Vehicle Tag" := DMCRec.Driver;
                    VFStagingHeader."Created Timestamp" := CurrentDateTime;
                    VFStagingHeader."Source Document Type" := VFStagingHeader."Source Document Type"::"Misc. Delivery Charge";

                    if VFStagingHeader.Modify() then begin
                        // modify/insert line
                        VFStagingLine.Reset;
                        VFStagingLine.SetRange("Parent Entry No.", VFStagingHeader."Entry No.");
                        VFStagingLine.SetRange("Sales Invoice No.", 'MISCDEL-' + Format(DMCRec."Entry No."));
                        VFStagingLine.SetRange("Sales Invoice Line No.", DMCRec."Entry No.");
                        if VFStagingLine.FindFirst() then begin
                            // update existing record
                            VFStagingLine."Item No." := VSSetup."Def. Item for MDC";
                            VFStagingLine."Item Description" := ItemRec.Description;
                            VFStagingLine.Qty := 1;
                            VFStagingLine.UOM := ItemRec."Base Unit of Measure";
                            VFStagingLine."Item Check Method" := Format(VSSetup."Item Check Method");
                            VFStagingLine."Item Unload Check Method" := Format(Format(VSSetup."Item Unload Check Method"));
                            VFStagingLine."Created Timestamp" := CurrentDateTime;

                            if VFStagingLine.Modify() then;
                        end
                        else begin
                            // insert as new record
                            VFStagingLine.Reset;
                            VFStagingLine.SetRange("Parent Entry No.", VFStagingHeader."Entry No.");
                            VFStagingLine.SetCurrentKey("Line No.");
                            VFStagingLine.SetAscending("Line No.", true);
                            if VFStagingLine.FindLast() then
                                LineNo := VFStagingLine."Line No." + 1
                            else
                                LineNo := 1;

                            VFStagingLine.Reset;
                            VFStagingLine.Init();
                            VFStagingLine."Parent Entry No." := VFStagingHeader."Entry No.";
                            VFStagingLine."Line No." := LineNo;
                            VFStagingLine."Sales Invoice No." := 'MISCDEL-' + Format(DMCRec."Entry No.");
                            VFStagingLine."Sales Invoice Line No." := DMCRec."Entry No.";
                            VFStagingLine."Item No." := VSSetup."Def. Item for MDC";
                            VFStagingLine."Item Description" := ItemRec.Description;
                            VFStagingLine.Qty := 1;
                            VFStagingLine.UOM := ItemRec."Base Unit of Measure";
                            VFStagingLine."Item Check Method" := Format(VSSetup."Item Check Method");
                            VFStagingLine."Item Unload Check Method" := Format(Format(VSSetup."Item Unload Check Method"));
                            VFStagingLine."Created Timestamp" := CurrentDateTime;

                            if VFStagingLine.Insert() then;
                        end;
                    end;
                end
                else begin
                    // To insert header and line
                    VFStagingHeader.Reset;

                    VFStagingHeader.Init();
                    VFStagingHeader."Entry No." := 0;
                    VFStagingHeader."Sales Invoice No." := 'MISCDEL-' + Format(DMCRec."Entry No.");
                    VFStagingHeader."Posting Date" := DMCRec.Date;
                    VFStagingHeader."Tracking ID" := 'MISCDEL-' + Format(DMCRec."Entry No.");
                    VFStagingHeader."Total Price" := 0;
                    VFStagingHeader."Time From Text" := Format(DMCRec.Date, 0, '<Year4>-<Month,2>-<Day,2>') + 'T00:00:00.000+08:00'; // "time_from": "2021-11-16T00:00:00.000+08:00",
                    VFStagingHeader."Time To Text" := Format(DMCRec.Date, 0, '<Year4>-<Month,2>-<Day,2>') + 'T23:59:59.999+08:00'; // "time_to": "2021-11-16T23:59:59.999+08:00",
                    VFStagingHeader."Time Type" := 'all_day';
                    VFStagingHeader.COD := 0;
                    VFStagingHeader.Remarks := DMCRec.Instruction + ' ' + DMCRec."Opening Hours";
                    VFStagingHeader."Source Delivery Charge" := DMCRec."Delivery Charge";
                    VFStagingHeader."Service Time" := VSSetup."Default Task Service Time";

                    VFStagingHeader."Delivery Address Name" := CustRec.Contact;
                    VFStagingHeader."Delivery Address Line 1" := DMCRec.Address;
                    VFStagingHeader."Delivery Address Line 2" := DMCRec.Branch;
                    VFStagingHeader."Delivery Address City" := '';
                    VFStagingHeader."Delivery Address Country" := '';
                    VFStagingHeader."Delivery Address Zip" := '';
                    VFStagingHeader."Delivery Address Email" := CustRec."E-Mail";
                    VFStagingHeader."Delivery Address Contact No." := CustRec."Phone No.";
                    VFStagingHeader."Delivery Address Contact Name" := CustRec."Name";

                    /*
                    VFStagingHeader."Delivery Address Name" := CustRec."Name";
                    VFStagingHeader."Delivery Address Line 1" := CustRec."Address";
                    VFStagingHeader."Delivery Address Line 2" := CustRec."Address 2";
                    VFStagingHeader."Delivery Address City" := CustRec."City";
                    VFStagingHeader."Delivery Address Country" := CountryName;
                    VFStagingHeader."Delivery Address Zip" := CustRec."Post Code";
                    VFStagingHeader."Delivery Address Email" := CustRec."E-Mail";
                    VFStagingHeader."Delivery Address Contact No." := CustRec."Phone No.";
                    VFStagingHeader."Delivery Address Contact Name" := CustRec.Contact;
                    */

                    VFStagingHeader."Driver Tag" := DMCRec.Driver;
                    VFStagingHeader."Vehicle Tag" := DMCRec.Driver;
                    VFStagingHeader."Created Timestamp" := CurrentDateTime;
                    VFStagingHeader."Source Document Type" := VFStagingHeader."Source Document Type"::"Misc. Delivery Charge";

                    if VFStagingHeader.Insert(true) then begin

                        LineNo := 1;
                        VFStagingLine.Reset;
                        VFStagingLine.Init();
                        VFStagingLine."Parent Entry No." := VFStagingHeader."Entry No.";
                        VFStagingLine."Line No." := LineNo;
                        VFStagingLine."Sales Invoice No." := 'MISCDEL-' + Format(DMCRec."Entry No.");
                        VFStagingLine."Sales Invoice Line No." := DMCRec."Entry No.";
                        VFStagingLine."Item No." := VSSetup."Def. Item for MDC";
                        VFStagingLine."Item Description" := ItemRec.Description;
                        VFStagingLine.Qty := 1;
                        VFStagingLine.UOM := ItemRec."Base Unit of Measure";
                        VFStagingLine."Item Check Method" := Format(VSSetup."Item Check Method");
                        VFStagingLine."Item Unload Check Method" := Format(Format(VSSetup."Item Unload Check Method"));
                        VFStagingLine."Created Timestamp" := CurrentDateTime;

                        if VFStagingLine.Insert() then;

                    end;
                end;

            until DMCRec.Next() = 0;

        Message('Delivery Queue submitted');

    end;
    // YF 25 Jul 2022


    // YF 14 Sep 2022
    procedure DebugAPIMessage(var StagingID: Integer; var JobID: Integer; var TaskIDParameter: Integer; var ProcessMessages: Text[150]; var HasError: Boolean): Boolean;
    var
        VersaFleetSetup: Record "VersaFleet Integration Setup";
        APIAddress: Text[500];
        TaskId: Integer;
        TaskGUID: Text;
        TaskState: Text;

        ItemJsonArray: JsonArray;
        ItemJsonObj: JsonObject;
        ItemJsonToken: JsonToken;
        ItemJsonChildToken: JsonToken;
        ItemId: Integer;
        ItemCode: Code[20];

        PostDateText: Text[30];
        TaskJsonObj: JsonObject;
        TaskJsonToken: JsonToken;

        VFStagingHeaderRec: Record "Staging VF Task Header";
        VFStagingHeaderModRec: Record "Staging VF Task Header"; // YF 13 Jun 2022
        VFStagingLineRec: Record "Staging VF Task Line";
        TotalTaskItemLines: Integer;
        CountTaskItemLines: Integer;
        BaseTimeFromText: Text;
        BaseTimeToText: Text;

        TempProcessMsg: Text[150];
        TempHasError: Boolean;

        VTextBuilder: TextBuilder;
        VResponseHTTPContent: HttpContent; // YF 15 Mar 2022
        VResponseInStream: InStream;

        // YF 21 Feb 2023
        PSIRec: Record "Sales Invoice Header";
        CustRec: Record Customer;
        WorkingHours: Text;
    // YF 21 Feb 2023

    begin
        // https://api.versafleet.co/api/customers?client_id=<clientid>&client_secret=<clientkey>

        TotalTaskItemLines := 0;
        CountTaskItemLines := 0;

        ClearObjects();
        if Not VersaFleetSetup.Get then begin
            ProcessMessages := 'Integration Setup not done';
            HasError := true;
            exit(false);
        end;

        if StagingID = 0 then begin
            ProcessMessages := 'Invalid Staging Entry No. Parameter';
            HasError := true;
            exit(false);
        end
        else begin
            VFStagingHeaderRec.Reset;
            if Not VFStagingHeaderRec.Get(StagingID) then begin
                ProcessMessages := 'Staging Header Record not found';
                HasError := true;
                exit(false);
            end
            else begin
                PostDateText := Format(VFStagingHeaderRec."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>');
                BaseTimeFromText := PostDateText + 'T00:00:00.000+08:00';
                BaseTimeToText := PostDateText + 'T23:59:59.999+08:00';

                VFStagingLineRec.Reset;
                VFStagingLineRec.SetRange("Parent Entry No.", VFStagingHeaderRec."Entry No.");
                TotalTaskItemLines := VFStagingLineRec.Count;
            end;
        end;

        // Check if tracking number exists in Versafleet (because of potential silent failure)
        if CheckVFTrackingIDExists(VFStagingHeaderRec."Tracking ID", TempProcessMsg, TempHasError, TaskIDParameter) then begin // YF 13 Jun 2022
            ProcessMessages := 'Tracking ID exists in VF';
            HasError := true;
            //exit(false);
        end
        else begin
            if TempHasError then begin
                ProcessMessages := TempProcessMsg;
                HasError := TempHasError;
                //exit(false);
            end;
        end;

        APIAddress := VersaFleetSetup."API Parent URL" + 'tasks'
                        + '?client_id=' + VersaFleetSetup."Client ID"
                        + '&client_secret=' + VersaFleetSetup."Client Secret";

        VTextBuilder.Clear();
        VTextBuilder.Append('{');
        VTextBuilder.Append('    "task_attributes": {');
        VTextBuilder.Append('        "job_id": ' + Format(JobID, 0, 1) + ',');
        VTextBuilder.Append('        "price": ' + Format(VFStagingHeaderRec."Total Price", 0, 1) + ',');
        VTextBuilder.Append('        "invoice_number": "' + VFStagingHeaderRec."Sales Invoice No." + '",');
        VTextBuilder.Append('        "tracking_id": "' + VFStagingHeaderRec."Tracking ID" + '",');
        VTextBuilder.Append('        "time_from": "' + PostDateText + 'T00:00:00.000+08:00' + '",');
        VTextBuilder.Append('        "time_to": "' + PostDateText + 'T23:59:59.999+08:00' + '",');
        VTextBuilder.Append('        "time_type": "all_day",');
        VTextBuilder.Append('        "time_window_id": null,');
        VTextBuilder.Append('        "expected_cod": 0,');
        VTextBuilder.Append('        "remarks": "' + SanitizeJSONText(VFStagingHeaderRec.Remarks) + '",');
        VTextBuilder.Append('        "service_time": ' + Format(VersaFleetSetup."Default Task Service Time", 0, 1) + ',');
        VTextBuilder.Append('        "address_attributes": {');
        VTextBuilder.Append('            "name": "' + VFStagingHeaderRec."Delivery Address Name" + '",');
        VTextBuilder.Append('            "zip": "' + VFStagingHeaderRec."Delivery Address Zip" + '",');
        VTextBuilder.Append('            "line_1": "' + VFStagingHeaderRec."Delivery Address Line 1" + '",');
        VTextBuilder.Append('            "line_2": "' + VFStagingHeaderRec."Delivery Address Line 2" + '",');
        VTextBuilder.Append('            "country": "' + VFStagingHeaderRec."Delivery Address Country" + '",');
        VTextBuilder.Append('            "city": "' + VFStagingHeaderRec."Delivery Address City" + '",');
        VTextBuilder.Append('            "email": "' + VFStagingHeaderRec."Delivery Address Email" + '",');
        VTextBuilder.Append('            "contact_person": "' + VFStagingHeaderRec."Delivery Address Contact Name" + '",');
        VTextBuilder.Append('            "contact_number": "' + VFStagingHeaderRec."Delivery Address Contact No." + '" ');
        VTextBuilder.Append('        },');
        VTextBuilder.Append('        "measurements_attributes": [');

        VFStagingLineRec.Reset;
        VFStagingLineRec.SetRange("Parent Entry No.", VFStagingHeaderRec."Entry No.");
        if VFStagingLineRec.FindSet() then
            repeat

                VTextBuilder.Append('            {');
                VTextBuilder.Append('                "quantity": ' + Format(VFStagingLineRec.Qty, 0, 1) + ',');
                VTextBuilder.Append('                "quantity_unit": "' + VFStagingLineRec.UOM + '",');
                VTextBuilder.Append('                "description": "' + SanitizeJSONText(VFStagingLineRec."Item Description") + '",');
                VTextBuilder.Append('                "custom_item_id": "' + VFStagingLineRec."Item No." + '",');
                VTextBuilder.Append('                "custom_item_check_method": "' + Format(VersaFleetSetup."Item Check Method") + '",');
                VTextBuilder.Append('                "custom_item_unload_check_method": "' + Format(VersaFleetSetup."Item Unload Check Method") + '" ');

                CountTaskItemLines += 1;

                if CountTaskItemLines = TotalTaskItemLines then
                    VTextBuilder.Append('            }')
                else
                    VTextBuilder.Append('            },');

            until VFStagingLineRec.Next() = 0;

        VTextBuilder.Append('        ],');

        // YF 27 Jun 2022
        VTextBuilder.Append('        "custom_field_group_id": ' + Format(VersaFleetSetup."Delivery Charge Field Group ID") + ',');
        VTextBuilder.Append('        "custom_fields_attributes": [');
        VTextBuilder.Append('        {');
        VTextBuilder.Append('            "custom_field_description_id": ' + Format(VersaFleetSetup."Delivery Charge Field Descr ID") + ',');
        VTextBuilder.Append('            "value": "' + VFStagingHeaderRec."Source Delivery Charge" + '" ');
        // YF 21 Feb 2023
        VTextBuilder.Append('        },');
        VTextBuilder.Append('        {');
        VTextBuilder.Append('            "custom_field_description_id": ' + Format(VersaFleetSetup."Operating Hours Field Descr ID") + ',');

        WorkingHours := '';
        PSIRec.Reset;
        PSIRec.SetLoadFields("No.", "Sell-to Customer No.");
        PSIRec.SetRange("No.", VFStagingHeaderRec."Sales Invoice No.");
        if PSIRec.FindFirst() then begin
            CustRec.Reset;
            CustRec.SetLoadFields("Working Hours");
            CustRec.SetRange("No.", PSIRec."Sell-to Customer No.");
            if CustRec.FindFirst() then
                WorkingHours := SanitizeJSONText(CustRec."Working Hours");
        end;

        VTextBuilder.Append('            "value": "' + WorkingHours + '" ');
        // YF 21 Feb 2023
        VTextBuilder.Append('        }');
        VTextBuilder.Append('        ],');
        // YF 27 Jun 2022

        VTextBuilder.Append('        "tag_list": [');
        VTextBuilder.Append('            "' + VFStagingHeaderRec."Driver Tag" + '",');
        VTextBuilder.Append('            "' + VFStagingHeaderRec."Vehicle Tag" + '" ');
        VTextBuilder.Append('        ],');
        VTextBuilder.Append('        "driver_skill_list": [');
        VTextBuilder.Append('            "' + VFStagingHeaderRec."Driver Tag" + '" ');
        VTextBuilder.Append('        ]');

        VTextBuilder.Append('    }');
        VTextBuilder.Append('}');

        /*
        // _httpContent.WriteFrom(apiRequestQuery); // add the payload
        _httpContent.WriteFrom(VTextBuilder.ToText()); // add the payload
        _httpContent.GetHeaders(contentHeaders); // retrieve content headers associated with content
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/json');

        // Request.Content := _httpContent;
        // Request.SetRequestUri(APIAddress);
        // Request.Method := 'POST';
        */

        Message('apirequest || ' + VTextBuilder.ToText());

        exit(false);
    end;
    // YF 14 Sep 2022

    local procedure GetLastLinkID()
    var
        RecordLink: Record "Record Link";
    begin
        RecordLink.Reset();
        if RecordLink.FindLast() then
            LastLinkID := RecordLink."Link ID"
        else
            LastLinkID := 0;
    end;

    local procedure GetNovemInvNo(SIHRec: Record "Sales Invoice Header"): code[20]
    var
        myInt: Integer;
        NovemSIHRec: Record "Sales Invoice Header";
    begin
        if SIHRec.I9G_InvoiceNo <> '' then
            exit(SIHRec.I9G_InvoiceNo)
        else begin
            NovemSIHRec.reset;
            NovemSIHRec.ChangeCompany(SIHRec.I9G_FromCompanyName);
            NovemSIHRec.SetCurrentKey("Order No.", I9G_InvoiceNo);
            NovemSIHRec.SetLoadFields("Order No.", I9G_InvoiceNo, "No.");
            NovemSIHRec.SetRange("Order No.", SIHRec."Order No.");
            NovemSIHRec.SetRange(I9G_InvoiceNo, SIHRec."No.");
            if NovemSIHRec.FindFirst() then
                exit(NovemSIHRec."No.")
            else
                exit(SIHRec."No.");
        end;

    end;

    local procedure GetNovemPhone(SIHRec: Record "Sales Invoice Header"): text[30]
    var
        myInt: Integer;
        NovemSIHRec: Record "Sales Invoice Header";
    begin
        NovemSIHRec.reset;
        NovemSIHRec.ChangeCompany(SIHRec.I9G_FromCompanyName);
        NovemSIHRec.SetCurrentKey("Order No.", I9G_InvoiceNo);
        NovemSIHRec.SetLoadFields("Order No.", I9G_InvoiceNo, "No.", "Ship-to Phone No.");
        NovemSIHRec.SetRange("Order No.", SIHRec."Order No.");
        NovemSIHRec.SetRange(I9G_InvoiceNo, SIHRec."No.");
        if NovemSIHRec.FindFirst() then
            exit(NovemSIHRec."Ship-to Phone No.")
        else
            exit(SIHRec."Ship-to Phone No.");
    end;

    local procedure GetNovemName(SIHRec: Record "Sales Invoice Header"): text[100]
    var
        myInt: Integer;
        NovemSIHRec: Record "Sales Invoice Header";
    begin
        NovemSIHRec.reset;
        NovemSIHRec.ChangeCompany(SIHRec.I9G_FromCompanyName);
        NovemSIHRec.SetCurrentKey("Order No.", I9G_InvoiceNo);
        NovemSIHRec.SetLoadFields("Order No.", I9G_InvoiceNo, "No.", "Sell-to Customer Name");
        NovemSIHRec.SetRange("Order No.", SIHRec."Order No.");
        NovemSIHRec.SetRange(I9G_InvoiceNo, SIHRec."No.");
        if NovemSIHRec.FindFirst() then
            exit(NovemSIHRec."Sell-to Customer Name")
        else
            exit(SIHRec."Sell-to Customer Name");
    end;

    local procedure IsNovemCust(SIHRec: Record "Sales Invoice Header"): Boolean
    var
        myInt: Integer;
    begin
        if SIHRec."Sell-to Customer No." = 'N071' then
            exit(true)
        else
            exit(false);
    end;
    //CR Restriction of versafleet
    local procedure IsAllowedDocNo(DocNo: code[20]): Boolean
    var
        myInt: Integer;
    begin
        if (CopyStr(DocNo, 1, 2) = 'WA') or (CopyStr(DocNo, 1, 2) = 'DN') then
            exit(false)
        else
            exit(true);
    end;

    var

        Client: HttpClient;
        Response: HttpResponseMessage;
        // json: Text[10000];
        jsonObj: JsonObject;
        _jsonToken: JsonToken;
        _httpContent: HttpContent;
        // apiRequestQuery: Text[10000];
        apiRequestQuery: Text; // YF 20 May 2022
        contentHeaders: HttpHeaders;
        Request: HttpRequestMessage;
        // ResponseText: Text[10000];
        ResponseText: Text; // YF 20 May 2022
        LastLinkID: Integer;
}

/*
    However, according to here (https://www.freeformatter.com/json-escape.html), please take a look at the list below:

    The following characters are reserved in JSON and must be properly escaped to be used in strings:

    Backspace is replaced with \b
    Form feed is replaced with \f
    Newline is replaced with \n
    Carriage return is replaced with \r
    Tab is replaced with \t
    Double quote is replaced with \"
    Backslash is replaced with \\
    Also you can check how to escape special character in json here:

    https://stackoverflow.com/questions/19176024/how-to-escape-special-characters-in-building-a-json-string	
*/
