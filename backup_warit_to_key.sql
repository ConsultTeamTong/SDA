SET NOCOUNT ON;
DECLARE @src   sysname = N'SBO_Warit';
DECLARE @dst   sysname = N'SBO_WARIT_KEY';
DECLARE @bak   nvarchar(4000);
DECLARE @sql   nvarchar(max);

/* timestamped backup path next to dst's data file folder */
DECLARE @dir nvarchar(4000) =
    LEFT( (SELECT TOP 1 physical_name FROM sys.master_files
           WHERE database_id = DB_ID(@dst) AND type_desc = 'ROWS'),
          LEN((SELECT TOP 1 physical_name FROM sys.master_files
               WHERE database_id = DB_ID(@dst) AND type_desc = 'ROWS'))
          - CHARINDEX('\', REVERSE((SELECT TOP 1 physical_name FROM sys.master_files
               WHERE database_id = DB_ID(@dst) AND type_desc = 'ROWS'))) );
SET @bak = @dir + N'\' + @src + N'_overwrite_KEY.bak';

PRINT '== Backup ' + @src + ' -> ' + @bak;
BACKUP DATABASE @src TO DISK = @bak
    WITH INIT, COMPRESSION, STATS = 10,
    NAME = N'SBO_Warit fresh backup for KEY overwrite';

/* build MOVE clauses: src logical name -> dst current physical path, by type+order */
DECLARE @move nvarchar(max) = N'';
;WITH s AS (
    SELECT logical_name = name, type_desc,
           rn = ROW_NUMBER() OVER (PARTITION BY type_desc ORDER BY file_id)
    FROM sys.master_files WHERE database_id = DB_ID(@src)
), d AS (
    SELECT physical_name, type_desc,
           rn = ROW_NUMBER() OVER (PARTITION BY type_desc ORDER BY file_id)
    FROM sys.master_files WHERE database_id = DB_ID(@dst)
)
SELECT @move = @move + N'    MOVE N''' + s.logical_name + N''' TO N''' + d.physical_name + N''',' + CHAR(13)+CHAR(10)
FROM s JOIN d ON s.type_desc = d.type_desc AND s.rn = d.rn;

SET @sql =
    N'ALTER DATABASE ' + QUOTENAME(@dst) + N' SET SINGLE_USER WITH ROLLBACK IMMEDIATE;' + CHAR(13)+CHAR(10) +
    N'RESTORE DATABASE ' + QUOTENAME(@dst) + N' FROM DISK = N''' + @bak + N''' WITH REPLACE, RECOVERY, STATS = 10,' + CHAR(13)+CHAR(10) +
    @move +
    N'    MOVE N''__dummy__'' TO N''__dummy__'';';
/* remove trailing dummy + fix last comma */
SET @sql = REPLACE(@sql, N',' + CHAR(13)+CHAR(10) + N'    MOVE N''__dummy__'' TO N''__dummy__'';',
                         N';' + CHAR(13)+CHAR(10));

PRINT '== Restore SQL:';
PRINT @sql;
EXEC sys.sp_executesql @sql;

ALTER DATABASE [SBO_WARIT_KEY] SET MULTI_USER;
PRINT '== DONE: SBO_Warit -> SBO_WARIT_KEY';
