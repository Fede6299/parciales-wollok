class Empleado {
  const property habilidades = []
  var property salud
  
  const property tipo_de_empleado
  const property equipo = []

  method incapacitado(salud_critica) = self.salud() < salud_critica

  method puede_usar_habilidad(salud_critica, habilidad) = not self.incapacitado(salud_critica) and self.posee_la_habilidad(habilidad)
  method posee_la_habilidad(habilidad) = habilidades.contains(habilidad)
  method cumple_la_mision(salud_critica, habilidad) =
    if(not self.posse_equipo()) { self.habilidades().all({habilidad => self.puede_usar_habilidad(salud_critica, habilidad)}) }
    else equipo.any({integrante => integrante.puede_usar_habilidad(salud_critica, habilidad)})
  method posse_equipo() = self.equipo().isEmpty()
}

object espia {
  // Son los referentes más importantes dentro de la agencia
  // y son capaces de aprender nuevas habilidades al completar misiones.
  method salud_critica() = 15
}
class Oficinita {
  var property cant_estrellas
  // de alguna forma u otra siempre terminan involucrándose en las misiones.
  // Sabemos que si un oficinista sobrevive a una misión gana una estrella.
  method salud_critica() = 40 - 5 * cant_estrellas
}

class Jefe inherits Empleado {
  const property subordinados = []

  method el_subordinado_posee_la_habilidad(salud_critica, habilidad) = self.subordinados().any({subordinado => subordinado.puede_usar_habilidad(salud_critica, habilidad)})
  override method puede_usar_habilidad(salud_critica, habilidad) = super(salud_critica, habilidad) and self.el_subordinado_posee_la_habilidad(salud_critica, habilidad)
}