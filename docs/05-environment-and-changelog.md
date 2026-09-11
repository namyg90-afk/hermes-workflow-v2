# 5. 확인된 환경과 V2 변경사항

확인일: **2026-09-12, Asia/Seoul**. 계정 및 개인 PC의 전체 설정을 공개하는 대신 교육에 필요한 항목만 기록했습니다.

## 확인된 상태

| 항목 | 확인 결과 | 확인 범위 |
|---|---|---|
| Hermes | v0.20.0, 표기 날짜 2026.8.3 | 로컬 `hermes --version` |
| 설치 코드 | 56dc01d, 커밋 날짜 2026-08-10 | 로컬 Git HEAD. 최신 배포판이라고 단정하지 않음 |
| Python | 3.11.15 | 기본 python은 Hermes venv |
| 주 모델 | gpt-5.6-sol / openai-codex | 기본 설정과 별도 봇 프로필 설정 |
| agy | 설치됨, 모델 목록 조회 성공 | Gemini 및 Claude 항목 조회. 실제 추론 테스트는 미실행 |
| Claude Code | 2.1.231 | 설치 확인 |
| Claude Code 로그인 | loggedIn=false | `claude auth status`; 별도 로그인 필요 |
| 스킬 | antigravity-cli, claude-code, 연구 운영 스킬 존재 | 로컬 파일 확인 |
| Notion | Hermes 설정에 MCP 항목 존재 | 이번 문서 업로드는 Codex의 Notion 연결 사용 |
| python-docx | 1.2.0 | 프로젝트 venv와 기본 Python에 설치, 기본 import 확인; 프로젝트에서 DOCX 왕복 검증 |
| Poppler | pdftoppm 명령 발견 | 렌더링 실행 테스트는 미실행 |
| LibreOffice | PATH와 표준 Program Files 위치에서 미발견 | PC 전체 미설치를 단정하지 않음 |
| Telegram 자동 시작 | 기존 구성 스크립트에 서비스 설치 및 로그인 시 시작 옵션 존재 | 이번 작업에서 재부팅·실제 메시지 전송 테스트는 미실행 |

환경 조회 시 인증 토큰과 비밀번호 값은 문서에 옮기지 않았습니다. 모델 연결·설치 환경은 문서 작성 중 변경하지 않았습니다.

## 원본 대비 변경

- 1일차·2일차를 준비 → 설치 → 모델 연결 → Telegram → 업무 실습 → 운영 흐름으로 통합.
- 과거 GPT-5.5 설명을 현재 로컬 기본 모델과 구분.
- agy를 통한 Gemini·Claude 호출을 직접 API 연결과 구분해 추가.
- Claude Code 설치와 로그인 상태를 구별하고 Max/API/extra usage 비용 차이 추가.
- Telegram 가입·BotFather 흐름 유지, 자격 증명·개인 ID를 예시 값으로 대체.
- 과거 지원사업 리스트를 현재 공고처럼 제시하지 않고 실행일 기준 재검색 실습으로 변경.
- GitHub Pages 설정 경로 수정.
- python-docx와 DOCX/PDF 렌더링 도구를 분리해 안내.
- “항상 재시작”, “PC가 꺼져도 응답”, “특정 모델은 계속 무료” 같은 일반화를 제거.
- 설치·연결·예약·발송·배포의 실제 완료 기준 추가.

원본의 화면 캡처에는 개인정보·자격 증명이 포함될 수 있어 이 공개 저장소에는 복제하지 않았습니다. 노션 V2의 원본 링크로 교육 작성자가 참고할 수 있습니다.
