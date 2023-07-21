import subprocess as sp
import pymysql
import pymysql.cursors
from tabulate import tabulate

def printResult(result):
    if(len(result) == 0):
        print("empty result")
        return
    rows = [list(result[0].keys())]
    for r in result:
        rows.append(list(r.values()))
    print(tabulate(rows, tablefmt='psql'))

def allPlayers():
    with con.cursor() as cur:
        cur.execute('SELECT * FROM Player;')

    result = cur.fetchall()
    printResult(result)

def fastWeapons():
    with con.cursor() as cur:
        cur.execute('SELECT * FROM Weapon WHERE Reload_Speed > 50;')

    result = cur.fetchall()
    printResult(result)

def highDefMap():
    with con.cursor() as cur:
        cur.execute('SELECT * FROM Map WHERE Defender_Win_Percent = (SELECT MAX(Defender_Win_Percent) FROM Map);')

    result = cur.fetchall()
    printResult(result)

def searchAgent():
    prefix = input("Enter prefix to be matched: ")

    with con.cursor() as cur:
        query = "SELECT * FROM Agent WHERE Agent_Name LIKE '{}%';".format(prefix)
        cur.execute(query)

    result = cur.fetchall()
    printResult(result)

def InsertPlayer():
    try:
        # Takes player details as input
        row = {}
        print("Enter Player details: ")

        row["Player_Name"] = input("Player Name: ")
        row["Tag"] = int(input("Player Tag: "))
        row["Curr_Rating"] = input("Current Rating: ")
        row["Peak_Rating"] = input("Peak Rating: ")

        query = "INSERT INTO `Player`(`Player_Tag`, `Player_Name`, `Current_Rating`, `Peak_Rating`) VALUES('%d', '%s', '%s', '%s')" % (
            row["Tag"], row["Player_Name"], row["Curr_Rating"], row["Peak_Rating"])

        print(query)
        cur.execute(query)
        con.commit()

        print("Inserted Into Database")

    except Exception as e:
        con.rollback()
        print("Failed to insert into database")
        print(">>>>>>>>>>>>>", e)

    return

def InsertWeaponSkin():
    try:
        # Takes Skin details as input
        row = {}
        print("Enter Skin details: ")

        row["Weapon"] = input("Weapon Name: ")
        row["Name"] = input("Skin Name: ")
        row["Price"] = int(input("Price: "))
        row["Availability"] = int(input("Availability (0 \ 1): "))

        query = "INSERT INTO `Weapon_Skin`(`Weapon`, `Name`, `Price`, `Availability`) VALUES('%s', '%s', '%d', '%d')" % (
            row["Weapon"], row["Name"], row["Price"], row["Availability"])

        print(query)
        cur.execute(query)
        con.commit()

        print("Inserted Into Database")

    except Exception as e:
        con.rollback()
        print("Failed to insert into database")
        print(">>>>>>>>>>>>>", e)

    return

def InsertMap():
    try:
        # Takes player details as input
        row = {}
        print("Enter Map details: ")

        row["Name"] = input("Map Name: ")
        row["totalSites"] = int(input("Total Sites: "))
        row["Location"] = input("Location: ")

        query = "INSERT INTO `Map` (`Map_Name`, `Total_Sites`, `Location`) VALUES('%s', '%d', '%s')" % (
            row["Name"], row["totalSites"], row["Location"])

        print(query)
        cur.execute(query)
        con.commit()

        print("Inserted Into Database")

    except Exception as e:
        con.rollback()
        print("Failed to insert into database")
        print(">>>>>>>>>>>>>", e)

    return

def deleteAgent():
    name = input("Enter Agent Name to delete: ")
    try:
        query = "DELETE FROM `Agent` WHERE `Agent_Name`='%s'" % (name)
        print(query)
        cur.execute(query)
        con.commit()
        print("Deleted From Database")

    except Exception as e:
        con.rollback()
        print("Failed to insert into database")
        print(">>>>>>>>>>>>>", e)

    return

def SlowWeapons():
    try:
        query = "SELECT * FROM `Weapon` WHERE `Reload_Speed` < (SELECT AVG(`Reload_Speed`) FROM `Weapon`);"
        with con.cursor() as cur:
            cur.execute(query)
        
        result = cur.fetchall()
        printResult(result)

    except Exception as e:
        con.rollback()
        print(">>>>>>>>>>>>>", e)

    return

def PopAgent():
    try:
        query = '''SELECT MPopA  from (
    SELECT COUNT(Map_Name) as count, Most_Popular_Agent as MPopA 
    FROM Map 
    WHERE Most_Popular_Agent IS NOT NULL 
    GROUP BY Most_Popular_Agent) tt 
WHERE count=(SELECT MAX(count) FROM (select COUNT(Map_Name) as count, Most_Popular_Agent from Map where Most_Popular_Agent IS NOT NULL group by Most_Popular_Agent) t);'''
        with con.cursor() as cur:
            cur.execute(query)
        
        result = cur.fetchall()
        printResult(result)
        
    except Exception as e:
        con.rollback()
        print(">>>>>>>>>>>>>", e)

    return

def dispatch(ch):
    if(ch == 1):
        allPlayers()
    elif(ch == 2):
        fastWeapons()
    elif(ch == 3):
        highDefMap()
    elif(ch == 4):
        searchAgent()
    elif(ch == 5):
        InsertPlayer()
    elif(ch == 6):
        InsertMap()
    elif(ch == 7):
        InsertWeaponSkin()
    elif(ch==8):
        deleteAgent()
    elif(ch==9):
        SlowWeapons()
    elif(ch==10):
        PopAgent()
    else:
        print("Error: Invalid Option")


try:
    con = pymysql.connect(host='localhost',
                            user="root",
                            password="221064",
                            db='ValorantTracker',
                            cursorclass=pymysql.cursors.DictCursor)

    if(con.open):
        print("Connected")
    else:
        print("Failed to connect")

except Exception as e:
    print(e)
    print("Connection Refused: Either username or password is incorrect or user doesn't have access to database")
    tmp = input("Enter any key to CONTINUE>")


# Global
while(1):
    tmp = input("Enter any key to CONTINUE>")

    with con.cursor() as cur:
        while(1):
            print("1. Fetch all Players")
            print("2. Weapons with reload speed > 50")
            print("3. High defending map")
            print("4. Search Agent")
            print("5. Insert Player")
            print("6. Insert Map")
            print("7. Insert Weapon Skin")
            print("8. Delete Agent")
            print("9. Faster than average Weapons")
            print("10. Most populer Agent among all maps")
            print("11. Logout")
            ch = int(input("Enter choice> "))
            if ch == 11:
                exit()
            else:
                dispatch(ch)
                tmp = input("Enter any key to CONTINUE>")

