-- This is a "Find and replace" script that can be used for attachment paths of all DBServer projects in a Citavi database.
-- You can use this script if you want to relocate all Citavi attachments to another file server, for example.

-- In the @SearchFor parameter (placeholder <SearchFor>), enter the part of the path you want to replace.
-- In the @ReplaceWith parameter (placeholder <ReplaceWith>), enter the replacement text.

set noexec off
set nocount on

declare @SearchFor nvarchar(2000) = '<SearchFor>'
declare @ReplaceWith nvarchar(2000) = '<ReplaceWith>'

if @SearchFor is null or len(@SearchFor) = 0 or charindex('<', @SearchFor) > 0 or charindex('>', @SearchFor) > 0
begin
	raiserror('Parameter ''@SearchFor'' is empty or invalid', 11, -1)
	set noexec on
end

if charindex('<', @ReplaceWith) > 0 or charindex('>', @ReplaceWith) > 0
begin
	raiserror('Parameter ''@ReplaceWith'' is empty or invalid', 11, -1)
	set noexec on
end

if @ReplaceWith is null
set @ReplaceWith = ''

declare @SchemaName nvarchar(2000);
declare @Sql nvarchar(2000);
declare @Before nvarchar(2000);
declare @After nvarchar(2000);

declare Schema_Cursor cursor for
select s.[Name] 
from sys.schemas s
inner join sys.tables t on s.schema_id = t.schema_id
where t.[Name] = 'ProjectSettings'

open Schema_Cursor;

fetch next from Schema_Cursor
into @SchemaName;

while @@fetch_status = 0
begin

	select @Sql = 'select @Result = [Value] ' +
                  'from ' + QUOTENAME(@SchemaName) + '.[ProjectSettings] ' +
                  'where [Key] =''ProjectSettings_AttachmentsFolderPath_1''';
	SET @Before = '@Result nvarchar(200) OUTPUT';

	exec sp_executesql @Sql, @Before, @Result=@Before OUTPUT;

	select @Sql = 'update ' + QUOTENAME(@SchemaName) + '.[ProjectSettings] ' +
                  'set [Value] = replace([Value],  ''' + @SearchFor + ''', ''' + @ReplaceWith + ''') ' +
                  'where [Key] = ''ProjectSettings_AttachmentsFolderPath_1''';

	exec sp_executesql @Sql

	select @Sql = 'select @Result = [Value] ' +
                  'from ' + QUOTENAME(@SchemaName) + '.[ProjectSettings] ' +
                  'where [Key] =''ProjectSettings_AttachmentsFolderPath_1''';
	SET @After = '@Result nvarchar(200) OUTPUT';

	exec sp_executesql @Sql, @After, @Result=@After OUTPUT;

	print 'Project ' + @SchemaName + ':'
	print 'Before: ' + @Before
	print 'Now   : ' + @After
	print ''

	fetch next from Schema_Cursor
	into @SchemaName;
end

close Schema_Cursor;
deallocate Schema_Cursor;
