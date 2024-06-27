# Archivo Proguard básico
# Puedes agregar reglas adicionales según tus necesidades

# Mantener clases anotadas con @Keep
-keep @androidx.annotation.Keep class *

# Mantener clases y métodos públicos en el paquete especificado
-keep class com.example.flutter_application_1.** { *; }
