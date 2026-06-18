from dotenv import load_dotenv
from getpass import getpass
from hashlib import sha256
from time import sleep
import os
import oracledb
import queries

load_dotenv()

DB_URL=os.getenv("DB_URL")

if not DB_URL:
    raise ValueError("Database URL is missing")
DB_CONN=oracledb.connect(dsn=DB_URL)

def cls():
    os.system('cls' if os.name=='nt' else 'clear')

def mainLoop():
    cls()
    command = input("\nTUI: ")
    match command:
        case _:
            print(f"Unknown command '{command}'")
    input()

def executeQuery(sqlQuery: str, param: tuple)->list:
    if not sqlQuery:
        print("    WARNING! executeQuery: No query provided!")
        return None
    with DB_CONN:
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
    print("\n","="*29,f"    Login successful\n  Permission level: {permLevel[0][0]}","\n","="*29)
else:
    print("Invalid credentials")
sleep(5)
#cls()    
