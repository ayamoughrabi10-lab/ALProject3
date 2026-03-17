report 50100 "Create Purchase Invoice"
{
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = Tasks;
    Caption = 'Create Purchase Invoice';

    dataset
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            DataItemTableView = sorting("Posting Date");

            trigger OnPreDataItem()
            begin
                if (StartDate = 0D) or (EndDate = 0D) then
                    Error('Please enter both Start Date and End Date.');

                SetRange("Posting Date", StartDate, EndDate);
                SetRange(Processed, false);
                SetRange("Entry Type", "Entry Type"::Purchase);
                SetRange("Document Type", "Document Type"::"Purchase Receipt");

                LastVendorNo := '';
            end;

            trigger OnAfterGetRecord()
            var
                ItemRec: Record Item;
                PurchHeader: Record "Purchase Header";
                PurchLine: Record "Purchase Line";
                CurrentVendor: Code[20];
                LineNo: Integer;
            begin
                // Get vendor from item
                if not ItemRec.Get("Item No.") then
                    Error('Item %1 not found', "Item No.");

                if ItemRec."Vendor No." = '' then
                    Error('Item %1 has no Vendor', ItemRec."No.");

                CurrentVendor := ItemRec."Vendor No.";

                // Check if Purchase Invoice exists today for this vendor
                PurchHeader.Reset();
                PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Invoice);
                PurchHeader.SetRange("Buy-from Vendor No.", CurrentVendor);
                PurchHeader.SetRange("Posting Date", TODAY);

                if PurchHeader.FindFirst() then begin

                    PurchLine.Reset();
                    PurchLine.SetRange("Document Type", PurchHeader."Document Type");
                    PurchLine.SetRange("Document No.", PurchHeader."No.");
                    PurchLine.SetRange("No.", "Item No."); // check by item

                    if PurchLine.FindFirst() then begin
                        // Item already exists → just add quantity
                        PurchLine.Validate(Quantity, PurchLine.Quantity + Quantity);
                        PurchLine.Modify(true);
                    end else begin
                        // Item not in invoice → insert new line with next available line number
                        PurchLine.Reset();
                        PurchLine.SetRange("Document Type", PurchHeader."Document Type");
                        PurchLine.SetRange("Document No.", PurchHeader."No.");
                        if PurchLine.FindLast() then
                            LineNo := PurchLine."Line No." + 10000
                        else
                            LineNo := 10000;

                        PurchLine.Init();
                        PurchLine."Document Type" := PurchHeader."Document Type";
                        PurchLine."Document No." := PurchHeader."No.";
                        PurchLine."Line No." := LineNo;
                        PurchLine.Validate(Type, PurchLine.Type::Item);
                        PurchLine.Validate("No.", "Item No.");
                        PurchLine.Validate(Quantity, Quantity);
                        PurchLine.Insert(true);
                    end;

                end else begin
                    // No invoice → create header and first line
                    PurchHeader.Init();
                    PurchHeader."Document Type" := PurchHeader."Document Type"::Invoice;
                    PurchHeader.Validate("Buy-from Vendor No.", CurrentVendor);
                    PurchHeader.Insert(true);

                    // First line
                    LineNo := 10000;
                    PurchLine.Init();
                    PurchLine."Document Type" := PurchHeader."Document Type";
                    PurchLine."Document No." := PurchHeader."No.";
                    PurchLine."Line No." := LineNo;
                    PurchLine.Validate(Type, PurchLine.Type::Item);
                    PurchLine.Validate("No.", "Item No.");
                    PurchLine.Validate(Quantity, Quantity);
                    PurchLine.Insert(true);
                end;

                // Mark entry as processed
                Processed := true;
                Modify();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(StartDate; StartDate)
                    {
                        Caption = 'Starting Date';
                    }
                    field(EndDate; EndDate)
                    {
                        Caption = 'Ending Date';
                    }
                }
            }
        }
    }

    var
        StartDate: Date;
        EndDate: Date;
        LastVendorNo: Code[20];
}