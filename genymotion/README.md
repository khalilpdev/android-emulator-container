# Flutter + .NET MAUI com Genymotion e Containers

Abordagem recomendada para evitar o Android Studio Emulator local:

- **Genymotion Desktop** para o device Android
- **ADB TCP/IP** para conectar apps e containers
- **Docker** para ambientes Flutter e .NET MAUI
- **VS Code / Visual Studio** para desenvolvimento

> No Windows, prefira rodar esse workspace via WSL2 + Docker Desktop; o build local pode depender do estado do Docker Desktop.
> Para Linux Mint, veja `linux-mint.md`.

## Fluxo

1. Inicie o Genymotion Desktop.
2. Abra um device Android.
3. Ative **ADB over TCP/IP** na porta `5555`.
4. Rode o script de conexão ADB.
5. Suba os containers de desenvolvimento.

## Scripts

- `connect-adb.ps1`
- `connect-adb.sh`

## Exemplo de conexão

```powershell
adb connect 192.168.1.10:5555
adb devices
```

## Docker Compose

Use `genymotion/docker-compose.yml` com dois serviços:

- `flutter`
- `maui`

Cada serviço pode montar o workspace atual em `/workspace`.

## Estrutura

```text
genymotion/
├── docker-compose.yml
├── flutter/
│   └── Dockerfile
├── maui/
│   └── Dockerfile
└── scripts/
    ├── connect-adb.ps1
    └── connect-adb.sh
```

## Dockerfile Flutter

Base sugerida:

- `ubuntu:24.04`
- `openjdk-21-jdk`
- `adb`
- `flutter` instalado em `/opt/flutter`

## Dockerfile .NET MAUI

Base sugerida:

- `mcr.microsoft.com/dotnet/sdk:8.0`
- Android SDK commandline-tools
- Java 21
- workloads Android instalados

## Observações

- Se o device do Genymotion estiver em outra máquina, use o IP real dela no `adb connect`.
- Se estiver no mesmo host, normalmente `127.0.0.1:5555` funciona quando a porta está exposta.
- O objetivo aqui é usar o Android fora do emulator local do Windows, que já mostrou crash no driver Intel.
