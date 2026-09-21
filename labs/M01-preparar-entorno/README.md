# M01 — Preparar el entorno

[← Página anterior](../../README.md) · [Siguiente página →](M01-02-gestionar-permisos.md)

En este módulo levantas tu propio servidor **IBM DOORS Next**, entras a la
herramienta y preparas **tu proyecto de trabajo**. A partir de aquí trabajarás
siempre contra este entorno.

Elige **una** de las dos opciones de arranque. En ambas accederás por
`https://localhost:9443/rm`.

## Qué aprenderás

- Arrancar DOORS Next + Mailpit con Docker Compose.
- Acceder a la interfaz web e iniciar sesión.
- Crear tu propia área de proyecto y dejarla lista para trabajar.
- Concederte permiso de **autoría** para poder crear módulos y artefactos.

---

## Opción A — Docker en tu equipo

Necesitas **Docker** (Docker Desktop en Windows/macOS, Docker Engine en Linux),
~6-8 GB de RAM libres y el **usuario + token de Docker Hub** que se te facilita.

1. Clona el repositorio y entra:
   ```bash
   git clone https://github.com/my-it-labs/doors-next-101.git
   cd doors-next-101
   ```
2. Inicia sesión en Docker Hub (la contraseña es el **token** que se te facilita):
   ```bash
   docker login -u <USUARIO_DOCKERHUB>
   ```
3. Arranca:
   ```bash
   docker compose -f infra/docker-compose.yml up -d
   ```
4. Espera ~3-4 min (sigue el log hasta `Application rm started`):
   ```bash
   docker compose -f infra/docker-compose.yml logs -f doors
   ```
5. Abre `https://localhost:9443/rm`. **No necesitas reenvío de puerto.**

---

## Opción B — GitHub Codespaces

Necesitas los secretos `DOCKERHUB_USER` y `DOCKERHUB_TOKEN` ya configurados en
**Settings → Codespaces → Secrets**, y reenviar el puerto a tu equipo con
**VS Code de escritorio** o **`gh`**.

1. Haz **fork** de este repositorio.
2. **Code → Codespaces → Create codespace** (acepta la máquina por defecto; si
   DOORS va lento, sube a **4 núcleos / 16 GB** en la configuración del codespace).
3. En la terminal del Codespace:
   ```bash
   bash infra/up.sh
   ```
4. Espera ~3-4 min:
   ```bash
   docker compose -f infra/docker-compose.yml logs -f doors
   ```
5. **Reenvía el puerto 9443 a tu equipo** y abre `https://localhost:9443/rm`.
   El cómo, según tu sistema operativo, está detallado en
   [infra/README.md](../../infra/README.md#reenvío-de-puerto-opción-b--según-tu-sistema).
   En resumen:
   - **VS Code de escritorio**: *Open in VS Code Desktop* → reenvía el 9443 solo.
   - **GitHub CLI**: `gh codespace ports forward 9443:9443 8025:8025` (deja la
     terminal abierta).

   > **No** abras la URL `*.app.github.dev`: por ahí el inicio de sesión no funciona.

   > [!TIP]
   > Si al crear el codespace ves *«no machine types are available»*, sincroniza tu fork
   > con `main` del repositorio del curso (versión antigua exigía 4 núcleos / 16 GB fijos).
   > Tras actualizar, el desplegable de máquina debería ofrecer al menos la opción por defecto.

   > [!WARNING]
   > Si ves **`503 CRJAZ1972E`** / **`IMailerService`**, no entres hasta que el log muestre
   > `Application rm started`. Si persiste, recrea el stack (`docker compose ... down` +
   > `up -d`) o reinicia DOORS. Detalle en
   > [infra/README.md — Comprobaciones](../../infra/README.md#comprobaciones-y-problemas).

---

## Iniciar sesión

En `https://localhost:9443/rm`, acepta el aviso de **certificado autofirmado** e
inicia sesión con **`formador` / `formador`**.

> [!IMPORTANT]
> **Esta es la cuenta que tiene licencia.** `alumno` / `alumno` autentica, pero DOORS
> responde `CRRRW7281E` (*hace falta una licencia*) y no puedes continuar.
>
> El aviso de certificado **no significa que falte configuración**: DOORS en laboratorio
> siempre usa HTTPS autofirmado. Si Chrome/Edge no te deja continuar, o el aviso
> aparece en bucle, sigue la guía
> [Certificado autofirmado](../../infra/certificado-autofirmado.md) (aceptar excepción
> o instalar `infra/certs/doors-localhost.crt` una vez).
>
> Si el login **no avanza** tras aceptar el certificado, casi seguro estás entrando
> por `*.app.github.dev` en lugar de `localhost` — revisa el reenvío del puerto 9443.

![Pantalla de inicio de sesión de IBM Engineering Lifecycle Management](../img/login.png)

Al entrar verás la página **Todos los proyectos**. En la cabecera aparece
**Formador DOORS**. Algunas capturas del material muestran *Alumno*: es el mismo
flujo, solo cambió el usuario de la imagen.

![Página de todos los proyectos](../img/dashboard-proyectos.png)

> [!WARNING]
> La imagen trae un proyecto residual **`Validacion 201`**. **No lo uses** para los
> labs: es de otra edición y no tiene el modelo con el que está escrito este curso.
> Tú creas el tuyo en el siguiente apartado.

---

## Tu proyecto de trabajo

Durante el curso trabajarás en **tu propio proyecto**, del que serás administrador
y autor. Hay **dos “plantillas” distintas** y se eligen en momentos distintos.
Mezclarlas es el error que más tiempo come en clase.

| Cuándo | Cómo se llama | Cuál eliges | Qué aporta |
|--------|---------------|-------------|------------|
| Al **crear el área** | Plantilla de **proceso** | `Plantilla de la aplicación Gestión de requisitos` (la que viene marcada) | Roles (Administrador, Autor, Comentarista…) y la matriz de permisos. **No** crea tipos de requisito. |
| Al **abrir el proyecto por primera vez** | Plantilla de **proyecto** | **`Systems Requirement Sample`** | Tipos de artefacto, atributos, carpetas y módulos de ejemplo. **Sin esto no puedes crear un requisito.** |

### 1. Crear el área de proyecto

1. Abre la administración de requisitos en `https://localhost:9443/rm/admin`.
2. Menú **Áreas de proyecto → Área de proyecto** (crear).
3. Nombre: `Tienda Web - <tu nombre>` (así no lo confundes con `Validacion 201`).
4. En **Proceso**, deja marcada *Utilizar plantilla de proceso…* y la única opción
   **Plantilla de la aplicación Gestión de requisitos** (entorno local: español).
5. Pulsa **Guardar**.

![Formulario de creación de área de proyecto](../img/crear-area-form.png)

Al guardar, tu usuario queda como **Administrador** del área (en la captura aparece
*alumno*; en tu sesión verás *Formador DOORS*).

![Área de proyecto creada; tu usuario queda como administrador](../img/crear-area-creada.png)

Todavía **no hay tipos de artefacto**. El área está vacía a propósito: el proceso
solo ha dejado roles y permisos.

### 2. Aplicar la plantilla de proyecto: `Systems Requirement Sample`

Vuelve a `https://localhost:9443/rm`, abre **tu** proyecto (`Tienda Web - …`, no
`Validacion 201`). Aparece el aviso *Este proyecto no tiene tipos de artefacto*.
Elige **Aplicar una plantilla de proyecto**.

1. Marca la casilla **Utilizar una plantilla para llenar el proyecto inicialmente**.
2. En la lista, pulsa **exactamente** **`Systems Requirement Sample`**
   (*A sample component containing requirements for the Automated Meter Reader*).
3. **Finalizar** se habilita al seleccionarla. Confirma y espera: crea tipos,
   atributos, carpetas y un conjunto de módulos de ejemplo.

![Selección de plantilla: marca Systems Requirement Sample (verde), no MEC (rojo)](../img/aplicar-plantilla.png)

#### Cómo está concebida

IBM la diseñó como **muestra de ingeniería de sistemas**: un contador de agua
inteligente (*Automated Meter Reader*). No es el producto de la “tienda web”;
es un **modelo ya montado** para aprender. Por eso el curso de tienda web
**reutiliza su metamodelo** (tipos y atributos) y, en M04, tú escribes el
contenido de la tienda en un módulo nuevo.

*Sample* frente a *Template*:

- **Sample** = tipos + atributos + **contenido de ejemplo** (módulos que puedes
  abrir en M02 y M03 sin crear nada).
- **Template** = solo esqueleto. En esta imagen, *Systems Requirement Template*
  deja crear módulos pero **sin Status/Priority**, y M04-02 se queda a medias.

#### Qué trae (y en qué lab lo usas)

| Lo que trae | Para qué |
|-------------|----------|
| Tipos **Module**, **Heading**, **System Requirement** | Crear el SRS de la tienda (M04-01) |
| Atributos **Status**, **Priority**, **Risk** | Estados y columnas (M04-02) |
| Carpetas de ejemplo (`0. README`, *Business Goals*, *Glossary*, *Non Functional Requirements*…) | Orientarte en M02 |
| Módulos de ejemplo (p. ej. *AMR System Requirements Specification*) | Navegar y aplicar vistas en M03; red de seguridad de M04-02 |
| Tipos de enlace (*Deriva de*, etc.) | Trazabilidad (M05) |

#### Qué no elijas (aunque estén en la misma lista)

| Si marcas… | Qué pasa |
|------------|----------|
| **MEC** / **MPC** o cualquier *SAFe … Component* | El proyecto **no es de requisitos**: no aparece el tipo Módulo. |
| **Systems Requirement Template** (sin *Sample*) | Hay módulo, pero **sin Status/Priority**. M04-02 no se puede hacer. |
| **Medical Devices Template** | Es la del curso 201: otros nombres de tipo. Los labs de este 101 no coinciden. |
| **JKE Banking Sample** / *Agile* / *Use Case*… | Otro modelo. Carpetas y atributos distintos a las capturas. |

Tras aplicarla, el panel del proyecto muestra cambios recientes y el contenido
de ejemplo. Las capturas pueden decir *Tienda Web (demo)*: busca **tu** nombre.

![Panel del proyecto tras aplicar la plantilla](../img/plantilla-aplicada.png)

### 3. Date permiso de autoría

Aunque eres administrador del área, un proyecto recién creado **todavía no te deja crear
artefactos**: hay que concederte el permiso **una vez**. Lo haces, paso a paso, en el
siguiente lab.

→ **[M01-02 · Gestionar permisos](M01-02-gestionar-permisos.md)**

---

## Comprueba

- Ves la página de proyectos de DOORS Next con el usuario **Formador DOORS**.
- Tu proyecto (no `Validacion 201`) aparece en **Todos los proyectos** y puedes abrir sus artefactos.
- Mailpit responde en `http://localhost:8025` (en Codespaces, con el 8025 también
  reenviado).

## Reto

Localiza en la administración (`https://localhost:9443/jts/admin`) la fecha de
caducidad de la licencia de evaluación del servidor.

<details>
<summary>Solución</summary>

En `/jts/admin`, menú **Usuarios → Gestión de licencias de acceso de cliente →
Gestión de claves de licencia**. La columna **Caduca el** muestra la fecha de cada
licencia de prueba activada.
</details>
