class Empleado {
  const property habilidades = []
  var property salud
  
  const property puesto

  method incapacitado() = self.salud() < puesto.salud_critica()
  
  method puede_usar_habilidad(habilidad) = not self.incapacitado() and self.posee_la_habilidad(habilidad)
  method posee_la_habilidad(habilidad) = habilidades.contains(habilidad)

  method recibir_danio(cantidad) { salud -= cantidad }
  method vive() = salud > 0

  method finalizar_mision(mision) {
		if (self.vive()) {
			self.completar_mision(mision)
		}
	}

  method completar_mision(mision) {
		puesto.completar_mision(mision, self)
	}
  method aprender_habilidad(habilidad) {
		habilidades.add(habilidad)
	}
}
object espia {
  // Son los referentes más importantes dentro de la agencia
  // y son capaces de aprender nuevas habilidades al completar misiones.
  method salud_critica() = 15
  method completar_mision(mision, empleado) {
		mision.enseniar_habilidades(empleado)
	}
}
class Oficinita {
  var property cant_estrellas
  // de alguna forma u otra siempre terminan involucrándose en las misiones.
  // Sabemos que si un oficinista sobrevive a una misión gana una estrella.
  method salud_critica() = 40 - 5 * cant_estrellas
  method completar_mision(mision, empleado) {
		cant_estrellas += 1
		if (cant_estrellas == 3) {
			empleado.puesto(espia)
		}
	}
}
class Jefe inherits Empleado {
  const property subordinados = []

  method un_subordinado_posee_la_habilidad(habilidad) = self.subordinados().any({subordinado => subordinado.puede_usar_habilidad(habilidad)})
  override method posee_la_habilidad(habilidad) = super(habilidad) and self.un_subordinado_posee_la_habilidad(habilidad)
}

class Mision {
  var property habilidades_requeridas = [] 
  const property peligrosidad

  method tiene_las_habilidades_requeridas(agente) = habilidades_requeridas.all({habilidad => agente.puede_usar_habilidad(habilidad)})

  method realiza_mision(agente) {
		self.validar_habilidades(agente)
		agente.recibir_danio(peligrosidad)		
		agente.finalizar_mision(self)
	}

  method validar_habilidades(agente) {
		if (not self.tiene_las_habilidades_requeridas(agente)) {
			throw new DomainException (message = "La misión no se puede cumplir")
		}
	}
  method enseniar_habilidades(empleado) {
		self.habilidades_que_no_posee(empleado)
			.forEach({hab => empleado.aprender_habilidad(hab)})
	}

  method habilidades_que_no_posee(empleado) =
		habilidades_requeridas.filter({hab => not empleado.posee_la_habilidad(hab)})
}

class Equipo {
	const empleados = []
	
	method puede_usar_habilidad(habilidad) = 
		empleados.any({empleado => empleado.puede_usar_habilidad(habilidad)})
		
	method recibir_danio(cantidad) {
		empleados.forEach({empleado => empleado.recibir_danio(cantidad / 3)})
	}
	
	method finalizar_mision(mision) {
		empleados.forEach({empleado => empleado.finalizar_mision(mision)})
	}
}