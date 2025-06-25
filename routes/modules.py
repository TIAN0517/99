from fastapi import APIRouter

router = APIRouter()

@router.get('/modules')
def get_modules():
    modules = [
        {"name": "帳務管理", "desc": "查詢收支、發票、對帳、報表"},
        {"name": "成本分析", "desc": "瓦斯進貨、運輸、分裝、人工等成本"},
        {"name": "派工管理", "desc": "派工、維修、進度追蹤"},
        {"name": "FAQ", "desc": "常見問題、知識庫"},
        {"name": "優惠活動", "desc": "促銷、折扣、會員活動"},
        {"name": "員工管理", "desc": "多用戶、權限分級、頭像"},
        {"name": "設備管理", "desc": "瓦斯桶、配送車、設備狀態"},
        {"name": "分裝廠分析", "desc": "分裝廠產能、庫存、效率"},
    ]
    return {"modules": modules}
