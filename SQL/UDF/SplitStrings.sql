USE spring_2014_peer_evaluation
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Split]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
    DROP FUNCTION [dbo].[Split]
GO

CREATE FUNCTION [dbo].[Split] (@String VARCHAR(max), @Delimiter CHAR(1))       
	RETURNS
		@temptable TABLE (items VARCHAR(8000))       
	AS       
	BEGIN       
		DECLARE @idx INT       
		DECLARE @slice VARCHAR(8000)        
		SELECT @idx = 1       
		IF len(@String)<1 OR @String IS NULL  RETURN       
		while @idx!= 0       
		BEGIN       
			SET @idx = charindex(@Delimiter,@String)       
			IF @idx!=0       
				SET @slice = LEFT(@String,@idx - 1)       
			ELSE       
				SET @slice = @String       
			IF(len(@slice)>0)  
				INSERT INTO @temptable(Items) VALUES(@slice)       
			SET @String = RIGHT(@String,len(@String) - @idx)       
				IF len(@String) = 0 break       
		END   
	RETURN       
	END
GO



SELECT * FROM dbo.[Split]('ram. shyam" hari, gopal',' ')
