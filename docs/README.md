# Slot Fight+RPG

Slot Fight 是一款結合老虎機與角色扮演元素的遊戲專案。

## 🚀 部署資訊
- **伺服器 IP**: `192.168.18.9`
- **後端連接埠**: `8080`
- **前端連接埠**: `23001`

## 📁 專案結構
```
slotfight/
├── docs/                    # 開發文件
│   ├── README.md           # 本文件
│   ├── slot_dev.md         # 前端開發規格
│   └── ai.txt              # AI 指令配置
├── frontend/               # Flutter 前端 (slotfight-frontend)
├── backend/                # Go 後端 (slotfight-backend)
└── restart.sh             # 服務重啟腳本
```

## 🛠 啟動與管理
請統一使用 `restart.sh` 腳本來啟動或重啟前後端服務。

```bash
cd /home/dev/slotfight
./restart.sh
```

## 🔄 開發工作流 (Workflow)
為了確保開發進度同步且環境一致，所有開發人員必須遵守以下流程：

1. **同步狀態**: 在進行任何代碼修改之前，必須先更新並同步本 `README.md` 中的 [修改紀錄與測試計劃] 區塊。
2. **實作修改**: 執行功能開發或 Bug 修復。
3. **編譯驗證**: 確保程式碼編譯通過且無基本錯誤。
4. **提交代碼**: 將修改後的代碼上傳至 GitHub 倉庫。
5. **部署生效**: 執行 `restart.sh` 重新啟動服務以套用更改。

## 📝 修改紀錄與測試計劃 (Centralized Log & Test Plan)

| 日期 | 編號 | 修改內容 | 測試計劃 | 狀態 |
| :--- | :--- | :--- | :--- | :--- |
| 2026-04-25 | INIT-01 | 初始化專案結構（前端 Flutter + 後端 Go）| flutter build web + go build 成功 | ✅ 完成 |
| 2026-04-25 | INIT-02 | 建立 GitHub 倉庫（slotfight-frontend, slotfight-backend）| git push 成功 | ✅ 完成 |
| 2026-04-25 | INIT-03 | 修復後端 r.Run(":8080") 啟動問題 | curl http://localhost:8080/health 返回 {"status":"ok"} | ✅ 完成 |
| 2026-04-25 | P1-01 | Phase 1 後端實作（用戶系統/JWT/英雄/怪物/老虎機/戰鬥API）| go build 成功 | ✅ 完成 |
| 2026-04-25 | P1-02 | Phase 1 前端實作（登入/註冊/首頁/戰鬥頁面）| flutter build web 成功 | ✅ 完成 |

## 🐛 測試問題追蹤 (Bug & UX Tracking)

| ID | 分類 | 問題描述 | 嚴重程度 | 狀態 | 備註 |
| :--- | :--- | :--- | :--- | :--- | :--- |

## 🗄️ GitHub 倉庫
- **前端**: https://github.com/xinholib/slotfight-frontend
- **後端**: https://github.com/xinholib/slotfight-backend

## 🎮 Phase 1 已實現功能

### 後端 API
| 方法 | 路徑 | 說明 |
| :--- | :--- | :--- |
| POST | /api/v1/auth/register | 用戶註冊 |
| POST | /api/v1/auth/login | 用戶登入 |
| GET | /api/v1/auth/me | 當前用戶資訊 |
| GET | /api/v1/heroes | 英雄列表 |
| POST | /api/v1/battle/start | 開始戰鬥 |
| POST | /api/v1/battle/spin | 執行旋轉 |

### 前端頁面
- /login - 登入頁面
- /register - 註冊頁面
- /home - 首頁（用戶資訊 + 開始戰鬥）
- /battle - 戰鬥頁面（英雄選擇）

## 🎮 下一階段開發計劃 (Phase 2)

### 後端
1. 完善戰鬥結算邏輯
2. 敵人 AI 系統
3. 技能系統
4. 傷害計算優化

### 前端
1. Flame 格子遊戲區塊
2. 英雄/怪物卡片動畫
3. 旋轉動畫特效
4. 傷害數字顯示

### 共同
1. 回合制戰鬥流程串接
2. 音效系統
3. 勝敗結算畫面
