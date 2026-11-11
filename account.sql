-- Create application account
DROP USER IF EXISTS 'videogame_app'@'localhost';

CREATE USER 'videogame_app'@'localhost'
IDENTIFIED BY 'Ilovesql100!';

-- Allow viewing data from all tables
GRANT SELECT ON VideoGameDB.*
TO 'videogame_app'@'localhost';

-- Allow adding new players
GRANT INSERT ON VideoGameDB.Player
TO 'videogame_app'@'localhost';

-- Allow recording new matches
GRANT INSERT ON VideoGameDB.GameMatch
TO 'videogame_app'@'localhost';

GRANT INSERT ON VideoGameDB.PlayerMatch
TO 'videogame_app'@'localhost';

-- Allow updating player information
GRANT UPDATE ON VideoGameDB.Player
TO 'videogame_app'@'localhost';

-- Verify permissions
SHOW GRANTS FOR 'videogame_app'@'localhost';