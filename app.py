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


# Main menu
while True:
    print("\nVideo Game Database")
    print("1. Search for Player")
    print("2. Exit")

    choice = input("Enter your choice: ")

    if choice == "1":
        search_player()
    elif choice == "2":
        break
    else:
        print("Invalid choice.")

cursor.close()
db.close()