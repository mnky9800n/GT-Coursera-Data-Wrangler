USE summer_2013_mooc  -- Define your DB Name here
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Drop the function if it already exists
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetChildren]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
    DROP FUNCTION [dbo].[GetChildren]
GO

-- Create the function
CREATE FUNCTION [dbo].[GetChildren] (@childIDsJsonArray VARCHAR(MAX))  
    RETURNS 
	    @Children TABLE(ID varchar(max))--BIGINT) /*------the return value is a bigint, this should be varchar-------*/
    AS 
    BEGIN
        -- A temp table to store intermediary data
	    DECLARE @Temp TABLE(ID varchar(max))--BIGINT)	/*-----intermediary data is assumed to be bigint and yet it is varchar-------*/
    	
	    -- Remove whitespace
	    SET @childIDsJsonArray = LTRIM(RTRIM(ISNULL(@childIDsJsonArray, '')))
   	
	    -- If there's braces, get what's between them
	    IF CHARINDEX('[',@childIDsJsonArray) > 0
	    OR CHARINDEX(']',@childIDsJsonArray) < CHARINDEX('[',@childIDsJsonArray) /*-----this is very clever, find the next close bracket assumingthere is a following bracket-----*/
	        SELECT @childIDsJsonArray = SUBSTRING(@childIDsJsonArray
	                                             ,CHARINDEX('[',@childIDsJsonArray)+1
	                                             ,CHARINDEX(']',@childIDsJsonArray)-2)
	                                             
        -- Remove quotes
	    SELECT @childIDsJsonArray = REPLACE(@childIdsJsonArray,'"','')

        -- Initialize some variables
        DECLARE @delimeter CHAR, @size BIGINT, @index BIGINT, @child VARCHAR(max)
        SELECT @delimeter = ','
             , @size = LEN(@childIDsJsonArray) -- lentgh of string
             , @index = CHARINDEX(@delimeter,@childIDsJsonArray) -- location of delimeter
    	
	    WHILE @size > 0
            BEGIN
                IF @index = 0
                    SELECT @child = @childIDsJsonArray
                         , @size = 0
                ELSE
                    SELECT @child = SUBSTRING(@childIDsJsonArray,0,@index)
                         , @childIDsJsonArray = SUBSTRING(@childIDsJsonArray,@index+1,@size)
                         , @index = CHARINDEX(@delimeter,@childIDsJsonArray)
                         , @size = LEN(@childIDsJsonArray)
                
		--conversion required here!                    
                --IF isnumeric(@child) = 1
					INSERT INTO @Temp
						SELECT @child--CONVERT(varchar,@child) --BIGINT,@child)
            END
            
	    INSERT INTO @Children
	        SELECT DISTINCT ID
	        FROM @Temp
    	
	    RETURN
    END
GO

SELECT * from dbo.GetChildren('["4","5","6"]')

-- Some tests to make sure it doesnt assplode

SELECT * FROM GetChildren(null)
SELECT * FROM GetChildren('')
SELECT * FROM GetChildren('1')
SELECT * FROM GetChildren('[]')
SELECT * FROM GetChildren('[1]')
SELECT * FROM GetChildren('[1,2,3]')
SELECT * FROM GetChildren('[,,]')
SELECT * FROM GetChildren('["","",""]')
SELECT * FROM GetChildren('["1","2","3"]')
SELECT * FROM GetChildren('[3,3,3]')
SELECT * FROM GetChildren('["3","3","3"]')
SELECT * FROM GetChildren('["1","2",]')
SELECT * FROM GetChildren('[1,2,]')
SELECT * FROM GetChildren('["1","2",]')
SELECT * FROM GetChildren('[,2,3]')
SELECT * FROM GetChildren('[,"2","3"]')
SELECT * FROM GetChildren('1,2,3')
SELECT * FROM GetChildren(',,')
SELECT * FROM GetChildren('"","",""')
SELECT * FROM GetChildren('"1","2","3"')
