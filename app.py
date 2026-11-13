import mysql.connector
from getpass import getpass

# Connect to MySQL using the limited application account
db = mysql.connector.connect(
    host="localhost",
    user="videogame_app",
    password=getpass("Enter database password: "),
    database="VideoGameDB"
)

cursor = db.cursor()
print("Connected to VideoGameDB!")

# Feature 1: Search for players
def search_player():
    username = input("Enter username: ")

    sql = """
    SELECT PlayerID, UserName, Email, AccountLevel
    FROM Player
    WHERE UserName LIKE %s
    """

    cursor.execute(sql, ("%" + username + "%",))
    results = cursor.fetchall()

    if results:
        for player in results:
            print(player)
    else:
        print("No players found.")
        
# Feature 2: Combine tables using JOIN
def player_match_history():
    username = input("Enter username: ")

    sql = """
        SELECT gm.MatchID,
               gm.MatchDate,
               m.MapName,
               pm.Placement,
               pm.Kills,
               pm.DamageDealt
        FROM Player AS p
        JOIN PlayerMatch AS pm
            ON p.PlayerID = pm.Player_PlayerID
        JOIN GameMatch AS gm
            ON pm.Match_MatchID = gm.MatchID
        JOIN Map AS m
            ON gm.Map_MapID = m.MapID
        WHERE p.UserName LIKE %s
        ORDER BY gm.MatchDate DESC
    """

    cursor.execute(sql, ("%" + username + "%",))
    results = cursor.fetchall()

    if results:
        print("\nPlayer Match History")

        for match in results:
            print("\nMatch ID:", match[0])
            print("Match Date:", match[1])
            print("Map:", match[2])
            print("Placement:", match[3])
            print("Kills:", match[4])
            print("Damage Dealt:", match[5])

    else:
        print("No match history found.")

# Feature 3: Summarize a player
def player_statistics():
    username = input("Enter username: ")

    sql = """
        SELECT p.UserName,
               SUM(pm.Kills) AS TotalKills,
               AVG(pm.DamageDealt) AS AverageDamage,
               COUNT(pm.Match_MatchID) AS MatchesPlayed
        FROM Player AS p
        JOIN PlayerMatch AS pm
            ON p.PlayerID = pm.Player_PlayerID
        WHERE p.UserName LIKE %s
        GROUP BY p.PlayerID, p.UserName
    """

    cursor.execute(sql, ("%" + username + "%",))
    results = cursor.fetchall()

    if results:
        for player in results:
            print("\nPlayer Statistics")
            print("Username:", player[0])
            print("Total Kills:", player[1])
            print("Average Damage:", round(player[2], 2))
            print("Matches Played:", player[3])
    else:
        print("No player statistics found.")

# Feature 4: Above-Average Leaderboard Points
def above_average_players():
    sql = """
    SELECT UserName, Points
    FROM Player
    JOIN LeaderboardEntry
        ON Player.PlayerID = LeaderboardEntry.Player_PlayerID
    WHERE Points > (SELECT AVG(Points) FROM LeaderboardEntry)
    ORDER BY Points DESC
    """

    cursor.execute(sql)
    results = cursor.fetchall()

    if results:
        for player in results:
            print(player)
    else:
        print("No players found above the average.")

# Feature 5: Register New Player
def register_player():
    try:
        player_id = int(input("Enter Player ID: "))
        username = input("Enter username: ")
        email = input("Enter email: ")
        level = int(input("Enter account level: "))

        if player_id <= 0 or level < 1 or not username.strip() or not email.strip():
            print("Please enter valid player information.")
            return

        sql = """
        INSERT INTO Player
        (PlayerID, UserName, Email, AccountLevel, DateJoined)
        VALUES (%s, %s, %s, %s, CURDATE())
        """

        cursor.execute(sql, (player_id, username, email, level))
        db.commit()

        print("Player registered successfully!")

    except ValueError:
        print("Player ID and account level must be numbers.")

    except mysql.connector.IntegrityError as error:
        db.rollback()
        if error.errno == 1062:
            print("Player ID, username, or email already exists.")
        else:
            print("Could not register player. Check the information.")

    except mysql.connector.Error:
        db.rollback()
        print("Database error. Could not register player.")

#Feature 6: Update account information
def update_account():
    username = input("Enter username: ")

    sql = """
        SELECT PlayerID, UserName, Email, AccountLevel
        FROM Player
        WHERE UserName = %s
    """

    cursor.execute(sql, (username,))
    player = cursor.fetchone()

    if player:
        print("\nPlayer Account Information")
        print("Username:", player[1])
        print("Email:", player[2])
        print("Account Level:", player[3])

        print("\nWhat would you like to update?")
        print("1. Username")
        print("2. Email")

        choice = input("Enter your choice: ")

        if choice == "1":
            new_value = input("Enter new username: ").strip()
            sql = """
                UPDATE Player
                SET UserName = %s
                WHERE PlayerID = %s
            """
            
        elif choice == "2":
            new_value = input("Enter new email: ").strip().lower()
            sql = """
                UPDATE Player
                SET Email = %s
                WHERE PlayerID = %s
            """     
        else:
            print("Invalid choice.")
            return

        if not new_value:
            print("The new value cannot be empty.")
            return
        try:
            cursor.execute(sql, (new_value, player[0]))
            db.commit()
            print(
                f"Account with the name {username} "
                "has been updated successfully!")
        
        except mysql.connector.IntegrityError:
            db.rollback()
            print("Username or email is already in use.")
            
        except mysql.connector.Error:
            db.rollback()
            print("Unable to update account information.")
    else:
        print("No players found.")

# Main menu
while True:
    print("\nVideo Game Database")
    print("1. Search for Player")
    print("2. Combine Tables")
    print("3. Summarize a Player")
    print("4. Search for Above-Average Leadboard Points")
    print("5. Register New Player")
    print("6. Update Account Information")
    print("7. LALLALALAL")
    print("8. Exit")

    choice = input("Enter your choice: ")

    if choice == "1":
        search_player()
    elif choice == "2":
        player_match_history()
    elif choice == "3":
        player_statistics()
    elif choice == '4':
        above_average_players()
    elif choice == '5':
        register_player()
    elif choice == "6":
        update_account()
    elif choice == "8":
        break    
    else:
        print("Invalid choice.")

cursor.close()
db.close()
