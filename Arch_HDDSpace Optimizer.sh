!/bin/bash

#Small Script para eliminar archivos innecesarios en el Almacenamiento de Arch Linux#

# Elevar a root si no se ejecuta como root
if [ "$EUID" -ne 0 ]; then
  echo "🔐 Este script requiere privilegios de superusuario. Reiniciando con sudo..."
  exec sudo "$0" "$@"
fi

echo "🧼 Iniciando limpieza del sistema Arch Linux..."

# 1. Evitar eliminación de subpaquetes de firmware requeridos
echo "🚫 Saltando eliminación de subpaquetes de linux-firmware (ahora son obligatorios)"

# 2. Eliminar dependencias huérfanas
echo "➡️ Eliminando dependencias huérfanas..."
pacman -Rns --noconfirm $(pacman -Qdtq) 2>/dev/null || echo "✅ No hay paquetes huérfanos."

# 3. Limpiar caché de paquetes (dejando solo 1 versión anterior)
echo "➡️ Limpiando caché de paquetes (dejando 1 versión)..."
paccache -r

# 4. Limpiar archivos temporales
echo "➡️ Borrando archivos temporales..."
rm -rf /tmp/*
rm -rf /var/tmp/*

# 5. Mostrar kernel en uso
echo "🔎 Kernel actual en uso: $(uname -r)"

# 6. Listar kernels instalados
echo "📦 Kernels instalados:"
pacman -Q | grep linux | grep -v firmware

# 7. Sugerencia sobre kernels
echo "📝 Si tienes kernels que no usas, puedes eliminarlos manualmente con: pacman -Rns nombre-del-kernel"

echo "✅ Limpieza completada correctamente."
