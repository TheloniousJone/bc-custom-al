codeunit 80151 I9G_DimensionSetCleanupCU
{
    Permissions = tabledata "Dimension Set Entry" = RIMD,
                  tabledata "Dimension Set Tree Node" = RIMD,
                  tabledata "Config. Package" = RIMD,
                  tabledata "Config. Package Table" = RIMD,
                  tabledata "Sales Line" = RIMD,
                  tabledata "Sales Line Archive" = RIMD,
                  tabledata "Sales Header" = RIMD,
                  tabledata "Sales Header Archive" = RIMD,
                  tabledata "G/L Entry" = RIMD,
                  tabledata "Item Ledger Entry" = RIMD,
                  tabledata "Value Entry" = RIMD,
                  tabledata "Sales Shipment Line" = RIMD,
                  tabledata "Sales Invoice Line" = RIMD,
                  tabledata "Sales Cr.Memo Line" = RIMD,
                  tabledata "Return Receipt Line" = RIMD;

    procedure BackUpDimensionSetsAsConfigPackage()
    var
        ConfigPackage: Record "Config. Package";
        ConfigPackageTable: Record "Config. Package Table";
        ConfigPackageMgt: Codeunit "Config. Package Management";
        ConfigExcelExchange: Codeunit "Config. Excel Exchange";
        PackageCode: Code[20];
    begin
        PackageCode := 'DIMSETBACKUP';
        if ConfigPackage.Get(PackageCode) then
            ConfigPackage.Delete(true);
        ConfigPackage.Init();
        ConfigPackage.Code := PackageCode;
        ConfigPackage."Package Name" := 'Dimension Set Entry Backup';
        ConfigPackage.Insert(true);
        ConfigPackageMgt.InsertPackageTable(ConfigPackageTable, PackageCode, Database::"Dimension Set Entry");
        ConfigPackageMgt.InsertPackageTable(ConfigPackageTable, PackageCode, Database::"Dimension Set Tree Node");
        ConfigPackageTable.SetRange("Package Code", PackageCode);
        ConfigExcelExchange.ExportExcelFromTables(ConfigPackageTable);
    end;

    procedure CountDimSetRepointImpact()
    var
        Field: Record Field;
        RepointMap: Dictionary of [Integer, Integer];
        DupIDs: List of [Integer];
        Result: TextBuilder;
        Affected: Integer;
        GrandTotal: Integer;
    begin
        BuildRepointMap(RepointMap);
        DupIDs := RepointMap.Keys();
        Result.AppendLine(StrSubstNo('Duplicate sets to repoint then delete: %1', DupIDs.Count));

        Field.SetRange(FieldName, 'Dimension Set ID');
        Field.SetRange(Type, Field.Type::Integer);
        Field.SetRange(Class, Field.Class::Normal);
        if Field.FindSet() then
            repeat
                if not IsExcludedTable(Field.TableNo) then begin
                    Affected := CountAffectedInTable(Field.TableNo, Field."No.", DupIDs);
                    if Affected > 0 then begin
                        Result.AppendLine(StrSubstNo('  %1 (%2): %3', Field.TableName, Field.TableNo, Affected));
                        GrandTotal += Affected;
                    end;
                end;
            until Field.Next() = 0;

        Result.AppendLine(StrSubstNo('TOTAL references: %1', GrandTotal));
        Message(Result.ToText());
    end;

    procedure RepointAndDeleteDuplicateDimensionSets()
    var
        Field: Record Field;
        RepointMap: Dictionary of [Integer, Integer];
        FailedTables: List of [Text];
        DupID: Integer;
    begin
        BuildRepointMap(RepointMap);
        if RepointMap.Count = 0 then begin
            Message('No duplicate dimension sets found.');
            exit;
        end;
        if not Confirm(StrSubstNo('Repoint references and delete %1 duplicate dimension sets. Did you run option 5 (backup) and option 6 (count) first?', RepointMap.Count), false) then
            exit;

        Field.SetRange(FieldName, 'Dimension Set ID');
        Field.SetRange(Type, Field.Type::Integer);
        Field.SetRange(Class, Field.Class::Normal);
        if Field.FindSet() then
            repeat
                if not IsExcludedTable(Field.TableNo) then
                    if not TryRepointTable(Field.TableNo, Field."No.", RepointMap) then
                        FailedTables.Add(StrSubstNo('%1 (%2): %3', Field.TableName, Field.TableNo, GetLastErrorText()));
            until Field.Next() = 0;

        if FailedTables.Count > 0 then
            Error('Could not repoint these tables - aborted before any delete:\%1', ListToText(FailedTables));

        foreach DupID in RepointMap.Keys() do
            DeleteDimensionSet(DupID);
        Commit();
        Message('Done. Repointed references and removed %1 duplicate dimension sets.', RepointMap.Count);
    end;

    // Builds map: duplicateSetID -> canonical (tree-authoritative) SetID
    local procedure BuildRepointMap(var RepointMap: Dictionary of [Integer, Integer])
    var
        DimensionSetEntry: Record "Dimension Set Entry";
        DimSetEntryLoad: Record "Dimension Set Entry";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimMgt: Codeunit DimensionManagement;
        CurrentSetID: Integer;
        CanonicalID: Integer;
    begin
        Clear(RepointMap);
        DimensionSetEntry.SetCurrentKey("Dimension Set ID", "Dimension Code");
        if not DimensionSetEntry.FindSet() then
            exit;
        repeat
            CurrentSetID := DimensionSetEntry."Dimension Set ID";
            TempDimSetEntry.Reset();
            TempDimSetEntry.DeleteAll();
            DimSetEntryLoad.SetRange("Dimension Set ID", CurrentSetID);
            if DimSetEntryLoad.FindSet() then
                repeat
                    TempDimSetEntry := DimSetEntryLoad;
                    TempDimSetEntry.Insert();
                until DimSetEntryLoad.Next() = 0;

            CanonicalID := DimMgt.GetDimensionSetID(TempDimSetEntry);
            if (CanonicalID <> 0) and (CanonicalID <> CurrentSetID) then
                if not RepointMap.ContainsKey(CurrentSetID) then
                    RepointMap.Add(CurrentSetID, CanonicalID);

            DimensionSetEntry.SetRange("Dimension Set ID", CurrentSetID);
            DimensionSetEntry.FindLast();
            DimensionSetEntry.SetRange("Dimension Set ID");
        until DimensionSetEntry.Next() = 0;
    end;

    local procedure CountAffectedInTable(TableNo: Integer; FieldNo: Integer; DupIDs: List of [Integer]): Integer
    var
        Cnt: Integer;
    begin
        if TryCountAffected(TableNo, FieldNo, DupIDs, Cnt) then
            exit(Cnt);
        exit(0);
    end;

    [TryFunction]
    local procedure TryCountAffected(TableNo: Integer; FieldNo: Integer; DupIDs: List of [Integer]; var Cnt: Integer)
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
        FilterBuilder: TextBuilder;
        Id: Integer;
        InChunk: Integer;
    begin
        Cnt := 0;
        RecRef.Open(TableNo);
        if RecRef.IsEmpty() then begin
            RecRef.Close();
            exit;
        end;
        FieldRef := RecRef.Field(FieldNo);

        foreach Id in DupIDs do begin
            if FilterBuilder.Length() > 0 then
                FilterBuilder.Append('|');
            FilterBuilder.Append(Format(Id));
            InChunk += 1;

            if InChunk >= 100 then begin
                FieldRef.SetFilter(FilterBuilder.ToText());
                Cnt += RecRef.Count();
                FilterBuilder.Clear();
                InChunk := 0;
            end;
        end;

        if InChunk > 0 then begin
            FieldRef.SetFilter(FilterBuilder.ToText());
            Cnt += RecRef.Count();
        end;

        RecRef.Close();
    end;

    [TryFunction]
    local procedure TryRepointTable(TableNo: Integer; FieldNo: Integer; var RepointMap: Dictionary of [Integer, Integer])
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
        FilterBuilder: TextBuilder;
        DupID: Integer;
        InChunk: Integer;
        Touched: Boolean;
    begin
        RecRef.Open(TableNo);
        if RecRef.IsEmpty() then begin
            RecRef.Close();
            exit;
        end;
        RecRef.SetLoadFields(FieldNo);
        FieldRef := RecRef.Field(FieldNo);
        foreach DupID in RepointMap.Keys() do begin
            if FilterBuilder.Length() > 0 then
                FilterBuilder.Append('|');
            FilterBuilder.Append(Format(DupID));
            InChunk += 1;
            if InChunk >= 100 then begin
                if RepointChunk(RecRef, FieldRef, FilterBuilder.ToText(), RepointMap) then
                    Touched := true;
                FilterBuilder.Clear();
                InChunk := 0;
            end;
        end;
        if InChunk > 0 then
            if RepointChunk(RecRef, FieldRef, FilterBuilder.ToText(), RepointMap) then
                Touched := true;
        RecRef.Close();
        if Touched then
            Commit();
    end;

    local procedure RepointChunk(var RecRef: RecordRef; var FieldRef: FieldRef; FilterTxt: Text; var RepointMap: Dictionary of [Integer, Integer]): Boolean
    var
        CurrentID: Integer;
        CanonicalID: Integer;
        Touched: Boolean;
    begin
        FieldRef.SetFilter(FilterTxt);
        if RecRef.FindSet(true) then
            repeat
                CurrentID := FieldRef.Value();
                RepointMap.Get(CurrentID, CanonicalID);
                FieldRef.Value := CanonicalID;
                RecRef.Modify(false);
                Touched := true;
            until RecRef.Next() = 0;
        FieldRef.SetRange();
        exit(Touched);
    end;

    local procedure DeleteDimensionSet(DimSetID: Integer)
    var
        DimensionSetEntry: Record "Dimension Set Entry";
    begin
        DimensionSetEntry.Reset();
        DimensionSetEntry.SetRange("Dimension Set ID", DimSetID);
        if DimensionSetEntry.FindSet() then begin
            repeat
                DimensionSetEntry.Delete();
            until DimensionSetEntry.Next() = 0;
        end;
    end;

    local procedure IsExcludedTable(TableNo: Integer): Boolean
    var
        TableMetadata: Record "Table Metadata";
    begin
        if TableNo in [Database::"Dimension Set Entry", Database::"Dimension Set Tree Node"] then
            exit(true);
        if TableMetadata.Get(TableNo) then
            if TableMetadata.ObsoleteState <> TableMetadata.ObsoleteState::No then
                exit(true);
        exit(false);
    end;

    local procedure ListToText(MyList: List of [Text]): Text
    var
        Builder: TextBuilder;
        Item: Text;
    begin
        foreach Item in MyList do begin
            Builder.Append(Item);
            Builder.Append('\');
        end;
        exit(Builder.ToText());
    end;
}
