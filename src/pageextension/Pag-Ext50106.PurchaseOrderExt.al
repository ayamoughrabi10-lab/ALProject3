namespace ALProject.ALProject;

using Microsoft.Purchases.Document;

pageextension 50106 PurchaseOrderExt extends "Purchase Order"
{
    actions
    {
        addlast(Processing)
        {
            action(AddToConvert)
            {
                Caption = 'Add to Convert';
                ApplicationArea = all;

                trigger OnAction()
                var
                    DocConvert: Record "Documents Convert";
                begin
                    DocConvert.Reset();
                    DocConvert.SetRange("No.", rec."No.");
                    DocConvert.SetRange(Type, DocConvert.Type::Purchase);
                    DocConvert.SetRange("Document Type", Rec."Document Type"::Order); // Add this line!

                    if not DocConvert.IsEmpty() then // Better performance than FindFirst
                        Error('This %1 %2 already exists.', Rec."Document Type", Rec."No.");


                    DocConvert.Init();
                    DocConvert."No." := Rec."No.";
                    DocConvert.Type := DocConvert.Type::Purchase;
                    DocConvert."Document Type" := DocConvert."Document Type"::Order;
                    DocConvert."Source No." := Rec."Buy-from Vendor No.";
                    DocConvert.Insert(true);

                    Message('Document added to Convert list.');

                end;

            }
        }
    }
}
