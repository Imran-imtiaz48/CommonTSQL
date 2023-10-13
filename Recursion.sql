DECLARE @stack TABLE (
    AutoID INT IDENTITY, 
    lvl INT, 
    CategoryID int, 
    ParentID INT)
    
-- output table
DECLARE @output TABLE(
    lvl INT, 
    CategoryID INT, 
    ParentID INT)

-- Populate the output table with root level categories
INSERT INTO @output (lvl, CategoryID, ParentID) 
SELECT 0, CategoryID, ParentID 
FROM Categories 
WHERE ParentID IS NULL

-- Populate the stack table with root level categories
INSERT INTO @stack (lvl, CategoryID, ParentID) 
SELECT 0, CategoryID, ParentID 
FROM Categories 
WHERE ParentID IS NULL

-- Generate the category relationship chain
DECLARE @id INT, @lvl INT

WHILE EXISTS(SELECT * FROM @stack) BEGIN
    -- take the last row from the stack
    SELECT TOP 1 
        @id = CategoryID,
        @lvl = lvl
    FROM @stack
    ORDER BY AutoID DESC
    
    -- delete the row from stack
    DELETE FROM @stack WHERE CategoryID = @id
    
    -- process matching rows and insert to output
    INSERT INTO @output (lvl, CategoryID, ParentID) 
    SELECT @lvl + 1, CategoryID, ParentID 
    FROM Categories 
    WHERE ParentID = @id

    -- add to stack too.
    INSERT INTO @stack (lvl, CategoryID, ParentID) 
    SELECT @lvl + 1, CategoryID, ParentID 
    FROM Categories 
    WHERE ParentID = @id
    
END