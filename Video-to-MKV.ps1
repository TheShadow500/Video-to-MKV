Write-Host "Video-to-MKV v0.40 by Daniel Amores" -ForegroundColor Cyan
Write-Host "El script buscara todos los archivos con la extension indicada en la ruta especificada y los convertira a formato MKV, manteniendo la misma calidad pero utilizando un codec mas moderno y eficiente."

# Solicita al usuario la ruta
Write-Host "Introduzca la ruta absoluta (ej. d:\documentos\pdf\): " -NoNewline -ForegroundColor Cyan
$ruta = Read-Host

# Controla entrada en blanco
if ([string]::IsNullOrWhiteSpace($ruta)) {
    Write-Host "No se ha introducido ninguna ruta. Operacion cancelada.`n" -ForegroundColor Yellow
    exit
}

# Normaliza la ruta
$ruta = $ruta.TrimEnd('\')
$ruta = $ruta.TrimEnd().ToLower()

# Rutas no permitidas
$rutasNoPermitidas = @(
    "c:",
	"d:",
    "c:\windows",
    "c:\program files",
    "c:\program files (x86)",
    "c:\users"
)

# Controla rutas no permitidas principalmente de sistema
if ($rutasNoPermitidas -contains $ruta) {
	Write-Host "Ruta no permitida. Operacion cancelada.`n" - ForegroundColor Red
	exit
}

# Muestra el error en caso de escribir una ruta no valida
if (-Not (Test-Path -LiteralPath $ruta)) {
	Write-Host "ERROR:" -NoNewline -ForegroundColor DarkRed -BackgroundColor Black
	Write-Host " La ruta '$ruta' no existe`n"
	return
}

# Solicita la extension a convertir
Write-Host "Introduzca la extension a convertir (ej. avi): " -NoNewline -ForegroundColor Cyan
$ext = Read-Host

# Normaliza la extension
$ext = $ext.ToLower()

# Extensiones permitidas
$extensionesPermitidas = @(
	"avi", "mp4", "wmv", "mpg", "mpeg",
	"mov", "flv", "m4v", "3gp", "ts",
	"webm", "vob", "ogv"
)

# Controla las extensiones no permitidas
if ($extensionesPermitidas -notcontains $ext) {
	Write-Host "Extension no permitida. Operacion cancelada.`n"
	exit
}

# Carpeta base donde se ejecuta el script
$basePath = Get-Location

# Cambia de carpeta a la de la ruta
Set-Location -LiteralPath $ruta

# Establece las rutas
$ffmpeg = Join-Path $basePath "ffmpeg.exe"
$ffprobe = Join-Path $basePath "ffprobe.exe"

# Informacion
Write-Host "Convirtiendo videos $($ext) a MKV con el codec H.265/HEVC usando la libreria x265" -ForegroundColor Green

# Solicita la lista de archivos en la ruta establecida que cumplen con la extension introducida
$archivos = Get-ChildItem -LiteralPath $ruta -File | Where-Object { $_.Extension.TrimStart('.') -eq $ext }

# Controla que hayan resultados
if ($archivos.Count -gt 0) {
	# Comprueba que el archivo de destino no exista. En caso de existir avisa al usuario y se omite el archivo
	foreach ($archivo in $archivos){
		if (-Not (Test-Path "$($archivo.BaseName).mkv")){
			# Informa del video a convertir
			Write-Host "`nConvirtiendo: " -NoNewline
			Write-Host "$($archivo.Name)" -ForegroundColor Green

			# Informa de la duración del video
			Write-Host "Duracion: " -NoNewline
			$duracion = & $ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "`"$($archivo.FullName)`""
			$duracion = $duracion.Trim()
			Write-Host "$([TimeSpan]::FromSeconds($duracion).ToString("hh\:mm\:ss"))" -ForegroundColor Yellow

			# Convierte el video
			& $ffmpeg -i "$($archivo.FullName)" -c:v libx265 -preset slow -crf 24 -c:a aac -b:a 128k "$($archivo.BaseName).mkv" 2>&1 |

			# Actualiza y muestra en pantalla la informacion de conversion en tiempo real
			ForEach-Object {		
				if ($_ -match '^frame=') {
					Write-Host "`r$_" -NoNewline -ForegroundColor Green
				}
			}

			# Informa del video convertido
			Write-Host "`nCompletado: " -NoNewline
			Write-Host "$($archivo.BaseName).mkv" -ForegroundColor Green
		}
		else {
			Write-Host "`nERROR:" -BackgroundColor Black -ForegroundColor Red -NoNewline
			Write-Host " El archivo de destino YA existe."
			Write-Host "OMITIDO" -ForegroundColor Green
		}
	}
}
else {
	Write-Host "No se han encontrado resultados"
}

# Vuelve a la ruta inicial
Set-Location -LiteralPath $basePath

# Informa del trabajo realizado
Write-Host "`nTAREA COMPLETADA`n"