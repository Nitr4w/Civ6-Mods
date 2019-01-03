-- ===========================================================================
-- Real Strategy - Main file with Strategies and Leaders
-- Author: Infixo
-- 2018-12-14: Created
-- ===========================================================================
-- TODO: generic change - make sure DiplomaticActions are connected to Agendas!
-- TODO: some ideas are common - thnk about making TRAITS, like "more TRs", "more wonders", etc.
-- improvements are unique, so they SHOULD be built nonetheless - see Ziggurats!
-- TRAIT_RST_MORE_TRADE_ROUTES
-- TRAIT_RST_MORE_IMPROVEMENTS
-- TRAIT_RST_MORE_WONDERS
-- TRAIT_RST_MORE_DISTRICTS

-- ===========================================================================
-- Strategies
-- ===========================================================================

-- remove old conditions, leave only relevant
UPDATE Strategies SET NumConditionsNeeded = 1 WHERE StrategyType LIKE 'VICTORY_STRATEGY_%';
DELETE FROM StrategyConditions WHERE StrategyType LIKE 'VICTORY_STRATEGY_%' AND ConditionFunction NOT IN ('Is Not Major'); --, 'Cannot Found Religion', 'Religion Destroyed');

-- register new conditions
INSERT INTO StrategyConditions (StrategyType, ConditionFunction, StringValue, ThresholdValue) VALUES
('VICTORY_STRATEGY_MILITARY_VICTORY', 'Call Lua Function', 'ActiveStrategyConquest', 0),
('VICTORY_STRATEGY_SCIENCE_VICTORY',  'Call Lua Function', 'ActiveStrategyScience',  0),
('VICTORY_STRATEGY_CULTURAL_VICTORY', 'Call Lua Function', 'ActiveStrategyCulture',  0),
('VICTORY_STRATEGY_RELIGIOUS_VICTORY','Call Lua Function', 'ActiveStrategyReligion', 0);

-- remove Strategies AiLists - they mess up the conditions badly!
DELETE FROM AiFavoredItems WHERE ListType IN (SELECT ListType FROM AiLists WHERE System = 'Strategies');
DELETE FROM AiListTypes    WHERE ListType IN (SELECT ListType FROM AiLists WHERE System = 'Strategies');
DELETE FROM AiLists        WHERE System = 'Strategies';

/*
INSERT INTO Types (Type, Kind) VALUES
('RST_STRATEGY_CONQUEST', 'KIND_VICTORY_STRATEGY'),
('RST_STRATEGY_SCIENCE',  'KIND_VICTORY_STRATEGY'),
('RST_STRATEGY_CULTURE',  'KIND_VICTORY_STRATEGY'),
('RST_STRATEGY_RELIGION', 'KIND_VICTORY_STRATEGY');

INSERT INTO Strategies (StrategyType, VictoryType, NumConditionsNeeded) VALUES
('RST_STRATEGY_CONQUEST', 'VICTORY_CONQUEST',   1),
('RST_STRATEGY_SCIENCE',  'VICTORY_TECHNOLOGY', 1),
('RST_STRATEGY_CULTURE',  'VICTORY_CULTURE',    1),
('RST_STRATEGY_RELIGION', 'VICTORY_RELIGIOUS',  1);
 
-- forbid non-majors first - thery are called in the order as registered in DB, so this prevents from unnecessary calls on the 1st turn
INSERT INTO StrategyConditions (StrategyType, ConditionFunction, Disqualifier) VALUES
('RST_STRATEGY_CONQUEST', 'Is Not Major', 1),
('RST_STRATEGY_SCIENCE',  'Is Not Major', 1),
('RST_STRATEGY_CULTURE',  'Is Not Major', 1),
('RST_STRATEGY_RELIGION', 'Is Not Major', 1);

INSERT INTO StrategyConditions (StrategyType, ConditionFunction, StringValue, ThresholdValue) VALUES
('RST_STRATEGY_CONQUEST','Call Lua Function', 'ActiveStrategyConquest', 0),
('RST_STRATEGY_SCIENCE', 'Call Lua Function', 'ActiveStrategyScience',  0),
('RST_STRATEGY_CULTURE', 'Call Lua Function', 'ActiveStrategyCulture',  0),
('RST_STRATEGY_RELIGION','Call Lua Function', 'ActiveStrategyReligion', 0);
*/
/*
INSERT INTO Types (Type, Kind) VALUES
('STRATEGY_TEST_TURN_3', 'KIND_VICTORY_STRATEGY'),
('STRATEGY_TEST_TURN_5', 'KIND_VICTORY_STRATEGY'),
('STRATEGY_TEST_TURN_7', 'KIND_VICTORY_STRATEGY');

INSERT INTO Strategies (StrategyType, VictoryType, NumConditionsNeeded) VALUES
('STRATEGY_TEST_TURN_3', NULL, 1),
('STRATEGY_TEST_TURN_5', NULL, 1),
('STRATEGY_TEST_TURN_7', NULL, 1);

INSERT INTO StrategyConditions (StrategyType, ConditionFunction, StringValue, ThresholdValue) VALUES
('STRATEGY_TEST_TURN_3','Call Lua Function','CheckTurnNumber',3),
('STRATEGY_TEST_TURN_5','Call Lua Function','CheckTurnNumber',5),
('STRATEGY_TEST_TURN_7','Call Lua Function','CheckTurnNumber',7);
*/

-- ===========================================================================
-- AiLists & AiFavoredItems
-- Systems to use:
-- YES Buildings (Wonders)
-- YES Civics
-- YES PseudoYields
-- YES Technologies
-- YES Yields
-- (R&F Commemorations)
-- (R&F YieldSensitivities - isn't it redundant?)
-- System to use partially:
-- AiBuildSpecializations
-- ??? Alliances
-- ??? DiplomaticActions
-- ??? Districts
-- ??? Projects
-- ??? UnitPromotionClasses
-- ??? Units
-- Not needed?
-- AiOperationTypes
-- AiScoutUses
-- CityEvents
-- Homeland
-- PerWarOperationTypes
-- PlotEvaluations
-- SavingTypes
-- SettlementPreferences
-- NO! Strategies - don't use it, messes up conditions
-- Tactics
-- TechBoosts
-- TriggeredTrees
-- ===========================================================================


-- ===========================================================================
-- VICTORY_STRATEGY_CULTURAL_VICTORY
--CultureSensitivity
--CultureVictoryFavoredCommemorations

UPDATE AiFavoredItems SET Value = 40 WHERE ListType = 'CultureVictoryYields'       AND Item = 'YIELD_CULTURE'; -- def. 25

UPDATE AiFavoredItems SET Value = 15 WHERE ListType = 'CultureVictoryPseudoYields' AND Item LIKE 'PSEUDOYIELD_GREATWORK_%'; -- def. 10
UPDATE AiFavoredItems SET Value = 50 WHERE ListType = 'CultureVictoryPseudoYields' AND Item = 'PSEUDOYIELD_TOURISM'; -- def. 25

INSERT INTO AiFavoredItems (ListType, Item, Favored, Value) VALUES
('CultureVictoryPseudoYields', 'PSEUDOYIELD_CITY_DEFENSES', 1, 100), -- base 300
('CultureVictoryPseudoYields', 'PSEUDOYIELD_CITY_DEFENDING_UNITS', 1, 30), -- base 100
('CultureVictoryPseudoYields', 'PSEUDOYIELD_CIVIC', 1, 100), -- base 3
('CultureVictoryPseudoYields', 'PSEUDOYIELD_SPACE_RACE', 1, -100), -- base 100, so it should be 100*100 by logic???
('CultureVictoryPseudoYields', 'PSEUDOYIELD_WONDER', 1, 50), -- base 1.2
('CultureVictoryPseudoYields', 'PSEUDOYIELD_UNIT_ARCHAEOLOGIST', 1, 150); -- base 3

INSERT INTO AiListTypes (ListType) VALUES
--('CultureVictoryDistricts'),
('CultureVictoryDiplomacy'),
('CultureVictoryTechs'),
('CultureVictoryCivics'),
('CultureVictoryWonders');
INSERT INTO AiLists (ListType, System) VALUES
--('CultureVictoryDistricts', 'Districts'),
('CultureVictoryDiplomacy', 'DiplomaticActions'),
('CultureVictoryTechs',     'Technologies'),
('CultureVictoryCivics',    'Civics'),
('CultureVictoryWonders',   'Buildings');
INSERT INTO Strategy_Priorities (StrategyType, ListType) VALUES
--('VICTORY_STRATEGY_CULTURAL_VICTORY', 'CultureVictoryDistricts'),
('VICTORY_STRATEGY_CULTURAL_VICTORY', 'CultureVictoryDiplomacy'),
('VICTORY_STRATEGY_CULTURAL_VICTORY', 'CultureVictoryTechs'),
('VICTORY_STRATEGY_CULTURAL_VICTORY', 'CultureVictoryCivics'),
('VICTORY_STRATEGY_CULTURAL_VICTORY', 'CultureVictoryWonders');
INSERT INTO AiFavoredItems (ListType, Item, Favored, Value) VALUES
--('CultureVictoryDistricts', 'DISTRICT_THEATER', 1, 0),
('CultureVictoryDiplomacy', 'DIPLOACTION_ALLIANCE_CULTURAL', 1, 0),
('CultureVictoryDiplomacy', 'DIPLOACTION_KEEP_PROMISE_DONT_DIG_ARTIFACTS', 0, 0), -- notice! it is FALSE!
('CultureVictoryDiplomacy', 'DIPLOACTION_OPEN_BORDERS', 1, 0),
('CultureVictoryTechs', 'TECH_PRINTING', 1, 0),
('CultureVictoryTechs', 'TECH_RADIO', 1, 0),
('CultureVictoryTechs', 'TECH_COMPUTERS', 1, 0),
('CultureVictoryCivics', 'CIVIC_DRAMA_POETRY', 1, 0),
('CultureVictoryCivics', 'CIVIC_HUMANISM', 1, 0),
('CultureVictoryCivics', 'CIVIC_OPERA_BALLET', 1, 0),
('CultureVictoryCivics', 'CIVIC_NATURAL_HISTORY', 1, 0),
('CultureVictoryCivics', 'CIVIC_MASS_MEDIA', 1, 0),
('CultureVictoryCivics', 'CIVIC_CULTURAL_HERITAGE', 1, 0),
('CultureVictoryCivics', 'CIVIC_SOCIAL_MEDIA', 1, 0),
('CultureVictoryWonders', 'BUILDING_BOLSHOI_THEATRE', 1, 0),
('CultureVictoryWonders', 'BUILDING_BROADWAY', 1, 0),
('CultureVictoryWonders', 'BUILDING_CRISTO_REDENTOR', 1, 0),
('CultureVictoryWonders', 'BUILDING_HERMITAGE', 1, 0),
('CultureVictoryWonders', 'BUILDING_SYDNEY_OPERA_HOUSE', 1, 0);


-- ===========================================================================
-- VICTORY_STRATEGY_SCIENCE_VICTORY
--ScienceSensitivity
--ScienceVictoryFavoredCommemorations
--ScienceVictoryDistricts
--ScienceVictoryProjects

--UPDATE AiFavoredItems SET Value = 40 WHERE ListType = 'ScienceVictoryYields' AND Item = 'YIELD_SCIENCE'; -- def. 50

UPDATE AiFavoredItems SET Value =  40 WHERE ListType = 'ScienceVictoryPseudoYields' AND Item = 'PSEUDOYIELD_GPP_SCIENTIST'; -- base 1.0
UPDATE AiFavoredItems SET Value = 100 WHERE ListType = 'ScienceVictoryPseudoYields' AND Item = 'PSEUDOYIELD_TECHNOLOGY'; -- def 25

INSERT INTO AiFavoredItems (ListType, Item, Favored, Value) VALUES
('ScienceVictoryYields', 'YIELD_FAITH', 1, -15),
('ScienceVictoryPseudoYields', 'PSEUDOYIELD_CITY_DEFENSES', 1, 50), -- base 300
('ScienceVictoryPseudoYields', 'PSEUDOYIELD_CITY_DEFENDING_UNITS', 1, 20), -- base 100
('ScienceVictoryPseudoYields', 'PSEUDOYIELD_GPP_PROPHET', 1, -15), -- base 0.8
('ScienceVictoryPseudoYields', 'PSEUDOYIELD_UNIT_ARCHAEOLOGIST', 1, -150), -- base 3
('ScienceVictoryTechs', 'TECH_WRITING', 1, 0),
('ScienceVictoryTechs', 'TECH_EDUCATION', 1, 0),
('ScienceVictoryTechs', 'TECH_CHEMISTRY', 1, 0);

INSERT INTO AiListTypes (ListType) VALUES
('ScienceVictoryDiplomacy'),
('ScienceVictoryCivics'),
('ScienceVictoryWonders');
INSERT INTO AiLists (ListType, System) VALUES
('ScienceVictoryDiplomacy', 'DiplomaticActions'),
('ScienceVictoryCivics',    'Civics'),
('ScienceVictoryWonders',   'Buildings');
INSERT INTO Strategy_Priorities (StrategyType, ListType) VALUES
('VICTORY_STRATEGY_SCIENCE_VICTORY', 'ScienceVictoryDiplomacy'),
('VICTORY_STRATEGY_SCIENCE_VICTORY', 'ScienceVictoryCivics'),
('VICTORY_STRATEGY_SCIENCE_VICTORY', 'ScienceVictoryWonders');
INSERT INTO AiFavoredItems (ListType, Item, Favored, Value) VALUES
('ScienceVictoryDiplomacy', 'DIPLOACTION_ALLIANCE_RESEARCH', 1, 0),
('ScienceVictoryDiplomacy', 'DIPLOACTION_KEEP_PROMISE_DONT_DIG_ARTIFACTS', 1, 0),
('ScienceVictoryCivics', 'CIVIC_RECORDED_HISTORY', 1, 0),
('ScienceVictoryCivics', 'CIVIC_THE_ENLIGHTENMENT', 1, 0),
('ScienceVictoryCivics', 'CIVIC_SPACE_RACE', 1, 0),
('ScienceVictoryCivics', 'CIVIC_GLOBALIZATION', 1, 0),
('ScienceVictoryWonders', 'BUILDING_AMUNDSEN_SCOTT_RESEARCH_STATION', 1, 0),
('ScienceVictoryWonders', 'BUILDING_GREAT_LIBRARY', 1, 0),
('ScienceVictoryWonders', 'BUILDING_OXFORD_UNIVERSITY', 1, 0),
('ScienceVictoryWonders', 'BUILDING_RUHR_VALLEY', 1, 0);


-- ===========================================================================
-- VICTORY_STRATEGY_RELIGIOUS_VICTORY
--ReligiousVictoryFavoredCommemorations
--ReligiousVictoryBehaviors

UPDATE AiFavoredItems SET Value = 50 WHERE ListType = 'ReligiousVictoryYields' AND Item = 'YIELD_FAITH'; -- def. 75

UPDATE AiFavoredItems SET Value = 50 WHERE ListType = 'ReligiousVictoryPseudoYields' AND Item = 'PSEUDOYIELD_GPP_PROPHET'; -- base 0.8

INSERT INTO AiFavoredItems (ListType, Item, Favored, Value) VALUES
('ReligiousVictoryDiplomacy',    'DIPLOACTION_ALLIANCE_RELIGIOUS', 1, 0),
('ReligiousVictoryPseudoYields', 'PSEUDOYIELD_SPACE_RACE', 1, -100); -- base 100, so it should be 100*100 by logic???
--('ReligiousVictoryPseudoYields', 'PSEUDOYIELD_UNIT_RELIGIOUS', 1, 50); -- base 0.8 -- this includes Guru and Naturalist!


INSERT INTO AiListTypes (ListType) VALUES
('ReligiousVictoryTechs'),
('ReligiousVictoryCivics'),
('ReligiousVictoryWonders'),
('ReligiousVictoryUnits');
INSERT INTO AiLists (ListType, System) VALUES
('ReligiousVictoryTechs',   'Technologies'),
('ReligiousVictoryCivics',  'Civics'),
('ReligiousVictoryWonders', 'Buildings'),
('ReligiousVictoryUnits',   'Units');
INSERT INTO Strategy_Priorities (StrategyType, ListType) VALUES
('VICTORY_STRATEGY_RELIGIOUS_VICTORY', 'ReligiousVictoryTechs'),
('VICTORY_STRATEGY_RELIGIOUS_VICTORY', 'ReligiousVictoryCivics'),
('VICTORY_STRATEGY_RELIGIOUS_VICTORY', 'ReligiousVictoryWonders'),
('VICTORY_STRATEGY_RELIGIOUS_VICTORY', 'ReligiousVictoryUnits');
INSERT INTO AiFavoredItems (ListType, Item, Favored, Value) VALUES
('ReligiousVictoryTechs', 'TECH_ASTROLOGY', 1, 0),
('ReligiousVictoryTechs', 'TECH_NUCLEAR_FISSION', 1, 0),
('ReligiousVictoryTechs', 'TECH_NUCLEAR_FUSION', 1, 0),
('ReligiousVictoryCivics', 'CIVIC_MYSTICISM', 1, 0),
('ReligiousVictoryCivics', 'CIVIC_THEOLOGY', 1, 0),
('ReligiousVictoryCivics', 'CIVIC_REFORMED_CHURCH', 1, 0),
('ReligiousVictoryWonders', 'BUILDING_HAGIA_SOPHIA', 1, 0),
('ReligiousVictoryWonders', 'BUILDING_STONEHENGE', 1, 0),
('ReligiousVictoryWonders', 'BUILDING_MAHABODHI_TEMPLE', 1, 0),
('ReligiousVictoryUnits', 'UNIT_MISSIONARY', 1, 100),
('ReligiousVictoryUnits', 'UNIT_APOSTLE', 1, 100),
('ReligiousVictoryUnits', 'UNIT_INQUISITOR', 1, 50);


-- ===========================================================================
-- VICTORY_STRATEGY_MILITARY_VICTORY
--MilitaryVictoryFavoredCommemorations
--MilitaryVictoryOperations

--UPDATE AiFavoredItems SET Value = 50 WHERE ListType = 'MilitaryVictoryYields' AND Item = 'YIELD_FAITH'; -- def. 25

UPDATE AiFavoredItems SET Value =  40 WHERE ListType = 'MilitaryVictoryPseudoYields' AND Item = 'PSEUDOYIELD_NUCLEAR_WEAPON'; -- def. 25
UPDATE AiFavoredItems SET Value =  50 WHERE ListType = 'MilitaryVictoryPseudoYields' AND Item = 'PSEUDOYIELD_UNIT_AIR_COMBAT'; -- def. 25
UPDATE AiFavoredItems SET Value =  50 WHERE ListType = 'MilitaryVictoryPseudoYields' AND Item = 'PSEUDOYIELD_UNIT_COMBAT'; -- def. 25
UPDATE AiFavoredItems SET Value =  15 WHERE ListType = 'MilitaryVictoryPseudoYields' AND Item = 'PSEUDOYIELD_UNIT_NAVAL_COMBAT'; -- def. 25 -- leave it for Naval strategies
UPDATE AiFavoredItems SET Value = 150 WHERE ListType = 'MilitaryVictoryPseudoYields' AND Item = 'PSEUDOYIELD_CITY_ORIGINAL_CAPITAL'; -- def. 100
UPDATE AiFavoredItems SET Value = -50 WHERE ListType = 'MilitaryVictoryPseudoYields' AND Item = 'PSEUDOYIELD_CITY_DEFENSES'; -- def. -25

INSERT INTO AiFavoredItems (ListType, Item, Favored, Value) VALUES
('MilitaryVictoryYields', 'YIELD_SCIENCE', 1,  15),
('MilitaryVictoryYields', 'YIELD_FAITH',   1, -25),
('MilitaryVictoryPseudoYields', 'PSEUDOYIELD_CITY_BASE', 1, 250), -- base 350 - or maybe 15000????
--('MilitaryVictoryPseudoYields', 'PSEUDOYIELD_CITY_ORIGINAL_CAPITAL', 1, 150), -- base 100
--('MilitaryVictoryPseudoYields', 'PSEUDOYIELD_CITY_DEFENSES', 1, -50), -- base 200
('MilitaryVictoryPseudoYields', 'PSEUDOYIELD_CITY_DEFENDING_UNITS', 1, -20), -- base 100
('MilitaryVictoryPseudoYields', 'PSEUDOYIELD_SPACE_RACE', 1, -100), -- base 100, so it should be 100*100 by logic???
('MilitaryVictoryPseudoYields', 'PSEUDOYIELD_CLEAR_BANDIT_CAMPS', 1, 15), -- base 1.0, agenda lover uses 5, but it means probably 0.05
('MilitaryVictoryPseudoYields', 'PSEUDOYIELD_GPP_SCIENTIST', 1, 15), -- base 1.0
('MilitaryVictoryPseudoYields', 'PSEUDOYIELD_GPP_PROPHET', 1, -25), -- base 0.8
('MilitaryVictoryPseudoYields', 'PSEUDOYIELD_GPP_ADMIRAL', 1, 25), -- base 0.8
('MilitaryVictoryPseudoYields', 'PSEUDOYIELD_GPP_GENERAL', 1, 50), -- base 0.8
('MilitaryVictoryPseudoYields', 'PSEUDOYIELD_TOURISM', 1, -50), -- base 1
('MilitaryVictoryPseudoYields', 'PSEUDOYIELD_TECHNOLOGY', 1, 50), -- base 3
('MilitaryVictoryPseudoYields', 'PSEUDOYIELD_UNIT_EXPLORER', 1, 25); -- base 0.6


INSERT INTO AiListTypes (ListType) VALUES
('MilitaryVictoryDiplomacy'),
('MilitaryVictoryTechs'),
('MilitaryVictoryCivics'),
('MilitaryVictoryWonders'),
('MilitaryVictoryProjects'),
('MilitaryVictoryUnitBuilds');
INSERT INTO AiLists (ListType, System) VALUES
('MilitaryVictoryDiplomacy', 'DiplomaticActions'),
('MilitaryVictoryTechs',     'Technologies'),
('MilitaryVictoryCivics',    'Civics'),
('MilitaryVictoryWonders',   'Buildings'),
('MilitaryVictoryProjects',  'Projects'),
('MilitaryVictoryUnitBuilds','UnitPromotionClasses');
INSERT INTO Strategy_Priorities (StrategyType, ListType) VALUES
('VICTORY_STRATEGY_MILITARY_VICTORY', 'MilitaryVictoryDiplomacy'),
('VICTORY_STRATEGY_MILITARY_VICTORY', 'MilitaryVictoryTechs'),
('VICTORY_STRATEGY_MILITARY_VICTORY', 'MilitaryVictoryCivics'),
('VICTORY_STRATEGY_MILITARY_VICTORY', 'MilitaryVictoryWonders'),
('VICTORY_STRATEGY_MILITARY_VICTORY', 'MilitaryVictoryProjects'),
('VICTORY_STRATEGY_MILITARY_VICTORY', 'MilitaryVictoryUnitBuilds');
INSERT INTO AiFavoredItems (ListType, Item, Favored, Value) VALUES
--('MilitaryVictoryDiplomacy', 'DIPLOACTION_MAKE_PEACE', 0, 0), -- notice! it is FALSE
('MilitaryVictoryDiplomacy', 'DIPLOACTION_USE_NUCLEAR_WEAPON', 1, 0),
('MilitaryVictoryDiplomacy', 'DIPLOACTION_PROPOSE_PEACE_DEAL', 0, 0), -- notice! it is FALSE
--('MilitaryVictoryDiplomacy', 'DIPLOACTION_ALLIANCE_MILITARY', 1, 0),
('MilitaryVictoryDiplomacy', 'DIPLOACTION_DECLARE_SURPRISE_WAR', 1, 0),
('MilitaryVictoryDiplomacy', 'DIPLOACTION_DECLARE_FORMAL_WAR', 1, 0),
('MilitaryVictoryDiplomacy', 'DIPLOACTION_DECLARE_TERRITORIAL_WAR', 1, 0),
('MilitaryVictoryDiplomacy', 'DIPLOACTION_DECLARE_GOLDEN_AGE_WAR', 1, 0),
--('MilitaryVictoryDiplomacy', 'DIPLOACTION_DECLARE_WAR_OF_RETRIBUTION', 1, 0),
--('MilitaryVictoryDiplomacy', 'DIPLOACTION_DECLARE_RECONQUEST_WAR', 1, 0),
('MilitaryVictoryDiplomacy', 'DIPLOACTION_DECLARE_COLONIAL_WAR', 1, 0),
('MilitaryVictoryTechs', 'TECH_BRONZE_WORKING', 1, 0),
('MilitaryVictoryTechs', 'TECH_STIRRUPS', 1, 0),
('MilitaryVictoryTechs', 'TECH_MILITARY_ENGINEERING', 1, 0),
('MilitaryVictoryTechs', 'TECH_GUNPOWDER', 1, 0),
('MilitaryVictoryTechs', 'TECH_MILITARY_SCIENCE', 1, 0),
('MilitaryVictoryTechs', 'TECH_COMBUSTION', 1, 0),
('MilitaryVictoryTechs', 'TECH_NUCLEAR_FISSION', 1, 0),
('MilitaryVictoryTechs', 'TECH_NUCLEAR_FUSION', 1, 0),
('MilitaryVictoryCivics', 'CIVIC_MILITARY_TRADITION', 1, 0),
('MilitaryVictoryCivics', 'CIVIC_MILITARY_TRAINING', 1, 0),
('MilitaryVictoryCivics', 'CIVIC_MERCENARIES', 1, 0),
('MilitaryVictoryCivics', 'CIVIC_NATIONALISM', 1, 0),
('MilitaryVictoryCivics', 'CIVIC_MOBILIZATION', 1, 0),
('MilitaryVictoryCivics', 'CIVIC_TOTALITARIANISM', 1, 0),
('MilitaryVictoryCivics', 'CIVIC_RAPID_DEPLOYMENT', 1, 0),
('MilitaryVictoryWonders', 'BUILDING_TERRACOTTA_ARMY', 1, 0),
('MilitaryVictoryWonders', 'BUILDING_ALHAMBRA', 1, 0),
('MilitaryVictoryProjects', 'PROJECT_MANHATTAN_PROJECT', 1, 0),
('MilitaryVictoryProjects', 'PROJECT_OPERATION_IVY', 1, 0),
('MilitaryVictoryProjects', 'PROJECT_BUILD_NUCLEAR_DEVICE', 1, 0),
('MilitaryVictoryProjects', 'PROJECT_BUILD_THERMONUCLEAR_DEVICE', 1, 0),
('MilitaryVictoryUnitBuilds', 'PROMOTION_CLASS_SIEGE', 1, 25);


-- ===========================================================================
-- Changes to MINORS
-- ===========================================================================

-- extend possible war ops?
INSERT INTO AiFavoredItems (ListType, Item, Favored) VALUES
('Minor Civ Homeland', 'Attack Civilians', 1),
('Minor Civ Tactical', 'Attack Camps', 1), -- not sure about that?
('Minor Civ Tactical', 'Coastal Raid', 1),
('Minor Civ Tactical', 'Pillage District', 1),
('Minor Civ Tactical', 'Pillage Improvement', 1),
('Minor Civ Tactical', 'Plunder Trader', 1);

INSERT INTO AiFavoredItems (ListType, Item, Favored, Value) VALUES
('MinorCivUnitBuilds', 'PROMOTION_CLASS_ANTI_CAVALRY', 1, 20),
('MinorCivUnitBuilds', 'PROMOTION_CLASS_RANGED', 1, 15),
('MinorCivUnitBuilds', 'PROMOTION_CLASS_SIEGE', 1, -50),
('MinorCivUnitBuilds', 'PROMOTION_CLASS_SUPPORT', 1, -25),
('MinorCivPseudoYields', 'PSEUDOYIELD_CITY_DEFENSES', 1, 200),
('MinorCivPseudoYields', 'PSEUDOYIELD_CITY_DEFENDING_UNITS', 1, 50),
('MinorCivPseudoYields', 'PSEUDOYIELD_CLEAR_BANDIT_CAMPS', 1, 10);
/*
INSERT INTO AiListTypes (ListType) VALUES
('MinorCivOperations');
INSERT INTO AiLists (ListType, LeaderType, System) VALUES
('MinorCivOperations', 'MINOR_CIV_DEFAULT_TRAIT', 'AiOperationTypes');
INSERT INTO AiFavoredItems (ListType, Item, Favored, Value) VALUES
('MinorCivOperations', 'OP_DEFENSE', 1, 2);
*/

-- ===========================================================================
-- Changes to existing leaders and civs --> move to a separate file eventually
-- ===========================================================================

-- generic (all)
UPDATE AiFavoredItems SET Value = 2 WHERE ListType = 'BaseOperationsLimits' AND Item = 'OP_DEFENSE'; -- def. 1 ?number of simultaneus ops?


-- ALEXANDER / MACEDON
-- can't use DarwinistIgnoreWarmongerValue - others use it too

INSERT INTO AiListTypes (ListType) VALUES
('AlexanderPseudoYields'),
('AlexanderUnitBuilds');
INSERT INTO AiLists (ListType, LeaderType, System) VALUES
('AlexanderPseudoYields', 'TRAIT_LEADER_TO_WORLDS_END', 'PseudoYields'),
('AlexanderUnitBuilds', 'TRAIT_LEADER_TO_WORLDS_END', 'UnitPromotionClasses');
INSERT INTO AiFavoredItems (ListType, Item, Favored, Value) VALUES
('AlexanderPseudoYields', 'PSEUDOYIELD_CITY_BASE', 1, 150), -- because cities give boosts!
('AlexanderPseudoYields', 'PSEUDOYIELD_WONDER', 1, 25), -- because he has a ton of Wonders as favored and heals when captures one
('AlexanderPseudoYields', 'PSEUDOYIELD_UNIT_COMBAT', 1, 15), -- obvious
('AlexanderPseudoYields', 'PSEUDOYIELD_UNIT_EXPLORER', 1, 25), -- because he needs to know neighbors fast
('AlexanderPseudoYields', 'PSEUDOYIELD_GPP_GENERAL', 1, 15), -- obvious
('AlexanderUnitBuilds', 'PROMOTION_CLASS_SIEGE', 1, 15); -- for cities


-- AMANITORE / NUBIA
-- TRAIT_RST_MORE_DISTRICTS
-- TRAIT_RST_MORE_IMPROVEMENTS
-- she likes to build, improvements and districts

UPDATE AiFavoredItems SET Value = 25 WHERE ListType = 'AmanitoreUnitBuilds' AND Item = 'PROMOTION_CLASS_RANGED'; -- was 1

INSERT INTO AiListTypes (ListType) VALUES
('AmanitorePseudoYields'),
('AmanitoreUnits');
INSERT INTO AiLists (ListType, LeaderType, System) VALUES
('AmanitorePseudoYields', 'TRAIT_LEADER_KANDAKE_OF_MEROE', 'PseudoYields'),
('AmanitoreUnits', 'TRAIT_LEADER_KANDAKE_OF_MEROE', 'Units');
INSERT INTO AiFavoredItems (ListType, Item, Favored, Value) VALUES
('AmanitorePseudoYields', 'PSEUDOYIELD_CITY_POPULATION', 1, 15), -- more districts
('AmanitorePseudoYields', 'PSEUDOYIELD_DISTRICT', 1, 50), -- more districts
('AmanitorePseudoYields', 'PSEUDOYIELD_IMPROVEMENT', 1, 100), -- more improvements
('AmanitoreUnits', 'UNIT_BUILDER', 1, 25); -- more improvements


-- BARBAROSSA / GERMANY
-- TRAIT_RST_MORE_DISTRICTS

-- remove 23 favored Civics, insane!
DELETE FROM AiFavoredItems WHERE ListType = 'BarbarossaCivics';

INSERT INTO AiListTypes (ListType) VALUES
('BarbarossaPseudoYields');
INSERT INTO AiLists (ListType, LeaderType, System) VALUES
('BarbarossaPseudoYields', 'TRAIT_LEADER_HOLY_ROMAN_EMPEROR', 'PseudoYields');
INSERT INTO AiFavoredItems (ListType, Item, Favored, Value) VALUES
('BarbarossaTechs', 'TECH_INDUSTRIALIZATION', 1, 0),
('BarbarossaCivics', 'CIVIC_GAMES_RECREATION', 1, 0),
('BarbarossaCivics', 'CIVIC_GUILDS', 1, 0),
('BarbarossaCivics', 'CIVIC_EXPLORATION', 1, 0),
('BarbarossaCivics', 'CIVIC_URBANIZATION', 1, 0),
('BarbarossaPseudoYields', 'PSEUDOYIELD_DISTRICT', 1, 50), -- more districts
('BarbarossaPseudoYields', 'PSEUDOYIELD_GPP_MERCHANT', 1, 15), -- boost comm hubs
('BarbarossaPseudoYields', 'PSEUDOYIELD_GPP_ENGINEER', 1, 15); -- boost hansas


-- CATHERINE_DE_MEDICI / FRANCE
-- TRAIT_RST_MORE_IMPROVEMENTS
-- TRAIT_RST_MORE_WONDERS

INSERT INTO AiListTypes (ListType) VALUES
('CatherineYields'),
('CatherinePseudoYields');
INSERT INTO AiLists (ListType, LeaderType, System) VALUES
('CatherineYields', 'FLYING_SQUADRON_TRAIT', 'Yields'),
('CatherinePseudoYields', 'FLYING_SQUADRON_TRAIT', 'PseudoYields');
INSERT INTO AiFavoredItems (ListType, Item, Favored, Value) VALUES
('CatherineYields', 'YIELD_CULTURE', 1, 25),
('CatherineYields', 'YIELD_PRODUCTION', 1, 10),
('CatherineYields', 'YIELD_FAITH', 1, -15),
('CatherinePseudoYields', 'PSEUDOYIELD_GPP_PROPHET', 1, -25),
('CatherinePseudoYields', 'PSEUDOYIELD_IMPROVEMENT', 1, 100),
('CatherinePseudoYields', 'PSEUDOYIELD_TOURISM', 1, 25),
('CatherinePseudoYields', 'PSEUDOYIELD_WONDER', 1, 25),
('CatherinePseudoYields', 'PSEUDOYIELD_CITY_DEFENDING_UNITS', 1, 25),
('CatherinePseudoYields', 'PSEUDOYIELD_UNIT_SPY', 1, 500); -- 5 or 500????

-- CHANDRAGUPTA & GANDHI / INDIA

-- INDIA: GandhiUnitBuilds => this should be India-trait, so IndiaUnitBuilds
UPDATE AiListTypes    SET ListType = 'IndiaUnitBuilds' WHERE ListType = 'GandhiUnitBuilds';
UPDATE AiLists        SET ListType = 'IndiaUnitBuilds', LeaderType = 'TRAIT_CIVILIZATION_DHARMA' WHERE ListType = 'GandhiUnitBuilds';
UPDATE AiFavoredItems SET ListType = 'IndiaUnitBuilds' WHERE ListType = 'GandhiUnitBuilds';
UPDATE AiFavoredItems SET Value = -100 WHERE ListType = 'IndiaUnitBuilds' AND Item = 'PROMOTION_CLASS_INQUISITOR'; -- was -1

-- INDIA: stepwell
INSERT INTO AiListTypes (ListType) VALUES
('IndiaTechs'),
('IndiaYields'),
('IndiaPseudoYields');
INSERT INTO AiLists (ListType, LeaderType, System) VALUES
('IndiaTechs', 'TRAIT_CIVILIZATION_IMPROVEMENT_STEPWELL', 'Technologies'),
('IndiaYields', 'TRAIT_CIVILIZATION_IMPROVEMENT_STEPWELL', 'Yields'),
('IndiaPseudoYields', 'TRAIT_CIVILIZATION_IMPROVEMENT_STEPWELL', 'PseudoYields');
INSERT INTO AiFavoredItems (ListType, Item, Favored, Value) VALUES
('IndiaTechs', 'TECH_IRRIGATION', 1, 0),
('IndiaYields', 'YIELD_FOOD', 1, 10),
('IndiaYields', 'YIELD_FAITH', 1, 10),
('IndiaPseudoYields', 'PSEUDOYIELD_CITY_POPULATION', 1, 25), -- more people!
('IndiaPseudoYields', 'PSEUDOYIELD_GPP_PROPHET', 1, 15), -- holy sites
('IndiaPseudoYields', 'PSEUDOYIELD_IMPROVEMENT', 1, 100); -- stepwells

-- CHANDRAGUPTA: does not like his neighbors :(
-- TODO: similar expansionist trait to Trajan, to forward settle a bit more maybe?
INSERT INTO AiListTypes (ListType) VALUES
('ChandraguptaPseudoYields');
INSERT INTO AiLists (ListType, LeaderType, System) VALUES
('ChandraguptaPseudoYields', 'TRAIT_LEADER_ARTHASHASTRA', 'PseudoYields');
INSERT INTO AiFavoredItems (ListType, Item, Favored, Value) VALUES
('ChandraguptaPseudoYields', 'PSEUDOYIELD_CITY_BASE', 1, 150), -- conquer neighbors
('ChandraguptaPseudoYields', 'PSEUDOYIELD_UNIT_COMBAT', 1, 15), -- obvious
('ChandraguptaPseudoYields', 'PSEUDOYIELD_UNIT_RELIGIOUS', 1, -15), -- to differ from Gandhi
('ChandraguptaPseudoYields', 'PSEUDOYIELD_DIPLOMATIC_BONUS', 1, -25); -- conquer neighbors

-- GANDHI: hates warmongers, faith
DELETE FROM AiFavoredItems WHERE ListType = 'GandhiWonders' AND Item = 'BUILDING_OXFORD_UNIVERSITY'; -- really????
DELETE FROM AiFavoredItems WHERE ListType = 'GandhiTechs'   AND Item = 'TECH_IRRIGATION'; -- this is India now

INSERT INTO AiListTypes (ListType) VALUES
('GandhiPseudoYields'),
('GandhiProjects');
INSERT INTO AiLists (ListType, LeaderType, System) VALUES
('GandhiPseudoYields', 'TRAIT_LEADER_SATYAGRAHA', 'PseudoYields'),
('GandhiProjects', 'TRAIT_LEADER_SATYAGRAHA', 'Projects');
INSERT INTO AiFavoredItems (ListType, Item, Favored, Value) VALUES
('PeacekeeperWarLimits', 'DIPLOACTION_OPEN_BORDERS', 1, 0), -- get more religions
('PeacekeeperWarLimits', 'DIPLOACTION_ALLIANCE', 1, 0), -- peace!
('PeacekeeperWarLimits', 'DIPLOACTION_DECLARE_FRIENDSHIP', 1, 0), -- peace!
('PeacekeeperWarLimits', 'DIPLOACTION_RENEW_ALLIANCE', 1, 0), -- peace!
('PeacekeeperWarLimits', 'DIPLOACTION_RESIDENT_EMBASSY', 1, 0), -- peace
('GandhiPseudoYields', 'PSEUDOYIELD_CITY_BASE', 1, -150), -- conquer neighbors
('GandhiPseudoYields', 'PSEUDOYIELD_UNIT_COMBAT', 1, -15), -- obvious
('GandhiPseudoYields', 'PSEUDOYIELD_UNIT_RELIGIOUS', 1, 15), -- to differ from CHANDRAGUPTA
('GandhiPseudoYields', 'PSEUDOYIELD_DIPLOMATIC_BONUS', 1, 25), -- peace!
-- nukes, because... Gandhi
('PeacekeeperWarLimits', 'DIPLOACTION_USE_NUCLEAR_WEAPON', 1, 0),
('GandhiPseudoYields', 'PSEUDOYIELD_NUCLEAR_WEAPON', 1, 20),
('GandhiProjects', 'PROJECT_MANHATTAN_PROJECT', 1, 0),
('GandhiProjects', 'PROJECT_OPERATION_IVY', 1, 0),
('GandhiProjects', 'PROJECT_BUILD_NUCLEAR_DEVICE', 1, 0),
('GandhiProjects', 'PROJECT_BUILD_THERMONUCLEAR_DEVICE', 1, 0);


-- EGYPT / CLEOPATRA
-- TRAIT_RST_MORE_IMPROVEMENTS
-- TRAIT_RST_MORE_WONDERS

INSERT INTO AiListTypes (ListType) VALUES
('CleopatraDiplomacy'),
('CleopatraYields'),
('CleopatraPseudoYields');
INSERT INTO AiLists (ListType, LeaderType, System) VALUES
('CleopatraDiplomacy', 'TRAIT_LEADER_MEDITERRANEAN', 'DiplomaticActions'),
('CleopatraYields', 'TRAIT_LEADER_MEDITERRANEAN', 'Yields'),
('CleopatraPseudoYields', 'TRAIT_LEADER_MEDITERRANEAN', 'PseudoYields');
INSERT INTO AiFavoredItems (ListType, Item, Favored, Value) VALUES
('CleopatraDiplomacy', 'DIPLOACTION_ALLIANCE', 1, 0),
('CleopatraDiplomacy', 'DIPLOACTION_ALLIANCE_MILITARY', 1, 0),
('CleopatraDiplomacy', 'DIPLOACTION_RENEW_ALLIANCE', 1, 0),
('CleopatraYields', 'YIELD_GOLD', 1, 10),
('CleopatraYields', 'YIELD_PRODUCTION', 1, 10),
('CleopatraPseudoYields', 'PSEUDOYIELD_GPP_MERCHANT', 1, 20),
('CleopatraPseudoYields', 'PSEUDOYIELD_GPP_ADMIRAL', 1, 20),
('CleopatraPseudoYields', 'PSEUDOYIELD_GPP_PROPHET', 1, 10),
('CleopatraPseudoYields', 'PSEUDOYIELD_UNIT_TRADE', 1, 500),
('CleopatraPseudoYields', 'PSEUDOYIELD_WONDER', 1, 25),
('CleopatraPseudoYields', 'PSEUDOYIELD_TOURISM', 1, 10),
('CleopatraPseudoYields', 'PSEUDOYIELD_IMPROVEMENT', 1, 100),
('CleopatraPseudoYields', 'PSEUDOYIELD_DISTRICT', 1, 50);


-- PERSIA / CYRUS
-- TRAIT_RST_MORE_TRADE_ROUTES

INSERT INTO AiListTypes (ListType) VALUES
('CyrusYields'),
('CyrusPseudoYields');
INSERT INTO AiLists (ListType, LeaderType, System) VALUES
('CyrusYields', 'TRAIT_LEADER_FALL_BABYLON', 'Yields'),
('CyrusPseudoYields', 'TRAIT_LEADER_FALL_BABYLON', 'PseudoYields');
INSERT INTO AiFavoredItems (ListType, Item, Favored, Value) VALUES
('CyrusYields', 'YIELD_CULTURE', 1, 15),
('CyrusYields', 'YIELD_GOLD', 1, 10),
('CyrusPseudoYields', 'PSEUDOYIELD_DISTRICT', 1, 50),
('CyrusPseudoYields', 'PSEUDOYIELD_IMPROVEMENT', 1, 100),
('CyrusPseudoYields', 'PSEUDOYIELD_TOURISM', 1, 15),
('CyrusPseudoYields', 'PSEUDOYIELD_UNIT_COMBAT', 1, 10),
('CyrusPseudoYields', 'PSEUDOYIELD_UNIT_TRADE', 1, 500);


-- MONGOLIA / LEADER_GENGHIS_KHAN
-- Genghis seems OK!
-- TRAIT_RST_PREFER_TRADE_ROUTES


-- SUMERIA / GILGAMESH
-- TRAIT_RST_MORE_IMPROVEMENTS
-- Ziggurat has no tech req... so broken! - it is the ONLY unique improvement like this

INSERT INTO AiListTypes (ListType) VALUES
('GilgameshTechs'),
('GilgameshCivics'),
--('GilgameshWonders'),
('GilgameshPseudoYields');
INSERT INTO AiLists (ListType, LeaderType, System) VALUES
('GilgameshTechs', 'TRAIT_LEADER_ADVENTURES_ENKIDU', 'Technologies'),
('GilgameshCivics', 'TRAIT_LEADER_ADVENTURES_ENKIDU', 'Civics'),
--('GilgameshWonders', 'TRAIT_LEADER_ADVENTURES_ENKIDU', 'Buildings'),
('GilgameshPseudoYields', 'TRAIT_LEADER_ADVENTURES_ENKIDU', 'PseudoYields');
INSERT INTO AiFavoredItems (ListType, Item, Favored, Value) VALUES
('GilgameshDiplomacy', 'DIPLOACTION_ALLIANCE' , 1, 0),
('GilgameshDiplomacy', 'DIPLOACTION_JOINT_WAR' , 1, 0),
('GilgameshDiplomacy', 'DIPLOACTION_RENEW_ALLIANCE' , 1, 0),
('GilgameshDiplomacy', 'DIPLOACTION_DECLARE_WAR_MINOR_CIV' , 0, 0), -- friend of CS
('GilgameshTechs', 'TECH_STIRRUPS' , 1, 0),
('GilgameshTechs', 'TECH_WRITING' , 1, 0),
('GilgameshTechs', 'TECH_EDUCATION' , 1, 0),
('GilgameshCivics', 'CIVIC_FOREIGN_TRADE' , 1, 0), -- joint war
('GilgameshCivics', 'CIVIC_CIVIL_SERVICE' , 1, 0), -- alliance
('GilgameshPseudoYields', 'PSEUDOYIELD_CLEAR_BANDIT_CAMPS' , 1, 15), -- is it actually 0.25???
('GilgameshPseudoYields', 'PSEUDOYIELD_INFLUENCE' , 1, 15); -- friend of CS


-- INDONESIA / GITARJA
-- TRAIT_RST_MORE_NAVAL
-- TRAIT_RST_MORE_IMPROVEMENTS

INSERT INTO AiListTypes (ListType) VALUES
('GitarjaSettlement'),
('GitarjaYields'),
('GitarjaPseudoYields');
INSERT INTO AiLists (ListType, LeaderType, System) VALUES
('GitarjaSettlement', 'TRAIT_LEADER_EXALTED_GODDESS', 'PlotEvaluations'),
('GitarjaYields', 'TRAIT_LEADER_EXALTED_GODDESS', 'Yields'),
('GitarjaPseudoYields', 'TRAIT_LEADER_EXALTED_GODDESS', 'PseudoYields');
INSERT INTO AiFavoredItems (ListType, Item, Favored, Value) VALUES
('GitarjaSettlement', 'Coastal', 0, 10),
('GitarjaYields', 'YIELD_FAITH', 1, 10),
('GitarjaYields', 'YIELD_PRODUCTION', 1, 10),
('GitarjaPseudoYields', 'PSEUDOYIELD_CITY_POPULATION', 1, 15),
('GitarjaPseudoYields', 'PSEUDOYIELD_UNIT_NAVAL_COMBAT', 1, 15);



-- GORGO & PERICLES / GREECE
-- GREECE has an extra Wildcard slot & Acropolis, boosted Culture - nothing to add here
-- GORGO seems OK
-- PERICLES seems OK, CS ally, low faith



-- NORWAY / HARDRADA
-- high forest & coast, 

UPDATE AiFavoredItems SET Favored = 0, Value = 15 WHERE ListType = 'LastVikingKingCoastSettlement' AND Item = 'Coastal'; -- Harald, def. 30
UPDATE AiFavoredItems SET              Value = 25 WHERE ListType = 'LastVikingKingNavalPreference' AND Item = 'PSEUDOYIELD_UNIT_NAVAL_COMBAT'; -- def. 100

INSERT INTO AiListTypes (ListType) VALUES
('HaraldYields');
INSERT INTO AiLists (ListType, LeaderType, System) VALUES
('HaraldYields', 'TRAIT_AGENDA_LAST_VIKING_KING', 'Yields');
INSERT INTO AiFavoredItems (ListType, Item, Favored, Value) VALUES
('LastVikingKingCoastSettlement', 'Foreign Continent', 0, 40), -- try to settle other continents before others
('LastVikingKingCoastSettlement', 'Specific Feature', 0, 3, 'FEATURE_FOREST'), -- close to forests
('HaraldTechs', 'TECH_MINING', 1, 0),
('HaraldCivics', 'CIVIC_MYSTICISM', 1, 0),
('HaraldCivics', 'CIVIC_FOREIGN_TRADE', 1, 0),
('HaraldYields', 'YIELD_FAITH', 1, 10),
('LastVikingKingNavalPreference', 'PSEUDOYIELD_CITY_POPULATION', 1, 15),
('LastVikingKingNavalPreference', 'PSEUDOYIELD_CLEAR_BANDIT_CAMPS', 1, 15), -- get rid of barb ships asap
('LastVikingKingNavalPreference', 'PSEUDOYIELD_GPP_PROPHET', 1, 25), -- get the Holy Site asap
('LastVikingKingNavalPreference', 'PSEUDOYIELD_ENVIRONMENT', 1, 20), -- don't chop forests
('LastVikingKingNavalPreference', 'PSEUDOYIELD_UNIT_COMBAT', 1, -10), -- more ships, less land
('LastVikingKingNavalPreference', 'PSEUDOYIELD_UNIT_RELIGIOUS', 1, 20),
('LastVikingKingNavalPreference', 'PSEUDOYIELD_UNIT_SETTLER', 1, 20); -- more cities


-- JAYAVARMAN / KHMER
-- he doesn't build Holy Sites! -> can't get Prasat!

INSERT INTO AiListTypes (ListType) VALUES
('JayavarmanDistricts'),
('JayavarmanYields'),
('JayavarmanPseudoYields');
INSERT INTO AiLists (ListType, LeaderType, System) VALUES
('JayavarmanDistricts',    'TRAIT_LEADER_MONASTERIES_KING', 'Districts'),
('JayavarmanYields',       'TRAIT_LEADER_MONASTERIES_KING', 'Yields'),
('JayavarmanPseudoYields', 'TRAIT_LEADER_MONASTERIES_KING', 'PseudoYields');
INSERT INTO AiFavoredItems (ListType, Item, Favored, Value) VALUES
('JayavarmanDistricts', 'DISTRICT_HOLY_SITE', 1, 0),
('JayavarmanYields', 'YIELD_FAITH', 1, 20),
--('JayavarmanYields', 'YIELD_SCIENCE', 1, -10),
('JayavarmanPseudoYields', 'PSEUDOYIELD_GPP_PROPHET', 1, 25),
('JayavarmanPseudoYields', 'PSEUDOYIELD_UNIT_COMBAT', 1, -10),
('JayavarmanPseudoYields', 'PSEUDOYIELD_UNIT_NAVAL_COMBAT', 1, -10);


-- BRAZIL / PEDRO
-- lower a bit GP obsession, balance defense

UPDATE AiFavoredItems SET Value =  25 WHERE ListType = 'GreatPersonObsessedGreatPeople'; -- def. 50

INSERT INTO AiFavoredItems (ListType, Item, Favored, Value) VALUES
('GreatPersonObsessedGreatPeople', 'PSEUDOYIELD_CITY_DEFENSES', 1, 25);


-- 2019-01-02: Wrong assignment of PseudoYield to Wonders; remove, Pericles has Delian agenda which does that
DELETE FROM AiFavoredItems WHERE ListType = 'PericlesWonders' AND Item = 'PSEUDOYIELD_INFLUENCE';

/*


LEADER_HOJO
LEADER_JADWIGA
LEADER_JAYAVARMAN
LEADER_JOHN_CURTIN
LEADER_LAUTARO
LEADER_MONTEZUMA
LEADER_MVEMBA
LEADER_PEDRO
LEADER_PERICLES
-- 2019-01-02: Wrong assignment of PseudoYield to Wonders
-- <Row ListType="PericlesWonders" Item="PSEUDOYIELD_INFLUENCE" Favored="true"/>

LEADER_PETER_GREAT
LEADER_PHILIP_II
LEADER_POUNDMAKER
LEADER_QIN
LEADER_ROBERT_THE_BRUCE
LEADER_SALADIN
LEADER_SEONDEOK
LEADER_SHAKA
LEADER_TAMAR
LEADER_TOMYRIS
LEADER_TRAJAN
LEADER_T_ROOSEVELT
LEADER_VICTORIA
LEADER_WILHELMINA

underutilized wonders (2)
BUILDING_BOLSHOI_THEATRE
BUILDING_CASA_DE_CONTRATACION
BUILDING_ESTADIO_DO_MARACANA
BUILDING_FORBIDDEN_CITY
BUILDING_POTALA_PALACE
BUILDING_SYDNEY_OPERA_HOUSE
BUILDING_VENETIAN_ARSENAL

underutilized wonders (1)
BUILDING_AMUNDSEN_SCOTT_RESEARCH_STATION
BUILDING_ANGKOR_WAT
BUILDING_APADANA
BUILDING_BIG_BEN
BUILDING_HALICARNASSUS_MAUSOLEUM
BUILDING_KILWA_KISIWANI
BUILDING_KOTOKU_IN
BUILDING_TAJ_MAHAL
BUILDING_TEMPLE_ARTEMIS

not used wonders (0)
BUILDING_ST_BASILS_CATHEDRAL
BUILDING_STATUE_LIBERTY
BUILDING_HUEY_TEOCALLI
BUILDING_JEBEL_BARKAL

*/