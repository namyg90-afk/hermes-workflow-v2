# 1. Hermes 설치와 문서 작업 환경

검토일: 2026-09-12. Windows PowerShell을 기본으로 설명하고 Ubuntu는 별도 경로로 제공합니다.

## 에이전트에게 요청하기

Codex 또는 Antigravity에 다음을 입력합니다.

> 이 저장소의 설치 안내를 읽고 내 운영체제와 기존 Hermes 설치 여부를 먼저 확인해줘. 새 설치가 필요하면 NousResearch의 공식 설치 스크립트를 확인하고 설치해줘. 설치된 환경이 있으면 재설치하지 말고 버전, 모델 연결, 작업 폴더, Telegram gateway 상태를 확인해줘. 로그인 화면에서는 내가 직접 로그인할 수 있도록 안내해줘. 설치 결과와 남은 설정을 구분해 알려줘.

## Windows 새 설치

1. PowerShell 또는 Windows Terminal을 엽니다.
2. [Hermes 공식 Windows 안내](https://hermes-agent.nousresearch.com/docs/user-guide/windows-native/)와 스크립트 출처를 확인합니다.
3. 새 PC에서 아래 공식 설치 명령을 실행합니다.

```powershell
iex (irm https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.ps1)
```

4. 완료되면 터미널을 새로 열고 확인합니다.

```powershell
hermes --version
hermes model
hermes
```

설치 마법사가 이미 모델 설정을 마쳤다면 중복 설정할 필요는 없습니다. `hermes`에서 짧은 질문에 답을 받으면 기본 대화 연결을 확인할 수 있습니다.

Windows 기본 데이터 폴더는 `%LOCALAPPDATA%\hermes`, 코드 폴더는 그 아래 `hermes-agent`입니다. `HERMES_HOME` 또는 설치 옵션을 사용했다면 경로가 다를 수 있습니다. Linux의 `~/.hermes`를 Windows에 그대로 대입하지 않습니다.

## Ubuntu 24.04 새 설치

기존 자료의 Ubuntu 설치 순서를 유지하되 설정 중 강제 종료는 필수 단계에서 제외했습니다.

```bash
sudo apt update
sudo apt install -y build-essential git curl wget ca-certificates software-properties-common
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
source ~/.bashrc
hermes --version
hermes model
hermes
```

`source ~/.bashrc`는 Bash 기준입니다. 다른 셸에서는 설치 프로그램이 안내하는 셸 설정 파일을 다시 읽거나 터미널을 새로 엽니다. 마법사를 실수로 종료했어도 설치가 완료되었다면 `hermes model`로 연결을 이어갈 수 있습니다.

원격 접속을 사용할 때만 OpenSSH와 방화벽을 추가합니다. SSH 접속 중 방화벽을 켜기 전에는 실제 SSH 포트가 허용되어 있는지 확인합니다. NAS 연결은 교육 필수가 아니며 각 기관의 접속정보로 별도 구성합니다.

공식 설치 기준: [Hermes Installation](https://hermes-agent.nousresearch.com/docs/getting-started/installation/).

## 작업 폴더 준비

에이전트에게 프로젝트별 폴더를 만들도록 요청합니다.

```text
업무자동화실습/
  input/       원본 자료
  working/     중간 작업
  output/      검토한 결과물
  logs/        실행 내역과 근거
  TASK.md      목적·입력·출력·완료 기준
```

> 이 폴더를 이번 업무의 작업 공간으로 사용해줘. 원본은 유지하고 결과는 output에 저장해줘. 작업 결과에는 입력 파일, 사용한 출처, 생성한 파일, 미확인 사항을 함께 기록해줘.

## python-docx: 설치 대상 Python을 먼저 확인

`python-docx`는 DOCX를 생성·편집하는 라이브러리입니다. 설치할 때 패키지명은 `python-docx`, Python에서 불러올 때는 `docx`입니다.

프로젝트별 격리 환경:

```powershell
uv venv .venv
uv pip install --python .venv/Scripts/python.exe python-docx
& .\.venv\Scripts\python.exe -c "import docx; print(docx.__version__)"
```

현재 기본 `python`에 설치할 때:

```powershell
$targetPython = (Get-Command python -ErrorAction Stop).Source
uv pip install --python $targetPython python-docx
& $targetPython -c "import sys, docx; print(sys.executable); print(docx.__version__)"
```

이번 작성 환경에서는 기본 `python`이 Hermes의 venv를 가리켰습니다. 다른 PC에서도 같은지는 반드시 확인합니다. Hermes 업데이트 후 추가 패키지가 유지되는지도 다시 점검합니다.

## DOCX 생성과 PDF 렌더링은 다른 기능

- DOCX 생성·편집: `python-docx`
- DOCX를 PDF로 변환: LibreOffice 또는 사용 가능한 Word 기반 변환기
- PDF를 이미지로 렌더링: Poppler의 `pdftoppm`

```powershell
Get-Command python,uv,soffice,pdftoppm -ErrorAction SilentlyContinue
```

LibreOffice가 없다면 [공식 다운로드](https://www.libreoffice.org/download/download-libreoffice/)에서 설치한 후 경로를 다시 확인합니다. Poppler는 PDF 입력을 처리하므로 `python-docx`와 Poppler만으로 DOCX의 실제 페이지 배치를 확인할 수는 없습니다.

> DOCX를 작성한 뒤 PDF로 변환하고 페이지 이미지를 확인해줘. 표 잘림, 그림 크기, 한글 글꼴, 머리말·꼬리말, 페이지 나눔을 검사해줘. 렌더러가 없으면 DOCX 생성 완료와 시각 검증 미완료를 구별해 보고해줘.

## 업데이트

업무가 끝난 시점에 설정과 추가한 스킬을 안전한 로컬 위치에 백업한 후 `hermes update`를 실행합니다. 업데이트 뒤 모델 연결, gateway, 예약 작업을 확인합니다. 교육 자료 작성 때문에 운영 중인 Hermes를 즉시 업데이트할 필요는 없습니다.
