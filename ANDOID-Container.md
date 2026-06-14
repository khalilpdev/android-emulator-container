# ANDOID-Container

Este documento descreve opções e comandos para executar Android em container (via WSL2/Docker no Windows) e diretamente em Linux.

> Aviso: algumas operações exigem virtualização (BIOS), privilégios de administrador e /dev/kvm disponível.

## 1) Pré-requisitos (WSL2 + Docker Desktop)

- Windows 10/11 com WSL2 habilitado e uma distro WSL2 (ex.: FedoraLinux-43).
- Docker Desktop instalado e com backend WSL2 ativado.
- Virtualização por hardware ligada na BIOS (VT-x/AMD-V).
- Verificar /dev/kvm na distro WSL2:  
  wsl -d <sua-distro> -- ls -la /dev/kvm

Se /dev/kvm não existir: habilite "Virtual Machine Platform"/"Hyper-V" no Windows e reinicie; verifique configurações do Docker Desktop (expor/permitir integração com a distro).

## 2) Preparar WSL2 (recomendações)

1. Abra a distro (ex.: FedoraLinux-43) e instale dependências:
   - instale docker no lado da distro se for usar Docker Engine local, ou use o Docker Desktop (recomendado).
2. Confirme /dev/kvm:
   - dentro da distro: ls -l /dev/kvm
   - se presente, dê permissão ao usuário (ou execute containers com --device /dev/kvm).

## 3) Rodando um container Android (opções comuns)

- Observação: existem várias imagens públicas. Duas abordagens comuns:
  - redroid (imagem leve AOSP, porta adb 5555)
  - budtmo/docker-android (imagem com VNC/noVNC, interface web)

Exemplo genérico com KVM (WSL2/Linux):

```
# usando KVM (melhor performance)
docker run --rm -it --privileged --device /dev/kvm -p 5555:5555 ghcr.io/redroid/redroid:latest
```

Exemplo com interface web (budtmo/docker-android, muda a tag conforme sua API/AVD):

```
docker run --privileged -d \
  -p 6080:6080 -p 5555:5555 \
  -e DEVICE="Nexus 5" \
  budtmo/docker-android-x86-8.1
```

Acesse a interface VNC pelo navegador em http://localhost:6080 e conecte via adb: adb connect localhost:5555

> Nota: ajuste as tags/nomes de imagem para a versão que precisa (API level / x86/x86_64). Prefira imagens x86/x86_64 quando usar KVM para melhor velocidade.

## 4) Comandos úteis (WSL2)

- Listar distros e versão WSL:
  wsl -l -v

- Testar /dev/kvm na distro:
  wsl -d <distro> -- ls -la /dev/kvm

- Rodar container com /dev/kvm:
  docker run --device /dev/kvm --privileged ...

- Conectar adb (host):
  adb connect 127.0.0.1:5555

- Reiniciar adb:
  adb kill-server && adb start-server

## 5) Modo direto em Linux (não-WSL)

Requisitos: Docker, /dev/kvm, usuário no grupo kvm, kernel com suporte a KVM.

Exemplo:

```
# dê permissão ao usuário ao /dev/kvm (ex: ubuntu)
sudo usermod -aG kvm $USER
# depois reinicie sessão
# rodar container (exemplo budtmo)
docker run --privileged -d -p 6080:6080 -p 5555:5555 budtmo/docker-android-x86-8.1
```

## 6) Waydroid / Redroid / Wayland notes

- Waydroid: mais integrado (contêiner + kernel modules binder/ashmem). Requer kernel com suporte e não é trivial dentro de WSL2 sem preparo.
- Redroid: imagem containerizada AOSP, geralmente mais simples para testes com adb.

## 7) Troubleshooting rápido

- Se o container não inicia ou adb fica "offline":
  - Verificar logs do container: docker logs <container>
  - Verificar /dev/kvm e permissões
  - Verificar portas (5555/6080)
  - Se sem KVM, a execução será lenta — prefira imagens leve ou use emulador local com -gpu swiftshader_indirect

## 8) Recomendações de performance

- Use imagens x86/x86_64 com KVM.
- Habilite /dev/kvm e execute container com --device /dev/kvm.
- Em WSL2, prefira Docker Desktop com integração WSL2 habilitada.

---

Se quiser, gero exemplos específicos para a sua distro FedoraLinux-43 (com comandos para testar /dev/kvm, permissões e um docker-compose de exemplo).