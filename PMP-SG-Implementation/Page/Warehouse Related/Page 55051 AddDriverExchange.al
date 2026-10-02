page 55051 "Add Driver Exchange"
{

    Caption = 'Add Driver Exchange';
    PageType = Card;
    SourceTable = "Driver Shipping Line";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(SIHNo; SIHNo)
                {
                    ApplicationArea = all;
                    Caption = 'Select Sales Inv No.';
                    TableRelation = "Sales Invoice Header"."No.";
                    trigger OnValidate()
                    var
                        myInt: Integer;
                        SIHRec: Record "Sales Invoice Header";
                    begin
                        if SIHNo <> '' then begin
                            SIHRec.Reset();
                            SIHRec.SetRange("No.", SIHNo);
                            if SIHRec.FindFirst() then begin
                                CustNo := SIHRec."Sell-to Customer No.";
                                CustName := SIHRec."Sell-to Customer Name";
                                Add1 := SIHRec."Sell-to Address";
                                Add2 := SIHRec."Sell-to Address 2";
                            end;
                        end else begin

                        end;
                    end;
                }
                field("Description Of Exchange"; DescText)
                {
                    ApplicationArea = all;

                }
                field("Item Code"; ItemCode)
                {
                    ApplicationArea = all;
                    TableRelation = Item."No.";
                    trigger OnValidate()
                    var
                        myInt: Integer;
                        itemrec: Record item;
                    begin
                        itemrec.reset;
                        itemrec.SetRange("No.", ItemCode);
                        if itemrec.FindFirst() then begin
                            ItemDesc := itemrec.Description;
                        end else begin
                            ItemDesc := '';
                        end;

                    end;
                }
                field("Item Description"; ItemDesc)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Quantity"; QtyItem)
                {
                    ApplicationArea = all;
                }

            }
        }
    }


    trigger OnClosePage()
    var
        myInt: Integer;
    begin
        if (DescText <> '') and (ItemCode <> '') and (QtyItem <> 0) then begin
            CreateExchangeLine(DriverDocNo, DescText, ItemCode, ItemDesc, QtyItem, CustNo, CustName, add1, Add2, SIHNo);
        end;
    end;

    var
        SIHNo: code[20];
        CustNo: code[20];
        CustName: Text[100];
        Add1: text[100];
        Add2: text[50];
        DescText: Text[100];
        ItemCode: Code[100];
        ItemDesc: text[100];
        QtyItem: Decimal;
        DriverCU: Codeunit "Driver CU";
        DriverDocNo: Code[20];

    procedure SetDocNo(DocNo: Code[20])
    var
        myInt: Integer;
    begin
        DriverDocNo := DocNo;
    end;


    //DX        09 July 2021    Address issue 33 : add exchange lines.
    procedure CreateExchangeLine(DocNo: Code[20]; DescText: text[100]; Itemcode: Code[100]; ItemDesc: Text[100]; Qty: Decimal; CustNo: code[20]; CustName: text[100]; Add1: text[100]; add2: text[50]; Invno: code[20])
    var
        myInt: Integer;
        DriverLine: Record "Driver Shipping Line";
    begin
        DriverLine.reset;
        DriverLine.SetRange("Driver Doc No.", DocNo);
        if DriverLine.FindLast() then
            myInt := DriverLine."Line No." + 10000
        else
            myInt := 10000;


        DriverLine.reset;
        DriverLine.init;
        DriverLine.Validate("Driver Doc No.", DocNo);
        DriverLine.Validate("Line No.", myInt);
        DriverLine.Validate("Doc No.", Invno);
        DriverLine.validate(Address, Add1);
        DriverLine.Validate("Address 2", add2);
        DriverLine.Validate("Customer Name", CustName);
        DriverLine.Validate("Customer No.", CustNo);
        DriverLine.Validate("Delivery Instructions", Itemdesc + ' ' + DescText);
        DriverLine.Validate("Shipping Packacges", Qty);
        DriverLine.Insert(true);
    end;
    //DX        09 July 2021 


}
