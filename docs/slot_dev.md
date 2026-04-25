<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

# SlotRPG 英雄VS怪物戰鬥 Flutter 前端開發規格文件（AI Agent 實作指南）

**版本**：v1.0 | **目標**：完整戰鬥畫面對抗UI，Flame+Flutter，iOS/Android縱版。
**預計開發時數**：12-18小時 | **依賴**：Flutter 3.19+，Flame 1.10+。[^1]

## 1. 專案結構

```
lib/
├── main.dart
├── providers/battle_provider.dart  // Riverpod狀態
├── widgets/
│   ├── battle_screen.dart  // 主畫面Stack
│   ├── slot_grid.dart      // 5x3 FlameGame
│   ├── hero_card.dart      // 玩家英雄卡
│   ├── monster_card.dart   // 怪物卡
│   ├── hud.dart
│   └── battle_log.dart
├── flame/
│   └── battle_game.dart    // 格子+粒子
├── services/api_service.dart  // Dio API
└── assets/  // 符號/英雄/怪物/音效
```


## 2. pubspec.yaml（完整依賴）

```yaml
name: slotrpg_battle
description: Hero vs Monster Slot Battle UI
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.2.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.9
  flame: ^1.10.1
  flame_audio: ^2.0.0
  dio: ^5.4.0
  lottie: ^2.7.0
  rive: ^0.12.4
  shared_preferences: ^2.2.2

flutter:
  assets:
    - assets/images/symbols/  # 15符號PNG
    - assets/images/heroes/   # 玩家12英雄
    - assets/images/monsters/ # 敵方10怪物
    - assets/animations/      # Lottie JSON
    - assets/audio/           # OGG音效
  fonts:
    - family: BattleFont
      fonts: [asset: assets/fonts/Battle-Bold.ttf]
```


## 3. API規格（Dio整合）

```dart
class ApiService {
  static const baseUrl = 'http://localhost:8080/api';
  
  Future<BattleInitResponse> battleStart(int stageId) => dio.post('$baseUrl/battlestart', data: {'stage_id': stageId});
  Future<SpinResponse> battleSpin() => dio.post('$baseUrl/battlespin');
  Future<SkillResponse> battleSkill(int skillId) => dio.post('$baseUrl/battleskill', data: {'skill_id': skillId});
}
```


## 4. 狀態模型（Riverpod）

```dart
@freezed
class BattleState with _$BattleState {
  factory BattleState({
    required List<Hero> playerHeroes,
    required List<Monster> enemyMonsters,
    required List<int> grid,  // 15元素 column-major
    required String currentTurn,  // 'player'/'enemy'
    required int turnCount,
    required List<BattleLog> logs,
    required bool isSpinning,
    required int comboCount,
  }) = _BattleState;
}
```


## 5. 核心Widget實作規格

### 5.1 BattleScreen（主Stack，對抗佈局）

```dart
@override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  
  return Scaffold(
    body: Stack(
      children: [
        // 背景
        BattleBackground(),
        // HUD對稱
        PlayerHUD(),
        EnemyHUD(),
        // 格子戰場 (寬screenWidth*0.9, 高screenHeight*0.4)
        Positioned(
          top: screenHeight * 0.22,
          left: screenWidth * 0.05,
          child: SlotBattlefield(size: Size(screenWidth*0.9, screenHeight*0.4)),
        ),
        // 底對峙隊伍
        Positioned(
          bottom: screenHeight * 0.15,
          left: 0, right: 0,
          child: BattleTeamRow(),
        ),
        // Spin鈕
        Positioned(bottom: 80, left: 0, right: 0, child: SpinButton()),
        BattleLogOverlay(),
      ],
    ),
  );
}
```


### 5.2 SlotBattlefield（Flame格子）

```dart
class SlotBattlefield extends StatelessWidget {
  final Size size;
  
  @override
  Widget build(BuildContext context) {
    return FlameGame(
      size: size,
      children: [
        SlotGridComponent(grid: ref.watch(battleProvider.select((s) => s.grid))),
        BorderGlowEffect(turnColor: currentTurn == 'player' ? Colors.green : Colors.red),
        ComboCounter(),
        EliminationParticles(),
      ],
    );
  }
}
```


### 5.3 BattleTeamRow（左右對峙）

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    // 玩家左綠盾 (寬screenWidth*0.4)
    SizedBox(width: screenWidth*0.4, child: PlayerHeroesColumn()),
    // 怪物右紅棘 (寬screenWidth*0.4)
    SizedBox(width: screenWidth*0.4, child: EnemyMonstersColumn(reverse: true)),
  ],
)
```


### 5.4 HeroCard規格

```dart
Container(
  width: 110, height: 150,
  decoration: BoxDecoration(
    gradient: isMain ? LinearGradient(colors: [Colors.green, Colors.emerald]) : LinearGradient(colors: [Colors.green.shade700, Colors.green.shade900]),
    borderRadius: BorderRadius.circular(16),
    boxShadow: isMain ? [glowShadow] : [],
  ),
  child: Stack([
    ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.asset(hero.image)),
    Positioned(bottom: 8, child: HeroName(hero.name)),
    MPBar(value: hero.mp/100, color: Colors.lime),
    if (skillReady) SkillIcon(),
  ]),
)
```


## 6. 動畫與特效規格

| 特效 | 觸發 | 實作 | 持續 |
| :-- | :-- | :-- | :-- |
| Spin旋轉 | Spin開始 | RotationTransition 360° | 800ms |
| 消除爆破 | 匹配>=3 | Scale 1→0 + Particles | 400ms |
| 掉落填充 | 消除後 | Slide down 0.3s/格 | 600ms |
| 擊殺碎裂 | HP<=0 | Lottie shatter + fly out | 1000ms |
| 回合切換 | turn變 | 全屏ColorFiltered掃描 | 500ms |
| 5連Combo | combo>=5 | ScreenShake + 火花 | 2000ms |

## 7. 音效清單

```
spin_beep.ogg (Spin)
match_ding.ogg (消除)
combo_boom.ogg (連鎖)
skill_whoosh.ogg (技能)
hero_strike.ogg (玩家傷害)
monster_roar.ogg (怪物行動)
victory_fanfare.ogg (勝利)
```


## 8. API流程

```
1. GET /profile → 載入英雄隊伍
2. POST /battlestart → 初始化戰鬥/怪物
3. POST /battle/select → 選主英雄
4. POST /battlespin → Spin+動畫播放
5. POST /battleskill → 技能特效
6. POST /battleend → 結算動畫
```


## 9. 測試Checklist

- [ ] 縱版自適應 (iPhone14 ~ Pad)
- [ ] 60FPS格子動畫
- [ ] API斷線重連
- [ ] 音效同步
- [ ] 擊殺粒子無Lag
- [ ] 5連鎖壓力測試


## 10. 美術資產需求（28檔）

```
symbols/ (15 PNG 128x128): sword.png, magic.png, shield.png...
heroes/ (12 PNG 200x250): warrior_01.png...
monsters/ (10 PNG 200x250): slime_king.png...
animations/shatter.json (Lottie)
fonts/Battle-Bold.ttf
```

**開發順序**：1.BattleScreen骨架 → 2.Flame格子 → 3.英雄怪物卡 → 4.API+動畫 → 5.特效優化。

此規格零歧義，AI Agent可直接生成完整程式碼。預期輸出：可運行Demo APK。[^1][^2]

<div align="center">⁂</div>

[^1]: yong-u3d-golanglai-kai-fa-slot-VqVaYG6IQ02je5uN7sT6MA.md

[^2]: https://www.perplexity.ai/search/ed4c8fa4-277a-4d26-a932-196a3cec8fd2

