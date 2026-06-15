# Linux Mint: Flutter + .NET MAUI com Genymotion e Containers

Guia para rodar tudo direto no Linux Mint, sem Android Studio Emulator.

## Objetivo

- Usar **Genymotion Desktop** como dispositivo Android
- Conectar com **ADB TCP/IP**
- Desenvolver com **Docker**
- Rodar apps Flutter e .NET MAUI fora do emulador local

## 1. Pré-requisitos

Instale:

- Docker
- Docker Compose
- ADB (`adb`)
- Git
- Genymotion Desktop
- VirtualBox, se o Genymotion exigir no seu setup

Exemplo:

```bash
sudo apt update
sudo apt install -y docker.io docker-compose-plugin adb git curl unzip
sudo usermod -aG docker $USER
```

Depois faça logout/login.

## 2. Verificar virtualização

```bash
ls -l /dev/kvm
```

Se existir, melhor. Se não existir, o Genymotion pode funcionar, mas com menos desempenho.

## 3. Iniciar o Genymotion

1. Abra o **Genymotion Desktop**
2. Inicie um device Android
3. Em **ADB**, habilite **ADB over TCP/IP**
4. Use a porta `5555`

## 4. Conectar ADB

No host Linux:

```bash
adb connect 127.0.0.1:5555
adb devices
```

Se o device estiver em outra máquina:

```bash
adb connect IP_DO_DEVICE:5555
adb devices
```

Scripts prontos:

```bash
./scripts/connect-adb.sh 127.0.0.1:5555
```

## 5. Subir os containers

Entre na pasta `genymotion`:

```bash
cd genymotion
docker compose build
docker compose up -d
```

Verificar:

```bash
docker ps
```

## 6. Flutter dentro do container

```bash
docker exec -it flutter-dev bash
flutter doctor
flutter devices
flutter run
```

## 7. .NET MAUI dentro do container

```bash
docker exec -it maui-dev bash
adb devices
dotnet build -t:Run -f net8.0-android
```

## 8. Estrutura esperada

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

## 9. Problemas comuns

- **`adb devices` vazio**: o Genymotion não está com ADB TCP/IP ativo ou a porta está errada.
- **Docker não inicia**: confirme que o serviço Docker está ativo.
- **Build lento**: verifique `/dev/kvm`.
- **Flutter não encontra device**: rode `adb connect` de novo e confirme com `adb devices`.

## 10. Fluxo diário

1. Abrir Genymotion Desktop
2. Iniciar o device
3. Rodar `adb connect`
4. Subir containers
5. Abrir VS Code ou Visual Studio
6. Rodar `flutter run` ou `dotnet build -t:Run -f net8.0-android`
