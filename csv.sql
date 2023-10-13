USE CaringPeople
go

SELECT AideID,
	STUFF((
		SELECT ',' + t.[SkillName]
		FROM @tmlAideMissingSkills t
		WHERE t.AideID = t1.AideID
		ORDER BY t.[SkillName]
		FOR XML PATH('')
	),1,1,'') AS SkillName_csv
FROM @tmlAideMissingSkills t1
GROUP BY AideID