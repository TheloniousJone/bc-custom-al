report 60103 ItemWellyway
{
    Caption = 'Item Wellyway';
    ProcessingOnly = true;
    dataset
    {
        dataitem(ItemRec; Item)
        {

            trigger OnPreDataItem()
            begin
                ItemWellywayRec.DeleteAll();
            end;

            trigger OnAfterGetRecord()
            begin

                ItemWellywayRec.Init();
                ItemWellywayRec."Product Code" := ItemRec."No.";
                ItemWellywayRec."Producte Name" := ItemRec.Description;
                ItemWellywayRec."Base UOM" := ItemRec."Base Unit of Measure";
                ItemWellywayRec."Item Status" := ItemRec."Item Status";
                ItemWellywayRec."Sales UOM" := ItemRec."Sales Unit of Measure";
                ItemWellywayRec."Generic Name" := ItemRec."Generic Name";
                //ItemWellywayRec."Available Status" := ItemRec."Available Status";
                //ItemWellywayRec."Expiry Date" := ItemRec."Expiry Date";
                ItemWellywayRec."Forensic Group" := ItemRec."Forensic Group";
                //ItemWellywayRec."Product Type" := ItemRec."Product Type";
                ItemWellywayRec."Storage Condition" := ItemRec."Storage Condition";
                ItemWellywayRec.Manufacturer := ItemRec.Manufacturer;
                ItemWellywayRec.Principal := ItemRec.Principal;
                //ItemWellywayRec."WholeSales Price" := ItemRec."WholeSales Price";
                //ItemWellywayRec."Item Group" := ItemRec."Item Group";
                ItemWellywayRec."Base Unit Description" := ItemRec.Description;
                //ItemWellywayRec.WareHouse := ItemRec.WareHouse;
                //ItemWellywayRec."Instruction For Use" := ItemRec."Instruction For Use";
                //ItemWellywayRec.Precautions := ItemRec.Precautions;
                //ItemWellywayRec."Pack Size" := ItemRec."Pack Size";
                ItemWellywayRec."Purchase UOM" := ItemRec."Purch. Unit of Measure";
                //ItemWellywayRec."Purchase Lead Time" := ItemRec."Purchase Lead Time";
                //ItemWellywayRec."Sales Lead Time" := ItemRec."Sales Lead Time";
                ItemWellywayRec."Item GST Group" := ItemRec."VAT Prod. Posting Group";
                ItemWellywayRec."Default Vendor" := ItemRec."Vendor No.";
                //ItemWellywayRec."Item Model Group" := ItemRec."Item Model Group";
                //ItemWellywayRec."Dimension Group" := ItemRec."Dimension Group";
                ItemWellywayRec."Dimension [1]" := ItemRec."Global Dimension 1 Code";
                ItemWellywayRec."Dimension [2]" := ItemRec."Global Dimension 2 Code";
                //ItemWellywayRec."Dimension [3]" := ItemRec."Dimension [3]";
                // ItemWellywayRec."From Unit" := ItemRec."From Unit";
                // ItemWellywayRec."From Unit Description" := ItemRec."From Unit Description";
                // ItemWellywayRec.Factor := ItemRec.Factor;
                // ItemWellywayRec."To Unit" := ItemRec."To Unit";
                // ItemWellywayRec."To Unit Description" := ItemRec."To Unit Description";
                ItemWellywayRec.Insert();
                ItemWellywayRec.Modify();
            end;
        }

    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    trigger OnInitReport()

    begin


    end;

    var
        ItemWellywayRec: Record ItemWellyway;

}
