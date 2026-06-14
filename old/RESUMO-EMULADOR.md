# Emulador Android otimizado

- **AVD criado:** `Pixel_3a_API_28_Lite`
- **Perfil:** Pixel 3a
- **Imagem do sistema:** `system-images;android-28;google_apis;x86_64`
- **Aceleracao:** WHPX ativo no Windows
- **Ajustes aplicados:** 2 vCPUs, 1024 MB de RAM, GPU `swiftshader_indirect`, sem moldura do aparelho, sem audio de entrada/saida, sem cameras, sem animacao de boot e sem snapshot

## Arquivos uteis

- `E:\android\start-emulator.ps1` inicia o emulador com os parametros otimizados
- `E:\android\create-optimized-emulator.ps1` recria o AVD com a mesma configuracao

## Como iniciar

```powershell
powershell -ExecutionPolicy Bypass -File E:\android\start-emulator.ps1
```


