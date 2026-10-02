report 57110 "Item Status"
{
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = Administration;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("No.");

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                Item.SetFilter("Item Status", '%1|%2|%3', 'ACTIVE', 'ACTIVE (SHORT-EXPIRY)', 'OUT OF STOCK - PRINCIPAL');
            end;

            trigger OnAfterGetRecord()
            begin
                ConvertToOutOfStock(Item);
                ConvertToActiveShortExpiry(Item);
                //ConvertToSTO(Item);
                //ConvertToActive(Item);
                //ConvertToSlowMoving(Item);
            end;
        }
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get();
    end;

    var
        glb_Item: Record Item;
        CompanyInfo: Record "Company Information";

    local procedure ConvertToOutOfStock(par_Item: Record Item)
    begin
        par_Item.CalcFields(Inventory);
        if par_Item.Inventory <= 0 then begin
            glb_Item.Reset();
            glb_Item.SetRange("No.", par_Item."No.");
            if glb_Item.FindFirst() then begin
                glb_Item."Item Status" := 'OUT OF STOCK - PRINCIPAL';
                //glb_Item.Status := glb_Item.Status::"Out of Stock - Principal";
                glb_Item.Modify(false);
            end
        end;
    end;

    local procedure ConvertToActiveShortExpiry(par_Item: Record Item)
    var
        lcl_ILE: Record "Item Ledger Entry";
        RPMPCU: Codeunit "PMP-Enhancements";
        ExpDate: Date;
    begin

        glb_Item.Reset();
        glb_Item.SetRange("No.", par_Item."No.");
        if glb_Item.FindFirst() then begin
            ExpDate := RPMPCU.GetItemEarliestExpiration(glb_Item."No.", CompanyInfo."Location Code");
            if ExpDate <> 0D then begin
                if ExpDate - Today < 365 then begin
                    glb_Item."Item Status" := 'ACTIVE (SHORT-EXPIRY)';
                    glb_Item.Modify(false);
                end else begin
                    glb_Item."Item Status" := 'ACTIVE';
                    glb_Item.Modify(false);
                end;
            end;

        end

    end;

    /*
      local procedure ConvertToSTO(par_Item: Record Item)
      var
          lcl_SH: Record "Sales Header";
          lcl_SL: Record "Sales Line";
          After90Days: Date;
      begin
          lcl_SL.Reset();
          lcl_SL.SetRange("Document Type", lcl_SL."Document Type"::Order);
          lcl_SL.SetRange("No.", par_Item."No.");
          if lcl_SL.FindFirst() then begin
              lcl_SH.Reset();
              lcl_SH.SetRange("Document Type", lcl_SL."Document Type");
              lcl_SH.SetRange("No.", lcl_SL."Document No.");
              if lcl_SH.FindFirst() then begin
                  After90Days := CalcDate('<+90D>', lcl_SH."Posting Date");

                  if After90Days <= Today() then begin
                      glb_Item.Reset();
                      glb_Item.SetRange("No.", par_Item."No.");
                      if glb_Item.FindFirst() then begin
                          glb_Item.Status := glb_Item.Status::"Special-To-Order";
                          glb_Item.Modify(false);
                      end
                  end
              end
          end
      end;
  */
    /*
        local procedure ConvertToSlowMoving(par_Item: Record Item)
        var
            lcl_ILE: Record "Item Ledger Entry";
            Last3Months: Date;
            TotalQty: Decimal;
        begin
            Last3Months := CalcDate('-3M', Today);

            lcl_ILE.SetRange("Entry Type", lcl_ILE."Entry Type"::Sale);
            lcl_ILE.SetFilter("Posting Date", '%1..%2', Last3Months, Today);
            lcl_ILE.SetRange("Item No.", par_Item."No.");
            if lcl_ILE.FindSet() then begin
                repeat
                    TotalQty += lcl_ILE.Quantity;
                until lcl_ILE.Next() = 0;
            end;

            if TotalQty >= 100 then begin
                glb_Item.Reset();
                glb_Item.SetRange("No.", par_Item."No.");
                if glb_Item.FindFirst() then begin
                    glb_Item.Status := glb_Item.Status::"Slow moving";
                    glb_Item.Modify(false);
                end
            end
        end;
    */
}