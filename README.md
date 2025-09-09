**Video-to-MKV** es un script en **PowerShell** creado por *Daniel Amores*.  
Está diseñado para convertir archivos de vídeo a formato **MKV** con el códec **H.265/HEVC**, manteniendo la misma calidad visual pero optimizando la compresión con un estándar más moderno y eficiente.

---

## 🧾 RESUMEN GENERAL

El script:

- Solicita al usuario una **ruta de carpeta absoluta**.  
- Valida que la ruta exista y no sea una ubicación de sistema protegida.  
- Pide la **extensión de vídeo** a convertir (ej. avi, mp4, mov).  
- Verifica que la extensión esté en la lista de **formatos soportados**.  
- Recorre los archivos de esa extensión en la carpeta indicada.  

Para cada vídeo:  
- Muestra la **duración** con *ffprobe*.  
- Convierte el archivo a `.mkv` con *ffmpeg*, usando **H.265 (x265)** y **audio AAC**.  
- Si el archivo `.mkv` ya existe, lo omite y avisa al usuario.  
- Si no existe, lo genera y muestra el **progreso en tiempo real**.  

Al finalizar, vuelve a la carpeta base y muestra un mensaje de cierre.  

---

## 🟨 FUNCIONALIDADES CLAVE

- ✅ **Entrada validada** → controla rutas inválidas o protegidas (ej. `C:\Windows`, `C:\Users`).  
- ✅ **Extensiones soportadas** → avi, mp4, wmv, mpg, mpeg, mov, flv, m4v, 3gp, ts, webm, vob, ogv.  
- ✅ **Prevención de sobrescritura** → si el `.mkv` ya existe, omite la conversión de ese archivo.  
- ✅ **Información detallada** → muestra duración y progreso (`frame=...`) en tiempo real durante la conversión.  
- ✅ **Conversión eficiente** → vídeo en H.265 (x265) y audio en AAC 128 kbps.  
- ✅ **Final limpio** → regresa siempre a la ruta inicial y notifica con `TAREA COMPLETADA`.  

---

## 🛠️ TECNOLOGÍAS USADAS

- **PowerShell**  
- **FFmpeg** (`ffmpeg.exe`) para la conversión de vídeo  
- **FFprobe** (`ffprobe.exe`) para extraer duración y metadatos  
- **Comandos de PowerShell**:  
  - `Get-ChildItem`, `Set-Location`, `Test-Path`, `Join-Path`  
  - Validaciones con `-notcontains`, `[string]::IsNullOrWhiteSpace()`  
  - Coloreado de salida con `Write-Host`  

---

## 📌 EJEMPLO VISUAL

**Estructura de ejemplo en `D:\Peliculas`:**

```plaintext
D:\Peliculas
├── pelicula1.avi (700 MB)
├── pelicula2.mp4 (1.2 GB)
└── Series
├── episodio1.mov (400 MB)
└── episodio2.mp4 (450 MB)
```

**Procedimiento:**

1. El script pedirá la ruta (`D:\Peliculas`) y la extensión a convertir (ej. `avi`).  
2. Buscará todos los `.avi` y los convertirá a `.mkv`.  
3. Si ya existe un `pelicula1.mkv`, lo omitirá.  
4. Durante la conversión mostrará progreso con `frame=...`.  
5. Al terminar, mostrará:

TAREA COMPLETADA

---

## ✅ CONCLUSIÓN

Este script es una herramienta práctica para convertir colecciones de vídeos a formato **MKV estandarizado** sin riesgo de sobrescribir archivos existentes.  
Gracias al uso de **FFmpeg** y el códec **H.265**, consigue archivos más ligeros y eficientes sin sacrificar calidad.
