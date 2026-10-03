report 57019 "Transfer DO"
{
    ApplicationArea = All;
    Caption = 'Transfer DO';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayouts/ReportLayout 57019 - Transfer DO.rdl';
    PreviewMode = PrintLayout;
    dataset
    {

        dataitem("Transfer Header"; "Transfer Receipt Header")
        {
            DataItemTableView = order(ascending);
            column(CompRec; CompRec.Picture)
            {

            }
            column(Transfer_Order_No_; "No.")
            {

            }
            column(Transfer_to_Name; "Transfer-to Name")
            {

            }
            column(Transfer_to_Code; "Transfer-to Code")
            {

            }
            column(Transfer_to_Address; "Transfer-to Address")
            {

            }
            column(Transfer_to_Address_2; "Transfer-to Address 2")

            {

            }
            column(Transfer_to_City; "Transfer-to City")
            {

            }
            column(Transfer_to_Post_Code; "Transfer-to Post Code")
            {

            }
            column(Transfer_to_County; "Transfer-to County")
            {

            }
            column(CustName; CustRec.Name)
            {
            }
            column(Add1; Custrec.Address)
            {

            }
            column(Add2; CustRec."Address 2")
            {

            }
            column(PostCOde; CustRec."Country/Region Code" + ' ' + CustRec.City)
            {

            }

            dataitem(TransferLine; "Transfer Receipt Line")
            {
                DataItemLink = "Document No." = field("No.");

                column(ItemNo; TransferLine."Item No.")
                {

                }
                column(Quantity; Quantity)
                {

                }

                column(Description; Description)
                {

                }
                column(Unit_of_Measure_Code; "Unit of Measure Code")
                {

                }
                column(Transfer_To_Bin_Code; "Transfer-To Bin Code")
                {

                }


                dataitem(ResEntry; "Item Ledger Entry")
                {
                    DataItemLink = "Document No." = field("Document No."), "Document Line No." = field("Line No.");
                    column(LotNo; "Lot No.")
                    {

                    }
                    column(Expiration_Date; FORMAT("Expiration Date"))
                    {

                    }
                    column(LotQty; Quantity)
                    {

                    }
                    trigger OnPreDataItem()
                    var
                        myInt: Integer;
                    begin
                        ResEntry.SetRange("Location Code", "Transfer Header"."Transfer-to Code");
                    end;

                }


                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin

                end;
            }

            trigger OnAfterGetRecord()
            var
                TLRec: Record "Transfer Receipt Line";
            begin
                TLRec.reset;
                TLRec.SetRange("Document No.", "Transfer Header"."No.");
                if TLRec.FindFirst() then begin
                    CustRec.Reset();
                    CustRec.SetRange("No.", TLRec."Transfer-To Bin Code");
                    if CustRec.FindFirst() then begin

                    end;
                end;
                //CustRec.reset;
                //CustRec.SetRange("No.","Transfer Header".transfer);
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

    trigger OnPreReport()
    var
        myInt: Integer;
    begin
        CompRec.reset;
        CompRec.get;
        CompRec.CalcFields(Picture);
    end;


    var
        CustRec: record Customer;
        CompRec: record "Company Information";

        TempItemRec: Record Item;
        CurrQty: Decimal;
        DocNo: Code[20];
    //CSLETemp : record 
}
