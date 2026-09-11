# BOOTSTRAP — Hermes AI Workflow Environment

이 문서는 이 저장소의 **자동 설치·점검·복구용 단일 진입점**입니다.

사용자는 이 문서를 직접 단계별로 따라 하기보다, Codex 같은 에이전트에게
이 저장소와 `BOOTSTRAP.md`를 읽도록 지시하는 것을 권장합니다.

---

## 1. 목표

다음 환경을 가능한 범위까지 자동으로 구성하고 실제 호출까지 검증합니다.

- Hermes
- OpenAI Codex / GPT 계열
- agy CLI
- Gemini via agy
- Claude via agy
- Claude Code CLI
- Claude Max 로그인 경로
- 향후 Telegram gateway 연결을 위한 기본 상태 확인

원칙:

- 기존 정상 환경은 재설치하지 않습니다.
- Windows에서는 Ubuntu/WSL을 불필요하게 설치하지 않습니다.
- 로그인, OAuth 승인, 결제, 비밀번호 입력은 사용자가 직접 수행합니다.
- API Key, 토큰, 비밀번호를 로그에 출력하지 않습니다.
- “설치됨”이 아니라 **실제 호출 성공**을 기준으로 PASS 처리합니다.

---

# 2. Agent Execution Policy

에이전트는 아래 순서를 따릅니다.

## STEP 1 — 현재 환경 탐지

다음을 확인합니다.

- 운영체제 및 버전
- Shell
- CPU architecture
- Git
- Python
- uv
- Node.js / npm
- Hermes
- agy
- Claude Code CLI

이미 설치된 도구는 제거하거나 재설치하지 않습니다.

가능하면 다음 형식으로 내부 상태를 정리합니다.

| Component | Installed | Version | Path | Action |
|---|---:|---|---|---|
| Git | | | | KEEP/INSTALL/FIX |
| Python | | | | |
| uv | | | | |
| Node.js | | | | |
| Hermes | | | | |
| agy | | | | |
| Claude Code | | | | |

---

# 3. Hermes

## 3.1 기존 설치가 있는 경우

다음을 확인합니다.

```text
hermes --version
hermes model