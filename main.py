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
"""

load_dotenv()

DB_URL=os.getenv("DB_URL")

if not DB_URL:
    raise ValueError("Database URL is missing")
#DB_CONN=oracledb.connect(dsn=DB_URL)

def cls():
    os.system('cls' if os.name=='nt' else 'clear')

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
            rows = cur.fetchall()
    return rows

def login():
    cls()
    print("\n","="*29,"\n   ENTER CREDENTIALS\n",'='*29,"\n")
    credentials = (input("Enter login:\n ->"),sha256(getpass("Enter password:\n ->").encode()).hexdigest())
    return executeQuery(queries.login,credentials)

permLevel = login()
cls()
if permLevel:
    print("\n","="*29,f"\n  Login successful\n  Permission level: {permLevel[0][0]}","\n","="*29)
else:
    print("Invalid credentials")
    exit
sleep(3)
#cls()    
while True:
    mainLoop(permLevel)