page 50110 "Item Summary List"
{
    PageType = List;
    SourceTable = "Item Summary";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Item Summary';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.") { Editable = false; }
                field("Entry Date"; Rec."Entry Date") { Editable = false; }
                field("User ID"; Rec."User ID") { Editable = false; }
                field("Item No."; Rec."Item No.") { }
                field(Description; Rec.Description) { Editable = false; }
                field("Unit of Measure"; Rec."Unit of Measure") { Editable = false; }
                field(Barcode; Rec.Barcode) { }
                field("Item Inventory"; Rec."Item Inventory") { Editable = false; }
                field("Item Cost"; Rec."Item Cost") { Editable = false; }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(UpdateItemCost)
            {
                Caption = 'Update Item Cost';
                Image = Refresh;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ValueEntryRec: Record "Value Entry";
                    LastCost: Decimal;
                begin
                    // Check that Item No. is selected
                    if Rec."Item No." = '' then begin
                        Message('Please select an Item first.');
                        exit;
                    end;
                    ValueEntryRec.SetFilter("Item No.", '%1', Rec."Item No.");
                    if ValueEntryRec.FindLast() then begin
                        LastCost := ValueEntryRec."Cost Amount (Actual)";
                        Rec."Item Cost" := LastCost;
                        Rec.Modify(); // Save the updated cost
                        Message('Item Cost updated to %1 for Item %2', LastCost, Rec."Item No.");
                    end else
                        Message('No Value Entry found for Item %1', Rec."Item No.");
                end;
            }
        }
    }

}
