# SENTINEL — App de iOS

App para consultar, crear y dar seguimiento a reportes de fraudes de multas de tránsito y fotocívicas. Hecha con SwiftUI. Consume la API de [BackendEquipo1](https://github.com/TC2007B-451-Agosto-Diciembre-2026/BackendEquipo1).

## Ramas

| Rama | Servidor |
| --- | --- |
| `main` | Backend local en `http://localhost:3000/` |
| `lab` | Servidor del laboratorio en `http://172.16.64.2/api/` |

La dirección está en `Sentinel/APIClient.swift`, en `baseURL`.

## Correr en local desde cero

Primero levanta la base de datos y el backend siguiendo el README de [BackendEquipo1](https://github.com/TC2007B-451-Agosto-Diciembre-2026/BackendEquipo1#correr-en-local-desde-cero). El backend debe estar corriendo en http://localhost:3000. El panel web ([FrontendEquipo1](https://github.com/TC2007B-451-Agosto-Diciembre-2026/FrontendEquipo1)) es opcional para la app, pero sirve para aprobar reportes.

### Requisitos

- Mac con Xcode 26 o superior (la app pide iOS 26.5)
- Git

### 1. Clonar y abrir

```bash
git clone https://github.com/sentinelTec/Sentinel.git
cd Sentinel
open Sentinel.xcodeproj
```

### 2. Correr en el simulador

1. En la barra de arriba de Xcode elige el esquema **Sentinel** y un simulador de iPhone.
2. Presiona ▶︎ (o `Cmd + R`).

El simulador usa la red de la Mac, así que `localhost:3000` llega directo al backend. Debe aparecer la lista de **Reportes recientes**.

### 3. Correr en un iPhone físico (opcional)

En el iPhone, `localhost` es el propio teléfono, así que hay que usar la IP de la Mac.

1. Conecta la Mac y el iPhone a la misma red Wi-Fi.
2. Al arrancar, el backend imprime `API en http://localhost:3000 y en http://<IP de la Mac>:3000`. Copia esa IP.
3. En `Sentinel/APIClient.swift` cambia `baseURL` a `URL(string: "http://<IP de la Mac>:3000/")!`. No subas ese cambio.
4. Conecta el iPhone por cable y acepta **Confiar en esta computadora**.
5. En el iPhone activa **Ajustes → Privacidad y seguridad → Modo de desarrollador** (se reinicia).
6. En Xcode, en el target **Sentinel → Signing & Capabilities**, elige tu cuenta en **Team**. Si el bundle id ya está ocupado, cámbialo por uno tuyo.
7. Elige tu iPhone como destino y presiona ▶︎.
8. La primera vez, en el iPhone ve a **Ajustes → General → VPN y administración de dispositivos**, toca tu cuenta y confía en ella.
9. Cuando la app pida permiso para **encontrar dispositivos en la red local**, toca **Permitir**. Si la Mac pregunta si `node` puede aceptar conexiones entrantes, también **Permitir**.

Para comprobar la conexión, abre `http://<IP de la Mac>:3000/public/reports` en Safari del iPhone; debe mostrar JSON.

### Cuentas de prueba

| Rol | Email | Contraseña |
| --- | --- | --- |
| usuario | mafer.lopez@sentinel.test | Sentinel#2026 |
| admin | laura.mendez@sentinel.test | Admin#2026 |

### Problemas comunes

| Síntoma | Solución |
| --- | --- |
| Se queda cargando los reportes | El backend no está corriendo, o en iPhone físico la IP de `baseURL` no es la de la Mac |
| `The resource could not be loaded because the App Transport Security policy...` | Corre con la configuración **Debug** (la de ▶︎); el permiso de HTTP local solo está ahí |
| Safari del iPhone no abre la IP de la Mac | No están en la misma red, o la red aísla a los dispositivos (pasa en redes de escuela o públicas); usa el hotspot del iPhone o el simulador |
| Los reportes salen sin fotos | Falta copiar `db/seed-evidence` a `uploads` en el backend |
| `Untrusted Developer` al abrir la app | Paso 8 |
