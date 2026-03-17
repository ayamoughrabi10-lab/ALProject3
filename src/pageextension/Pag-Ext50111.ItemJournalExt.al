pageextension 50111 "Item Journal Ext" extends "Item Journal"
{
    actions
    {
        addlast(processing)
        {
            action(CreateProductionLines)
            {
                Caption = 'Explode Production BOM';
                ApplicationArea = All;
                Image = Production;

                trigger OnAction()
                var
                    ProdHandler: Codeunit ProductionJournal;
                    Item: Record Item;
                begin
                    // Only run if the item on the current line is an Inventory Item
                    if Item.Get(Rec."Item No.") and (Item.Type = Item.Type::Inventory) then begin
                        ProdHandler.CreateProductionJournal(
                            Rec."Item No.",
                            Rec.Quantity,
                            Rec."Journal Template Name",
                            Rec."Journal Batch Name"
                        );
                        Message('Production lines created for Item %1', Rec."Item No.");
                    end else
                        Error('The selected line must contain a valid Inventory Item.');
                end;
            }
        }
    }
}