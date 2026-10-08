# LESSONS

Lecciones aprendidas durante la migración de un `.zshrc` de 10 años a una configuración modular.

Este documento es **honesto**. No vende el proyecto. Cuenta lo que funcionó, lo que falló, y lo que se aprendió.

---

## 🎯 Filosofía general

### El principio que guio todo

> **Migrar no es mejorar. Es reorganizar lo que ya funciona.**

Cuando tienes un `.zshrc` que funciona desde hace 10 años, **no lo reescribas**. Reorganízalo.

Si algo parece raro, **entiéndelo antes de cambiarlo**. Puede ser raro por una buena razón (una tecla que se comporta raro porque un terminal la envía distinto, un alias con `=` porque un script lo requiere, etc.).

### Los 3 pilares

1. **Modularizar por dominio**, no por tipo.
2. **Separar config de lógica**.
3. **Documentar para tu yo del futuro** (que será un desconocido).

---

## 🏗️ Lecciones técnicas

### 1. `exec zsh` tras cada cambio

**Pasó 4 veces**. Modificar un archivo en `~/.config/zsh/` no recarga la función en memoria. Hay que hacer `exec zsh` o abrir terminal nueva.

**Regla mental**: cada vez que toques la config, `exec zsh`. Si algo se comporta raro, **eso es lo primero que hay que probar** antes de sospechar del código.

**Análogo en otros lenguajes**:
- Python: reiniciar el intérprete.
- Node.js: reiniciar el proceso.
- Hyprland: `hyprctl reload`.

### 2. `showkey -a` para diagnosticar teclas

Cuando una tecla "no funciona" en Zsh, lo primero es **ver qué envía realmente** el terminal.

```bash
showkey -a
# Pulsa la tecla problemática. Sal con Ctrl+D.
```

Cada terminal envía secuencias distintas para la misma tecla. `Ctrl+Backspace` es el peor: foot envía `^H`, otros terminales `^?`. La única forma de saberlo es verlo.

### 3. `fpath` ANTES de `compinit`

**Regla de oro del autocompletado**.

```zsh
# ✅ Correcto
fpath=("$ZDOTDIR/functions" $fpath)
for f in "$ZDOTDIR"/conf.d/[0-9][0-9]-*.zsh(N); do
    source "$f"  # aquí va 30-completion.zsh → compinit
done
autoload -Uz ...

# ❌ Incorrecto
for f in ...; do source "$f"; done  # compinit corre primero
fpath=("$ZDOTDIR/functions" $fpath)  # tarde
autoload -Uz ...
```

Si `compinit` corre antes de que `fpath` incluya las funciones, **no las encuentra**.

### 4. `compdef` en `conf.d/`, no dentro de `_funcion`

**Círculo vicioso**:

1. Zsh quiere completar `cryptosith`.
2. ¿Hay `compdef` registrado? **No** (nadie cargó `_cryptosith`).
3. Usa el completado por defecto (archivos).
4. Muestra los archivos.

**Solución**: `compdef` en `conf.d/31-compdefs.zsh`, que se carga al inicio.

### 5. `add-zsh-hook` vs `precmd()`

- `precmd() { ... }` → **sobrescribe**.
- `add-zsh-hook precmd ...` → **acumula**.

Si dos plugins quieren usar `precmd`, el primero que se carga es pisado por el segundo. Con `add-zsh-hook` conviven.

### 6. Los aliases NO aceptan argumentos

```zsh
alias nano-script='cp ~/Plantillas/new.sh "$1"'  # ❌ no funciona
```

El `$1` se expande al **definir** el alias (queda vacío), no al usarlo.

**Solución**: usar **función**.

### 7. Los checksums deben reflejar lo que se cifra

**Regla de cryptosith**: calcular el SHA-256 del **comprimido**, no del **original**.

Razón: si aplicas exclusiones (`--exclude node_modules`), el original tiene más archivos que el comprimido. El hash debe reflejar lo que realmente se cifró, no lo que se introdujo.

### 8. `script -qec` para automatizar comandos que exigen TTY

`age --passphrase` **exige un TTY** para leer la passphrase. No acepta stdin.

**Solución**: crear un pseudo-TTY con `script`.

```bash
printf 'pass\npass\n' | script -qec "age --passphrase -o out in" /dev/null
```

### 9. `systemd-creds` sella al TPM de forma simple

Para cifrar cosas con el TPM:

```bash
systemd-creds encrypt --with-key=tpm2 input output
systemd-creds decrypt --with-key=tpm2 input output
```

Sin configurar nada más. Solo requiere que el TPM esté habilitado.

### 10. `mktemp -d` para aislar trabajo

Cuando un script manipula archivos temporales:

```bash
tmp_dir=$(mktemp -d -t cryptosith.XXXXXX)
trap "rm -rf $tmp_dir" EXIT
```

Aísla el trabajo. Si algo falla, se limpia solo.

---

## 🎨 Lecciones de diseño

### 1. Modularizar por dominio, no por tipo

**Mal**: `functions.zsh` (todas las funciones), `aliases.zsh` (todos los aliases).
**Bien**: `aliases.d/git.sh`, `aliases.d/systemd.sh`, `aliases.d/pacman.sh`.

**Razón**: cuando buscas algo, lo buscas por **qué hace**, no por **qué tipo es**. Si quieres añadir un alias de git, abres `20-git.sh`, no un archivo de 2000 líneas.

### 2. Números con huecos

`00-`, `10-`, `20-`, etc. **no** `01-`, `02-`, `03-`.

**Razón**: si necesitas insertar algo entre `10-` y `20-`, tienes hueco (`15-`). No hay que renumerar.

### 3. Config vs lógica

- **Config** (variables, opciones, aliases) → `conf.d/`.
- **Lógica** (funciones con `if`, bucles, comandos externos) → `functions/`.

**Razón**: la config se lee siempre. La lógica se carga solo cuando se usa (`autoload`). Arranque rápido.

### 4. Subcomandos vs menús interactivos

- **Subcomandos** (`cryp encrypt x`) → para herramientas de uso **frecuente**. Scriptable, tab-completable.
- **Menús interactivos** → para herramientas de uso **puntual**. Más cómodos si no recuerdas la sintaxis.

**Ejemplo**: `cryptosith` (subcomandos) vs `ufw-manager` (menú). Uno se usa a diario, el otro rara vez.

### 5. Pausa unificada en menús

Los menús interactivos **deben pausar** al final del bucle, no por opción.

```zsh
while true; do
    mostrar_menu
    read opcion
    case $opcion in
        1) accion1 ;;
        2) accion2 ;;
        0) break ;;
    esac
    # Pausa unificada
    read -p "Enter para continuar"
done
```

**Razón**: olvidar pausa en una opción deja el output "pegado" con el siguiente menú.

### 6. Sin excepciones en menús

Si una opción de un menú hace `return 0` para salir, **rompe el bucle**. Diseñar para que **todas** las opciones vuelvan al menú.

### 7. Documentar honestamente

**Mal**: "sistema de cifrado de nivel militar".
**Bien**: "8/10 de seguridad real. No protege contra X, Y, Z."

**Razón**: mentirte a ti mismo en la documentación es peor que no documentar.

### 8. Manual separado del código

`cryp man` lee de `~/.config/cryptosith/manual.txt`. Se puede editar sin tocar código.

**Razón**: el manual se actualiza más a menudo que el código. Y puede ser leído por alguien que solo quiere usar la herramienta, no programarla.

### 9. Autocompletado mejora la usabilidad enormemente

Con `cryp <TAB>` el usuario descubre las opciones sin mirar el manual. Es la mejor documentación posible.

### 10. Un repo por proyecto

`cryptosith` en su propio repo. `zsh-config` en el suyo. Cada uno con su README, su INSTALL, su LICENSE.

**Razón**: los proyectos tienen ciclos de vida distintos. `cryptosith` puede evolucionar sin tocar `zsh-config`.

---

## 🔐 Lecciones de seguridad

### 1. Más capas ≠ más seguridad

**Error inicial**: 4 capas de cifrado con la misma categoría de cifrado. **Teatro**.

**Realidad**: la seguridad está en **la calidad de la clave**, no en el número de capas.

**Analogía**: 4 cerraduras en la misma puerta con la misma llave.

### 2. Los gestores de contraseñas han fallado

- **LastPass 2022**: filtración masiva de vaults.
- **Bitwarden 2022**: bug en el generador de contraseñas.

**Conclusión**: no confiar **ciegamente** en un gestor. Tener siempre un backup **físico** (papel en caja fuerte).

### 3. La clave privada en disco es punto de fallo

Si cifras con `age` usando clave pública/privada, la clave privada **vive en el disco**. Si te roban el disco, tienen la clave (cifrada, pero pueden intentar romperla).

**Alternativa**: usar `age --passphrase` (passphrase derivada con scrypt). No hay clave privada en disco.

### 4. Canales separados son la defensa real

**Modo dual**: 2 passphrases en 2 sitios distintos.
- PassA → tu cabeza + gestor.
- PassB → papel en caja fuerte.

Para descifrar, **A Y B**. Si roban uno de los dos canales, no descifran.

### 5. 9.5/10 es el máximo real sin hardware criptográfico

Con `age` + `systemd-creds` + TPM, llegas a 9.5/10. Para **10/10** necesitas:
- YubiKey (~50€).
- TPM sellado a PCRs específicos.
- Air-gap, Tails OS.
- Auditoría externa.

**Son procedimientos**, no código.

### 6. La comodidad importa

**"Si no lo usas, no protege."**

Un sistema seguro pero incómodo no se usa. Un sistema cómodo pero mediocre se usa todos los días.

**Ejemplo**: `cryptosith` con `-t` (TPM + 1 passphrase) es rápido y portable. El usuario lo usa. Si fuera solo `tpm-only`, no lo usaría fuera de casa.

### 7. Los gestores de contraseñas pueden filtrar

**Bitwarden 2022**: el generador de contraseñas tenía un bug. Si lo usaste, tus contraseñas **no eran aleatorias**.

**Conclusión**: usar `cryp key 128` (o `/dev/urandom`) para generar claves. No confiar en gestores para generación.

### 8. Los emojis del prompt pueden romperse

En un terminal, un emoji "compuesto" (con variation selector) no se renderiza igual que uno "simple".

**Conclusión**: probar el prompt en varios terminales. Si un emoji se ve raro, cambiarlo por otro.

---

## 📚 Lecciones meta

### 1. Documentar como si fuera para un desconocido

Dentro de 15 años, tu yo del futuro **será un desconocido**. No recordará por qué pusiste `bindkey '^[[1;5C'` ni por qué usaste `${line%%=*}` en lugar de `IFS='='`.

**Solución**: documentar **el por qué**, no solo el qué.

### 2. Cada decisión debe tener un por qué escrito

Un comentario de 3 líneas en el código puede ahorrarte una hora dentro de 6 meses.

```zsh
# Usamos `script -qec` porque age --passphrase exige un TTY y no acepta stdin.
# Esto crea un pseudo-TTY y le pasa la passphrase como si fuera interactiva.
```

### 3. Los proyectos personales tienen valor

Aunque no sean "industry-grade", un proyecto personal **es una prueba** de que entendiste algo lo suficientemente bien como para construirlo.

No necesitas que sea perfecto. Necesitas que **funcione** y que **lo entiendas**.

### 4. Aprender haciendo > leer tutoriales

En 2 días de migración aprendi más sobre Zsh, criptografía y TPM que en 6 meses de tutoriales.

**Razón**: leer es pasivo. Hacer es activo. Y resolver problemas reales **fuerza** el aprendizaje.

### 5. Los errores son lecciones (documentarlos)

Cada vez que algo falló (los 4 `exec zsh` olvidados, el bug del Backspace, el `--noconfirm` de pacman), lo documentamos.

**Razón**: los errores son más instructivos que los éxitos. Y si se documentan, no se repiten.

### 6. La estructura es más importante que el contenido

Un archivo de 100 líneas bien organizado es mejor que 5 archivos de 500 líneas mal organizados.

**Razón**: la estructura permite encontrar cosas. El contenido se olvida.

### 7. Menos es más

`50-keybindings.zsh` tiene 18 bindkeys. La versión inicial tenía 25. **Se Quitaron 7** que eran redundantes o rompían defaults.

**Razón**: cada línea es una responsabilidad. Menos líneas = menos bugs.

### 8. Migrar es un proceso interactivo

**No** se hace en un solo paso. Cada fase enseña algo. Cada fase permite corregir lo anterior.

**Ejemplo**: en la Fase 5 "se arreglo" los bindkeys. En la Fase 6 "se arreglaron" `PROMPT_SUBST`. En la Fase 7 "fueron" el parser del `.meta`.

### 9. La configuración es software

Un `.zshrc` es **código**. Merece:
- Control de versiones (git).
- Documentación.
- Tests (cuando se puede).
- Refactoring periódico.

**Razón**: el `.zshrc` se ejecuta cada vez que abres una terminal. Si tiene un bug, lo ves 100 veces al día.

### 10. Compartir enseña

Documentar para publicar en Codeberg te fuerza a:
- Escribir de forma clara.
- Explicar el "por qué", no solo el "qué".
- Justificar decisiones de diseño.
- Reconocer limitaciones.

**Razón**: cuando escribes para otros, escribes mejor. Y el que más aprende es uno mismo.

---

## 🎯 Frase final

> **Un `.zshrc` de 10 años no se reescribe. Se reorganiza, se documenta, se migra. Y al final, lo que queda no es "el nuevo" ni "el viejo". Es el mismo, pero limpio.**

---

**Fin de LESSONS.md.**


