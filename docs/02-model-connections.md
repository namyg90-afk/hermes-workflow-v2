# 2. GPT · Gemini · Claude 연결

검토일: 2026-09-12. 아래 구성은 사용자 PC의 설정, CLI 도움말과 모델 목록, 공급자 공식 안내를 구분해서 작성했습니다.

## 연결 방식을 먼저 고르기

| 목적 | 실행 경로 | 로그인·비용의 기준 |
|---|---|---|
| Hermes 주 모델로 GPT 사용 | Hermes → openai-codex | ChatGPT/Codex 로그인 경로. 실제 한도는 계정에서 확인 |
| Gemini 검토·작성 | Hermes → agy CLI → Gemini | Antigravity 계정의 모델 접근·한도 |
| agy에서 Claude 검토 | Hermes → agy CLI → Claude | Antigravity 계정. Claude Max와 별개 |
| Claude Code 직접 실행 | Hermes → 설치된 claude CLI | Claude Code에 로그인한 계정·선택한 인증 방식 |
| Claude를 Hermes 주 모델로 사용 | Hermes → Anthropic API | API 키의 별도 사용량 과금 |
| Hermes의 Claude Max OAuth | Hermes → Anthropic OAuth | Hermes 문서상 Max + 추가 사용 크레딧 경로. 적용 가능 여부 확인 필요 |

`agy`를 부르는 것은 Hermes의 주 모델을 Gemini로 바꾸는 것과 다릅니다. 현재 사용 환경은 GPT가 전체 작업을 관리하고 agy를 필요할 때 호출하는 구조입니다.

## A. GPT: 현재 사용 중인 기본 경로

```powershell
hermes model
```

1. ChatGPT / Codex 구독에 해당하는 항목을 선택합니다. 메뉴의 번호는 버전에 따라 바뀌므로 이름으로 찾습니다.
2. 표시된 공식 로그인 주소를 열어 본인 계정으로 로그인하고 일회용 코드를 입력합니다.
3. 장치 코드 인증이 막혀 있으면 ChatGPT 보안 설정 또는 조직의 권한 설정을 확인합니다.
4. 목록에 실제 표시되는 모델을 선택하고 Hermes에서 대화를 확인합니다.

이번 PC에서 확인된 값은 `provider: openai-codex`, `default: gpt-5.6-sol`입니다. 모든 계정에 같은 모델이 보장되는 것은 아닙니다. 일반 OpenAI API 키 방식과 구독 로그인을 혼동하지 않습니다. 자동화의 계정별 한도·과금은 서비스 화면에서 확인합니다.

근거: [OpenAI 공식 인증 안내](https://learn.chatgpt.com/docs/auth), [Hermes 공급자 설정](https://hermes-agent.nousresearch.com/docs/integrations/providers/).

## B. agy: Gemini와 Claude를 작업별로 호출

Windows 새 설치:

```powershell
irm https://antigravity.google/cli/install.ps1 | iex
```

설치 후 새 터미널에서 작업 폴더로 이동해 `agy`를 실행하고 초기 설정 및 계정 로그인을 완료합니다. 이어서 사용할 수 있는 모델을 조회합니다.

```powershell
agy --help
agy models
```

이번 PC에서 조회된 모델 ID 중 실습 예시:

- `gemini-3.1-pro-high`
- `gemini-3.8-flash-high`
- `claude-sonnet-4-6`
- `claude-opus-4-6-thinking`

위 목록은 조회 시점의 결과입니다. 오래된 문서의 모델명을 복사하기보다 `agy models` 결과의 ID를 사용합니다.

일회성 요청 예시:

```powershell
agy -p "TASK.md를 읽고 실행 전 점검사항 5개를 제안해줘. 파일은 수정하지 마." --model gemini-3.1-pro-high --print-timeout 5m
agy -p "TASK.md의 계획에서 빠진 근거와 모순을 검토해줘. 파일은 수정하지 마." --model claude-sonnet-4-6 --print-timeout 5m
```

Hermes에 자연어로 요청할 때:

> antigravity-cli 스킬을 사용해 이번 작업 폴더의 TASK.md와 공개 참고자료를 Gemini로 검토해줘. 실행 가능한 모델 ID를 먼저 확인하고, 검토 원문과 사용한 모델을 logs에 남겨줘. 최종 답변은 원자료와 대조해서 정리해줘.

스킬이 없으면 에이전트에게 `agy` 도움말을 읽고 터미널 호출 절차를 구성하도록 요청합니다. 다른 에이전트의 스킬 파일을 복사했다고 도구 이름·경로까지 자동 호환되는 것은 아닙니다.

근거: [Google Antigravity CLI 시작하기](https://antigravity.google/docs/cli/getting-started). 모델 ID와 플래그는 이번 PC의 `agy models`, `agy --help`에서 확인했습니다. 이 문서 작성 중 유료 추론 테스트는 실행하지 않았습니다.

## C. Claude Max를 사용한다면: Claude Code 직접 실행

Claude Code 공식 설치 안내에 따라 설치한 뒤 `claude`를 열어 본인이 로그인합니다. 설치 후 다음을 확인합니다.

```powershell
claude --version
claude auth status
```

로그인이 확인되면 작업 폴더에서 실행합니다.

```powershell
claude -p "TASK.md의 계획을 읽고 누락된 조건만 검토해줘. 파일은 수정하지 마." --allowedTools Read --max-turns 3
```

이 방식은 정식 Claude Code 프로그램을 실행하는 것입니다. 별도의 범용 API 키를 발급받는 절차가 아닙니다. API 키 환경변수 등 다른 인증이 적용되어 있다면 예상한 구독 경로로 실행되지 않을 수 있으므로 인증 상태를 먼저 확인합니다.

현재 PC의 Claude Code는 **2.1.231 설치 확인, 로그인 상태는 false**였습니다. 따라서 설치만으로 Max 연결이 완료되었다고 볼 수 없습니다. 반면 agy의 Claude 모델 목록 조회는 성공했습니다. 두 연결은 독립적입니다.

근거: [Claude Code 설치](https://code.claude.com/docs/en/setup), [프로그램 방식 실행](https://code.claude.com/docs/en/headless), [인증 사용 안내](https://code.claude.com/docs/en/legal-and-compliance).

## D. Claude를 Hermes의 주 모델로 연결: API 키

1. Claude Console에서 API 사용 계정과 결제 상태를 확인합니다.
2. API 키를 발급합니다.
3. `hermes model`에서 Anthropic의 API 키 경로를 선택하고 본인이 키를 입력합니다.
4. 실제 목록에서 모델을 선택하고 짧은 질의로 연결을 확인합니다.
5. Console 사용량 화면에서 비용과 한도를 확인합니다.

API 키로 실행하는 요청은 Claude Max 구독료와 별도로 계산됩니다. 키를 Notion·GitHub·채팅 예시에 붙이지 않습니다.

## E. Hermes 문서에 있는 Max OAuth 경로의 조건

현재 Hermes 문서는 Anthropic OAuth에 **Max 구독과 구매한 extra usage 크레딧**이 필요하고, 기본 Max 포함량을 소모하는 방식이 아니라고 설명합니다. 또한 Pro는 이 경로의 대상이 아니라고 명시합니다.

확인할 순서: Max 계정과 추가 크레딧 확인 → `hermes model`의 Anthropic OAuth 안내 확인 → 공급자의 자체 로그인 진행 → 소량 연결 확인 → extra usage 내역 확인. 해당 경로의 적용 여부가 불명확하면 API 키 또는 정식 Claude Code 실행 경로를 사용합니다.

Hermes의 기능 설명은 Anthropic의 허용 범위나 과금 보증을 대신하지 않습니다. Anthropic은 제3자가 사용자 구독 자격 증명을 수집·중개하는 사용을 제한하고 있습니다. 따라서 이 교재에서는 토큰 추출·복사·비공식 프록시 구성법을 제공하지 않습니다. 사용자 자신의 정식 Claude Code 실행과 API 키 사용을 구분해 안내합니다.

근거: [Hermes Anthropic 안내](https://hermes-agent.nousresearch.com/docs/integrations/providers/#anthropic-native), [Anthropic 인증 사용 범위](https://code.claude.com/docs/en/legal-and-compliance#authentication-and-credential-use).

## 운영 원칙

한 작업에 모든 모델을 무조건 호출하지 않습니다. 초안·통합은 GPT, 독립 검토는 Gemini 또는 Claude처럼 역할을 정합니다. 핵심 결과는 모델 간 다수결 대신 출처·원본 파일·계산·실행 결과로 검증합니다. 실패한 모델 호출은 다른 모델의 성공으로 덮어 쓰지 않고 실패 및 대체 경로를 기록합니다.
