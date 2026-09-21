# Certificado autofirmado de DOORS Next

[← Infraestructura](README.md)

DOORS Next en este curso usa **HTTPS con certificado autofirmado** (`CN=localhost`).
Es **normal** y **esperado**: la imagen de laboratorio no puede usar un certificado
público (Let's Encrypt, etc.) porque la URI del servidor está fijada a
`https://localhost:9443` y el login depende de esa dirección exacta.

**No falta configurar nada extra** en Docker ni en Codespaces. Lo que suele fallar
es **cómo** entra el alumno al navegador, no el servidor en sí.

---

## Antes de tocar el certificado, comprueba esto

Muchos avisos de “certificado” en realidad son **URL o reenvío incorrectos**:

| Síntoma | Causa probable | Qué hacer |
|---------|----------------|-----------|
| Pantalla roja de certificado al abrir un enlace `*.app.github.dev` | Entrar por el proxy web de Codespaces | Usar **VS Code de escritorio** o `gh codespace ports forward` y abrir **`https://localhost:9443/rm`** |
| Certificado OK pero login no avanza / bucle | Misma causa: URI distinta de `localhost:9443` | Reenvío de puerto activo + URL `https://localhost:9443/rm` |
| “No es seguro” al abrir `localhost` | Certificado autofirmado (este documento) | Aceptar excepción **o** instalar el certificado (abajo) |
| Otro nombre en el aviso (empresa, antivirus) | Proxy corporativo o inspección HTTPS | IT debe permitir `localhost:9443` o instalar **nuestro** certificado en el almacén del SO |

> **Obligatorio en Codespaces:** el puerto **9443 reenviado a tu `localhost`** antes de abrir el navegador. Si no hay túnel, `localhost:9443` no responde o responde otra cosa.

---

## Opción 1 — Aceptar la excepción en el navegador (rápido)

Abre exactamente: **`https://localhost:9443/rm`**

### Chrome / Edge (Windows, macOS, Linux)

1. Verás *“La conexión no es privada”* / *“Your connection is not private”*.
2. Pulsa **Avanzado** / **Advanced**.
3. Pulsa **Acceder a localhost (sitio no seguro)** / **Proceed to localhost (unsafe)**.
4. Solo hace falta **una vez por perfil de navegador** (a veces tras limpiar datos hay que repetir).

Si **no aparece** el botón de continuar, la política de la empresa lo bloquea → usa la **Opción 2**.

### Firefox

1. *“Advertencia: riesgo potencial de seguridad a continuación”*.
2. **Avanzado** → **Aceptar el riesgo y continuar**.

---

## Opción 2 — Confiar en el certificado una vez (recomendado en aulas corporativas)

En el repositorio está el certificado **público** (sin clave privada):

`infra/certs/doors-localhost.crt`

Descárgalo o cópialo desde tu clone/fork. Después de instalarlo, **cierra y vuelve a abrir el navegador**.

### Windows (PowerShell, usuario actual, sin admin)

Desde la carpeta del repositorio clonado:

```powershell
certutil -user -addstore Root infra\certs\doors-localhost.crt
```

### macOS

```bash
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain infra/certs/doors-localhost.crt
```

### Linux (Chrome/Edge usan certificados del sistema en muchas distros)

```bash
sudo cp infra/certs/doors-localhost.crt /usr/local/share/ca-certificates/doors-localhost.crt
sudo update-ca-certificates
```

> Firefox mantiene su propio almacén: *Ajustes → Privacidad → Certificados → Ver certificados → Importar* → marcar como confiable para sitios web.

---

## ¿Se puede quitar el autofirmado?

**No de forma práctica** en este curso:

- IBM ELM graba la **URI pública** en la instalación; cambiarla a otro dominio requiere una **clave de soporte IBM** (no disponible en evaluación).
- Un certificado “de verdad” para `localhost` solo ayuda si sigues entrando por `https://localhost:9443` — habría que **regenerar la imagen Docker** con otro keystore; no arregla el problema de entrar por `*.github.dev`.

Por eso la vía oficial sigue siendo: **túnel a `localhost` + aceptar o instalar este certificado**.

---

## Para el formador: actualizar el `.crt` tras nueva imagen

Si publicas una imagen nueva con otro keystore:

```bash
bash infra/export-cert.sh
git add infra/certs/doors-localhost.crt
```
