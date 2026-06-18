from dotenv import load_dotenv
from getpass import getpass
from hashlib import sha256
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

def executeQuery(sqlQuery: str, param: tuple)->list:
    if not sqlQuery:
        print("    WARNING! executeQuery: No query provided!")
        return None
    with DB_CONN:
        with DB_CONN.cursor as cur:
            cur.execute(sqlQuery, param)
    return cur.fetchone()

def login():
    cls()
    print("="*29, "\n   ENTER CREDENTIALS\n","="*29)
    credentials = (input("Enter login:\n ->"),sha256(getpass("Enter password:\n ->").encode()).hexdigest())
    return credentials
    result = executeQuery(queries.login,credentials)
    print(result)
    if not result:
        print("Invalid credentials")
        exit

print(login())