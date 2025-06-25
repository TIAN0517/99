// 將 Unicode 編碼自動轉中文
export function unicodeDecode(str: string): string {
    return str.replace(/\\u[0-9a-fA-F]{4}/g, (m) => String.fromCharCode(parseInt(m.replace('\\u', ''), 16)));
}
