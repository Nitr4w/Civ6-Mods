--------------------------------------------------------------
-- Real Fixes
-- Author: Infixo
-- 2018-03-25: Created, Typos in Traits
--------------------------------------------------------------

-- Typos in trait Names
-- TRAIT_LEADER_UNIT_ENGLISH_REDCOAT		LOC_TRAIT_LEADER_TRAIT_LEADER_UNIT_ENGLISH_REDCOAT_NAME
-- TRAIT_LEADER_UNIT_NORWEGIAN_LONGSHIP		LOC_TRAIT_LEADER_TRAIT_LEADER_UNIT_NORWEGIAN_LONGSHIP_NAME
-- TRAIT_LEADER_UNIT_AMERICAN_ROUGH_RIDER	LOC_TRAIT_LEADER_TRAIT_LEADER_UNIT_AMERICAN_ROUGH_RIDER_NAME
UPDATE Traits SET Name = 'LOC_TRAIT_LEADER_UNIT_ENGLISH_REDCOAT_NAME'      WHERE TraitType = 'TRAIT_LEADER_UNIT_ENGLISH_REDCOAT';
UPDATE Traits SET Name = 'LOC_TRAIT_LEADER_UNIT_NORWEGIAN_LONGSHIP_NAME'   WHERE TraitType = 'TRAIT_LEADER_UNIT_NORWEGIAN_LONGSHIP';
UPDATE Traits SET Name = 'LOC_TRAIT_LEADER_UNIT_AMERICAN_ROUGH_RIDER_NAME' WHERE TraitType = 'TRAIT_LEADER_UNIT_AMERICAN_ROUGH_RIDER';
UPDATE Traits SET Name = 'LOC_TRAIT_CIVILIZATION_UNIT_HETAIROI_NAME'       WHERE TraitType = 'TRAIT_LEADER_UNIT_HETAIROI'; -- different LOC defined

