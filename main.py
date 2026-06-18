from dotenv import load_dotenv
from getpass import getpass
from hashlib import sha256
from time import sleep
import os
import oracledb
import queries

help_str="""
    clear: clear TUI
    exit: exit program
    help: show this list
    view <option>:
        -list: list all available views
        -show <view_id>:show contents of selected view
    table <option>:
        -list: list all available tables
        -show <table_id>:show contents of selected table
"""

load_dotenv()

permissions={"Guy":1,"TopGuy":3,"BigYahoo":5}

DB_URL=os.getenv("DB_URL")

if not DB_URL:
    raise ValueError("Database URL is missing")
#DB_CONN=oracledb.connect(dsn=DB_URL)

def cls():
    os.system('cls' if os.name=='nt' else 'clear')
    print("Enter command. Type 'help' for help")

def mainLoop(permLvl):
    command = input("\nTUI: ").strip().split()
    if not command:
        return
    match command[0]:
        case "view":
            try:
                option=command[1]
                if option=="show":
                    view_id=command[2]
                    if not view_id.replace('_', '').replace('.', '').isalnum():
                        print("    BŁĄD: Nieprawidłowa nazwa widoku!")
                        return []
                    print(executeQuery(f"""SELECT * FROM {view_id}""", ()))
                elif option=="list":
                    print(executeQuery(queries.listViews, ()))
            except IndexError:
                print("Must provide a valid option")
                return
        case "table":
            if permLvl < permissions["TopGuy"]:
                print("You do not have permissions to use this command")
                return
            try:
                option=command[1]
                if option=="show":
                    table_id=command[2]
                    if not table_id.replace('_', '').replace('.', '').isalnum():
                        print("    BŁĄD: Nieprawidłowa nazwa tabeli!")
                        return []
                    print(executeQuery(f"""SELECT * FROM {table_id}""", ()))
                elif option=="list":
                    print(executeQuery(queries.listTables, ()))
            except IndexError:
                print("Must provide a valid option")
                return
        case "set-status":
            if permLvl < permissions["TopGuy"]:
                print("You do not have permissions to use this command")
                return

            try:
                status=command[1]
                user_id=command[2]
            except IndexError:
                print("Must provide a status and user_id")
                return
            
            if status not in validStatuses:
                print("Must provide a valid status:" \
                "ACTIVE, DELETED, SUSPENDED, WATCHED")
                return
            executeQuery(queries.changeUserStatus,(status,user_id))

        case "exit":
            exit()
        case "clear":
            cls()
        case "help":
            print("")
        case _:
            print(f"Unknown command '{command}' - see 'help'")

def executeQuery(sqlQuery: str, param: tuple)->list:
    if not sqlQuery:
        print("    WARNING! executeQuery: No query provided!")
        return None
    if not param:
        with oracledb.connect(dsn=DB_URL) as DB_CONN:
            with DB_CONN.cursor() as cur:
                cur.execute(sqlQuery)
                rows = cur.fetchall()
    with oracledb.connect(dsn=DB_URL) as DB_CONN:
        with DB_CONN.cursor() as cur:
            cur.execute(sqlQuery, param)
            DB_CONN.commit()
            try:
                rows = cur.fetchall()
            except Exception as e:
                print(e)
                return []
    return rows

def login():
    cls()
    print("\n","="*29,"\n   ENTER CREDENTIALS\n",'='*29,"\n")
    credentials = (input("Enter login:\n ->"),sha256(getpass("Enter password:\n ->").encode()).hexdigest())
    return executeQuery(queries.login,credentials)

permLevel = login()[0][0]
cls()
if permLevel:
    print("\n","="*29,f"\n  Login successful\n  Permission level: {permLevel}","\n","="*29)
else:
    print("Invalid credentials")
    exit
#cls()
validStatuses=[i[0] for i in executeQuery(queries.listStatuses,())]
while True:
    mainLoop(permLevel)