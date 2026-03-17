// namespace ALProject.ALProject;

// page 50101 "Document Convert"
// {
//     ApplicationArea = All;
//     Caption = 'Document Convert';
//     PageType = List;
//     SourceTable = "Documents Convert";
//     UsageCategory = Lists;

//     layout
//     {
//         area(Content)
//         {
//             repeater(General)
//             {
//                 field("Entry No."; Rec."Entry No.")
//                 {
//                     ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
//                 }
//                 field("No."; Rec."No.")
//                 {
//                     ToolTip = 'Specifies the value of the No. field.', Comment = '%';
//                 }
//                 field("Type"; Rec."Type")
//                 {
//                     ToolTip = 'Specifies the value of the Type field.', Comment = '%';
//                 }
//                 field("Document Type"; Rec."Document Type")
//                 {
//                     ToolTip = 'Specifies the value of the Document Type field.', Comment = '%';
//                 }

//                 field("Source No."; Rec."Source No.")
//                 {
//                     ToolTip = 'Specifies the value of the Source No. field.', Comment = '%';
//                 }
//                 field("Converted No."; Rec."Converted No.")
//                 {
//                     ToolTip = 'Specifies the value of the Converted No. field.', Comment = '%';
//                 }
//                 field("Converted Type"; Rec."Converted Type")
//                 {
//                     ToolTip = 'Specifies the value of the Converted Type field.', Comment = '%';
//                 }
//                 field("Converted Doc. Type"; Rec."Converted Doc. Type")
//                 {
//                     ToolTip = 'Specifies the value of the Converted Doc. Type field.', Comment = '%';
//                 }
//                 field("Converted Source No."; Rec."Converted Source No.")
//                 {
//                     ToolTip = 'Specifies the value of the Converted Source No. field.', Comment = '%';
//                 }
//                 field(Processed; Rec.Processed)
//                 {
//                     ToolTip = 'Specifies the value of the Processed field.', Comment = '%';
//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(Processing)
//         {

//             // begin
//             //     if Rec.Type = Rec.Type::Sales then begin
//             //         if Rec."Document Type" = Rec."Document Type"::Order then
//             //             Message('Sales - Order')
//             //         else if Rec."Document Type" = Rec."Document Type"::Invoice then
//             //             Message('Sales - Invoice')
//             //         else if Rec."Document Type" = Rec."Document Type"::"Credit Memo" then
//             //             Message('Sales - Credit Memo')
//             //         else if Rec."Document Type" = Rec."Document Type"::"Return Order" then
//             //             Message('Sales - Return Order');
//             //     end else begin
//             //         // Purchase
//             //         if Rec."Document Type" = Rec."Document Type"::Order then
//             //             Message('Purchase - Order')
//             //         else if Rec."Document Type" = Rec."Document Type"::Invoice then
//             //             Message('Purchase - Invoice')
//             //         else if Rec."Document Type" = Rec."Document Type"::"Credit Memo" then
//             //             Message('Purchase - Credit Memo')
//             //         else if Rec."Document Type" = Rec."Document Type"::"Return Order" then
//             //             Message('Purchase - Return Order');
//             //     end;
//             // end;
//             action(ConvertDocument)
//             {
//                 Caption = 'Convert Document';
//                 ApplicationArea = All;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 trigger OnAction()
//                 var
//                     DestLoc: Record "Destination Location";
//                     RelatedNo: Code[20];
//                 begin
//                     if Rec.Type = Rec.Type::Sales then begin
//                         // Sales → get Vendor from Destination Location based on Customer
//                         DestLoc.SetRange("Customer No.", Rec."Source No.");
//                         if DestLoc.FindFirst() then
//                             RelatedNo := DestLoc."Vendor No."
//                         else
//                             RelatedNo := '';

//                         if RelatedNo = '' then
//                             Message('No Vendor found in Destination Location for Customer %1', Rec."Source No.")
//                         else
//                             Message('Sales doc No.: %1, Related Vendor No.: %2', Rec."No.", RelatedNo);

//                     end else begin
//                         // Purchase → get Customer from Destination Location based on Vendor
//                         DestLoc.SetRange("Vendor No.", Rec."Source No.");
//                         if DestLoc.FindFirst() then
//                             RelatedNo := DestLoc."Customer No."
//                         else
//                             RelatedNo := '';

//                         if RelatedNo = '' then
//                             Message('No Customer found in Destination Location for Vendor %1', Rec."Source No.")
//                         else
//                             Message('Purchase doc No.: %1, Related Customer No.: %2', Rec."No.", RelatedNo);
//                     end;
//                 end;

//             }
//         }
//     }
// }



namespace ALProject.ALProject;
using Microsoft.Sales.Document;
using Microsoft.Purchases.Document;

page 50101 "Document Convert"
{
    ApplicationArea = All;
    Caption = 'Document Convert';
    PageType = List;
    SourceTable = "Documents Convert";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.") { }
                field("No."; Rec."No.") { }
                field("Type"; Rec."Type") { }
                field("Document Type"; Rec."Document Type") { }
                field("Source No."; Rec."Source No.") { }
                field("Converted No."; Rec."Converted No.") { }
                field("Converted Type"; Rec."Converted Type") { }
                field("Converted Doc. Type"; Rec."Converted Doc. Type") { }
                field("Converted Source No."; Rec."Converted Source No.") { }
                field(Processed; Rec.Processed) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ConvertDocument)
            {
                Caption = 'Convert Document';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Rec.Processed then
                        Error('This document is already processed.');

                    if Rec.Type = Rec.Type::Sales then
                        ConvertSalesToPurchase()
                    else
                        ConvertPurchaseToSales();

                    Message('Document Converted Successfully.');
                end;
            }
        }
    }

    procedure GetLastPurchNumber(DocType: Enum "Purchase Document Type"; DocNo: code[20]): Integer
    var
        PurchLine: Record "Purchase Line";
    begin
        PurchLine.Reset();
        PurchLine.SetRange("Document Type", DocType);
        PurchLine.SetRange("Document No.", DocNo);
        if PurchLine.FindLast() then exit(PurchLine."Line No.") else exit(0);
    end;

    procedure GetLastSalesNumber(DocType: Enum "Sales Document Type"; DocNo: code[20]): Integer
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", DocType);
        SalesLine.SetRange("Document No.", DocNo);
        if SalesLine.FindLast() then exit(SalesLine."Line No.") else exit(0);
    end;

    local procedure ConvertSalesToPurchase()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        DestLocation: Record "Destination Location";
        VendorNo: Code[20];
    begin
        // Get Sales Header
        SalesHeader.Get(GetSalesDocType(), Rec."No.");

        // Find Vendor from Destination Location
        DestLocation.SetRange("Customer No.", Rec."Source No.");
        if DestLocation.FindFirst() then
            VendorNo := DestLocation."Vendor No."
        else
            Error('No Vendor found for this Customer.');

        // Create Purchase Header
        PurchHeader.Init();
        PurchHeader."Document Type" := GetPurchaseDocType();
        PurchHeader.Insert(true);
        PurchHeader.Validate("Buy-from Vendor No.", VendorNo);
        PurchHeader.Modify(true);

        // Copy Lines
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");

        if SalesLine.FindSet() then
            repeat
                PurchLine.Init();
                PurchLine."Document Type" := PurchHeader."Document Type";
                PurchLine."Document No." := PurchHeader."No.";
                PurchLine."Line No." := GetLastPurchNumber(PurchHeader."Document Type", PurchHeader."No.") + 1000;
                PurchLine.Type := PurchLine.Type::Item;
                PurchLine.Validate("No.", SalesLine."No.");
                PurchLine.Validate(Quantity, SalesLine.Quantity);
                PurchLine.Validate("Direct Unit Cost", SalesLine."Unit Price");
                PurchLine.Insert(true);
            until SalesLine.Next() = 0;

        // Update Convert Table
        Rec."Converted No." := PurchHeader."No.";
        Rec."Converted Type" := Rec."Converted Type"::Purchase;
        // Rec."Converted Doc. Type" := Rec."Document Type";
        Rec."Converted Doc. Type" := PurchHeader."Document Type";
        Rec."Converted Source No." := VendorNo;
        Rec.Processed := true;
        Rec.Modify(true);
    end;

    local procedure ConvertPurchaseToSales()
    var
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        DestLocation: Record "Destination Location";
        CustomerNo: Code[20];
    begin
        // Get Purchase Header
        PurchHeader.Get(GetPurchaseDocType(), Rec."No.");

        // Find Customer from Destination Location
        DestLocation.SetRange("Vendor No.", Rec."Source No.");
        if DestLocation.FindFirst() then
            CustomerNo := DestLocation."Customer No."
        else
            Error('No Customer found for this Vendor.');

        // Create Sales Header
        SalesHeader.Init();
        SalesHeader."Document Type" := GetSalesDocType();
        SalesHeader.Insert(true);
        SalesHeader.Validate("Sell-to Customer No.", CustomerNo);
        SalesHeader.Modify(true);

        // Copy Lines
        PurchLine.SetRange("Document Type", PurchHeader."Document Type");
        PurchLine.SetRange("Document No.", PurchHeader."No.");

        if PurchLine.FindSet() then
            repeat
                SalesLine.Init();
                SalesLine."Document Type" := SalesHeader."Document Type";
                SalesLine."Document No." := SalesHeader."No.";
                SalesLine."Line No." := GetLastSalesNumber(SalesHeader."Document Type", SalesHeader."No.") + 1000;

                SalesLine.Type := SalesLine.Type::Item;
                SalesLine.Validate("No.", PurchLine."No.");
                SalesLine.Validate(Quantity, PurchLine.Quantity);
                SalesLine.Validate("Unit Price", PurchLine."Direct Unit Cost");
                SalesLine.Insert(true);
            until PurchLine.Next() = 0;

        // Update Convert Table
        Rec."Converted No." := SalesHeader."No.";
        Rec."Converted Type" := Rec."Converted Type"::Sales;
        // Rec."Converted Doc. Type" := Rec."Document Type";
        Rec."Converted Doc. Type" := SalesHeader."Document Type";
        Rec."Converted Source No." := CustomerNo;
        Rec.Processed := true;
        Rec.Modify(true);
    end;


    local procedure GetSalesDocType(): Enum "Sales Document Type"
    begin
        case Rec."Document Type" of
            Rec."Document Type"::Order:
                exit(Enum::"Sales Document Type"::Order);
            Rec."Document Type"::Invoice:
                exit(Enum::"Sales Document Type"::Invoice);
            Rec."Document Type"::"Return Order":
                exit(Enum::"Sales Document Type"::"Return Order");
        end;
    end;


    local procedure GetPurchaseDocType(): Enum "Purchase Document Type"
    begin
        case Rec."Document Type" of
            Rec."Document Type"::Order:
                exit(Enum::"Purchase Document Type"::Order);
            Rec."Document Type"::Invoice:
                exit(Enum::"Purchase Document Type"::Invoice);
            Rec."Document Type"::"Return Order":
                exit(Enum::"Purchase Document Type"::"Return Order");
        end;
    end;
}