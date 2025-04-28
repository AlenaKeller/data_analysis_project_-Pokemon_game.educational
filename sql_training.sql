--Here are MySQL queries for your Pokémon dataset based on the requirements for Plan A and Plan B:

1. Assemble Team for Plan A

-- Find Flying-type with HP > 70 OR Attack > 70
SELECT Name, Type1, Type2, HP, Attack 
FROM pokemon 
WHERE (Type1 = 'Flying' OR Type2 = 'Flying') 
  AND (HP > 70 OR Attack > 70)
LIMIT 1;

-- Find Water-type with Speed > 110
SELECT Name, Type1, Type2, Speed
FROM pokemon
WHERE (Type1 = 'Water' OR Type2 = 'Water')
  AND Speed > 110
LIMIT 1;

-- Find Pokémon with Total > 720
SELECT Name, Type1, Type2, Total
FROM pokemon
WHERE Total > 720
LIMIT 1;

-- Complete team assembly (all conditions in one query)
SELECT Name, Type1, Type2, Total, HP, Attack, Speed
FROM pokemon
WHERE 
  ((Type1 = 'Flying' OR Type2 = 'Flying') AND (HP > 70 OR Attack > 70))
  OR ((Type1 = 'Water' OR Type2 = 'Water') AND Speed > 110)
  OR (Total > 720)
LIMIT 5;


2. Gather Data for Plan B Development

  -- 1. Top 5 Attack stats between 50-70
SELECT Name, Type1, Attack
FROM pokemon
WHERE Attack BETWEEN 50 AND 70
ORDER BY Attack DESC
LIMIT 5;

-- 2. Average HP by Type1
SELECT Type1, ROUND(AVG(HP),2) AS avg_hp
FROM pokemon
GROUP BY Type1
ORDER BY avg_hp DESC;

-- 3. Generation and Legendary ratio
SELECT 
  Generation,
  COUNT(*) AS total,
  SUM(CASE WHEN Legendary = TRUE THEN 1 ELSE 0 END) AS legendary_count,
  ROUND(SUM(CASE WHEN Legendary = TRUE THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS legendary_percentage
FROM pokemon
GROUP BY Generation;

-- 4. Aggregated data by Type1 and Generation (Attack and HP)
SELECT 
  Type1,
  Generation,
  COUNT(*) AS pokemon_count,
  ROUND(AVG(Attack),2) AS avg_attack,
  ROUND(AVG(HP),2) AS avg_hp,
  ROUND(AVG(Attack)/AVG(HP),2) AS attack_hp_ratio
FROM pokemon
GROUP BY Type1, Generation
ORDER BY Type1, Generation;


3. Universal Team Builder Module

-- Parameterized team builder (example for Flying-type)
DELIMITER //
CREATE PROCEDURE BuildTeam(
  IN type1_filter VARCHAR(20),
  IN type2_filter VARCHAR(20),
  IN min_stat INT,
  IN stat_column VARCHAR(20),
  IN team_size INT
)
BEGIN
  SET @sql = CONCAT('
    SELECT Name, Type1, Type2, ', stat_column, '
    FROM pokemon
    WHERE (Type1 = ? OR Type2 = ?)
      AND ', stat_column, ' > ?
    LIMIT ?');
  
  PREPARE stmt FROM @sql;
  EXECUTE stmt USING type1_filter, type2_filter, min_stat, team_size;
  DEALLOCATE PREPARE stmt;
END //
DELIMITER ;

-- Example usage for Flying-types with HP > 70
CALL BuildTeam('Flying', 'Flying', 70, 'HP', 3);


Power Ratio Calculation
-- Calculate power ratio between two Pokémon
SELECT 
  a.Name AS pokemon1,
  b.Name AS pokemon2,
  ROUND((a.Attack + a.SP_Atk) / (b.Defense + b.SP_Def), 2) AS power_ratio
FROM pokemon a
CROSS JOIN pokemon b
WHERE a.Name = 'Charizard' AND b.Name = 'Blastoise';
