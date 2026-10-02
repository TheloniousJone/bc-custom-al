report 69001 "VersaFleet Check Task Status"
{

    Caption = 'VersaFleet Check Task Status';
    ProcessingOnly = true;
    // RDLCLayout = './ReportLayouts/Test2.rdl';
    UseRequestPage = false;

    dataset
    {

        dataitem("Staging VF Task Header"; "Staging VF Task Header")
        {
            trigger OnPreDataItem()
            begin
                "Staging VF Task Header".SetRange(Created, true);
                // "Staging VF Task Header".SetFilter("VF Task State", '<>%1', 'successful'); // YF 20 Jun 2022
                "Staging VF Task Header".SetFilter("Posting Date", '01072022..'); // YF 14 Sep 2022
                // "Staging VF Task Header".SetFilter("Delivered Date", '0D'); // YF 14 Sep 2022 // YF 29 Sep 2022
                // "Staging VF Task Header".SetRange("Delivered Date", 0D); // YF 29 Sep 2022
                // "Staging VF Task Header".SetFilter("Delivered Date Text", '%1', ''); // YF 29 Sep 2022
                "Staging VF Task Header".SetFilter("VF Task ID", '<>0'); // YF 14 Sep 2022
            end;

            trigger OnAfterGetRecord()
            var
                IntegrationCU: Codeunit "VersaFleet Integrations";
                ProcessMessage: Text[150];
                HasErrors: Boolean;
            begin
                ProcessMessage := '';
                HasErrors := false;

                // YF 20 Jun 2022
                if ("Staging VF Task Header"."VF Task State" <> 'successful') Or "Staging VF Task Header"."Force Delivery Status Check" then begin
                    // IntegrationCU.CheckTaskTrackingStatus("Staging VF Task Header"."VF Task ID", "Staging VF Task Header", ProcessMessage, HasErrors); // Original
                    IntegrationCU.GetTaskDataForDeliveryStatus("Staging VF Task Header"."VF Task ID", "Staging VF Task Header", ProcessMessage, HasErrors); // Revised

                    if "Staging VF Task Header"."Force Delivery Status Check" then begin
                        "Staging VF Task Header"."Force Delivery Status Check" := false;
                        // Dev Notes: To insert/cater for ProcessMessage in future for error handling/troubleshooting // YF 29 Sep 2022
                        "Staging VF Task Header".Modify();
                    end;
                end;
                // YF 20 Jun 2022
            end;
        }

    }

}

