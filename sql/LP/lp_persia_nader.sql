INSERT INTO RequirementSetRequirements VALUES
	('OPPONENT_IS_FULL_HEALTH_REQUIREMENTS', 'OPPONENT_IS_NOT_DISTRICT');
UPDATE Modifiers SET SubjectRequirementSetId = 'OPPONENT_IS_FULL_HEALTH_UNIT_REQUIREMENTS' WHERE RequirementSetRequirements = 'OPPONENT_IS_FULL_HEALTH_REQUIREMENTS';
UPDATE RequirementSetRequirements SET RequirementSetId = 'OPPONENT_IS_FULL_HEALTH_UNIT_REQUIREMENTS' WHERE RequirementSetId = 'OPPONENT_IS_FULL_HEALTH_REQUIREMENTS';
