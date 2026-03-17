namespace ALProject.ALProject;

using Microsoft.Sales.Document;

pageextension 50102 SalesOrderExt extends "Sales Order"
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
                    DocConvert.SetRange(Type, DocConvert.Type::Sales);
                    DocConvert.SetRange("Document Type", Rec."Document Type"::Order); // Add this line!

                    if not DocConvert.IsEmpty() then // Better performance than FindFirst
                        Error('This %1 %2 already exists.', Rec."Document Type", Rec."No.");


                    DocConvert.Init();
                    DocConvert."No." := Rec."No.";
                    DocConvert.Type := DocConvert.Type::Sales;
                    DocConvert."Document Type" := DocConvert."Document Type"::Order;
                    DocConvert."Source No." := Rec."Sell-to Customer No.";
                    DocConvert.Insert(true);

                    Message('Document added to Convert list.');

                end;

            }
        }
    }
}
