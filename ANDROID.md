# Setup Android no Fedora/Linux

## Pré-requisitos

- .NET 10 SDK
- workload MAUI/Android (`dotnet workload install maui` ou `dotnet workload install android`)
- Android SDK + Platform Tools
- Java/OpenJDK

## Fedora

```bash
sudo dnf install -y java-17-openjdk-devel android-tools
./android/scripts/enable-android-virt-fedora.sh
```

## Variáveis de ambiente recomendadas

```bash
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator"
```

## Referências rápidas

- Build/deploy: [`ANDROID_BUILD.md`](ANDROID_BUILD.md)
- Waydroid: [`WAYDROID_INSTALL.md`](WAYDROID_INSTALL.md)
- Redroid: [`REDROID_MAUI_DEBUG.md`](REDROID_MAUI_DEBUG.md)
