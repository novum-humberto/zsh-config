##########################################################################
# 45/password-solutions                                                   #
#                                                                         #
# SINÓPSIS:                                                               #
#   password-correction [usuario]                                         #
#   passuser [usuario]  ->  alias de password-correction                  #
#                                                                         #
# OBJETIVO:                                                               #
#   Resetear el contador de intentos fallidos (faillock) de un usuario.   #
#   Es útil cuando sudo deja de reconocer la contraseña por un bloqueo    #
#   temporal de seguridad.                                                #
#                                                                         #
# FUNCIONAMIENTO:                                                         #
#   - Ejecuta: sudo faillock --user <usuario> --reset                     #
#   - Si no se indica usuario, usa $USER (el usuario actual).             #
#   - Requiere privilegios de sudo.                                       #
#   - Antes de definir la función, elimina cualquier alias previo con     #
#     el mismo nombre para evitar conflictos.                             #
#                                                                         #
# USO:                                                                    #
#   passuser              # resetea el faillock del usuario actual        #
#   passuser paquito2     # resetea el faillock de paquito2               #
#   password-correction   # equivalente a passuser                        #
#                                                                          #
# Creado por: NOVUM-COMUNIDAD_OFICIAL                                     #                                    #
##########################################################################

unalias password-correction 2>/dev/null

password-correction() {
  sudo faillock --user "${1:-$USER}" --reset
}

alias passuser='password-correction'


