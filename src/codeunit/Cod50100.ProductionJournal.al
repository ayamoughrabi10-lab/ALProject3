// codeunit 50100 ProductionJournal
// {
//     var
//         ItemJournalLine: Record "Item Journal Line";
//         CurrentLineNo: Integer;
//         DocNo: Code[20];
//         GlobalTemplate: Code[10];
//         GlobalBatch: Code[10];

//     procedure CreateProductionJournal(ParentItemNo: Code[20]; QtyToMake: Decimal; TemplateName: Code[10]; BatchName: Code[10])
//     var
//         Item: Record Item;
//     begin
//         // Ensure parent is an Inventory Item
//         if not IsInventoryItem(ParentItemNo) then
//             exit;

//         GlobalTemplate := TemplateName;
//         GlobalBatch := BatchName;
//         DocNo := 'BOM-01';

//         // Find next line number
//         ItemJournalLine.SetRange("Journal Template Name", GlobalTemplate);
//         ItemJournalLine.SetRange("Journal Batch Name", GlobalBatch);

//         if ItemJournalLine.FindLast() then
//             CurrentLineNo := ItemJournalLine."Line No." + 10000
//         else
//             CurrentLineNo := 10000;

//         // Get UOM from Item
//         Item.Get(ParentItemNo);

//         // Produce parent item
//         InsertJournalLine(
//             ParentItemNo,
//             QtyToMake,
//             Item."Base Unit of Measure",
//             ItemJournalLine."Entry Type"::"Positive Adjmt."
//         );

//         // Explode BOM recursively if it is a manufactured item
//         // ExplodeBOM(ParentItemNo, QtyToMake);
//         ExplodeBOM(ParentItemNo, QtyToMake, true);
//     end;

//     procedure ExplodeBOM(ItemNo: Code[20]; Qty: Decimal; IsTopLevel: Boolean)
//     var
//         BOMComponent: Record "BOM Component";
//         CompQty: Decimal;
//         Item: Record Item;
//     begin
//         if not Item.Get(ItemNo) then
//             exit;

//         BOMComponent.SetRange("Parent Item No.", ItemNo);

//         // Step 1: +ve adjustment for subassemblies
//         // For top-level item, we skip +ve (already created in CreateProductionJournal)
//         if not IsTopLevel and IsManufacturedItem(ItemNo) then
//             InsertJournalLine(
//                 ItemNo,
//                 Qty,
//                 Item."Base Unit of Measure",
//                 ItemJournalLine."Entry Type"::"Positive Adjmt."
//             );

//         // Step 2: Process direct BOM components
//         if BOMComponent.FindSet() then
//             repeat
//                 if IsInventoryItem(BOMComponent."No.") then begin
//                     CompQty := Qty * BOMComponent."Quantity per";

//                     // --- EXTRA +ve adjustment for BOM components directly under top item ---
//                     if IsTopLevel and IsManufacturedItem(BOMComponent."No.") then begin
//                         Item.Get(BOMComponent."No.");
//                         InsertJournalLine(
//                             BOMComponent."No.",
//                             CompQty,
//                             Item."Base Unit of Measure",
//                             ItemJournalLine."Entry Type"::"Positive Adjmt."
//                         );
//                     end;

//                     // Recursive explosion for all subcomponents
//                     ExplodeBOM(BOMComponent."No.", CompQty, false);

//                     // Consume component (-ve)
//                     InsertJournalLine(
//                         BOMComponent."No.",
//                         CompQty,
//                         BOMComponent."Unit of Measure Code",
//                         ItemJournalLine."Entry Type"::"Negative Adjmt."
//                     );
//                 end;

//             until BOMComponent.Next() = 0;
//     end;

//     local procedure InsertJournalLine(TargetItemNo: Code[20]; Qty: Decimal; UOM: Code[10]; EType: Enum "Item Ledger Entry Type")
//     begin
//         ItemJournalLine.Init();
//         ItemJournalLine."Journal Template Name" := GlobalTemplate;
//         ItemJournalLine."Journal Batch Name" := GlobalBatch;
//         ItemJournalLine."Line No." := CurrentLineNo;

//         ItemJournalLine.Validate("Posting Date", Today);
//         ItemJournalLine."Entry Type" := EType;
//         ItemJournalLine."Document No." := DocNo;

//         ItemJournalLine.Validate("Item No.", TargetItemNo);
//         ItemJournalLine.Validate("Unit of Measure Code", UOM);
//         ItemJournalLine.Validate(Quantity, Qty);

//         ItemJournalLine."Location Code" := 'EAST';
//         ItemJournalLine."Reason Code" := 'PRODUCTION';

//         ItemJournalLine.Insert(true);

//         CurrentLineNo += 10000;
//     end;

//     local procedure IsInventoryItem(ItemNo: Code[20]): Boolean
//     var
//         Item: Record Item;
//     begin
//         if not Item.Get(ItemNo) then
//             exit(false);

//         exit(Item.Type = Item.Type::Inventory);
//     end;

//     local procedure IsManufacturedItem(ItemNo: Code[20]): Boolean
//     var
//         Item: Record Item;
//     begin
//         if not Item.Get(ItemNo) then
//             exit(false);

//         exit(Item."Assembly BOM");
//     end;
// }



codeunit 50100 ProductionJournal
{
    var
        ItemJournalLine: Record "Item Journal Line";
        CurrentLineNo: Integer;
        DocNo: Code[20];
        GlobalTemplate: Code[10];
        GlobalBatch: Code[10];

    // Main procedure to create production journal
    procedure CreateProductionJournal(ParentItemNo: Code[20]; QtyToMake: Decimal; TemplateName: Code[10]; BatchName: Code[10])
    var
        Item: Record Item;
    begin
        // Ensure parent is an inventory item
        if not IsInventoryItem(ParentItemNo) then
            exit;

        GlobalTemplate := TemplateName;
        GlobalBatch := BatchName;
        DocNo := 'BOM-01';

        // Determine next line number
        ItemJournalLine.SetRange("Journal Template Name", GlobalTemplate);
        ItemJournalLine.SetRange("Journal Batch Name", GlobalBatch);
        if ItemJournalLine.FindLast() then
            CurrentLineNo := ItemJournalLine."Line No." + 10000
        else
            CurrentLineNo := 10000;

        // Explode BOM recursively
        ExplodeBOM(ParentItemNo, QtyToMake);
    end;

    // Recursive procedure to explode BOMs
    procedure ExplodeBOM(ItemNo: Code[20]; Qty: Decimal)
    var
        BOMComponent: Record "BOM Component";
        CompQty: Decimal;
        Item: Record Item;
    begin
        // Check if this item exists
        if not Item.Get(ItemNo) then
            exit;

        // Insert +ve adjustment for BOM items (subassemblies)
        if IsManufacturedItem(ItemNo) then begin
            InsertJournalLine(
                ItemNo,
                Qty,
                Item."Base Unit of Measure",
                ItemJournalLine."Entry Type"::"Positive Adjmt."
            );
        end;

        // Loop through all components of this BOM
        BOMComponent.SetRange("Parent Item No.", ItemNo);
        if BOMComponent.FindSet() then
            repeat
                if IsInventoryItem(BOMComponent."No.") then begin
                    CompQty := Qty * BOMComponent."Quantity per";

                    // Recursively process this component
                    ExplodeBOM(BOMComponent."No.", CompQty);

                    // Only raw inventory items (not BOMs) get -ve adjustments
                    if not IsManufacturedItem(BOMComponent."No.") then
                        InsertJournalLine(
                            BOMComponent."No.",
                            CompQty,
                            BOMComponent."Unit of Measure Code",
                            ItemJournalLine."Entry Type"::"Negative Adjmt."
                        );
                end;
            until BOMComponent.Next() = 0;
    end;

    // Procedure to insert a journal line
    local procedure InsertJournalLine(TargetItemNo: Code[20]; Qty: Decimal; UOM: Code[10]; EType: Enum "Item Ledger Entry Type")
    begin
        ItemJournalLine.Init();
        ItemJournalLine."Journal Template Name" := GlobalTemplate;
        ItemJournalLine."Journal Batch Name" := GlobalBatch;
        ItemJournalLine."Line No." := CurrentLineNo;

        ItemJournalLine.Validate("Posting Date", Today);
        ItemJournalLine."Entry Type" := EType;
        ItemJournalLine."Document No." := DocNo;

        ItemJournalLine.Validate("Item No.", TargetItemNo);
        ItemJournalLine.Validate("Unit of Measure Code", UOM);
        ItemJournalLine.Validate(Quantity, Qty);

        ItemJournalLine."Location Code" := 'EAST';
        ItemJournalLine."Reason Code" := 'PRODUCTION';

        ItemJournalLine.Insert(true);

        CurrentLineNo += 10000;
    end;

    // Check if item is inventory
    local procedure IsInventoryItem(ItemNo: Code[20]): Boolean
    var
        Item: Record Item;
    begin
        if not Item.Get(ItemNo) then
            exit(false);

        exit(Item.Type = Item.Type::Inventory);
    end;

    // Check if item is a manufactured item (BOM)
    // local procedure IsManufacturedItem(ItemNo: Code[20]): Boolean
    // var
    //     Item: Record Item;
    // begin
    //     if not Item.Get(ItemNo) then
    //         exit(false);

    //     exit(Item."Assembly BOM");
    // end;
    local procedure IsManufacturedItem(ItemNo: Code[20]): Boolean
    var
        Item: Record Item;
    begin
        if not Item.Get(ItemNo) then
            exit(false);
        Item.CalcFields("Assembly BOM");
        exit(Item."Assembly BOM");
    end;

    // var 
    // x: Record "Gen. Journal Line";

}