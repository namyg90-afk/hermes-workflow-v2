# 3. Telegram 가입과 Hermes 봇 연결

원본 교재의 가입 → BotFather → 봇 이름 → 봇 ID → Hermes 연결 순서를 유지했습니다. 실제 토큰·개인 ID·NAS 비밀번호는 교육 자료에 포함하지 않습니다.

## Telegram 설치·가입

1. 휴대폰에 공식 Telegram 앱을 설치합니다.
2. 앱을 열고 Start Messaging을 누릅니다.
3. 국가와 본인 휴대폰 번호를 입력합니다.
4. 화면에 안내된 방식으로 인증코드를 확인해 입력합니다. 반드시 SMS로만 오는 것은 아닙니다.
5. 이름을 입력하면 계정 생성이 완료됩니다. 기존 계정이면 로그인 흐름으로 진행합니다.

기본 가입에는 전화번호가 필요하며 이메일만으로 가입하는 과정이 아닙니다. [Telegram 공식 안내](https://telegram.org/faq).

## BotFather로 봇 생성

1. Telegram에서 인증된 `@BotFather`를 찾습니다.
2. `/newbot`을 보냅니다.
3. 봇을 부를 이름을 지정합니다.
4. 겹치지 않는 사용자 이름을 정합니다. 예: `my_work_assistant_bot`.
5. BotFather가 발급한 토큰을 안전하게 보관합니다.
6. 새 봇의 대화창에서 Start 또는 `/start`를 누릅니다.

근거: [Telegram BotFather 튜토리얼](https://core.telegram.org/bots/tutorial).

## Hermes에 연결

에이전트에게 요청:

> Hermes에 새 Telegram 봇을 연결해줘. 사용할 Hermes 프로필을 먼저 확인하고 Telegram 설정 화면을 열어줘. 토큰은 내가 직접 입력할게. 내 사용자만 허용하고 gateway를 시작한 뒤 실제 봇 대화와 예약 메시지 도착까지 확인해줘. 기존 봇이 있으면 같은 토큰으로 gateway를 중복 실행하지 마.

직접 설정할 때:

```powershell
hermes gateway setup
```

설정 과정에서 Telegram을 선택하고 토큰·허용 사용자를 지정합니다. 페어링을 사용하면 자기 계정의 요청인지 확인하고 승인합니다. 수동 구성 예시는 다음과 같습니다. 실제 값은 로컬 설정에서만 입력합니다.

```dotenv
TELEGRAM_BOT_TOKEN=YOUR_BOT_TOKEN
TELEGRAM_ALLOWED_USERS=YOUR_NUMERIC_TELEGRAM_USER_ID
```

Windows 기본 환경의 `.env`는 `%LOCALAPPDATA%\hermes` 아래에 있지만 별도 프로필이면 그 프로필의 설정 위치를 사용합니다. 사용자 이름과 숫자 사용자 ID를 혼동하지 않습니다.

최초 확인에는 터미널에서 gateway를 실행합니다.

```powershell
hermes gateway run
```

봇에서 답변이 오는지 확인한 뒤 foreground 실행을 종료하고, 계속 켜두는 서비스로 전환할 수 있습니다.

```powershell
hermes gateway install --start-now --start-on-login
hermes gateway status
```

이 옵션들은 이번 PC에서 도움말로 확인했습니다. 설치 버전이 다르면 먼저 `hermes gateway install --help`를 확인합니다. 설정 수정 뒤 재시작이 필요할 수 있습니다.

```powershell
hermes gateway restart
```

근거: [Hermes Telegram 안내](https://hermes-agent.nousresearch.com/docs/user-guide/messaging/telegram/).

## 연결 확인

- [ ] 허용된 본인 계정으로 보낸 질문에 응답한다.
- [ ] 알 수 없는 사용자는 접근하지 못한다.
- [ ] PC 재로그인 후 서비스가 살아 있는지 확인한다.
- [ ] 봇 채팅에서 `/sethome`을 실행해 알림 도착 위치를 정한다.
- [ ] 5분 뒤 테스트 알림 1건을 예약하고 실제 도착을 확인한다.
- [ ] 테스트 예약을 종료·삭제하고 현재 예약 목록을 확인한다.

Telegram 메시지 자체가 꺼진 PC를 자동으로 켜주지는 않습니다. 상시 운영에는 PC/서버의 전원, 절전 정책, 인터넷 연결, gateway 서비스가 모두 필요합니다.

## 자주 생기는 문제

| 증상 | 확인할 항목 |
|---|---|
| 답이 없음 | gateway 상태, 사용자 허용, 토큰, 네트워크 |
| Telegram 연결은 되지만 모델 오류 | 해당 프로필의 모델 인증·한도 |
| 충돌 오류·중복 답변 | 같은 봇 토큰의 중복 gateway |
| 채팅은 되지만 예약 알림이 없음 | 홈 채널, 시간대, 예약 저장 여부, PC 절전 |
| 재부팅 후 중단 | 자동 시작 옵션과 실제 로그인 조건 |

토큰이 노출되었다면 BotFather에서 폐기·재발급하고 로컬 설정을 갱신한 뒤 gateway를 재시작합니다. 원본 교육 자료의 실제 자격 증명을 재사용하지 않습니다.
