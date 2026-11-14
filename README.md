# VideoGameDB — Video Game Database Application

**Course:** CS317 — Files and Database Systems, Fall 2026  
**Project:** From Database to Application  
**Technology:** Python command-line application and MySQL

## Project Overview

VideoGameDB is a command-line application that allows users to view and manage information about video game players, matches, maps, and leaderboard rankings without writing SQL themselves. The application connects to a MySQL relational database through a limited-permission application account. Its features demonstrate searching, joins, aggregation, subqueries, inserts, updates, and transactions.

## Requirements

- Python 3
- MySQL Server running locally (`localhost`)
- MySQL Workbench or another SQL client for running setup scripts
- Python package: `mysql-connector-python`

On Windows, install the connector from a terminal:

```powershell
py -m pip install mysql-connector-python
```

## Files

| File | Purpose |

| `setup.sql` | Creates `VideoGameDB`, its tables, keys, constraints, and sample records |
| `account.sql` | Creates the limited `videogame_app` MySQL account and grants its necessary permissions |
| `app.py` | Runs the menu-driven Python application |
| `README.md` | Explains setup, features, security, testing, and team contributions |


## Setup and Run Instructions

1. **Start MySQL Server** and open MySQL Workbench using an administrator/root connection.
2. **Run `setup.sql`** in Workbench to create `VideoGameDB`, its seven tables, and sample data.
3. **Prepare `account.sql` with a private password.** The supplied account script contains a plaintext password. Before submitting or publishing files, replace that value with a non-secret placeholder in the shareable copy, and use a newly chosen password when running the actual account-creation statement locally. Do not add the real password to `app.py` or this README.
4. **Run `account.sql` as an administrator** after the database has been created. It creates the `videogame_app` account and grants access only to the operations used by the application.
5. **Save your final working Python code as `app.py`** in the project folder. If copying from a Markdown export, remove Markdown markup (`**`, `*`) before running it as Python.
6. **Run the Python application** in the VS Code terminal or Windows Command Prompt from the folder containing `app.py`:

   ```powershell
   py app.py
   ```

7. **Enter the database password** when prompted. The application uses `getpass()` and connects as `videogame_app`, not as `root`.
8. **Select a feature** from the menu. Choose **9. Exit** to close the application.

**Important:** The setup script starts with `DROP DATABASE IF EXISTS VideoGameDB;`. Rerunning it permanently resets the database and removes any accounts or match records added or updated through the application. Ensure to back up important data before rerunning it. The account script also starts with `DROP USER IF EXISTS`, so rerunning it recreates the limited user.

## Application Features

| Menu | Feature | SQL Requirement |

| **1** | Search for a player by username and display their account information; optionally search again | `SELECT` with `WHERE` |
| **2** | View a player's match history, including match date, map, placement, kills, and damage dealt | `JOIN` among `Player`, `PlayerMatch`, `GameMatch`, and `Map` |
| **3** | Display total kills, average damage dealt, and matches played for a player | `GROUP BY`, `SUM()`, `AVG()`, `COUNT()` |
| **4** | List players whose leaderboard points exceed the average leaderboard points | Subquery using `AVG()` |
| **5** | Register a new player with a manually entered Player ID, username, email, and account level | `INSERT` |
| **6** | Change an existing player's username or email address | `UPDATE` |
| **7** | Record a new match and each participating player's statistics as one transaction | `COMMIT` and `ROLLBACK` |
| **8** | Demonstrate a restricted `DELETE` operation rejected by MySQL | Limited-account permission/security demonstration |
| **9** | Exit the program | Menu navigation |

The first seven menu options cover the seven required database feature categories. Option 8 is an additional security demonstration, separate from the seven features.

## Database Structure

The updated setup script creates these **seven** tables:

| Table | Description | Initial sample rows |

| `Player` | Player ID, username, email, account level, and date joined | 10 |
| `Map` | Map name, map size, and maximum players | 10 |
| `Weapon` | Weapon name, type, rarity, and damage | 10 |
| `Leaderboard` | Leaderboard name, season number, start date, and end date | 3 |
| `GameMatch` | Match date, mode, player count, and associated map | 10 |
| `PlayerMatch` | Player participation in matches, placement, kills, damage, and survival time | 30 |
| `LeaderboardEntry` | Player rank, points, and wins on a leaderboard | 10 |

### Relationships and Constraints

- `GameMatch.Map_MapID` references `Map.MapID`.
- `PlayerMatch.Player_PlayerID` references `Player.PlayerID`.
- `PlayerMatch.Match_MatchID` references `GameMatch.MatchID`.
- `LeaderboardEntry.Player_PlayerID` references `Player.PlayerID`.
- `LeaderboardEntry.Leaderboard_LeaderboardID` references `Leaderboard.LeaderboardID`.
- `PlayerMatch` has a composite primary key: `(Player_PlayerID, Match_MatchID)`.
- `LeaderboardEntry` has a composite primary key: `(Player_PlayerID, Leaderboard_LeaderboardID)`.
- `Player.UserName` and `Player.Email` are `UNIQUE`, so duplicate usernames or email addresses are rejected.


## Limited Application Account and Security

`app.py` connects as `videogame_app` using a password requested when the program starts. Administrative setup runs separately in MySQL Workbench.

The supplied `account.sql` grants:

| Privilege | Table or Scope | Reason |

| `SELECT` | All tables in `VideoGameDB` | Search, history, statistics, and reports |
| `INSERT` | `Player` | Register new players |
| `INSERT` | `GameMatch`, `PlayerMatch` | Record matches and participant statistics |
| `UPDATE` | `Player` | Change account details |

The account does **not** receive `DELETE` privileges. The security-test menu option attempts a `DELETE` from `Player`. When MySQL rejects the operation for insufficient permissions, the application catches the error and shows a readable permission-denied message. The function rolls back if the operation is unexpectedly allowed or an error occurs.

Queries use parameter placeholders (`%s`) for user-supplied values instead of concatenating user input into SQL statements. Database constraints prevent duplicate account values and invalid foreign-key references.

## Transaction Handling

Feature 7 records a match as one transaction:

1. Start a transaction.
2. Insert the new match into `GameMatch`.
3. Insert each participating player's statistics into `PlayerMatch`.
4. **Commit** only when all inserts succeed.
5. **Roll back** if an input is invalid or MySQL rejects an insert so no partial match remains.

The program catches `ValueError`, `IntegrityError`, and general MySQL errors during match recording. An invalid player ID can demonstrate a foreign-key failure and rollback.

## Testing and Verification

The following test outcomes were confirmed during development through the Python application and checks in MySQL Workbench:

| Test | Outcome |

| Update an existing player's email | The updated value appeared in the MySQL `Player` table |
| Try updating an email to one already registered | The application displayed a duplicate-account-value message |
| Record a valid match with valid participants | The match and its participant rows were saved together |
| Try recording a match with a nonexistent Player ID | The operation failed and the transaction was rolled back |
| Inspect records after failed/successful transaction tests | No partial records remained after rollback; valid records appeared after commit |


Examples of verification queries to run in Workbench:

```sql
-- See updated account details (replace the ID if needed)
SELECT PlayerID, UserName, Email, AccountLevel
FROM VideoGameDB.Player
WHERE PlayerID = 2;

-- Check a new match and its participant statistics
-- Replace 11 with the Match ID you used in testing
SELECT * FROM VideoGameDB.GameMatch WHERE MatchID = 11;
SELECT * FROM VideoGameDB.PlayerMatch WHERE Match_MatchID = 11;
```

You can inspect the limited account's grants from an administrator connection with:

```sql
SHOW GRANTS FOR 'videogame_app'@'localhost';
```

## AI Assistance

AI was used to assist with Python debugging, examples when creating multiple data inputs for users, and clarification with formatting. The team reviewed and tested application behavior locally. 

## Team Contributions


**| Team Member | Contribution |******
| --- | --- |
| [Kaylee Trujillo] | Created features 2,6, 8, and 9. |
| [Member 2] | [Describe responsibilities] |
