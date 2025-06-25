from fastapi import FastAPI, UploadFile, File, Form, Query
from pydantic import BaseModel
from fastapi.responses import JSONResponse

app = FastAPI()

class DbConn(BaseModel):
    type: str
    host: str
    port: int
    user: str
    password: str
    dbname: str

class QueryReq(BaseModel):
    dbtype: str
    connectionId: str
    sql: str

class CodeGenReq(BaseModel):
    connectionId: str
    table: str
    language: str

@app.post("/api/db/connect")
def db_connect(conn: DbConn):
    # 模擬成功
    return {"status": "success", "data": {"msg": "連線成功"}}

@app.get("/api/db/schema")
def get_schema(dbtype: str = Query(...), connectionId: str = Query(...)):
    return {"status": "success", "data": [
        {"name": "test", "tables": [
            {"name": "users", "columns": [{"name": "id", "type": "int"}, {"name": "name", "type": "varchar"}]},
            {"name": "orders", "columns": [{"name": "id", "type": "int"}, {"name": "user_id", "type": "int"}]}
        ]}
    ]}

@app.post("/api/db/query")
def run_query(req: QueryReq):
    if any(x in req.sql.lower() for x in ["drop", "delete", "truncate"]):
        return {"status": "fail", "error": "高風險操作需二次確認"}
    return {"status": "success", "data": {
        "columns": ["id", "name"],
        "rows": [[1, "Alice"], [2, "Bob"]]
    }}

@app.post("/api/db/import")
async def db_import(file: UploadFile = File(...), connectionId: str = Form(...)):
    return {"status": "success", "msg": "匯入成功"}

@app.get("/api/db/export")
def db_export(connectionId: str, format: str):
    return {"status": "success", "url": "/download/export.csv"}

@app.post("/api/db/backup")
def db_backup(data: dict):
    return {"status": "success", "url": "/download/backup-20250623.sql"}

@app.get("/api/db/permissions")
def get_permissions(dbtype: str = Query(...), connectionId: str = Query(...)):
    return {"status": "success", "data": [
        {"username": "admin", "roles": ["DBA"], "privileges": ["ALL"]},
        {"username": "user1", "roles": ["reader"], "privileges": ["SELECT"]}
    ]}

@app.get("/api/db/erd")
def er_diagram(connectionId: str = Query(...)):
    return {"status": "success", "data": {"mermaid": "erDiagram\nusers ||--o{ orders : has\norders }|..|{ products : contains"}}

@app.post("/api/db/gen_code")
def gen_code(req: CodeGenReq):
    return {"status": "success", "data": {"code": f"// CRUD for {req.table} in {req.language}"}}

@app.get("/api/db/audit-log")
def audit_log(connectionId: str = Query(...)):
    return {"status": "success", "data": [
        {"id": 1, "time": "2025-06-23 10:00", "user": "admin", "table": "users", "action": "UPDATE"},
        {"id": 2, "time": "2025-06-23 10:05", "user": "user1", "table": "orders", "action": "DELETE"}
    ]}
