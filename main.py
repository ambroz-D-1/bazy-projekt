from dotenv import load_dotenv
from getpass import getpass
from hashlib import sha256
from time import sleep
import os
import oracledb
import queries

help_str="""
    add-admin: create new admin account
    clear: clear TUI
    exit: exit program
    help: show this list
    set-status <status> <user_id>: change user's status
        <status>: ACTIVE | DELETED | SUSPENDED | WATCHED
    table <option>:
        -list: list all available tables
        -show <table_id>:show contents of selected table
    view <option>:
        -list: list all available views
        -show <view_id>:show contents of selected view
    
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

def view(options:list = []):
    try:
        option=options[0]
        if option=="show":
            view_id=options[1]
            if not view_id.replace('_', '').replace('.', '').isalnum():
                print("    BŁĄD: Nieprawidłowa nazwa widoku!")
                return []
            print(executeQuery(f"""SELECT * FROM {view_id}""", ()))
        elif option=="list":
            print(executeQuery(queries.listViews, ()))
    except IndexError:
        print("Must provide a valid option")
        return

def table(options:list = []):
    if permLevel < permissions["TopGuy"]:
        print("You do not have permissions to use this command")
        return
    try:
        option=options[0]
        if option=="show":
            table_id=options[1]
            if not table_id.replace('_', '').replace('.', '').isalnum():
                print("    BŁĄD: Nieprawidłowa nazwa tabeli!")
                return []
            print(executeQuery(f"""SELECT * FROM {table_id}""", ()))
        elif option=="list":
            print(executeQuery(queries.listTables, ()))
    except IndexError:
        print("Must provide a valid option")
        return

def setStatus(options:list = []):
    if permLevel < permissions["TopGuy"]:
        print("You do not have permissions to use this command")
        return

    try:
        status=options[0]
        user_id=options[1]
    except IndexError:
        print("Must provide a status and user_id")
        return
            
    if status not in validStatuses:
        print("Must provide a valid status:" \
        "ACTIVE, DELETED, SUSPENDED, WATCHED")
        return
    executeQuery(queries.changeUserStatus,(status,user_id))

def addAdmin():
    if permLevel < permissions["BigYahoo"]:
        print("You do not have permissions to use this command")
        return
    print("\n","="*29,"\n   ENTER CREDENTIALS FOR CREATED ACCOUNT\n",'='*29,"\n")
    try:
        level=int(input("Enter permission level for new account\n ->"))
        if level not in range(1,6):
            raise ValueError
    except (ValueError, TypeError):
        print("Priviledge must be an integer between 1 and 5 (inclusive)")
        return
    credentials = (input("Enter login for new account:\n ->"),
        sha256(getpass("Enter password for new account:\n ->").encode()).hexdigest(),
        level)
    return executeQuery(queries.addAdminAcc,credentials)

def query():
    if permLevel < permissions["BigYahoo"]:
        print("You do not have permissions to use this command")
        return
    print("\n","="*29,"\n   ENTER QUERY\n",'='*29,"\n")
    q = input("\n->")
    print("Result:\n",executeQuery(q, ()))
    
def mainLoop(command: list)->None:
    if not command:
        return
    match command[0]:
        case "view":
            view(command[1:])
        case "table":
            table(command[1:])
        case "set-status":
            setStatus(command[1:])
        case "query":
            query()
        case "add-admin":
            addAdmin()
        case "exit":
            exit()
        case "clear":
            cls()
        case "help":
            print(help_str)
        case _:
            print(f"Unknown command '{command}' - see 'help'")

def executeQuery(sqlQuery: str, param: tuple)->list:
    if not sqlQuery:
        print("    WARNING! executeQuery: No query provided!")
        return []
    with oracledb.connect(dsn=DB_URL) as DB_CONN:
        with DB_CONN.cursor() as cur:
            cur.execute(sqlQuery, param if param else None)
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
    print(credentials)
    return executeQuery(queries.login,credentials)

permLevel = login()[0][0]
#cls()
if permLevel:
    print("\n","="*29,f"\n  Login successful\n  Permission level: {permLevel}","\n","="*29)
else:
    print("Invalid credentials")
    exit
#cls()
validStatuses=[i[0] for i in executeQuery(queries.listStatuses,())]
while True:
    mainLoop(input("\nTUI: ").strip().split())