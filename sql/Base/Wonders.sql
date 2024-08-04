--=============
--== WONDERS ==
--=============

-- cristo gets 1 relic + reduce cost
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType , RunOnce , Permanent)
	VALUES ('WONDER_GRANT_RELIC_BBG' , 'MODIFIER_PLAYER_GRANT_RELIC' , 1 , 1);	
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('WONDER_GRANT_RELIC_BBG' , 'Amount' , '1');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId) VALUES
	('BUILDING_CRISTO_REDENTOR', 'WONDER_GRANT_RELIC_BBG');

UPDATE Buildings SET Cost=1220 WHERE BuildingType='BUILDING_CRISTO_REDENTOR';

-- Cristo bonus on beach resort reduced to +75%
UPDATE ModifierArguments SET Value=150 WHERE ModifierId='CRISTOREDENTOR_BEACHTOURISM' AND Name='ScalingFactor';

-- Hanging Gardens gives +1 housing to cities within 6 tiles
UPDATE Buildings SET Housing='1' WHERE BuildingType='BUILDING_HANGING_GARDENS';
INSERT OR IGNORE INTO BuildingModifiers (BuildingType , ModifierId)
	VALUES ('BUILDING_HANGING_GARDENS' , 'HANGING_GARDENS_REGIONAL_HOUSING');
INSERT OR IGNORE INTO Modifiers (ModifierId , ModifierType, SubjectRequirementSetId)
	VALUES ('HANGING_GARDENS_REGIONAL_HOUSING' , 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_HOUSING' , 'HANGING_GARDENS_REGIONAL_HOUSING_REQUIREMENTS');
INSERT OR IGNORE INTO ModifierArguments (ModifierId , Name , Value)
	VALUES ('HANGING_GARDENS_REGIONAL_HOUSING' , 'Amount' , '1');
INSERT OR IGNORE INTO RequirementSets (RequirementSetId , RequirementSetType)
	VALUES ('HANGING_GARDENS_REGIONAL_HOUSING_REQUIREMENTS' , 'REQUIREMENTSET_TEST_ANY');
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId , RequirementId)
	VALUES ('HANGING_GARDENS_REGIONAL_HOUSING_REQUIREMENTS' , 'REQUIRES_PLOT_HAS_HANGING_GARDENS_WITHIN_6');
INSERT OR IGNORE INTO Requirements (RequirementId , RequirementType)
	VALUES ('REQUIRES_PLOT_HAS_HANGING_GARDENS_WITHIN_6' , 'REQUIREMENT_PLOT_ADJACENT_BUILDING_TYPE_MATCHES');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
	VALUES ('REQUIRES_PLOT_HAS_HANGING_GARDENS_WITHIN_6' , 'BuildingType' ,'BUILDING_HANGING_GARDENS');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
	VALUES ('REQUIRES_PLOT_HAS_HANGING_GARDENS_WITHIN_6' , 'MaxRange' ,'6');
INSERT OR IGNORE INTO RequirementArguments (RequirementId , Name , Value)
	VALUES ('REQUIRES_PLOT_HAS_HANGING_GARDENS_WITHIN_6' , 'MinRange' ,'0');

-- Great Library unlocks at Drama & Poetry instead of Recorded History
UPDATE Buildings SET PrereqCivic='CIVIC_DRAMA_POETRY' WHERE BuildingType='BUILDING_GREAT_LIBRARY';

-- Venetian Arsenal gives 80% production boost to all naval units in all cities instead of an extra naval unit in its city each time you build one
DELETE FROM BuildingModifiers WHERE	BuildingType='BUILDING_VENETIAN_ARSENAL';

INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ANCIENT_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ANCIENT');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ATOMIC_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ATOMIC');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('CLASSICAL_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_CLASSICAL');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INDUSTRIAL_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INDUSTRIAL');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INFORMATION_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INFORMATION');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MEDIEVAL_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MEDIEVAL');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MODERN_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MODERN');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('RENAISSANCE_NAVAL_MELEE_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_MELEE_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_RENAISSANCE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_MELEE_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_MELEE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_MELEE_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');

INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ANCIENT_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ANCIENT');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ATOMIC_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ATOMIC');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('CLASSICAL_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_CLASSICAL');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INDUSTRIAL_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INDUSTRIAL');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INFORMATION_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INFORMATION');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MEDIEVAL_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MEDIEVAL');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MODERN_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MODERN');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('RENAISSANCE_NAVAL_RANGED_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_RANGED_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_RENAISSANCE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_RANGED_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RANGED');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_RANGED_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');

INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ANCIENT_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ANCIENT');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ATOMIC_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ATOMIC');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('CLASSICAL_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_CLASSICAL');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INDUSTRIAL_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INDUSTRIAL');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INFORMATION_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INFORMATION');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MEDIEVAL_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MEDIEVAL');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MODERN_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MODERN');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('RENAISSANCE_NAVAL_RAIDER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_RAIDER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_RENAISSANCE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_RAIDER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_RAIDER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_RAIDER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');

INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ANCIENT_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ANCIENT');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ANCIENT_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('ATOMIC_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_ATOMIC');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('ATOMIC_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('CLASSICAL_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_CLASSICAL');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('CLASSICAL_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INDUSTRIAL_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INDUSTRIAL');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INDUSTRIAL_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('INFORMATION_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_INFORMATION');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('INFORMATION_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MEDIEVAL_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MEDIEVAL');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MEDIEVAL_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('MODERN_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_MODERN');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('MODERN_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, RunOnce, NewOnly, Permanent)
VALUES ('RENAISSANCE_NAVAL_CARRIER_PRODUCTION', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION', 0, 0, 0);
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_CARRIER_PRODUCTION', 'EraType', 'ARGTYPE_IDENTITY', 'ERA_RENAISSANCE');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_CARRIER_PRODUCTION', 'UnitPromotionClass', 'ARGTYPE_IDENTITY', 'PROMOTION_CLASS_NAVAL_CARRIER');
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Type, Value)
VALUES ('RENAISSANCE_NAVAL_CARRIER_PRODUCTION', 'Amount', 'ARGTYPE_IDENTITY', '75');

INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ANCIENT_NAVAL_MELEE_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ATOMIC_NAVAL_MELEE_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'CLASSICAL_NAVAL_MELEE_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INDUSTRIAL_NAVAL_MELEE_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INFORMATION_NAVAL_MELEE_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MEDIEVAL_NAVAL_MELEE_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MODERN_NAVAL_MELEE_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'RENAISSANCE_NAVAL_MELEE_PRODUCTION');

INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ANCIENT_NAVAL_RANGED_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ATOMIC_NAVAL_RANGED_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'CLASSICAL_NAVAL_RANGED_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INDUSTRIAL_NAVAL_RANGED_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INFORMATION_NAVAL_RANGED_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MEDIEVAL_NAVAL_RANGED_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MODERN_NAVAL_RANGED_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'RENAISSANCE_NAVAL_RANGED_PRODUCTION');

INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ANCIENT_NAVAL_RAIDER_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ATOMIC_NAVAL_RAIDER_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'CLASSICAL_NAVAL_RAIDER_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INDUSTRIAL_NAVAL_RAIDER_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INFORMATION_NAVAL_RAIDER_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MEDIEVAL_NAVAL_RAIDER_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MODERN_NAVAL_RAIDER_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'RENAISSANCE_NAVAL_RAIDER_PRODUCTION');

INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ANCIENT_NAVAL_CARRIER_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'ATOMIC_NAVAL_CARRIER_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'CLASSICAL_NAVAL_CARRIER_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INDUSTRIAL_NAVAL_CARRIER_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'INFORMATION_NAVAL_CARRIER_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MEDIEVAL_NAVAL_CARRIER_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'MODERN_NAVAL_CARRIER_PRODUCTION');
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_VENETIAN_ARSENAL', 'RENAISSANCE_NAVAL_CARRIER_PRODUCTION');

-- Colosseum - reduce culture to 1 (from 2)
UPDATE Building_YieldChanges SET YieldChange=1 WHERE BuildingType='BUILDING_COLOSSEUM' AND YieldType='YIELD_CULTURE';

-- Jabel Barkal - Increase strategics ressource storage by 20 (online speed).


-- Chichen Itza - Culture +2 / prod +1 for all jungle in the empire.
UPDATE Modifiers SET ModifierType='MODIFIER_PLAYER_ADJUST_PLOT_YIELD' WHERE ModifierId='CHICHEN_ITZA_JUNGLE_CULTURE';
UPDATE Modifiers SET SubjectRequirementSetId='PLOT_HAS_JUNGLE_REQUIREMENTS' WHERE ModifierId='CHICHEN_ITZA_JUNGLE_CULTURE';
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('CHICHEN_ITZA_JUNGLE_CULTURE', 'YieldType', 'YIELD_CULTURE'),
    ('CHICHEN_ITZA_JUNGLE_CULTURE', 'Amount', '1');

UPDATE Modifiers SET ModifierType='MODIFIER_PLAYER_ADJUST_PLOT_YIELD' WHERE ModifierId='CHICHEN_ITZA_JUNGLE_PRODUCTION';
UPDATE Modifiers SET SubjectRequirementSetId='PLOT_HAS_JUNGLE_REQUIREMENTS' WHERE ModifierId='CHICHEN_ITZA_JUNGLE_PRODUCTION';
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('CHICHEN_ITZA_JUNGLE_PRODUCTION', 'YieldType', 'YIELD_PRODUCTION'),
    ('CHICHEN_ITZA_JUNGLE_PRODUCTION', 'Amount', '1');
--CHICHEN_ITZA_JUNGLE_CULTURE_MODIFIER and CHICHEN_ITZA_PRODUCTION_CULTURE_MODIFIER are not used anymore

-- Hagia Sophia - Missionaries/apostles recieve +2 movement and missionaries are 30% cheaper to purchase.
INSERT INTO Modifiers (ModifierId , ModifierType) VALUES
	('HAGIA_SOPHIA_GRANT_MISSIONARY_APOSTLE_MOVEMENT' , 'MODIFIER_PLAYER_UNITS_GRANT_ABILITY'),
	('HAGIA_SOPHIA_ADJUST_MISSIONARY_APOSTLE_MOVEMENT' , 'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT'),
	('HAGIA_SOPHIA_ADJUST_MISSIONARY_DISCOUNT' , 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_PURCHASE_COST');
INSERT INTO Types (Type, Kind) VALUES
    ('ABILITY_HAGIA_SOPHIA_MISSIONARY_APOSTLE_MOVEMENT', 'KIND_ABILITY');
INSERT INTO TypeTags (Type, Tag) VALUES
    ('ABILITY_HAGIA_SOPHIA_MISSIONARY_APOSTLE_MOVEMENT', 'CLASS_RELIGIOUS');
INSERT INTO UnitAbilities(UnitAbilityType, Name, Description, Inactive) VALUES
    ('ABILITY_HAGIA_SOPHIA_MISSIONARY_APOSTLE_MOVEMENT', 'LOC_HAGIA_SOPHIA_MOVEMENT_ABILITY', 'LOC_HAGIA_SOPHIA_MOVEMENT_ABILITY', 1);
INSERT INTO UnitAbilityModifiers (UnitAbilityType, ModifierId) VALUES
    ('ABILITY_HAGIA_SOPHIA_MISSIONARY_APOSTLE_MOVEMENT', 'HAGIA_SOPHIA_ADJUST_MISSIONARY_APOSTLE_MOVEMENT');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('HAGIA_SOPHIA_GRANT_MISSIONARY_APOSTLE_MOVEMENT', 'AbilityType', 'ABILITY_HAGIA_SOPHIA_MISSIONARY_APOSTLE_MOVEMENT'),
    ('HAGIA_SOPHIA_ADJUST_MISSIONARY_APOSTLE_MOVEMENT', 'Amount', '2'),
    ('HAGIA_SOPHIA_ADJUST_MISSIONARY_DISCOUNT', 'UnitType', 'UNIT_MISSIONARY'),
    ('HAGIA_SOPHIA_ADJUST_MISSIONARY_DISCOUNT', 'Amount', '25');
INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES
	('BUILDING_HAGIA_SOPHIA', 'HAGIA_SOPHIA_GRANT_MISSIONARY_APOSTLE_MOVEMENT'),
	('BUILDING_HAGIA_SOPHIA', 'HAGIA_SOPHIA_ADJUST_MISSIONARY_DISCOUNT');

-- Mont St. Michel - Culture +1 for flood plains in the empire. (unless you wanna split this change amongst many dlc recreate the reqs and use abstract queries)
CREATE TABLE Floodplains_tmp(
	FloodplainType TEXT NOT NULL
	);
--populate
INSERT INTO Floodplains_tmp(FloodplainType)
	SELECT Features.FeatureType 
	FROM Features WHERE FeatureType LIKE '%FLOODPLAINS%';
--Create Reqs and Reqsets, use INSERT OR IGNORE to not clash with similar code
INSERT OR IGNORE INTO Requirements(RequirementId, RequirementType)
	SELECT 'PLOT_HAS_'||Floodplains_tmp.FloodplainType||'_REQ_BBG', 'REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES'
	FROM Floodplains_tmp;
INSERT OR IGNORE INTO RequirementArguments(RequirementId, Name, Value)
	SELECT 'PLOT_HAS_'||Floodplains_tmp.FloodplainType||'_REQ_BBG', 'FeatureType', Floodplains_tmp.FloodplainType
	FROM Floodplains_tmp;
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType)
	SELECT 'PLOT_HAS_'||Floodplains_tmp.FloodplainType||'_REQSET_BBG', 'REQUIREMENTSET_TEST_ALL'
	FROM Floodplains_tmp;
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId)
	SELECT 'PLOT_HAS_'||Floodplains_tmp.FloodplainType||'_REQSET_BBG', 'PLOT_HAS_'||Floodplains_tmp.FloodplainType||'_REQ_BBG'
	FROM Floodplains_tmp;
--Modifiers
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
	SELECT 'MONT_ST_MICHEL_CULTURE_'||Floodplains_tmp.FloodplainType, 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'PLOT_HAS_'||Floodplains_tmp.FloodplainType||'_REQSET_BBG'
	FROM Floodplains_tmp;
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
	SELECT 'MONT_ST_MICHEL_FOOD_'||Floodplains_tmp.FloodplainType, 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'PLOT_HAS_'||Floodplains_tmp.FloodplainType||'_REQSET_BBG'
	FROM Floodplains_tmp;
INSERT INTO ModifierArguments (ModifierId, Name, Value)
	SELECT 'MONT_ST_MICHEL_CULTURE_'||Floodplains_tmp.FloodplainType, 'YieldType', 'YIELD_CULTURE'
	FROM Floodplains_tmp;
INSERT INTO ModifierArguments (ModifierId, Name, Value)
	SELECT 'MONT_ST_MICHEL_CULTURE_'||Floodplains_tmp.FloodplainType, 'Amount', '1'
	FROM Floodplains_tmp;
INSERT INTO ModifierArguments (ModifierId, Name, Value)
	SELECT 'MONT_ST_MICHEL_FOOD_'||Floodplains_tmp.FloodplainType, 'YieldType', 'YIELD_FOOD'
	FROM Floodplains_tmp;
INSERT INTO ModifierArguments (ModifierId, Name, Value)
	SELECT 'MONT_ST_MICHEL_FOOD_'||Floodplains_tmp.FloodplainType, 'Amount', '1'
	FROM Floodplains_tmp;
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
	SELECT 'BUILDING_MONT_ST_MICHEL', 'MONT_ST_MICHEL_CULTURE_'||Floodplains_tmp.FloodplainType
	FROM Floodplains_tmp;
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
	SELECT 'BUILDING_MONT_ST_MICHEL', 'MONT_ST_MICHEL_FOOD_'||Floodplains_tmp.FloodplainType
	FROM Floodplains_tmp;
--DELETE FROM BuildingModifiers WHERE BuildingType='BUILDING_MONT_ST_MICHEL' AND ModifierId='MONT_ST_MICHEL_GRANT_MARTYR'; (We weren't supposed to drop Martyr)
DROP TABLE Floodplains_tmp;

-- Great Zimbabwe - Give 2 trader capacity instead of 1
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='GREAT_ZIMBABWE_ADDTRADEROUTE';
-- 14/10/23 also gives the trader
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent) VALUES
	('BBG_GREAT_ZIMBABWE_GRANT_TRADER', 'MODIFIER_SINGLE_CITY_GRANT_UNIT_IN_CITY', 1, 1);
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
	('BBG_GREAT_ZIMBABWE_GRANT_TRADER', 'Amount', 2),
	('BBG_GREAT_ZIMBABWE_GRANT_TRADER', 'UnitType', 'UNIT_TRADER');
INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES
	('BUILDING_GREAT_ZIMBABWE', 'BBG_GREAT_ZIMBABWE_GRANT_TRADER');

-- Orszaghaz +300% diplomatic favor for each turn starting as the suz of a city state (from +100%)
UPDATE ModifierArguments SET Value='300' WHERE ModifierId='ORSZAGHAZ_DOUBLE_FAVOR_SUZERAIN';

-- Torre de Belem - International trade routes from any city recieve +2 gold for every luxury at the destination (from this city only).
UPDATE Modifiers SET ModifierType='MODIFIER_PLAYER_CITIES_ADJUST_TRADE_ROUTE_YIELD_PER_DESTINATION_LUXURY_FOR_INTERNATIONAL' WHERE ModifierId='TORREDEBELEM_TRADE_GOLD_LUXURIES';

-- Amundsen-Scott Research Station - +1 Science per snow tile in the city. Citizen can work snow tile for 3 science.

-- Golden Gate Bridge

-- Hermitage - GW inside double their tourism yields
--INSERT INTO Modifiers (ModifierId , ModifierType, Permanent) VALUES
--	('HERMITAGE_DOUBLE_TOURISM_GREAT_WORK', 'MODIFIER_PLAYER_ADJUST_GREAT_WORK_OBJECT_TOURISM', 1);
--INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
--    ('HERMITAGE_DOUBLE_TOURISM_GREAT_WORK', 'Amount', '100');
--INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES
--	('BUILDING_HERMITAGE', 'HERMITAGE_DOUBLE_TOURISM_GREAT_WORK');
INSERT OR IGNORE INTO Modifiers(ModifierId, ModifierType) VALUES
	('THEMED_YIELD_MODIFIER', 'MODIFIER_PLAYER_ADJUST_THEMED_ALL_YIELDS'),
	('THEMED_TOURISM_MODIFIER', 'MODIFIER_PLAYER_ADJUST_THEMED_TOURISM');
INSERT OR IGNORE INTO ModifierArguments(ModifierId, Name, Value) VALUES
	('THEMED_YIELD_MODIFIER', 'Amount', 100),
	('THEMED_TOURISM_MODIFIER', 'Amount', 100);
INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
	('HERMITAGE_AUTOTHEMING_BBG', 'MODIFIER_PLAYER_ADJUST_AUTO_THEMED_BUILDING');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
	('HERMITAGE_AUTOTHEMING_BBG', 'BuildingType', 'BUILDING_HERMITAGE');
INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
	('TRAIT_LEADER_MAJOR_CIV', 'HERMITAGE_AUTOTHEMING_BBG'),
	('TRAIT_LEADER_MAJOR_CIV', 'THEMED_YIELD_MODIFIER'),
	('TRAIT_LEADER_MAJOR_CIV', 'THEMED_TOURISM_MODIFIER');

-- BioSphere - reduce cost
UPDATE Buildings SET Cost=1620 WHERE BuildingType='BUILDING_BIOSPHERE';

-- 02/07/24 Oxford moved to Urbanization from Scientific Theory
UPDATE Buildings SET PrereqTech=NULL, PrereqCivic='CIVIC_URBANIZATION' WHERE BuildingType='BUILDING_OXFORD_UNIVERSITY';