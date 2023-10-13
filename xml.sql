declare @XmlHandle int 
declare @MyTable TABLE 
( 
   ID int
) 

EXEC sp_xml_preparedocument @XmlHandle output, 
'<tblXML>
  <tblTable>
    <ID>1</ID>
  </tblTable>
  <tblTable>
    <ID>2</ID>
  </tblTable>
  <tblTable>
    <ID>3</ID>
  </tblTable>
  <tblTable>
    <ID>4</ID>
  </tblTable>
</tblXML>' 

insert into @MyTable 
SELECT ID
FROM  OPENXML (@XmlHandle, '/tblXML/tblTable', 2) 
            WITH (ID int) 
select * from @MyTable 

SELECT ID
FROM @MyTable 
for xml raw('tblTable'), elements, root('tblXML')