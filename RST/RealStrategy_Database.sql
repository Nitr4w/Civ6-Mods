-- ===========================================================================
-- Real Strategy
-- Author: Infixo
-- 2018-12-14: Created
-- ===========================================================================

-- just to make versioning easier
INSERT INTO GlobalParameters (Name, Value) VALUES ('RST_VERSION_MAJOR', '0');
INSERT INTO GlobalParameters (Name, Value) VALUES ('RST_VERSION_MINOR', '1');

-- configuration
INSERT INTO GlobalParameters (Name, Value) VALUES ('RST_OPTION_LOG_STRAT', '1'); -- log strategy priorities
INSERT INTO GlobalParameters (Name, Value) VALUES ('RST_OPTION_LOG_GUESS', '1'); -- log guess priorities


-- ===========================================================================
-- Parameters
-- ===========================================================================

INSERT INTO GlobalParameters (Name, Value) VALUES
-- weights
('RST_WEIGHT_LEADER', 20), -- weight of the leader's base priority
('RST_WEIGHT_POLICY', 3), -- how much each slotted policy weights
('RST_WEIGHT_WONDER', 3), -- how much each wonder weights
('RST_WEIGHT_GOVERNMENT', 6), -- how much each government weights
('RST_WEIGHT_MINOR', 4), -- how much each suzerained city state weights
('RST_WEIGHT_GREAT_PERSON', 1), -- how much each earned GP weights
('RST_WEIGHT_BELIEF', 3), -- how much each earned belief weights
-- generic
('RST_STRATEGY_LEADER_ERA_BIAS', 120), -- [x100] leader's individual bias is multiplied by Era and this factor, def. 250, for Atomic=7, low=2 mid=5 high=8 => 17 / 42 / 67
('RST_STRATEGY_TURN_ADJUST_START', 25), -- [x100] specific and generic priorities scale lineary, value at turn 0
('RST_STRATEGY_TURN_ADJUST_STOP', 200), -- [x100] specific and generic priorities scale lineary, value at the last turn
('RST_STRATEGY_NUM_TURNS_MUST_BE_ACTIVE', 5), -- how many turns a strategy must be active before checking for new priorities, def. 10
('RST_STRATEGY_MINIMUM_PRIORITY', 100), -- minimum priority to activate a strategy
('RST_STRATEGY_CURRENT_PRIORITY', 40), -- how much current strategy adds to the priority, random between 20..40
('RST_STRATEGY_RANDOM_PRIORITY', 30), -- random part of the priority, def. 50
('RST_STRATEGY_BETTER_THAN_US_NERF', -25), -- [x100] each player better than us decreases our priority by this percent -- VP uses 33, seems a lot
('RST_STRATEGY_COMPARE_OTHERS_NUM_TURNS', 40), -- def. 60, generic parameter for all strategies, we will start comparing with other known civs after this many turns
-- conquest
('RST_CONQUEST_NOBODY_MET_NUM_TURNS', 20), -- will check if anybody met after this many turns, def. 20
('RST_CONQUEST_NOBODY_MET_PRIORITY', -200), -- if nobody met, then decrease the priority, def. -100 -> this is scaled in a moment by approx. 0.3, so -100 gives actually -30.
('RST_CONQUEST_CAPTURED_CAPITAL_PRIORITY', 60), -- increase conquest priority for each captured capital if we have more than 1, def. 125 + added in VP, seems quite a lot?
('RST_CONQUEST_POWER_RATIO_MULTIPLIER', 100), -- how does our military strength compare to others, -100 = we are at 0, 0 = we are average, +100 = we are 2x as average, +200 = we are 3x as average, etc.
('RST_CONQUEST_AT_WAR_PRIORITY', 20), -- conquest priority for each ongoing war with a major civ, def. 10
('RST_CONQUEST_SOMEONE_CLOSE_TO_VICTORY', 15), -- add this for each player close to victory when we are NOT, def. 25 (desperate!), multiplied by ERA - seems a lot!!!
('RST_CONQUEST_BOTH_CLOSE_TO_VICTORY', 5), -- add this for each player close to victory when we are too, def. 5, multiplied by ERA
('RST_CONQUEST_LESS_CITIES_WEIGHT', 15), -- added for each city we have less than all known civs on average, because conquest is a wide play, check together with power
('RST_CONQUEST_NUKE_THREAT', -50), -- others have WMDs, but we don't, counted only once?
-- science
--('RST_SCIENCE_YIELD_WEIGHT', 20), -- [x100] how much each beaker weights
('RST_SCIENCE_YIELD_RATIO_MULTIPLIER', 80), -- how does our situation compare to others, -100..100 and more
--('RST_SCIENCE_TECH_WEIGHT', 20), -- each tech we are ahead of average -- with techs it is difficult to be very ahead, and techs are limited, so each one is important
('RST_SCIENCE_TECH_RATIO_MULTIPLIER', 80), -- how does our situation compare to others, -100..100 and more
('RST_SCIENCE_PROJECT_WEIGHT', 60), -- each completed space race project
('RST_SCIENCE_HAS_SPACEPORT', 30), -- adds if player has a spaceport
-- culture
--('RST_CULTURE_YIELD_WEIGHT', 20), -- [x100] how much culture yield is worth
--('RST_CULTURE_TOURISM_WEIGHT', 20), -- [x100] how much tourism yield is worth
('RST_CULTURE_YIELD_RATIO_MULTIPLIER', 80), -- how does our situation compare to others, -100..100 and more
--('RST_CULTURE_TOURISM_RATIO_MULTIPLIER', 50), -- how does our situation compare to others, -100..100 and more  -- USE +AVERAGE approach?
-- tourism is tough to measure! yields are very small at the begining
-- try different approach - for Ancient & Classical use weight (like 1 Tourism = 2-3 pts.), after that use avg HOWEVER 
-- also cannot use Tourism to Guess - too rare in early game
('RST_CULTURE_PROGRESS_EXPONENT', 3), -- [x100], cultural progress formula, exponent => 0.03 speeds up after 50 and goes high after 80
('RST_CULTURE_PROGRESS_MULTIPLIER', 22), -- cultural progress formula, multiplier; 50 => 80, 60 => 110, 70 => 160, 80 => 220, 90 => 300
-- religion
--('RST_RELIGION_FAITH_YIELD_WEIGHT', 25), -- [x100] faith yield
('RST_RELIGION_FAITH_FACTOR', 10), -- how does our situation compare to others; uses typical formula but actual Multiplier = Factor * Era - this smoothes down early faith jumps
--('RST_RELIGION_CITIES_RATIO_MULTIPLIER', 40), -- number of cities following our religion, how does our situation compare to others, -100..100 and more - problem with early converts, gives huge negatives when working your own empire even
('RST_RELIGION_CITIES_EXPONENT', 3), -- [x100], cultural progress formula used for cities converted, exponent => 0.03 speeds up after 50 and goes high after 80
('RST_RELIGION_CITIES_MULTIPLIER', 25), -- cultural progress formula used for cities converted, multiplier; 50 => 90, 60 => 130, 70 => 180, 80 => 250, 90 => 350
('RST_RELIGION_RELIGION_WEIGHT', 40), -- founded religion
('RST_RELIGION_CONVERTED_WEIGHT', 60), -- each converted civ after 1 (I assume the 1st is us)
('RST_RELIGION_INQUISITION_WEIGHT', -20), -- each inquisition launched by others decreases the priority
('RST_RELIGION_NOBODY_MET_NUM_TURNS', 20), -- will check if anybody met after this many turns, def. 20
('RST_RELIGION_NOBODY_MET_PRIORITY', 0); -- if nobody met, then decrease the priority, def. -100 -> ???? But we still need a religion! Conquest is different, it is not limited; we shouldn't stop here I think


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

UPDATE AiFavoredItems SET Value =  50 WHERE ListType = 'MilitaryVictoryPseudoYields' AND Item = 'PSEUDOYIELD_NUCLEAR_WEAPON'; -- def. 25
UPDATE AiFavoredItems SET Value =  50 WHERE ListType = 'MilitaryVictoryPseudoYields' AND Item = 'PSEUDOYIELD_UNIT_AIR_COMBAT'; -- def. 25
UPDATE AiFavoredItems SET Value =  50 WHERE ListType = 'MilitaryVictoryPseudoYields' AND Item = 'PSEUDOYIELD_UNIT_COMBAT'; -- def. 25
UPDATE AiFavoredItems SET Value =  15 WHERE ListType = 'MilitaryVictoryPseudoYields' AND Item = 'PSEUDOYIELD_UNIT_NAVAL_COMBAT'; -- def. 25 -- leave it for Naval strategies

INSERT INTO AiFavoredItems (ListType, Item, Favored, Value) VALUES
('MilitaryVictoryYields', 'YIELD_SCIENCE', 1,  15),
('MilitaryVictoryYields', 'YIELD_FAITH',   1, -25),
('MilitaryVictoryPseudoYields', 'PSEUDOYIELD_CITY_BASE', 1, 150), -- base 350 - or maybe 15000????
('MilitaryVictoryPseudoYields', 'PSEUDOYIELD_SPACE_RACE', 1, -100), -- base 100, so it should be 100*100 by logic???
('MilitaryVictoryPseudoYields', 'PSEUDOYIELD_CLEAR_BANDIT_CAMPS', 1, 2), -- base 1.6, agenda lover uses 5
('MilitaryVictoryPseudoYields', 'PSEUDOYIELD_CITY_DEFENDING_UNITS', 1, -20), -- base 100
('MilitaryVictoryPseudoYields', 'PSEUDOYIELD_GPP_SCIENTIST', 1, 15), -- base 1.0
('MilitaryVictoryPseudoYields', 'PSEUDOYIELD_GPP_PROPHET', 1, -25), -- base 0.8
('MilitaryVictoryPseudoYields', 'PSEUDOYIELD_GPP_ADMIRAL', 1, 25), -- base 0.8
('MilitaryVictoryPseudoYields', 'PSEUDOYIELD_GPP_GENERAL', 1, 50), -- base 0.8
('MilitaryVictoryPseudoYields', 'PSEUDOYIELD_TOURISM', 1, -50), -- base 1
('MilitaryVictoryPseudoYields', 'PSEUDOYIELD_TECHNOLOGY', 1, 50); -- base 3

INSERT INTO AiListTypes (ListType) VALUES
('MilitaryVictoryDiplomacy'),
('MilitaryVictoryTechs'),
('MilitaryVictoryCivics'),
('MilitaryVictoryWonders'),
('MilitaryVictoryProjects');
INSERT INTO AiLists (ListType, System) VALUES
('MilitaryVictoryDiplomacy', 'DiplomaticActions'),
('MilitaryVictoryTechs',     'Technologies'),
('MilitaryVictoryCivics',    'Civics'),
('MilitaryVictoryWonders',   'Buildings'),
('MilitaryVictoryProjects',  'Projects');
INSERT INTO Strategy_Priorities (StrategyType, ListType) VALUES
('VICTORY_STRATEGY_MILITARY_VICTORY', 'MilitaryVictoryDiplomacy'),
('VICTORY_STRATEGY_MILITARY_VICTORY', 'MilitaryVictoryTechs'),
('VICTORY_STRATEGY_MILITARY_VICTORY', 'MilitaryVictoryCivics'),
('VICTORY_STRATEGY_MILITARY_VICTORY', 'MilitaryVictoryWonders'),
('VICTORY_STRATEGY_MILITARY_VICTORY', 'MilitaryVictoryProjects');
INSERT INTO AiFavoredItems (ListType, Item, Favored, Value) VALUES
--('MilitaryVictoryDiplomacy', 'DIPLOACTION_MAKE_PEACE', 0, 0), -- notice! it is FALSE
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
('MilitaryVictoryProjects', 'PROJECT_BUILD_THERMONUCLEAR_DEVICE', 1, 0);


-- ===========================================================================
-- Changes to existing leaders and civs --> move to a separate file eventually
-- ===========================================================================

-- KHMER / JAYAVARMAN
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
('JayavarmanPseudoYields', 'PSEUDOYIELD_UNIT_COMBAT', 1, -20),
('JayavarmanPseudoYields', 'PSEUDOYIELD_UNIT_NAVAL_COMBAT', 1, -20);



-- ===========================================================================
-- Flavors
-- ===========================================================================

CREATE TABLE RSTFlavors (
	ObjectType TEXT NOT NULL,
	Type TEXT NOT NULL CHECK (Type IN ('Parameter', 'STRATEGY', 'LEADER', 'POLICY', 'GOVERNMENT', 'Wonder', 'BELIEF', 'CityState', 'GreatPerson')),
	Subtype TEXT,
	Strategy TEXT NOT NULL CHECK (Strategy IN ('CONQUEST', 'SCIENCE', 'CULTURE', 'RELIGION', 'DIPLO', 'DEFENCE', 'NAVAL', 'TRADE')),
	Value INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY (ObjectType, Strategy)
);
/* not used
INSERT INTO RSTFlavors (ObjectType, Type, Subtype, Strategy, Value) VALUES -- generated from Excel
('BasePriority', 'Parameter', 'STRATEGY', 'SCIENCE', 20),	('BasePriority', 'Parameter', 'STRATEGY', 'CULTURE', 20),	('BasePriority', 'Parameter', 'STRATEGY', 'RELIGION', 20),	('BasePriority', 'Parameter', 'STRATEGY', 'CONQUEST', 20),
('SCIENCE', 'Parameter', 'STRATEGY', 'SCIENCE', 2),	('SCIENCE', 'Parameter', 'STRATEGY', 'CULTURE', -2),	('SCIENCE', 'Parameter', 'STRATEGY', 'RELIGION', -2),	('SCIENCE', 'Parameter', 'STRATEGY', 'CONQUEST', 1),
('CULTURE', 'Parameter', 'STRATEGY', 'SCIENCE', -2),	('CULTURE', 'Parameter', 'STRATEGY', 'CULTURE', 2),	('CULTURE', 'Parameter', 'STRATEGY', 'RELIGION', -1),	('CULTURE', 'Parameter', 'STRATEGY', 'CONQUEST', -2),
('RELIGION', 'Parameter', 'STRATEGY', 'SCIENCE', -2),	('RELIGION', 'Parameter', 'STRATEGY', 'CULTURE', -1),	('RELIGION', 'Parameter', 'STRATEGY', 'RELIGION', 2),	
('CONQUEST', 'Parameter', 'STRATEGY', 'SCIENCE', 1),	('CONQUEST', 'Parameter', 'STRATEGY', 'CULTURE', -1),	('CONQUEST', 'Parameter', 'STRATEGY', 'RELIGION', -1),	('CONQUEST', 'Parameter', 'STRATEGY', 'CONQUEST', 3),
('DIPLO', 'Parameter', 'STRATEGY', 'CULTURE', 1),		('DIPLO', 'Parameter', 'STRATEGY', 'CONQUEST', -1);
*/
-- LEADERS
INSERT INTO RSTFlavors (ObjectType, Type, Subtype, Strategy, Value) VALUES -- generated from Excel
('LEADER_ALEXANDER', 'LEADER', '', 'SCIENCE', 5),	('LEADER_ALEXANDER', 'LEADER', '', 'CULTURE', 4),	('LEADER_ALEXANDER', 'LEADER', '', 'RELIGION', 3),	('LEADER_ALEXANDER', 'LEADER', '', 'CONQUEST', 8),
('LEADER_AMANITORE', 'LEADER', '', 'SCIENCE', 2),	('LEADER_AMANITORE', 'LEADER', '', 'CULTURE', 3),	('LEADER_AMANITORE', 'LEADER', '', 'RELIGION', 6),	('LEADER_AMANITORE', 'LEADER', '', 'CONQUEST', 5),
('LEADER_BARBAROSSA', 'LEADER', '', 'SCIENCE', 7),	('LEADER_BARBAROSSA', 'LEADER', '', 'CULTURE', 4),	('LEADER_BARBAROSSA', 'LEADER', '', 'RELIGION', 4),	('LEADER_BARBAROSSA', 'LEADER', '', 'CONQUEST', 6),
('LEADER_CATHERINE_DE_MEDICI', 'LEADER', '', 'SCIENCE', 6),	('LEADER_CATHERINE_DE_MEDICI', 'LEADER', '', 'CULTURE', 8),	('LEADER_CATHERINE_DE_MEDICI', 'LEADER', '', 'RELIGION', 4),	('LEADER_CATHERINE_DE_MEDICI', 'LEADER', '', 'CONQUEST', 4),
('LEADER_CHANDRAGUPTA', 'LEADER', '', 'SCIENCE', 4),	('LEADER_CHANDRAGUPTA', 'LEADER', '', 'CULTURE', 4),	('LEADER_CHANDRAGUPTA', 'LEADER', '', 'RELIGION', 5),	('LEADER_CHANDRAGUPTA', 'LEADER', '', 'CONQUEST', 6),
('LEADER_CLEOPATRA', 'LEADER', '', 'SCIENCE', 5),	('LEADER_CLEOPATRA', 'LEADER', '', 'CULTURE', 6),	('LEADER_CLEOPATRA', 'LEADER', '', 'RELIGION', 5),	('LEADER_CLEOPATRA', 'LEADER', '', 'CONQUEST', 5),
('LEADER_CYRUS', 'LEADER', '', 'SCIENCE', 5),	('LEADER_CYRUS', 'LEADER', '', 'CULTURE', 4),	('LEADER_CYRUS', 'LEADER', '', 'RELIGION', 4),	('LEADER_CYRUS', 'LEADER', '', 'CONQUEST', 8),
('LEADER_GANDHI', 'LEADER', '', 'SCIENCE', 5),	('LEADER_GANDHI', 'LEADER', '', 'CULTURE', 7),	('LEADER_GANDHI', 'LEADER', '', 'RELIGION', 8),	('LEADER_GANDHI', 'LEADER', '', 'CONQUEST', 2),
('LEADER_GENGHIS_KHAN', 'LEADER', '', 'SCIENCE', 4),	('LEADER_GENGHIS_KHAN', 'LEADER', '', 'CULTURE', 2),	('LEADER_GENGHIS_KHAN', 'LEADER', '', 'RELIGION', 2),	('LEADER_GENGHIS_KHAN', 'LEADER', '', 'CONQUEST', 8),
('LEADER_GILGAMESH', 'LEADER', '', 'SCIENCE', 8),	('LEADER_GILGAMESH', 'LEADER', '', 'CULTURE', 4),	('LEADER_GILGAMESH', 'LEADER', '', 'RELIGION', 2),	('LEADER_GILGAMESH', 'LEADER', '', 'CONQUEST', 5),
('LEADER_GITARJA', 'LEADER', '', 'SCIENCE', 4),	('LEADER_GITARJA', 'LEADER', '', 'CULTURE', 5),	('LEADER_GITARJA', 'LEADER', '', 'RELIGION', 7),	('LEADER_GITARJA', 'LEADER', '', 'CONQUEST', 3),
('LEADER_GORGO', 'LEADER', '', 'SCIENCE', 2),	('LEADER_GORGO', 'LEADER', '', 'CULTURE', 5),	('LEADER_GORGO', 'LEADER', '', 'RELIGION', 3),	('LEADER_GORGO', 'LEADER', '', 'CONQUEST', 7),
('LEADER_HARDRADA', 'LEADER', '', 'SCIENCE', 5),	('LEADER_HARDRADA', 'LEADER', '', 'CULTURE', 1),	('LEADER_HARDRADA', 'LEADER', '', 'RELIGION', 5),	('LEADER_HARDRADA', 'LEADER', '', 'CONQUEST', 7),
('LEADER_HOJO', 'LEADER', '', 'SCIENCE', 5),	('LEADER_HOJO', 'LEADER', '', 'CULTURE', 4),	('LEADER_HOJO', 'LEADER', '', 'RELIGION', 2),	('LEADER_HOJO', 'LEADER', '', 'CONQUEST', 7),
('LEADER_JADWIGA', 'LEADER', '', 'SCIENCE', 4),	('LEADER_JADWIGA', 'LEADER', '', 'CULTURE', 6),	('LEADER_JADWIGA', 'LEADER', '', 'RELIGION', 7),	('LEADER_JADWIGA', 'LEADER', '', 'CONQUEST', 4),
('LEADER_JAYAVARMAN', 'LEADER', '', 'SCIENCE', 4),	('LEADER_JAYAVARMAN', 'LEADER', '', 'CULTURE', 5),	('LEADER_JAYAVARMAN', 'LEADER', '', 'RELIGION', 8),	('LEADER_JAYAVARMAN', 'LEADER', '', 'CONQUEST', 3),
('LEADER_JOHN_CURTIN', 'LEADER', '', 'SCIENCE', 6),	('LEADER_JOHN_CURTIN', 'LEADER', '', 'CULTURE', 6),	('LEADER_JOHN_CURTIN', 'LEADER', '', 'RELIGION', 4),	('LEADER_JOHN_CURTIN', 'LEADER', '', 'CONQUEST', 4),
('LEADER_LAUTARO', 'LEADER', '', 'SCIENCE', 2),	('LEADER_LAUTARO', 'LEADER', '', 'CULTURE', 7),	('LEADER_LAUTARO', 'LEADER', '', 'RELIGION', 3),	('LEADER_LAUTARO', 'LEADER', '', 'CONQUEST', 7),
('LEADER_MONTEZUMA', 'LEADER', '', 'SCIENCE', 3),	('LEADER_MONTEZUMA', 'LEADER', '', 'CULTURE', 2),	('LEADER_MONTEZUMA', 'LEADER', '', 'RELIGION', 2),	('LEADER_MONTEZUMA', 'LEADER', '', 'CONQUEST', 9),
('LEADER_MVEMBA', 'LEADER', '', 'SCIENCE', 6),	('LEADER_MVEMBA', 'LEADER', '', 'CULTURE', 8),	('LEADER_MVEMBA', 'LEADER', '', 'RELIGION', 1),	('LEADER_MVEMBA', 'LEADER', '', 'CONQUEST', 2),
('LEADER_PEDRO', 'LEADER', '', 'SCIENCE', 6),	('LEADER_PEDRO', 'LEADER', '', 'CULTURE', 8),	('LEADER_PEDRO', 'LEADER', '', 'RELIGION', 3),	('LEADER_PEDRO', 'LEADER', '', 'CONQUEST', 3),
('LEADER_PERICLES', 'LEADER', '', 'SCIENCE', 5),	('LEADER_PERICLES', 'LEADER', '', 'CULTURE', 8),	('LEADER_PERICLES', 'LEADER', '', 'RELIGION', 3),	('LEADER_PERICLES', 'LEADER', '', 'CONQUEST', 3),
('LEADER_PETER_GREAT', 'LEADER', '', 'SCIENCE', 5),	('LEADER_PETER_GREAT', 'LEADER', '', 'CULTURE', 5),	('LEADER_PETER_GREAT', 'LEADER', '', 'RELIGION', 6),	('LEADER_PETER_GREAT', 'LEADER', '', 'CONQUEST', 4),
('LEADER_PHILIP_II', 'LEADER', '', 'SCIENCE', 4),	('LEADER_PHILIP_II', 'LEADER', '', 'CULTURE', 3),	('LEADER_PHILIP_II', 'LEADER', '', 'RELIGION', 7),	('LEADER_PHILIP_II', 'LEADER', '', 'CONQUEST', 5),
('LEADER_POUNDMAKER', 'LEADER', '', 'SCIENCE', 6),	('LEADER_POUNDMAKER', 'LEADER', '', 'CULTURE', 5),	('LEADER_POUNDMAKER', 'LEADER', '', 'RELIGION', 5),	('LEADER_POUNDMAKER', 'LEADER', '', 'CONQUEST', 4),
('LEADER_QIN', 'LEADER', '', 'SCIENCE', 6),	('LEADER_QIN', 'LEADER', '', 'CULTURE', 7),	('LEADER_QIN', 'LEADER', '', 'RELIGION', 5),	('LEADER_QIN', 'LEADER', '', 'CONQUEST', 5),
('LEADER_ROBERT_THE_BRUCE', 'LEADER', '', 'SCIENCE', 7),	('LEADER_ROBERT_THE_BRUCE', 'LEADER', '', 'CULTURE', 4),	('LEADER_ROBERT_THE_BRUCE', 'LEADER', '', 'RELIGION', 2),	('LEADER_ROBERT_THE_BRUCE', 'LEADER', '', 'CONQUEST', 4),
('LEADER_SALADIN', 'LEADER', '', 'SCIENCE', 7),	('LEADER_SALADIN', 'LEADER', '', 'CULTURE', 4),	('LEADER_SALADIN', 'LEADER', '', 'RELIGION', 7),	('LEADER_SALADIN', 'LEADER', '', 'CONQUEST', 4),
('LEADER_SEONDEOK', 'LEADER', '', 'SCIENCE', 9),	('LEADER_SEONDEOK', 'LEADER', '', 'CULTURE', 5),	('LEADER_SEONDEOK', 'LEADER', '', 'RELIGION', 1),	('LEADER_SEONDEOK', 'LEADER', '', 'CONQUEST', 5),
('LEADER_SHAKA', 'LEADER', '', 'SCIENCE', 3),	('LEADER_SHAKA', 'LEADER', '', 'CULTURE', 2),	('LEADER_SHAKA', 'LEADER', '', 'RELIGION', 2),	('LEADER_SHAKA', 'LEADER', '', 'CONQUEST', 9),
('LEADER_TAMAR', 'LEADER', '', 'SCIENCE', 3),	('LEADER_TAMAR', 'LEADER', '', 'CULTURE', 4),	('LEADER_TAMAR', 'LEADER', '', 'RELIGION', 7),	('LEADER_TAMAR', 'LEADER', '', 'CONQUEST', 6),
('LEADER_TOMYRIS', 'LEADER', '', 'SCIENCE', 2),	('LEADER_TOMYRIS', 'LEADER', '', 'CULTURE', 3),	('LEADER_TOMYRIS', 'LEADER', '', 'RELIGION', 4),	('LEADER_TOMYRIS', 'LEADER', '', 'CONQUEST', 8),
('LEADER_TRAJAN', 'LEADER', '', 'SCIENCE', 4),	('LEADER_TRAJAN', 'LEADER', '', 'CULTURE', 2),	('LEADER_TRAJAN', 'LEADER', '', 'RELIGION', 2),	('LEADER_TRAJAN', 'LEADER', '', 'CONQUEST', 8),
('LEADER_T_ROOSEVELT', 'LEADER', '', 'SCIENCE', 5),	('LEADER_T_ROOSEVELT', 'LEADER', '', 'CULTURE', 7),	('LEADER_T_ROOSEVELT', 'LEADER', '', 'RELIGION', 3),	('LEADER_T_ROOSEVELT', 'LEADER', '', 'CONQUEST', 4),
('LEADER_VICTORIA', 'LEADER', '', 'SCIENCE', 5),	('LEADER_VICTORIA', 'LEADER', '', 'CULTURE', 7),	('LEADER_VICTORIA', 'LEADER', '', 'RELIGION', 2),	('LEADER_VICTORIA', 'LEADER', '', 'CONQUEST', 7),
('LEADER_WILHELMINA', 'LEADER', '', 'SCIENCE', 5),	('LEADER_WILHELMINA', 'LEADER', '', 'CULTURE', 6),	('LEADER_WILHELMINA', 'LEADER', '', 'RELIGION', 2),	('LEADER_WILHELMINA', 'LEADER', '', 'CONQUEST', 5);

-- GOVERNMENTS
INSERT INTO RSTFlavors (ObjectType, Type, Subtype, Strategy, Value) VALUES -- generated from Excel
('GOVERNMENT_CHIEFDOM', 'GOVERNMENT', 'TIER_0', 'SCIENCE', 2),	('GOVERNMENT_CHIEFDOM', 'GOVERNMENT', 'TIER_0', 'CULTURE', 2),	('GOVERNMENT_CHIEFDOM', 'GOVERNMENT', 'TIER_0', 'RELIGION', 2),	('GOVERNMENT_CHIEFDOM', 'GOVERNMENT', 'TIER_0', 'CONQUEST', 2),
('GOVERNMENT_AUTOCRACY', 'GOVERNMENT', 'TIER_1', 'SCIENCE', 2),	('GOVERNMENT_AUTOCRACY', 'GOVERNMENT', 'TIER_1', 'CULTURE', 4),	('GOVERNMENT_AUTOCRACY', 'GOVERNMENT', 'TIER_1', 'RELIGION', 2),	('GOVERNMENT_AUTOCRACY', 'GOVERNMENT', 'TIER_1', 'CONQUEST', 4),
('GOVERNMENT_OLIGARCHY', 'GOVERNMENT', 'TIER_1', 'SCIENCE', 2),	('GOVERNMENT_OLIGARCHY', 'GOVERNMENT', 'TIER_1', 'CULTURE', 2),	('GOVERNMENT_OLIGARCHY', 'GOVERNMENT', 'TIER_1', 'RELIGION', 2),	('GOVERNMENT_OLIGARCHY', 'GOVERNMENT', 'TIER_1', 'CONQUEST', 6),
('GOVERNMENT_CLASSICAL_REPUBLIC', 'GOVERNMENT', 'TIER_1', 'SCIENCE', 3),	('GOVERNMENT_CLASSICAL_REPUBLIC', 'GOVERNMENT', 'TIER_1', 'CULTURE', 3),	('GOVERNMENT_CLASSICAL_REPUBLIC', 'GOVERNMENT', 'TIER_1', 'RELIGION', 1),	('GOVERNMENT_CLASSICAL_REPUBLIC', 'GOVERNMENT', 'TIER_1', 'CONQUEST', 1),
('GOVERNMENT_MONARCHY', 'GOVERNMENT', 'TIER_2', 'SCIENCE', 2),	('GOVERNMENT_MONARCHY', 'GOVERNMENT', 'TIER_2', 'CULTURE', 2),	('GOVERNMENT_MONARCHY', 'GOVERNMENT', 'TIER_2', 'RELIGION', 2),	('GOVERNMENT_MONARCHY', 'GOVERNMENT', 'TIER_2', 'CONQUEST', 4),
('GOVERNMENT_THEOCRACY', 'GOVERNMENT', 'TIER_2', 'SCIENCE', 2),	('GOVERNMENT_THEOCRACY', 'GOVERNMENT', 'TIER_2', 'CULTURE', 2),	('GOVERNMENT_THEOCRACY', 'GOVERNMENT', 'TIER_2', 'RELIGION', 7),	('GOVERNMENT_THEOCRACY', 'GOVERNMENT', 'TIER_2', 'CONQUEST', 4),
('GOVERNMENT_MERCHANT_REPUBLIC', 'GOVERNMENT', 'TIER_2', 'SCIENCE', 4),	('GOVERNMENT_MERCHANT_REPUBLIC', 'GOVERNMENT', 'TIER_2', 'CULTURE', 4),	('GOVERNMENT_MERCHANT_REPUBLIC', 'GOVERNMENT', 'TIER_2', 'RELIGION', 3),	('GOVERNMENT_MERCHANT_REPUBLIC', 'GOVERNMENT', 'TIER_2', 'CONQUEST', 2),
('GOVERNMENT_FASCISM', 'GOVERNMENT', 'TIER_3', 'SCIENCE', 2),	('GOVERNMENT_FASCISM', 'GOVERNMENT', 'TIER_3', 'CULTURE', 2),	('GOVERNMENT_FASCISM', 'GOVERNMENT', 'TIER_3', 'RELIGION', 1),	('GOVERNMENT_FASCISM', 'GOVERNMENT', 'TIER_3', 'CONQUEST', 9),
('GOVERNMENT_COMMUNISM', 'GOVERNMENT', 'TIER_3', 'SCIENCE', 7),	('GOVERNMENT_COMMUNISM', 'GOVERNMENT', 'TIER_3', 'CULTURE', 3),	('GOVERNMENT_COMMUNISM', 'GOVERNMENT', 'TIER_3', 'RELIGION', 1),	('GOVERNMENT_COMMUNISM', 'GOVERNMENT', 'TIER_3', 'CONQUEST', 4),
('GOVERNMENT_DEMOCRACY', 'GOVERNMENT', 'TIER_3', 'SCIENCE', 5),	('GOVERNMENT_DEMOCRACY', 'GOVERNMENT', 'TIER_3', 'CULTURE', 7),	('GOVERNMENT_DEMOCRACY', 'GOVERNMENT', 'TIER_3', 'RELIGION', 3),	('GOVERNMENT_DEMOCRACY', 'GOVERNMENT', 'TIER_3', 'CONQUEST', 1);

-- POLICIES
INSERT INTO RSTFlavors (ObjectType, Type, Subtype, Strategy, Value) VALUES -- generated from Excel
	('POLICY_AESTHETICS', 'POLICY', 'ECONOMIC', 'CULTURE', 7),		
			('POLICY_AFTER_ACTION_REPORTS', 'POLICY', 'MILITARY', 'CONQUEST', 5),
			('POLICY_AGOGE', 'POLICY', 'MILITARY', 'CONQUEST', 6),
('POLICY_ARSENAL_OF_DEMOCRACY', 'POLICY', 'DIPLOMATIC', 'SCIENCE', 2),	('POLICY_ARSENAL_OF_DEMOCRACY', 'POLICY', 'DIPLOMATIC', 'CULTURE', 1),	('POLICY_ARSENAL_OF_DEMOCRACY', 'POLICY', 'DIPLOMATIC', 'RELIGION', 1),	('POLICY_ARSENAL_OF_DEMOCRACY', 'POLICY', 'DIPLOMATIC', 'CONQUEST', 2),
			
			
			
			('POLICY_CHIVALRY', 'POLICY', 'MILITARY', 'CONQUEST', 6),
('POLICY_CIVIL_PRESTIGE', 'POLICY', 'ECONOMIC', 'SCIENCE', 1),	('POLICY_CIVIL_PRESTIGE', 'POLICY', 'ECONOMIC', 'CULTURE', 1),	('POLICY_CIVIL_PRESTIGE', 'POLICY', 'ECONOMIC', 'RELIGION', 1),	('POLICY_CIVIL_PRESTIGE', 'POLICY', 'ECONOMIC', 'CONQUEST', 1),
	('POLICY_COLLECTIVE_ACTIVISM', 'POLICY', 'DIPLOMATIC', 'CULTURE', 6),		
('POLICY_COLLECTIVISM', 'POLICY', 'DARKAGE', 'SCIENCE', 1),	('POLICY_COLLECTIVISM', 'POLICY', 'DARKAGE', 'CULTURE', -2),		('POLICY_COLLECTIVISM', 'POLICY', 'DARKAGE', 'CONQUEST', 2),
('POLICY_COLLECTIVIZATION', 'POLICY', 'ECONOMIC', 'SCIENCE', 1),	('POLICY_COLLECTIVIZATION', 'POLICY', 'ECONOMIC', 'CULTURE', 1),		
			('POLICY_COLONIAL_OFFICES', 'POLICY', 'ECONOMIC', 'CONQUEST', 4),
			('POLICY_COLONIAL_TAXES', 'POLICY', 'ECONOMIC', 'CONQUEST', 4),
('POLICY_COLONIZATION', 'POLICY', 'ECONOMIC', 'SCIENCE', 2),	('POLICY_COLONIZATION', 'POLICY', 'ECONOMIC', 'CULTURE', 2),	('POLICY_COLONIZATION', 'POLICY', 'ECONOMIC', 'RELIGION', 2),	('POLICY_COLONIZATION', 'POLICY', 'ECONOMIC', 'CONQUEST', 2),
			('POLICY_COMMUNICATIONS_OFFICE', 'POLICY', 'DIPLOMATIC', 'CONQUEST', 3),
			('POLICY_CONSCRIPTION', 'POLICY', 'MILITARY', 'CONQUEST', 3),
			
('POLICY_CORVEE', 'POLICY', 'ECONOMIC', 'SCIENCE', 1),	('POLICY_CORVEE', 'POLICY', 'ECONOMIC', 'CULTURE', 2),	('POLICY_CORVEE', 'POLICY', 'ECONOMIC', 'RELIGION', 2),	('POLICY_CORVEE', 'POLICY', 'ECONOMIC', 'CONQUEST', 1),
('POLICY_CRAFTSMEN', 'POLICY', 'ECONOMIC', 'SCIENCE', 2),			('POLICY_CRAFTSMEN', 'POLICY', 'ECONOMIC', 'CONQUEST', 2),
			('POLICY_CRYPTOGRAPHY', 'POLICY', 'DIPLOMATIC', 'CONQUEST', 1),
			
			('POLICY_DISCIPLINE', 'POLICY', 'MILITARY', 'CONQUEST', 2),
			
('POLICY_ECOMMERCE', 'POLICY', 'ECONOMIC', 'SCIENCE', 3),			
			
			('POLICY_ELITE_FORCES', 'POLICY', 'DARKAGE', 'CONQUEST', 5),
('POLICY_EXPROPRIATION', 'POLICY', 'ECONOMIC', 'SCIENCE', 2),	('POLICY_EXPROPRIATION', 'POLICY', 'ECONOMIC', 'CULTURE', 2),	('POLICY_EXPROPRIATION', 'POLICY', 'ECONOMIC', 'RELIGION', 2),	('POLICY_EXPROPRIATION', 'POLICY', 'ECONOMIC', 'CONQUEST', 2),
			('POLICY_FEUDAL_CONTRACT', 'POLICY', 'MILITARY', 'CONQUEST', 6),
			('POLICY_FINEST_HOUR', 'POLICY', 'MILITARY', 'CONQUEST', 7),
('POLICY_FIVE_YEAR_PLAN', 'POLICY', 'ECONOMIC', 'SCIENCE', 6),			('POLICY_FIVE_YEAR_PLAN', 'POLICY', 'ECONOMIC', 'CONQUEST', 3),
('POLICY_FREE_MARKET', 'POLICY', 'ECONOMIC', 'SCIENCE', 1),	('POLICY_FREE_MARKET', 'POLICY', 'ECONOMIC', 'CULTURE', 1),	('POLICY_FREE_MARKET', 'POLICY', 'ECONOMIC', 'RELIGION', 1),	('POLICY_FREE_MARKET', 'POLICY', 'ECONOMIC', 'CONQUEST', 1),
	('POLICY_FRESCOES', 'POLICY', 'GREAT_PERSON', 'CULTURE', 5),		
		('POLICY_GOD_KING', 'POLICY', 'ECONOMIC', 'RELIGION', 4),	
('POLICY_GOTHIC_ARCHITECTURE', 'POLICY', 'ECONOMIC', 'SCIENCE', 2),	('POLICY_GOTHIC_ARCHITECTURE', 'POLICY', 'ECONOMIC', 'CULTURE', 3),	('POLICY_GOTHIC_ARCHITECTURE', 'POLICY', 'ECONOMIC', 'RELIGION', 3),	('POLICY_GOTHIC_ARCHITECTURE', 'POLICY', 'ECONOMIC', 'CONQUEST', 2),

('POLICY_GOV_AUTOCRACY', 'POLICY', 'WILDCARD', 'SCIENCE', 2),	('POLICY_GOV_AUTOCRACY', 'POLICY', 'WILDCARD', 'CULTURE', 2),	('POLICY_GOV_AUTOCRACY', 'POLICY', 'WILDCARD', 'RELIGION', 2),	('POLICY_GOV_AUTOCRACY', 'POLICY', 'WILDCARD', 'CONQUEST', 2),
('POLICY_GOV_CLASSICAL_REPUBLIC', 'POLICY', 'WILDCARD', 'SCIENCE', 2),	('POLICY_GOV_CLASSICAL_REPUBLIC', 'POLICY', 'WILDCARD', 'CULTURE', 2),	('POLICY_GOV_CLASSICAL_REPUBLIC', 'POLICY', 'WILDCARD', 'RELIGION', 2),	('POLICY_GOV_CLASSICAL_REPUBLIC', 'POLICY', 'WILDCARD', 'CONQUEST', 2),
('POLICY_GOV_COMMUNISM', 'POLICY', 'WILDCARD', 'SCIENCE', 3),	('POLICY_GOV_COMMUNISM', 'POLICY', 'WILDCARD', 'CULTURE', 3),	('POLICY_GOV_COMMUNISM', 'POLICY', 'WILDCARD', 'RELIGION', 1),	('POLICY_GOV_COMMUNISM', 'POLICY', 'WILDCARD', 'CONQUEST', 3),
('POLICY_GOV_DEMOCRACY', 'POLICY', 'WILDCARD', 'SCIENCE', 3),	('POLICY_GOV_DEMOCRACY', 'POLICY', 'WILDCARD', 'CULTURE', 3),	('POLICY_GOV_DEMOCRACY', 'POLICY', 'WILDCARD', 'RELIGION', 1),	('POLICY_GOV_DEMOCRACY', 'POLICY', 'WILDCARD', 'CONQUEST', 3),
			('POLICY_GOV_FASCISM', 'POLICY', 'WILDCARD', 'CONQUEST', 8),
('POLICY_GOV_MERCHANT_REPUBLIC', 'POLICY', 'WILDCARD', 'SCIENCE', 2),	('POLICY_GOV_MERCHANT_REPUBLIC', 'POLICY', 'WILDCARD', 'CULTURE', 2),	('POLICY_GOV_MERCHANT_REPUBLIC', 'POLICY', 'WILDCARD', 'RELIGION', 2),	('POLICY_GOV_MERCHANT_REPUBLIC', 'POLICY', 'WILDCARD', 'CONQUEST', 2),
('POLICY_GOV_MONARCHY', 'POLICY', 'WILDCARD', 'SCIENCE', 2),	('POLICY_GOV_MONARCHY', 'POLICY', 'WILDCARD', 'CULTURE', 2),	('POLICY_GOV_MONARCHY', 'POLICY', 'WILDCARD', 'RELIGION', 2),	('POLICY_GOV_MONARCHY', 'POLICY', 'WILDCARD', 'CONQUEST', 2),
			('POLICY_GOV_OLIGARCHY', 'POLICY', 'WILDCARD', 'CONQUEST', 6),
		('POLICY_GOV_THEOCRACY', 'POLICY', 'WILDCARD', 'RELIGION', 7),	

			('POLICY_GRANDE_ARMEE', 'POLICY', 'MILITARY', 'CONQUEST', 6),
	('POLICY_GRAND_OPERA', 'POLICY', 'ECONOMIC', 'CULTURE', 7),		
			
	('POLICY_HERITAGE_TOURISM', 'POLICY', 'ECONOMIC', 'CULTURE', 8),		
('POLICY_ILKUM', 'POLICY', 'ECONOMIC', 'SCIENCE', 1),	('POLICY_ILKUM', 'POLICY', 'ECONOMIC', 'CULTURE', 1),	('POLICY_ILKUM', 'POLICY', 'ECONOMIC', 'RELIGION', 1),	('POLICY_ILKUM', 'POLICY', 'ECONOMIC', 'CONQUEST', 1),
('POLICY_INQUISITION', 'POLICY', 'DARKAGE', 'SCIENCE', -2),			
('POLICY_INSPIRATION', 'POLICY', 'GREAT_PERSON', 'SCIENCE', 5),			
('POLICY_INSULAE', 'POLICY', 'ECONOMIC', 'SCIENCE', 1),	('POLICY_INSULAE', 'POLICY', 'ECONOMIC', 'CULTURE', 1),		
('POLICY_INTEGRATED_SPACE_CELL', 'POLICY', 'MILITARY', 'SCIENCE', 7),			
('POLICY_INTERNATIONAL_SPACE_AGENCY', 'POLICY', 'DIPLOMATIC', 'SCIENCE', 6),			
			('POLICY_INTERNATIONAL_WATERS', 'POLICY', 'MILITARY', 'CONQUEST', 3),
('POLICY_INVENTION', 'POLICY', 'GREAT_PERSON', 'SCIENCE', 2),			('POLICY_INVENTION', 'POLICY', 'GREAT_PERSON', 'CONQUEST', 2),
('POLICY_ISOLATIONISM', 'POLICY', 'DARKAGE', 'SCIENCE', 2),	('POLICY_ISOLATIONISM', 'POLICY', 'DARKAGE', 'CULTURE', 1),		('POLICY_ISOLATIONISM', 'POLICY', 'DARKAGE', 'CONQUEST', 2),
			
			
			('POLICY_LETTERS_OF_MARQUE', 'POLICY', 'DARKAGE', 'CONQUEST', 5),
			('POLICY_LEVEE_EN_MASSE', 'POLICY', 'MILITARY', 'CONQUEST', 4),
			
			('POLICY_LIGHTNING_WARFARE', 'POLICY', 'MILITARY', 'CONQUEST', 7),
			
			('POLICY_LIMITANEI', 'POLICY', 'MILITARY', 'CONQUEST', 4),
	('POLICY_LITERARY_TRADITION', 'POLICY', 'GREAT_PERSON', 'CULTURE', 5),		
			('POLICY_LOGISTICS', 'POLICY', 'MILITARY', 'CONQUEST', 5),
			('POLICY_MACHIAVELLIANISM', 'POLICY', 'DIPLOMATIC', 'CONQUEST', 3),
			('POLICY_MANEUVER', 'POLICY', 'MILITARY', 'CONQUEST', 7),
			('POLICY_MARITIME_INDUSTRIES', 'POLICY', 'MILITARY', 'CONQUEST', 3),
('POLICY_MARKET_ECONOMY', 'POLICY', 'ECONOMIC', 'SCIENCE', 3),	('POLICY_MARKET_ECONOMY', 'POLICY', 'ECONOMIC', 'CULTURE', 3),		
			('POLICY_MARTIAL_LAW', 'POLICY', 'MILITARY', 'CONQUEST', 7),
('POLICY_MEDINA_QUARTER', 'POLICY', 'ECONOMIC', 'SCIENCE', 2),	('POLICY_MEDINA_QUARTER', 'POLICY', 'ECONOMIC', 'CULTURE', 2),	('POLICY_MEDINA_QUARTER', 'POLICY', 'ECONOMIC', 'RELIGION', 2),	('POLICY_MEDINA_QUARTER', 'POLICY', 'ECONOMIC', 'CONQUEST', 2),
			
	('POLICY_MERITOCRACY', 'POLICY', 'ECONOMIC', 'CULTURE', 5),		
			('POLICY_MILITARY_FIRST', 'POLICY', 'MILITARY', 'CONQUEST', 6),
			('POLICY_MILITARY_ORGANIZATION', 'POLICY', 'GREAT_PERSON', 'CONQUEST', 8),
('POLICY_MILITARY_RESEARCH', 'POLICY', 'MILITARY', 'SCIENCE', 3),			
('POLICY_MONASTICISM', 'POLICY', 'DARKAGE', 'SCIENCE', 4),	('POLICY_MONASTICISM', 'POLICY', 'DARKAGE', 'CULTURE', -2),		
			('POLICY_NATIONAL_IDENTITY', 'POLICY', 'MILITARY', 'CONQUEST', 7),
			('POLICY_NATIVE_CONQUEST', 'POLICY', 'MILITARY', 'CONQUEST', 5),
('POLICY_NATURAL_PHILOSOPHY', 'POLICY', 'ECONOMIC', 'SCIENCE', 7),			
			
			('POLICY_NAVIGATION', 'POLICY', 'GREAT_PERSON', 'CONQUEST', 3),
('POLICY_NEW_DEAL', 'POLICY', 'ECONOMIC', 'SCIENCE', 3),	('POLICY_NEW_DEAL', 'POLICY', 'ECONOMIC', 'CULTURE', 3),	('POLICY_NEW_DEAL', 'POLICY', 'ECONOMIC', 'RELIGION', 3),	('POLICY_NEW_DEAL', 'POLICY', 'ECONOMIC', 'CONQUEST', 3),
('POLICY_NOBEL_PRIZE', 'POLICY', 'GREAT_PERSON', 'SCIENCE', 5),			
('POLICY_NUCLEAR_ESPIONAGE', 'POLICY', 'DIPLOMATIC', 'SCIENCE', 4),			
	('POLICY_ONLINE_COMMUNITIES', 'POLICY', 'ECONOMIC', 'CULTURE', 8),		
			('POLICY_PATRIOTIC_WAR', 'POLICY', 'MILITARY', 'CONQUEST', 3),
			
			('POLICY_PRAETORIUM', 'POLICY', 'DIPLOMATIC', 'CONQUEST', 1),
			('POLICY_PRESS_GANGS', 'POLICY', 'MILITARY', 'CONQUEST', 4),
			('POLICY_PROFESSIONAL_ARMY', 'POLICY', 'MILITARY', 'CONQUEST', 5),
			('POLICY_PROPAGANDA', 'POLICY', 'MILITARY', 'CONQUEST', 7),
('POLICY_PUBLIC_TRANSPORT', 'POLICY', 'ECONOMIC', 'SCIENCE', 2),	('POLICY_PUBLIC_TRANSPORT', 'POLICY', 'ECONOMIC', 'CULTURE', 2),	('POLICY_PUBLIC_TRANSPORT', 'POLICY', 'ECONOMIC', 'RELIGION', 2),	('POLICY_PUBLIC_TRANSPORT', 'POLICY', 'ECONOMIC', 'CONQUEST', 2),
('POLICY_PUBLIC_WORKS', 'POLICY', 'ECONOMIC', 'SCIENCE', 2),	('POLICY_PUBLIC_WORKS', 'POLICY', 'ECONOMIC', 'CULTURE', 2),	('POLICY_PUBLIC_WORKS', 'POLICY', 'ECONOMIC', 'RELIGION', 2),	('POLICY_PUBLIC_WORKS', 'POLICY', 'ECONOMIC', 'CONQUEST', 2),
('POLICY_RAID', 'POLICY', 'MILITARY', 'SCIENCE', 2),	('POLICY_RAID', 'POLICY', 'MILITARY', 'CULTURE', 2),	('POLICY_RAID', 'POLICY', 'MILITARY', 'RELIGION', 2),	('POLICY_RAID', 'POLICY', 'MILITARY', 'CONQUEST', 6),
('POLICY_RAJ', 'POLICY', 'DIPLOMATIC', 'SCIENCE', 2),	('POLICY_RAJ', 'POLICY', 'DIPLOMATIC', 'CULTURE', 2),	('POLICY_RAJ', 'POLICY', 'DIPLOMATIC', 'RELIGION', 2),	
	('POLICY_RATIONALISM', 'POLICY', 'ECONOMIC', 'SCIENCE', 7),		
		('POLICY_RELIGIOUS_ORDERS', 'POLICY', 'ECONOMIC', 'RELIGION', 7),	
			('POLICY_RESOURCE_MANAGEMENT', 'POLICY', 'ECONOMIC', 'CONQUEST', 6),
('POLICY_RETAINERS', 'POLICY', 'MILITARY', 'SCIENCE', 2),	('POLICY_RETAINERS', 'POLICY', 'MILITARY', 'CULTURE', 2),	('POLICY_RETAINERS', 'POLICY', 'MILITARY', 'RELIGION', 2),	
		('POLICY_REVELATION', 'POLICY', 'GREAT_PERSON', 'RELIGION', 8),	
('POLICY_ROBBER_BARONS', 'POLICY', 'DARKAGE', 'SCIENCE', 4),			('POLICY_ROBBER_BARONS', 'POLICY', 'DARKAGE', 'CONQUEST', 4),
			('POLICY_ROGUE_STATE', 'POLICY', 'DARKAGE', 'CONQUEST', 5),
	('POLICY_SATELLITE_BROADCASTS', 'POLICY', 'ECONOMIC', 'CULTURE', 8),		
		('POLICY_SCRIPTURE', 'POLICY', 'ECONOMIC', 'RELIGION', 6),	
			('POLICY_SECOND_STRIKE_CAPABILITY', 'POLICY', 'MILITARY', 'CONQUEST', 6),
('POLICY_SERFDOM', 'POLICY', 'ECONOMIC', 'SCIENCE', 1),	('POLICY_SERFDOM', 'POLICY', 'ECONOMIC', 'CULTURE', 1),	('POLICY_SERFDOM', 'POLICY', 'ECONOMIC', 'RELIGION', 1),	('POLICY_SERFDOM', 'POLICY', 'ECONOMIC', 'CONQUEST', 1),
		('POLICY_SIMULTANEUM', 'POLICY', 'ECONOMIC', 'RELIGION', 7),	
('POLICY_SKYSCRAPERS', 'POLICY', 'ECONOMIC', 'SCIENCE', 2),	('POLICY_SKYSCRAPERS', 'POLICY', 'ECONOMIC', 'CULTURE', 3),	('POLICY_SKYSCRAPERS', 'POLICY', 'ECONOMIC', 'RELIGION', 3),	('POLICY_SKYSCRAPERS', 'POLICY', 'ECONOMIC', 'CONQUEST', 2),
('POLICY_SPORTS_MEDIA', 'POLICY', 'ECONOMIC', 'SCIENCE', 1),	('POLICY_SPORTS_MEDIA', 'POLICY', 'ECONOMIC', 'CULTURE', 6),	('POLICY_SPORTS_MEDIA', 'POLICY', 'ECONOMIC', 'RELIGION', 1),	('POLICY_SPORTS_MEDIA', 'POLICY', 'ECONOMIC', 'CONQUEST', 1),
			('POLICY_STRATEGIC_AIR_FORCE', 'POLICY', 'MILITARY', 'CONQUEST', 5),
			('POLICY_STRATEGOS', 'POLICY', 'GREAT_PERSON', 'CONQUEST', 5),
			
	('POLICY_SYMPHONIES', 'POLICY', 'GREAT_PERSON', 'CULTURE', 6),		
('POLICY_THIRD_ALTERNATIVE', 'POLICY', 'ECONOMIC', 'SCIENCE', 6),			
('POLICY_TOTAL_WAR', 'POLICY', 'MILITARY', 'SCIENCE', 2),	('POLICY_TOTAL_WAR', 'POLICY', 'MILITARY', 'CULTURE', 2),	('POLICY_TOTAL_WAR', 'POLICY', 'MILITARY', 'RELIGION', 2),	('POLICY_TOTAL_WAR', 'POLICY', 'MILITARY', 'CONQUEST', 6),
('POLICY_TOWN_CHARTERS', 'POLICY', 'ECONOMIC', 'SCIENCE', 1),	('POLICY_TOWN_CHARTERS', 'POLICY', 'ECONOMIC', 'CULTURE', 1),	('POLICY_TOWN_CHARTERS', 'POLICY', 'ECONOMIC', 'RELIGION', 1),	('POLICY_TOWN_CHARTERS', 'POLICY', 'ECONOMIC', 'CONQUEST', 1),
('POLICY_TRADE_CONFEDERATION', 'POLICY', 'ECONOMIC', 'SCIENCE', 4),	('POLICY_TRADE_CONFEDERATION', 'POLICY', 'ECONOMIC', 'CULTURE', 4),		
			
		('POLICY_TRIANGULAR_TRADE', 'POLICY', 'ECONOMIC', 'RELIGION', 3),	
			('POLICY_TWILIGHT_VALOR', 'POLICY', 'DARKAGE', 'CONQUEST', 3),
('POLICY_URBAN_PLANNING', 'POLICY', 'ECONOMIC', 'SCIENCE', 1),	('POLICY_URBAN_PLANNING', 'POLICY', 'ECONOMIC', 'CULTURE', 1),	('POLICY_URBAN_PLANNING', 'POLICY', 'ECONOMIC', 'RELIGION', 1),	('POLICY_URBAN_PLANNING', 'POLICY', 'ECONOMIC', 'CONQUEST', 1),
			('POLICY_VETERANCY', 'POLICY', 'MILITARY', 'CONQUEST', 4),
			('POLICY_WARS_OF_RELIGION', 'POLICY', 'MILITARY', 'CONQUEST', 6),
('POLICY_WISSELBANKEN', 'POLICY', 'DIPLOMATIC', 'SCIENCE', 2),	('POLICY_WISSELBANKEN', 'POLICY', 'DIPLOMATIC', 'CULTURE', 1),	('POLICY_WISSELBANKEN', 'POLICY', 'DIPLOMATIC', 'RELIGION', 1),	('POLICY_WISSELBANKEN', 'POLICY', 'DIPLOMATIC', 'CONQUEST', 2);

-- CityStates
INSERT INTO RSTFlavors (ObjectType, Type, Subtype, Strategy, Value) VALUES -- generated from Excel
	('CULTURAL', 'CityState', '', 'CULTURE', 7),		
('INDUSTRIAL', 'CityState', '', 'SCIENCE', 4),	('INDUSTRIAL', 'CityState', '', 'CULTURE', 2),	('INDUSTRIAL', 'CityState', '', 'RELIGION', 2),	('INDUSTRIAL', 'CityState', '', 'CONQUEST', 3),
			('MILITARISTIC', 'CityState', '', 'CONQUEST', 7),
		('RELIGIOUS', 'CityState', '', 'RELIGION', 7),	
('SCIENTIFIC', 'CityState', '', 'SCIENCE', 7),
('TRADE', 'CityState', '', 'SCIENCE', 1),	('TRADE', 'CityState', '', 'CULTURE', 1),	('TRADE', 'CityState', '', 'RELIGION', 1),	('TRADE', 'CityState', '', 'CONQUEST', 1);

-- GreatPeople
INSERT INTO RSTFlavors (ObjectType, Type, Subtype, Strategy, Value) VALUES -- generated from Excel
			('GREAT_PERSON_CLASS_ADMIRAL', 'GreatPerson', '', 'CONQUEST', 3),
	('GREAT_PERSON_CLASS_ARTIST', 'GreatPerson', '', 'CULTURE', 4),		
('GREAT_PERSON_CLASS_ENGINEER', 'GreatPerson', '', 'SCIENCE', 1),	('GREAT_PERSON_CLASS_ENGINEER', 'GreatPerson', '', 'CULTURE', 1),		
			('GREAT_PERSON_CLASS_GENERAL', 'GreatPerson', '', 'CONQUEST', 5),
('GREAT_PERSON_CLASS_MERCHANT', 'GreatPerson', '', 'SCIENCE', 1),	('GREAT_PERSON_CLASS_MERCHANT', 'GreatPerson', '', 'CULTURE', 1),		
	('GREAT_PERSON_CLASS_MUSICIAN', 'GreatPerson', '', 'CULTURE', 4),		
		('GREAT_PERSON_CLASS_PROPHET', 'GreatPerson', '', 'RELIGION', 5),	
('GREAT_PERSON_CLASS_SCIENTIST', 'GreatPerson', '', 'SCIENCE', 8),			
	('GREAT_PERSON_CLASS_WRITER', 'GreatPerson', '', 'CULTURE', 3);

-- BELIEFS
INSERT INTO RSTFlavors (ObjectType, Type, Subtype, Strategy, Value) VALUES -- generated from Excel
		('BELIEF_BURIAL_GROUNDS', 'BELIEF', 'ENHANCER', 'RELIGION', 3),	
	('BELIEF_CATHEDRAL', 'BELIEF', 'WORSHIP', 'CULTURE', 2),	('BELIEF_CATHEDRAL', 'BELIEF', 'WORSHIP', 'RELIGION', 5),	
	('BELIEF_CHORAL_MUSIC', 'BELIEF', 'FOLLOWER', 'CULTURE', 4),		
		('BELIEF_CHURCH_PROPERTY', 'BELIEF', 'FOUNDER', 'RELIGION', 3),	
('BELIEF_CITY_PATRON_GODDESS', 'BELIEF', 'PANTHEON', 'SCIENCE', 1),	('BELIEF_CITY_PATRON_GODDESS', 'BELIEF', 'PANTHEON', 'CULTURE', 1),	('BELIEF_CITY_PATRON_GODDESS', 'BELIEF', 'PANTHEON', 'RELIGION', 1),	
('BELIEF_CROSS_CULTURAL_DIALOGUE', 'BELIEF', 'FOUNDER', 'SCIENCE', 3),		('BELIEF_CROSS_CULTURAL_DIALOGUE', 'BELIEF', 'FOUNDER', 'RELIGION', 3),	
		('BELIEF_DANCE_OF_THE_AURORA', 'BELIEF', 'PANTHEON', 'RELIGION', 4),	
		('BELIEF_DAR_E_MEHR', 'BELIEF', 'WORSHIP', 'RELIGION', 6),	
			
		('BELIEF_DESERT_FOLKLORE', 'BELIEF', 'PANTHEON', 'RELIGION', 5),	
	('BELIEF_DIVINE_INSPIRATION', 'BELIEF', 'FOLLOWER', 'CULTURE', 3),	('BELIEF_DIVINE_INSPIRATION', 'BELIEF', 'FOLLOWER', 'RELIGION', 4),	
('BELIEF_DIVINE_SPARK', 'BELIEF', 'PANTHEON', 'SCIENCE', 3),	('BELIEF_DIVINE_SPARK', 'BELIEF', 'PANTHEON', 'CULTURE', 3),	('BELIEF_DIVINE_SPARK', 'BELIEF', 'PANTHEON', 'RELIGION', 3),	
		('BELIEF_EARTH_GODDESS', 'BELIEF', 'PANTHEON', 'RELIGION', 9),	
('BELIEF_FEED_THE_WORLD', 'BELIEF', 'FOLLOWER', 'SCIENCE', 3),	('BELIEF_FEED_THE_WORLD', 'BELIEF', 'FOLLOWER', 'CULTURE', 2),		
('BELIEF_FERTILITY_RITES', 'BELIEF', 'PANTHEON', 'SCIENCE', 2),	('BELIEF_FERTILITY_RITES', 'BELIEF', 'PANTHEON', 'CULTURE', 2),	('BELIEF_FERTILITY_RITES', 'BELIEF', 'PANTHEON', 'RELIGION', 2),	('BELIEF_FERTILITY_RITES', 'BELIEF', 'PANTHEON', 'CONQUEST', 2),
('BELIEF_GODDESS_OF_FESTIVALS', 'BELIEF', 'PANTHEON', 'SCIENCE', 1),	('BELIEF_GODDESS_OF_FESTIVALS', 'BELIEF', 'PANTHEON', 'CULTURE', 1),	('BELIEF_GODDESS_OF_FESTIVALS', 'BELIEF', 'PANTHEON', 'RELIGION', 1),	('BELIEF_GODDESS_OF_FESTIVALS', 'BELIEF', 'PANTHEON', 'CONQUEST', 1),
		('BELIEF_GODDESS_OF_THE_HARVEST', 'BELIEF', 'PANTHEON', 'RELIGION', 4),	
('BELIEF_GODDESS_OF_THE_HUNT', 'BELIEF', 'PANTHEON', 'SCIENCE', 1),	('BELIEF_GODDESS_OF_THE_HUNT', 'BELIEF', 'PANTHEON', 'CULTURE', 1),	('BELIEF_GODDESS_OF_THE_HUNT', 'BELIEF', 'PANTHEON', 'RELIGION', 1),	('BELIEF_GODDESS_OF_THE_HUNT', 'BELIEF', 'PANTHEON', 'CONQUEST', 1),
('BELIEF_GOD_OF_CRAFTSMEN', 'BELIEF', 'PANTHEON', 'SCIENCE', 3),	('BELIEF_GOD_OF_CRAFTSMEN', 'BELIEF', 'PANTHEON', 'CULTURE', 1),	('BELIEF_GOD_OF_CRAFTSMEN', 'BELIEF', 'PANTHEON', 'RELIGION', 1),	('BELIEF_GOD_OF_CRAFTSMEN', 'BELIEF', 'PANTHEON', 'CONQUEST', 3),
		('BELIEF_GOD_OF_HEALING', 'BELIEF', 'PANTHEON', 'RELIGION', 8),	('BELIEF_GOD_OF_HEALING', 'BELIEF', 'PANTHEON', 'CONQUEST', 3),
			('BELIEF_GOD_OF_THE_FORGE', 'BELIEF', 'PANTHEON', 'CONQUEST', 8),
	('BELIEF_GOD_OF_THE_OPEN_SKY', 'BELIEF', 'PANTHEON', 'CULTURE', 5),		
('BELIEF_GOD_OF_THE_SEA', 'BELIEF', 'PANTHEON', 'SCIENCE', 2),	('BELIEF_GOD_OF_THE_SEA', 'BELIEF', 'PANTHEON', 'CULTURE', 1),	('BELIEF_GOD_OF_THE_SEA', 'BELIEF', 'PANTHEON', 'RELIGION', 1),	('BELIEF_GOD_OF_THE_SEA', 'BELIEF', 'PANTHEON', 'CONQUEST', 2),
			('BELIEF_GOD_OF_WAR', 'BELIEF', 'PANTHEON', 'CONQUEST', 4),
('BELIEF_GURDWARA', 'BELIEF', 'WORSHIP', 'SCIENCE', 2),	('BELIEF_GURDWARA', 'BELIEF', 'WORSHIP', 'CULTURE', 1),	('BELIEF_GURDWARA', 'BELIEF', 'WORSHIP', 'RELIGION', 6),	('BELIEF_GURDWARA', 'BELIEF', 'WORSHIP', 'CONQUEST', 1),
		('BELIEF_HOLY_ORDER', 'BELIEF', 'ENHANCER', 'RELIGION', 6),	
		('BELIEF_INITIATION_RITES', 'BELIEF', 'PANTHEON', 'RELIGION', 2),	
		('BELIEF_ITINERANT_PREACHERS', 'BELIEF', 'ENHANCER', 'RELIGION', 6),	
('BELIEF_JESUIT_EDUCATION', 'BELIEF', 'FOLLOWER', 'SCIENCE', 8),	('BELIEF_JESUIT_EDUCATION', 'BELIEF', 'FOLLOWER', 'CULTURE', 8),		
		('BELIEF_JUST_WAR', 'BELIEF', 'ENHANCER', 'RELIGION', 4),	('BELIEF_JUST_WAR', 'BELIEF', 'ENHANCER', 'CONQUEST', 7),
('BELIEF_LADY_OF_THE_REEDS_AND_MARSHES', 'BELIEF', 'PANTHEON', 'SCIENCE', 2),	('BELIEF_LADY_OF_THE_REEDS_AND_MARSHES', 'BELIEF', 'PANTHEON', 'CULTURE', 1),	('BELIEF_LADY_OF_THE_REEDS_AND_MARSHES', 'BELIEF', 'PANTHEON', 'RELIGION', 1),	('BELIEF_LADY_OF_THE_REEDS_AND_MARSHES', 'BELIEF', 'PANTHEON', 'CONQUEST', 2),
	('BELIEF_LAY_MINISTRY', 'BELIEF', 'FOUNDER', 'CULTURE', 3),	('BELIEF_LAY_MINISTRY', 'BELIEF', 'FOUNDER', 'RELIGION', 3),	
('BELIEF_MEETING_HOUSE', 'BELIEF', 'WORSHIP', 'SCIENCE', 2),		('BELIEF_MEETING_HOUSE', 'BELIEF', 'WORSHIP', 'RELIGION', 5),	('BELIEF_MEETING_HOUSE', 'BELIEF', 'WORSHIP', 'CONQUEST', 2),
		('BELIEF_MISSIONARY_ZEAL', 'BELIEF', 'ENHANCER', 'RELIGION', 8),	
		('BELIEF_MONASTIC_ISOLATION', 'BELIEF', 'ENHANCER', 'RELIGION', 7),	
('BELIEF_MONUMENT_TO_THE_GODS', 'BELIEF', 'PANTHEON', 'SCIENCE', 2),	('BELIEF_MONUMENT_TO_THE_GODS', 'BELIEF', 'PANTHEON', 'CULTURE', 2),	('BELIEF_MONUMENT_TO_THE_GODS', 'BELIEF', 'PANTHEON', 'RELIGION', 2),	('BELIEF_MONUMENT_TO_THE_GODS', 'BELIEF', 'PANTHEON', 'CONQUEST', 2),
		('BELIEF_MOSQUE', 'BELIEF', 'WORSHIP', 'RELIGION', 9),	
	('BELIEF_ORAL_TRADITION', 'BELIEF', 'PANTHEON', 'CULTURE', 3),		
('BELIEF_PAGODA', 'BELIEF', 'WORSHIP', 'SCIENCE', 2),	('BELIEF_PAGODA', 'BELIEF', 'WORSHIP', 'CULTURE', 1),	('BELIEF_PAGODA', 'BELIEF', 'WORSHIP', 'RELIGION', 5),	('BELIEF_PAGODA', 'BELIEF', 'WORSHIP', 'CONQUEST', 1),
('BELIEF_PAPAL_PRIMACY', 'BELIEF', 'FOUNDER', 'SCIENCE', 5),	('BELIEF_PAPAL_PRIMACY', 'BELIEF', 'FOUNDER', 'CULTURE', 5),	('BELIEF_PAPAL_PRIMACY', 'BELIEF', 'FOUNDER', 'RELIGION', 5),	('BELIEF_PAPAL_PRIMACY', 'BELIEF', 'FOUNDER', 'CONQUEST', 5),
		('BELIEF_PILGRIMAGE', 'BELIEF', 'FOUNDER', 'RELIGION', 3),	
		('BELIEF_RELIGIOUS_COLONIZATION', 'BELIEF', 'ENHANCER', 'RELIGION', 4),	
('BELIEF_RELIGIOUS_COMMUNITY', 'BELIEF', 'FOLLOWER', 'SCIENCE', 2),	('BELIEF_RELIGIOUS_COMMUNITY', 'BELIEF', 'FOLLOWER', 'CULTURE', 1),	('BELIEF_RELIGIOUS_COMMUNITY', 'BELIEF', 'FOLLOWER', 'RELIGION', 1),	('BELIEF_RELIGIOUS_COMMUNITY', 'BELIEF', 'FOLLOWER', 'CONQUEST', 1),
		('BELIEF_RELIGIOUS_IDOLS', 'BELIEF', 'PANTHEON', 'RELIGION', 5),	
('BELIEF_RELIGIOUS_SETTLEMENTS', 'BELIEF', 'PANTHEON', 'SCIENCE', 1),	('BELIEF_RELIGIOUS_SETTLEMENTS', 'BELIEF', 'PANTHEON', 'CULTURE', 1),	('BELIEF_RELIGIOUS_SETTLEMENTS', 'BELIEF', 'PANTHEON', 'RELIGION', 1),	('BELIEF_RELIGIOUS_SETTLEMENTS', 'BELIEF', 'PANTHEON', 'CONQUEST', 3),
		('BELIEF_RELIGIOUS_UNITY', 'BELIEF', 'FOUNDER', 'RELIGION', 4),	
	('BELIEF_RELIQUARIES', 'BELIEF', 'FOLLOWER', 'CULTURE', 7),	('BELIEF_RELIQUARIES', 'BELIEF', 'FOLLOWER', 'RELIGION', 3),	
('BELIEF_RIVER_GODDESS', 'BELIEF', 'PANTHEON', 'SCIENCE', 1),	('BELIEF_RIVER_GODDESS', 'BELIEF', 'PANTHEON', 'CULTURE', 1),	('BELIEF_RIVER_GODDESS', 'BELIEF', 'PANTHEON', 'RELIGION', 3),	('BELIEF_RIVER_GODDESS', 'BELIEF', 'PANTHEON', 'CONQUEST', 1),
		('BELIEF_SACRED_PATH', 'BELIEF', 'PANTHEON', 'RELIGION', 3),	
		('BELIEF_SCRIPTURE', 'BELIEF', 'ENHANCER', 'RELIGION', 8),	
('BELIEF_STEWARDSHIP', 'BELIEF', 'FOUNDER', 'SCIENCE', 6),			
		('BELIEF_STONE_CIRCLES', 'BELIEF', 'PANTHEON', 'RELIGION', 5),	
		('BELIEF_STUPA', 'BELIEF', 'WORSHIP', 'RELIGION', 5),	
		('BELIEF_SYNAGOGUE', 'BELIEF', 'WORSHIP', 'RELIGION', 6),	
('BELIEF_TITHE', 'BELIEF', 'FOUNDER', 'SCIENCE', 1),	('BELIEF_TITHE', 'BELIEF', 'FOUNDER', 'CULTURE', 1),	('BELIEF_TITHE', 'BELIEF', 'FOUNDER', 'RELIGION', 2),	('BELIEF_TITHE', 'BELIEF', 'FOUNDER', 'CONQUEST', 1),
		('BELIEF_WARRIOR_MONKS', 'BELIEF', 'FOLLOWER', 'RELIGION', 3),	('BELIEF_WARRIOR_MONKS', 'BELIEF', 'FOLLOWER', 'CONQUEST', 7),
('BELIEF_WAT', 'BELIEF', 'WORSHIP', 'SCIENCE', 4),		('BELIEF_WAT', 'BELIEF', 'WORSHIP', 'RELIGION', 5),	
('BELIEF_WORK_ETHIC', 'BELIEF', 'FOLLOWER', 'SCIENCE', 4),	('BELIEF_WORK_ETHIC', 'BELIEF', 'FOLLOWER', 'CULTURE', 2),	('BELIEF_WORK_ETHIC', 'BELIEF', 'FOLLOWER', 'RELIGION', 3),	('BELIEF_WORK_ETHIC', 'BELIEF', 'FOLLOWER', 'CONQUEST', 3),
	('BELIEF_WORLD_CHURCH', 'BELIEF', 'FOUNDER', 'CULTURE', 4),	('BELIEF_WORLD_CHURCH', 'BELIEF', 'FOUNDER', 'RELIGION', 4),	
('BELIEF_ZEN_MEDITATION', 'BELIEF', 'FOLLOWER', 'SCIENCE', 1),	('BELIEF_ZEN_MEDITATION', 'BELIEF', 'FOLLOWER', 'CULTURE', 1),	('BELIEF_ZEN_MEDITATION', 'BELIEF', 'FOLLOWER', 'RELIGION', 1),	('BELIEF_ZEN_MEDITATION', 'BELIEF', 'FOLLOWER', 'CONQUEST', 1);

-- Wonders
INSERT INTO RSTFlavors (ObjectType, Type, Subtype, Strategy, Value) VALUES -- generated from Excel
			('BUILDING_ALHAMBRA', 'Wonder', '', 'CONQUEST', 5),
('BUILDING_AMUNDSEN_SCOTT_RESEARCH_STATION', 'Wonder', '', 'SCIENCE', 8),			
('BUILDING_ANGKOR_WAT', 'Wonder', '', 'SCIENCE', 1),		('BUILDING_ANGKOR_WAT', 'Wonder', '', 'RELIGION', 2),	
	('BUILDING_APADANA', 'Wonder', '', 'CULTURE', 2),		
('BUILDING_BIG_BEN', 'Wonder', '', 'SCIENCE', 2),	('BUILDING_BIG_BEN', 'Wonder', '', 'CULTURE', 2),	('BUILDING_BIG_BEN', 'Wonder', '', 'RELIGION', 2),	
	('BUILDING_BOLSHOI_THEATRE', 'Wonder', '', 'CULTURE', 8),		
	('BUILDING_BROADWAY', 'Wonder', '', 'CULTURE', 8),		
('BUILDING_CASA_DE_CONTRATACION', 'Wonder', '', 'SCIENCE', 2),		('BUILDING_CASA_DE_CONTRATACION', 'Wonder', '', 'RELIGION', 2),	
	('BUILDING_CHICHEN_ITZA', 'Wonder', '', 'CULTURE', 2),		
	('BUILDING_COLOSSEUM', 'Wonder', '', 'CULTURE', 3),		
			('BUILDING_COLOSSUS', 'Wonder', '', 'CONQUEST', 1),
	('BUILDING_CRISTO_REDENTOR', 'Wonder', '', 'CULTURE', 9),		
	('BUILDING_EIFFEL_TOWER', 'Wonder', '', 'CULTURE', 6),		
('BUILDING_ESTADIO_DO_MARACANA', 'Wonder', '', 'SCIENCE', 2),	('BUILDING_ESTADIO_DO_MARACANA', 'Wonder', '', 'CULTURE', 4),	('BUILDING_ESTADIO_DO_MARACANA', 'Wonder', '', 'RELIGION', 2),	('BUILDING_ESTADIO_DO_MARACANA', 'Wonder', '', 'CONQUEST', 2),
('BUILDING_FORBIDDEN_CITY', 'Wonder', '', 'SCIENCE', 3),	('BUILDING_FORBIDDEN_CITY', 'Wonder', '', 'CULTURE', 4),	('BUILDING_FORBIDDEN_CITY', 'Wonder', '', 'RELIGION', 3),	('BUILDING_FORBIDDEN_CITY', 'Wonder', '', 'CONQUEST', 3),
('BUILDING_GREAT_LIBRARY', 'Wonder', '', 'SCIENCE', 6),	('BUILDING_GREAT_LIBRARY', 'Wonder', '', 'CULTURE', 3),		
			('BUILDING_GREAT_LIGHTHOUSE', 'Wonder', '', 'CONQUEST', 5),
			
		('BUILDING_HAGIA_SOPHIA', 'Wonder', '', 'RELIGION', 7),	
('BUILDING_HALICARNASSUS_MAUSOLEUM', 'Wonder', '', 'SCIENCE', 3),			
('BUILDING_HANGING_GARDENS', 'Wonder', '', 'SCIENCE', 2),	('BUILDING_HANGING_GARDENS', 'Wonder', '', 'CULTURE', 1),	('BUILDING_HANGING_GARDENS', 'Wonder', '', 'RELIGION', 2),	('BUILDING_HANGING_GARDENS', 'Wonder', '', 'CONQUEST', 2),
	('BUILDING_HERMITAGE', 'Wonder', '', 'CULTURE', 8),		
('BUILDING_HUEY_TEOCALLI', 'Wonder', '', 'SCIENCE', 2),	('BUILDING_HUEY_TEOCALLI', 'Wonder', '', 'CULTURE', 1),	('BUILDING_HUEY_TEOCALLI', 'Wonder', '', 'RELIGION', 1),	('BUILDING_HUEY_TEOCALLI', 'Wonder', '', 'CONQUEST', 2),
		('BUILDING_JEBEL_BARKAL', 'Wonder', '', 'RELIGION', 4),	('BUILDING_JEBEL_BARKAL', 'Wonder', '', 'CONQUEST', 3),
('BUILDING_KILWA_KISIWANI', 'Wonder', '', 'SCIENCE', 4),	('BUILDING_KILWA_KISIWANI', 'Wonder', '', 'CULTURE', 4),	('BUILDING_KILWA_KISIWANI', 'Wonder', '', 'RELIGION', 4),	('BUILDING_KILWA_KISIWANI', 'Wonder', '', 'CONQUEST', 4),
		('BUILDING_KOTOKU_IN', 'Wonder', '', 'RELIGION', 3),	('BUILDING_KOTOKU_IN', 'Wonder', '', 'CONQUEST', 6),
		('BUILDING_MAHABODHI_TEMPLE', 'Wonder', '', 'RELIGION', 5),	
	('BUILDING_MONT_ST_MICHEL', 'Wonder', '', 'CULTURE', 5),	('BUILDING_MONT_ST_MICHEL', 'Wonder', '', 'RELIGION', 4),	
('BUILDING_ORACLE', 'Wonder', '', 'SCIENCE', 3),	('BUILDING_ORACLE', 'Wonder', '', 'CULTURE', 4),		
('BUILDING_OXFORD_UNIVERSITY', 'Wonder', '', 'SCIENCE', 6),	('BUILDING_OXFORD_UNIVERSITY', 'Wonder', '', 'CULTURE', 2),		
('BUILDING_PETRA', 'Wonder', '', 'SCIENCE', 2),	('BUILDING_PETRA', 'Wonder', '', 'CULTURE', 2),	('BUILDING_PETRA', 'Wonder', '', 'RELIGION', 2),	('BUILDING_PETRA', 'Wonder', '', 'CONQUEST', 2),
	('BUILDING_POTALA_PALACE', 'Wonder', '', 'CULTURE', 2),	('BUILDING_POTALA_PALACE', 'Wonder', '', 'RELIGION', 2),	
('BUILDING_PYRAMIDS', 'Wonder', '', 'SCIENCE', 2),	('BUILDING_PYRAMIDS', 'Wonder', '', 'CULTURE', 2),	('BUILDING_PYRAMIDS', 'Wonder', '', 'RELIGION', 2),	('BUILDING_PYRAMIDS', 'Wonder', '', 'CONQUEST', 2),
('BUILDING_RUHR_VALLEY', 'Wonder', '', 'SCIENCE', 6),	('BUILDING_RUHR_VALLEY', 'Wonder', '', 'CULTURE', 2),	('BUILDING_RUHR_VALLEY', 'Wonder', '', 'RELIGION', 2),	('BUILDING_RUHR_VALLEY', 'Wonder', '', 'CONQUEST', 5),
			('BUILDING_STATUE_LIBERTY', 'Wonder', '', 'CONQUEST', 5),
		('BUILDING_STONEHENGE', 'Wonder', '', 'RELIGION', 7),	
('BUILDING_ST_BASILS_CATHEDRAL', 'Wonder', '', 'SCIENCE', 1),	('BUILDING_ST_BASILS_CATHEDRAL', 'Wonder', '', 'CULTURE', 7),		
	('BUILDING_SYDNEY_OPERA_HOUSE', 'Wonder', '', 'CULTURE', 8),		
('BUILDING_TAJ_MAHAL', 'Wonder', '', 'SCIENCE', 2),	('BUILDING_TAJ_MAHAL', 'Wonder', '', 'CULTURE', 2),	('BUILDING_TAJ_MAHAL', 'Wonder', '', 'RELIGION', 2),	('BUILDING_TAJ_MAHAL', 'Wonder', '', 'CONQUEST', 2),
('BUILDING_TEMPLE_ARTEMIS', 'Wonder', '', 'SCIENCE', 1),	('BUILDING_TEMPLE_ARTEMIS', 'Wonder', '', 'CULTURE', 1),	('BUILDING_TEMPLE_ARTEMIS', 'Wonder', '', 'RELIGION', 1),	('BUILDING_TEMPLE_ARTEMIS', 'Wonder', '', 'CONQUEST', 1),
	('BUILDING_TERRACOTTA_ARMY', 'Wonder', '', 'CULTURE', 5),		('BUILDING_TERRACOTTA_ARMY', 'Wonder', '', 'CONQUEST', 7),
			('BUILDING_VENETIAN_ARSENAL', 'Wonder', '', 'CONQUEST', 7);
