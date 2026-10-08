# 70-media.sh
# ================================================================
# Aliases de multimedia, entretenimiento y streaming:
# música, clima, reloj, pomodoro, OBS, descargas con yt-dlp.
# ================================================================

# --- Reproducción de música ---
alias music='cliamp'                 # cliente MPD en terminal

# --- Reloj ---
alias clock='tty-clock -S -C 6 -c'     # reloj grande en terminal (Ctrl+C para salir)

# --- Clima ---
# clima: muestra el clima de La Habana combinando ansiweather + wttr.in
alias clima='ansiweather -l "Havana,CU" -u metric -s true -f 2 -d true && curl "wttr.in/Havana?2"'
alias clima-1='weathr'                 # alternativa: visor gráfico

# --- Pomodoro (temporizador de estudio) ---
# REQUISITOS:
#   - libnotify        → proporciona notify-send (notificaciones de escritorio)
#   - pulseaudio-utils → proporciona paplay (reproducir sonidos)
#     (o pipewire-pulse si usas PipeWire)
#   - sound-theme-freedesktop → proporciona /usr/share/sounds/freedesktop/stereo/complete.oga
#
# Ciclos: 50min estudio + 10min descanso x2, luego 30min repaso + 30min estudio.
# Notificación por notify-send y sonido al cambiar de ciclo.
alias pomodoro='echo "Estudiando..."; sleep 3000; notify-send "Descanso" -t 5000 && paplay /usr/share/sounds/freedesktop/stereo/complete.oga; echo "Descansando..."; sleep 600; notify-send "Vuelve al estudio" -t 5000 && paplay /usr/share/sounds/freedesktop/stereo/complete.oga; echo "Estudiando..."; sleep 3000; notify-send "Descanso" -t 5000 && paplay /usr/share/sounds/freedesktop/stereo/complete.oga; echo "Descansando..."; sleep 600; notify-send "Vuelve al estudio" -t 5000 && paplay /usr/share/sounds/freedesktop/stereo/complete.oga; echo "Estudiando (ultima sesion)..."; sleep 1800; notify-send "Ultimos 30 minutos: Repaso y toma de notas" -t 5000 && paplay /usr/share/sounds/freedesktop/stereo/complete.oga; echo "Repasando y tomando notas..."; sleep 1800; notify-send "Fin del estudio" -t 5000 && paplay /usr/share/sounds/freedesktop/stereo/complete.oga'

# --- OBS (grabación/streaming) ---
# obs-rt: requiere kernel xanmod-rt + schedtool. Prioridad SCHED_RR máxima.
alias obs-rt='sudo schedtool -R -p 99 -n -20 obs'
# obs-xanmod: prioridad nice media. Funciona con cualquier kernel.
alias obs-xanmod='sudo nice -n -5 obs'

# --- Descargas con yt-dlp ---
# Ambos leen URLs desde urls.txt y descargan a subcarpetas por uploader/playlist.
# --download-archive evita re-descargar (descargados.txt).
# --no-overwrites evita pisar archivos existentes.

# yt-audio: descarga solo audio en MP3 (mejor calidad) + thumbnail + metadata.
alias yt-audio='yt-dlp -a urls.txt -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 -o "%(uploader)s/%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s" --download-archive descargados.txt --continue --no-overwrites --embed-thumbnail --embed-metadata --yes-playlist'

# yt-video: descarga video+audio en MP4 + thumbnail + metadata + capítulos + subtítulos ES.
alias yt-video='yt-dlp -a urls.txt -f bestvideo+bestaudio --merge-output-format mp4 -o "%(uploader)s/%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s" --download-archive descargados.txt --continue --no-overwrites --embed-thumbnail --embed-metadata --embed-chapters --write-auto-sub --sub-lang "es" --convert-subs srt --yes-playlist'
