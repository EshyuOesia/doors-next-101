# Infraestructura — IBM DOORS Next 101

[← Volver al índice](../README.md)

El laboratorio levanta **IBM DOORS Next** (gestión de requisitos) y **Mailpit**
(servidor SMTP de pruebas) con Docker Compose, a partir de una imagen ya
preparada. Hay **dos formas de ejecutarlo**:

- **Opción A — Docker local**: en tu propio equipo.
- **Opción B — GitHub Codespaces + reenvío de puerto**: en la nube.

En ambas se accede a DOORS por `https://localhost:9443/rm`. Esto es **obligatorio**:
DOORS tiene grabada una URI pública fija (`localhost:9443`) que usa para el inicio
de sesión, así que solo funciona accediendo por `localhost` (en Codespaces, vía
reenvío del puerto; nunca por la URL `*.app.github.dev`).

## Qué se levanta

| Servicio | Imagen | Puertos |
|----------|--------|---------|
| `doors` | imagen publicada en Docker Hub (privada) | 9443 (HTTPS), 9080 (HTTP) |
| `mailpit` | `axllent/mailpit` | 8025 (web), 1025 (SMTP) |

## Credenciales y URLs

| Qué | URL | Credenciales |
|-----|-----|--------------|
| DOORS Next (Requisitos) | https://localhost:9443/rm | `formador` / `formador` |
| Administración (JTS) | https://localhost:9443/jts/admin | `formador` / `formador` |
| Mailpit (correo) | http://localhost:8025 | — |

> [!IMPORTANT]
> Usa **`formador` / `formador`**. La cuenta `alumno` existe en el servidor pero **no tiene
> licencia** de DOORS Next: entrarás y verás `CRRRW7281E` (*hace falta una licencia*).

El certificado es autofirmado: acepta el aviso del navegador la primera vez, o
instala el certificado del repo (útil en entornos corporativos). Guía completa:
[certificado-autofirmado.md](certificado-autofirmado.md).

El **primer arranque tarda ~3-4 minutos** (más la descarga de la imagen la primera
vez, varios GB). Está listo cuando en el log aparece `Application rm started`.

---

## Opción A — Docker local

**Requisitos:** Docker (Docker Desktop en Windows/macOS, Docker Engine en Linux),
~6-8 GB de RAM libres, y el token de Docker Hub que entrega el formador.

1. Clona el repositorio y entra en él:
   ```bash
   git clone https://github.com/my-it-labs/doors-next-101.git
   cd doors-next-101
   ```
2. Inicia sesión en Docker Hub (usuario y, como contraseña, el **token** del formador):
   ```bash
   docker login -u <USUARIO_DOCKERHUB>
   ```
3. Levanta el stack:
   ```bash
   docker compose -f infra/docker-compose.yml up -d
   ```
4. Espera ~3-4 min. Sigue el arranque:
   ```bash
   docker compose -f infra/docker-compose.yml logs -f doors
   ```
5. Abre `https://localhost:9443/rm` → acepta el certificado → `formador` / `formador`.

> No hace falta reenvío de puerto: ya estás en `localhost`.

**Parar:** `docker compose -f infra/docker-compose.yml down` (añade `-v` para borrar datos).

---

## Opción B — Codespaces + reenvío de puerto

**Requisitos:** los secretos `DOCKERHUB_USER` y `DOCKERHUB_TOKEN` configurados en
**GitHub → Settings → Codespaces → Secrets** con acceso a este repositorio
(los entrega el formador). Y un cliente para reenviar el puerto (VS Code de
escritorio **o** GitHub CLI — ver tabla por SO más abajo).

1. Haz **fork** del repositorio.
2. **Code → Codespaces → Create codespace** sobre tu fork (máquina por defecto;
   opcional **4 núcleos / 16 GB** si DOORS va lento).
3. En la terminal del Codespace:
   ```bash
   bash infra/up.sh
   ```
4. Espera ~3-4 min:
   ```bash
   docker compose -f infra/docker-compose.yml logs -f doors
   ```
5. **Reenvía el puerto 9443 a tu equipo** (ver siguiente sección) y abre
   `https://localhost:9443/rm` → `formador` / `formador`.

> **No** abras la URL `*.app.github.dev`: el login no funciona por ahí.

**Parar:** `bash infra/down.sh` (o cierra el Codespace; añade `--wipe` para borrar datos).

---

## Reenvío de puerto (Opción B) — según tu sistema

El **comando** de reenvío es idéntico en todos los SO; lo que cambia es **cómo
instalas** el cliente. Elige UNA de las dos vías.

> [!TIP]
> **La Vía 1 (VS Code de escritorio) es la más fiable.** La Vía 2 (`gh`) a veces falla con
> `create tunnel port failed ... 400: Bad Request` por un problema del túnel del propio CLI.
> Si te topas con eso, usa la Vía 1 y olvídate de `gh`.

### Vía 1 — VS Code de escritorio (recomendada, sin línea de comandos)

| SO | Instalar VS Code |
|----|------------------|
| Windows | *User Installer* (no requiere admin): https://code.visualstudio.com/download |
| macOS | Descarga el `.zip`, arrastra VS Code a *Aplicaciones* |
| Linux | Paquete `.deb`/`.rpm` o `sudo snap install code --classic` |

Después:
1. Instala la extensión **GitHub Codespaces** en VS Code.
2. Desde el Codespace en el navegador: menú **≡ → Open in VS Code Desktop**
   (o en VS Code: `Ctrl/Cmd+Shift+P` → *Codespaces: Connect to Codespace*).
3. VS Code reenvía el **9443 a tu `localhost`** automáticamente (pestaña **Ports**).
4. Abre `https://localhost:9443/rm`.

### Vía 2 — GitHub CLI (`gh`)

| SO | Instalar `gh` (y Git) |
|----|----------------|
| Windows | `winget install GitHub.cli` **y** `winget install Git.Git` (o los `.msi`) |
| macOS | `brew install gh` (Git ya viene con las *Command Line Tools*) |
| Linux (Debian/Ubuntu) | `sudo apt install gh git` (con el repo de GitHub CLI) |

> **Git es obligatorio.** Si ves `unable to find git executable in PATH`, instala Git
> y **cierra y vuelve a abrir** la terminal para que se actualice el PATH.

Después (mismo comando en todos los SO):
```bash
gh auth login -s codespace
gh codespace ports forward 9443:9443 8025:8025
```
Elige tu Codespace si lo pide (o añade `-c <nombre-del-codespace>`). **Deja la
terminal abierta** mientras trabajas. Abre `https://localhost:9443/rm`.
`Ctrl+C` corta el túnel.

> [!IMPORTANT]
> **Error `HTTP 403 ... needs the "codespace" scope`** — tu sesión de `gh` no tiene
> permiso para Codespaces (pasa si hiciste `gh auth login` sin el scope). Arréglalo
> **sin volver a loguearte** con:
> ```bash
> gh auth refresh -h github.com -s codespace
> ```
> Se abre el navegador, autorizas, y repites el `gh codespace ports forward`.

> [!WARNING]
> **Error `create tunnel port failed ... 400: Bad Request`** — fallo conocido del túnel de
> `gh`. En orden:
> 1. Actualiza `gh` (`winget upgrade GitHub.cli`) y **reabre la terminal**.
> 2. Reenvía **un solo puerto**: `gh codespace ports forward 9443:9443 -c <tu-codespace>`.
> 3. Comprueba si ya estaba reenviado: `gh codespace ports -c <tu-codespace>`.
> 4. Si sigue fallando, **cambia a la Vía 1 (VS Code de escritorio)** — es la solución segura.

---

## Comprobaciones y problemas

- **¿Arrancó DOORS?** `docker compose -f infra/docker-compose.yml logs doors | grep "Application rm started"`
- **`status: 0` o lentitud al navegar al principio**: el servidor está calentando;
  reintenta en un momento.
- **El login no avanza / redirige raro**: estás entrando por la URL `*.app.github.dev`
  en vez de por `localhost`. Usa el reenvío de puerto.
- **`CRRRW7281E` / “Para acceder a la aplicación hace falta una licencia”**: estás
  usando `alumno` (o `ADMIN`). Cierra sesión y entra con `formador` / `formador`.
- **Aviso de certificado / “conexión no privada”**: es normal (HTTPS autofirmado).
  Comprueba primero que usas `https://localhost:9443/rm` con el puerto reenviado.
  Si el navegador no deja continuar, instala `infra/certs/doors-localhost.crt` siguiendo
  [certificado-autofirmado.md](certificado-autofirmado.md).
- **`gh`: `HTTP 403 ... needs the "codespace" scope`** (al reenviar el puerto): añade el
  permiso con `gh auth refresh -h github.com -s codespace` y reintenta.
- **`gh`/`git`: `unable to find git executable in PATH`**: instala **Git** (en Windows
  `winget install Git.Git`) y reabre la terminal.
- **`gh`: `create tunnel port failed ... 400: Bad Request`**: fallo del túnel de `gh`.
  Actualiza `gh` (`winget upgrade GitHub.cli`), reenvía un puerto a la vez, o usa la
  **Vía 1 (VS Code de escritorio)**, que es la opción fiable.
- **`503` / `CRJAZ1972E` / `IMailerService`**: DOORS no encuentra el servidor SMTP de
  laboratorio (Mailpit). Suele pasar por una de estas causas:
  1. **Entraste antes de tiempo** — espera a `Application rm started` en el log y recarga.
  2. **Compose antiguo** — Mailpit en otro contenedor no era visible como `localhost:1025`
     desde DOORS. Actualiza el repo y recrea el stack:
     ```bash
     docker compose -f infra/docker-compose.yml down
     docker compose -f infra/docker-compose.yml up -d
     ```
  3. **Arranque en mal estado** — reinicia DOORS (Mailpit ya debe estar arriba):
     ```bash
     docker compose -f infra/docker-compose.yml restart doors
     ```
  4. **Volumen corrupto o setup a medias** — borra datos y vuelve a levantar:
     ```bash
     docker compose -f infra/docker-compose.yml down -v
     docker compose -f infra/docker-compose.yml up -d
     ```
  Comprueba que Mailpit responde: `http://localhost:8025` (en Codespaces, reenvía también el 8025).
  si ya habías levantado una versión anterior de la imagen, los datos quedaron en el
  volumen y no se actualizan solos. Bórralo y vuelve a arrancar para que se siembre de
  nuevo desde la imagen:
  ```bash
  docker compose -f infra/docker-compose.yml down -v
  docker compose -f infra/docker-compose.yml up -d
  ```
- La imagen lleva una **licencia de evaluación** de IBM (60 días). Es material de
  formación, no para uso productivo.
