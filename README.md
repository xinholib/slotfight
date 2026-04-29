# Slot RPG - 老虎機戰鬥遊戲

## 專案概述
結合老虎機轉盤與 RPG 戰鬥的網頁遊戲，玩家透過轉動老虎機來對怪物造成傷害。

## 技術架構

### 前端 (Flutter Web)
- **框架**: Flutter 3.44.0 (Web)
- **狀態管理**: Riverpod
- **路由**: go_router
- **HTTP 客戶端**: Dio

### 後端 (Go)
- **框架**: Gin
- **數據庫**: SQLite
- **認證**: JWT

## 戰鬥系統規格

### 老虎機配置
| 項目 | 規格 |
|------|------|
| 網格大小 | 5 列 × 3 行 |
| 符號數量 | 12 種獨特符號 |
| 排列方向 | 橫向 (Landscape) |
| 單次轉動時間 | 10 秒以內 |

### 符號定義
| 符號 | 名稱 | 陣營 | 顏色 |
|------|------|------|------|
| 🧙‍♂️ | Hero | 玩家 (綠/金) | #4CAF50 |
| ⚔️ | Warrior | 玩家 (金) | #FFD700 |
| 🔮 | Mage | 玩家 (綠) | #4CAF50 |
| 🛡️ | Shield | 玩家 (綠) | #4CAF50 |
| ✨ | Holy Light | 玩家 (金) | #FFD700 |
| ⚡ | Lightning | 玩家 (綠) | #4CAF50 |
| 👹 | Monster | 怪物 (紅) | #F44336 |
| 😈 | Demon | 怪物 (紅) | #F44336 |
| 💀 | Red Skull | 怪物 (黑) | #212121 |
| 🌑 | Black Spike | 怪物 (黑) | #212121 |
| 👾 | Chaos Orb | 怪物 (紫) | #9C27B0 |
| 🌟 | Wild | 萬用 (金) | #FFD700 |

## 開發狀態

### ✅ 已完成功能
| 項目 | 狀態 | 備註 |
|------|------|------|
| Flutter 專案建立 | ✅ 完成 | |
| 老虎機網格顯示 | ✅ 完成 | 5x3 grid |
| 12 種符號定義 | ✅ 完成 | |
| SPIN 按鈕動畫 | ✅ 完成 | 金色漸層 |
| 轉動動畫 | ✅ 完成 | |
| 符號特效動畫 | ✅ 完成 | GreenSweepEffect, RedFogEffect, etc. |
| 新增遊戲元件 | ✅ 完成 | visual_effects, particles, combo_counter |
| 編譯成功 | ✅ 完成 | flutter build web |
| 前端 HTTP 伺服器 | ✅ 運行中 | 192.168.18.9:23001 |

### 🔄 待開發功能
| 項目 | 優先級 | 備註 |
|------|--------|------|
| 後端 API 整合 | 高 | /api/battle/spin |
| 符號匹配 logic | 高 | 3+ 相同符號橫向/直向 |
| 傷害結算 | 中 | 依符號類型計算 |
| 勝利/失敗結算 | 中 | |

## 測試記錄

| 日期 | 測試項目 | 結果 | 備註 |
|------|----------|------|------|
| 2026-04-28 | flutter build web | ✅ 通過 | 編譯成功，無錯誤 |
| 2026-04-28 | HTTP 伺服器啟動 | ✅ 通過 | 192.168.18.9:23001 |
| 2026-04-28 | Git 推送 | ✅ 通過 | main branch |
| 2026-04-28 | Phase 2 開發 | ⚠️ 子程式超時 | 新增 visual_effects.dart |
| 2026-04-28 | 編譯修復 | ✅ 通過 | 修復 int→double, 缺失 effect |
| 2026-04-28 | Symbol 飛出演出修復 | ✅ 通過 | 使用真實盤面而非 mock |

## Phase 3 修復記錄 (2026-04-28)

| 問題 | 修復內容 | 狀態 |
|------|----------|------|
| Symbol 飛出演出與盤面不一致 | 移除 mock gridSymbols 生成，改用 battleState.grid | ✅ 已修復 |
| comboCount 無法取得 | 從盤面計算最大相同符號數量 | ✅ 已修復 |
| _showHealGroup 參數缺失 | 傳入 grid 和 totalHeal 參數 | ✅ 已修復 |

| 2026-04-29 | 画面震动特效 | ✅ 已完成 | 攻擊扣血時加入畫面震動特效，普通300ms/強烈500ms |
| 2026-04-29 | 目标打击震动 | ✅ 已完成 | 英雄/怪物立绘侧边栏局部震动200ms |
| 2026-04-29 | 单符号震动 | ✅ 已完成 | 每个symbol到达时触发小幅震动(8px,100ms) + 目标震动 |
| 2026-04-29 | 目标打击感 | ✅ 已完成 | 取消画面震动，只保留目标震动，仅伤害>0时触发，150ms快速震动 |
| 2026-04-29 | 震动时机修复 | ✅ 已完成 | 改为在symbol飞行到达扣血时触发震动，不是延迟2秒 |
| 2026-04-29 | 震动时机修复v2 | ✅ 已完成 | 扣血时立即触发震动，打到时立即震动而非延迟 |

## Phase 5 开发记录 (2026-04-29)

| 功能 | 开发内容 | 状态 |
|------|----------|------|
| 画面震动特效 | 攻擊扣血時加入畫面震動特效 | ✅ 已完成 |
| 普通震动 | 玩家攻击扣血时触发 | ✅ 已完成 |
| 强烈震动 | 怪物攻击扣血时触发(strong=true) | ✅ 已完成 |

## 快速開始

### 前端
```bash
cd frontend
flutter pub get
flutter run -d chrome
```

### 後端
```bash
cd backend
go run main.go
```

### 部署 (HTTP)
```bash
cd frontend
flutter build web
python3 -m http.server 23001 -b 192.168.18.9 -d build/web
```

## API 端點

| 端點 | 方法 | 描述 |
|------|------|------|
| /api/auth/register | POST | 註冊 |
| /api/auth/login | POST | 登入 |
| /api/battle/start | POST | 開始戰鬥 |
| /api/battle/spin | POST | 轉動老虎機 |
| /api/battle/result | GET | 獲取戰鬥結果 |

## 聯絡
- GitHub: https://github.com/xinholib/slotfight
- 前端: https://github.com/xinholib/slotfight-frontend