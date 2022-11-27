import subprocess as sp
import pymysql
import pymysql.cursors


def allPlayers():

    with con.cursor() as cur:
        cur.execute('SELECT * FROM Player')

    result = cur.fetchall()

    for row in result:
        print(result)

def fastWeapons():

    with con.cursor() as cur:
        cur.execute('SELECT * FROM Weapon WHERE Reload_Speed > 50')

    result = cur.fetchall()

    for row in result:
        print(result)

def highDefMap():

    with con.cursor() as cur:
        cur.execute('SELECT * FROM Map WHERE Defender_Win_Percent = (SELECT MAX(Defender_Win_Percent) FROM Map)')

    result = cur.fetchall()

    for row in result:
        print(result)


def searchAgent():
    prefix = input("Enter prefix to be matched: ")

    with con.cursor() as cur:
        cur.execute("SELECT * FROM Agent WHERE Agent_Name LIKE '%s%' ",prefix)

    result = cur.fetchall()

    for row in result:
        print(result)















def hireAnEmployee():
    """
    This is a sample function implemented for the refrence.
    This example is related to the Employee Database.
    In addition to taking input, you are required to handle domain errors as well
    For example: the SSN should be only 9 characters long
    Sex should be only M or F
    If you choose to take Super_SSN, you need to make sure the foreign key constraint is satisfied
    HINT: Instead of handling all these errors yourself, you can make use of except clause to print the error returned to you by MySQL
    """
    try:
        # Takes emplyee details as input
        row = {}
        print("Enter new employee's details: ")
        name = (input("Name (Fname Minit Lname): ")).split(' ')
        row["Fname"] = name[0]
        row["Minit"] = name[1]
        row["Lname"] = name[2]
        row["Ssn"] = input("SSN: ")
        row["Bdate"] = input("Birth Date (YYYY-MM-DD): ")
        row["Address"] = input("Address: ")
        row["Sex"] = input("Sex: ")
        row["Salary"] = float(input("Salary: "))
        row["Dno"] = int(input("Dno: "))

        query = "INSERT INTO EMPLOYEE(Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Dno) VALUES('%s', '%c', '%s', '%s', '%s', '%s', '%c', %f, %d)" % (
            row["Fname"], row["Minit"], row["Lname"], row["Ssn"], row["Bdate"], row["Address"], row["Sex"], row["Salary"], row["Dno"])

        print(query)
        cur.execute(query)
        con.commit()

        print("Inserted Into Database")

    except Exception as e:
        con.rollback()
        print("Failed to insert into database")
        print(">>>>>>>>>>>>>", e)

    return


def dispatch(ch):
    """
    Function that maps helper functions to option entered
    """

    if(ch == 1):
        allPlayers()
    elif(ch == 2):
        fastWeapons()
    elif(ch == 3):
        highDefMap()
    elif(ch == 4):
        searchAgent()
    else:
        print("Error: Invalid Option")


try:
    # Set db name accordingly which have been create by you
    # Set host to the server's address if you don't want to use local SQL server
    con = pymysql.connect(host='localhost',
                            user="aditya",
                            password="horse",
                            db='ValorantTracker',
                            cursorclass=pymysql.cursors.DictCursor)
    tmp = sp.call('clear', shell=True)

    if(con.open):
        print("Connected")
    else:
        print("Failed to connect")

except Exception as e:
    tmp = sp.call('clear', shell=True)
    print(e)
    print("Connection Refused: Either username or password is incorrect or user doesn't have access to database")
    tmp = input("Enter any key to CONTINUE>")


# Global
while(1):
    tmp = sp.call('clear', shell=True)
    tmp = input("Enter any key to CONTINUE>")

    with con.cursor() as cur:
        while(1):
            tmp = sp.call('clear', shell=True)
            # Here taking example of Employee Mini-world
            print("1. Option 1")
            print("2. Option 2")
            print("3. Option 3")
            print("4. Option 4")
            print("5. Logout")
            ch = int(input("Enter choice> "))
            tmp = sp.call('clear', shell=True)
            if ch == 5:
                exit()
            else:
                dispatch(ch)
                tmp = input("Enter any key to CONTINUE>")

