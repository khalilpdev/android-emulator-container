# Instalação e Configuração: KasmWeb Redroid no Manjaro 24.1 (X11 + Nvidia 390xx)

Este guia prático ensina a preparar o **Manjaro 24.1** com servidor gráfico **X11** para rodar o container Android Virtualizado (`kasmweb/redroid:develop`) de forma estável, garantindo compatibilidade com kernels até a linha 6.10 e drivers de vídeo legados Nvidia.

---

## 🛠️ Passo 1: Preparando o Manjaro (Pós-Instalação)

Logo após instalar o Manjaro 24.1, precisamos instalar os cabeçalhos do Kernel (`headers`) e os visualizadores de tela.

1. Abra o terminal e instale os pacotes necessários:
   ```bash
   sudo pacman -Syu --noconfirm
   sudo pacman -S git docker scrcpy tigervnc --noconfirm
   ```

2. Instale os **Headers do Kernel** atuais do seu sistema para permitir o carregamento de módulos externos:
   ```bash
   sudo pacman -S \$(mhwd-kernel -li | grep -o 'linux[0-9]*' | head -n 1)-headers
   ```

3. Habilite e inicie o serviço do Docker:
   ```bash
   sudo systemctl enable --now docker
   sudo usermod -aG docker \$USER
   ```
   *Nota: Após o comando acima, feche o terminal e abra-o novamente para aplicar a permissão do Docker ao seu usuário.*

---

## 🧠 Passo 2: Configurando Módulos do Kernel do Android (Persistente)

O Redroid necessita dos drivers de comunicação do ecossistema Android (`binder_linux`). Para não precisar digitar os comandos a cada reinicialização, vamos deixá-los automáticos no boot do Manjaro.

1. Configure o Manjaro para carregar o módulo no boot:
   ```bash
   echo "binder_linux" | sudo tee /etc/modules-load.d/redroid.conf
   ```

2. Defina os parâmetros de comunicação exigidos pelo Android:
   ```bash
   echo 'options binder_linux devices="binder,hwbinder,vndbinder"' | sudo tee /etc/modprobe.d/redroid.conf
   ```

3. Carregue os módulos imediatamente para uso imediato (sem precisar reiniciar agora):
   ```bash
   sudo modprobe binder_linux devices="binder,hwbinder,vndbinder"
   ```

---

## 🚀 Passo 3: Inicialização do Container Redroid

Como você está utilizando o driver Nvidia legado `390xx`, rodaremos o container isolando os recursos gráficos modernos e deixando o Kasm processar a tela de forma híbrida (via Software/Mesa interna), o que evita congelamentos e incompatibilidades.

Execute o comando de inicialização com as flags de privilégio e mapeamento do `/dev`:

```bash
docker run -d --name redroid \
  --privileged \
  --security-opt seccomp=unconfined \
  --security-opt apparmor=unconfined \
  -v /dev:/dev \
  -v /lib/modules:/lib/modules:ro \
  -p 5555:5555 \
  -p 5901:5901 \
  -p 6901:6901 \
  kasmweb/redroid:develop
```

> ⏳ **Atenção:** Aguarde **20 segundos** para que o ecossistema interno do Android termine de subir antes de tentar conectar.

---

## 📺 Passo 4: Como Acessar a Tela do Android no X11

O servidor gráfico X11 do Manjaro trabalha perfeitamente com renderização nativa de janelas. Você tem três formas de visualizar o Android:

### Método 1: Espelhamento Nativo via Scrcpy (Recomendado)
Oferece a melhor taxa de quadros e menor latência. O `scrcpy` usará a sua placa Nvidia para desenhar a janela na área de trabalho.

1. Crie a ponte de conexão do ADB:
   ```bash
   adb connect localhost:5555
   ```
   *Deve retornar obrigatoriamente: `connected to localhost:5555`*

2. Abra a tela do Android:
   ```bash
   scrcpy
   ```

### Método 2: Interface Web do Kasm (Navegador)
Útil se você quiser usar o painel completo do Kasm.
* **Endereço:** [http://localhost:6901](http://localhost:6901)
* **Usuário:** `kasm_user`
* **Senha:** `vncpassword`

### Método 3: Visualizador VNC Clássico
* **Comando:** `vncviewer localhost:1`
* **Senha:** `vncpassword`

---

## 🔍 Resolução de Problemas (Troubleshooting)

* **Erro `Device could not be connected (state=offline)`:** 
  Significa que o Android travou internamente por falta do módulo do kernel. Certifique-se de que instalou os `headers` corretos descritos no **Passo 1** e repita o comando do **Passo 2**.
* **Erros de vídeo com o driver 390xx:**
  O X11 gerencia janelas de forma estável. Se o `scrcpy` apresentar falhas de renderização na sua GPU, force-o a rodar via software no terminal do Manjaro com:
  ```bash
  LIBGL_ALWAYS_SOFTWARE=1 scrcpy
  ```

