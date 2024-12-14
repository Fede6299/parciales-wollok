class Empleado {
  const property lenguajes = []

  method aprender_lenguaje(lenguaje) {
    self.lenguajes().add(lenguaje)
  }

  method esta_invitado() = self.es_copado() or self.puede_ser_invitado()

  method es_copado()
  method puede_ser_invitado()

  method conoce_lenguaje_antiguo() = lenguajes.any({lenguaje => lenguaje.es_antiguo()})
  method conoce_lenguaje_moderno() = lenguajes.any({lenguaje => lenguaje.es_moderno()})
  method sabe_programar_en(lenguaje) = lenguajes.contains(lenguaje)
  method cantidad_lenguajes() = lenguajes.size()

  method mesa() = self.cant_de_lenguajes_moderenos()
  method cant_de_lenguajes_moderenos() = lenguajes.count({lenguaje => lenguaje.es_moderno()})
  method regalo_en_efectivo() = 1000 * self.cant_de_lenguajes_moderenos()
}

class Desarrollador inherits Empleado {
  override method es_copado() = self.conoce_lenguaje_antiguo() or self.conoce_lenguaje_moderno()
  override method puede_ser_invitado() = self.sabe_programar_en(wlk) or self.conoce_lenguaje_antiguo()
}

class Infrastuctura inherits Empleado {
  var property anios_experiencia

  override method puede_ser_invitado() = self.lenguajes() >= 5
  override method es_copado() = self.anios_experiencia() > 10
}

class Lenguaje {
  const property anio_creacion

  method es_antiguo() = self.hace_cuanto_se_creo() > 30
  method es_moderno() = self.hace_cuanto_se_creo() < 10
  method hace_cuanto_se_creo() = new Date().year() - anio_creacion
}
const wlk = new Lenguaje(anio_creacion = 2016)

class Jefe inherits Empleado{
  const property empleados = []
  
  method agregar_empleado(empleado) { empleados.add(empleado) }
  override method es_copado() = true
  override method puede_ser_invitado() = self.conoce_lenguaje_antiguo() and self.tiene_solo_empleados_copados()

  method tiene_solo_empleados_copados() = empleados.all({empleado => empleado.es_copado()})

  override method mesa() = 99
  override method regalo_en_efectivo() = super() + 1000 * self.cantidad_de_empleados()
  method cantidad_de_empleados() = self.empleados().size()
}

object acmeSA {
  const property personal_de_la_empresa = []
  method lista_de_invitados() = personal_de_la_empresa.filter({personal => personal.esta_invitado()})

  method cantidad_de_invitados() = self.lista_de_invitados().size()
}

class Asistencia {
    const property mesa
    const property empleado
}

class Evento {
  const asistencias = []
  const empresa = acmeSA

  method registrar(empleado) {
    self.verificar_registro_de(empleado)
    self.registrar_asistencia_de(empleado)
  }

  method verificar_registro_de(empleado) {
    if (not empleado.esta_invitado()) {
      throw new DomainException (message = "La persona no se encuentra invitada al evento")
    }
  }

  method registrar_asistencia_de(unEmpleado) {
    asistencias.add(new Asistencia(empleado = unEmpleado, mesa = unEmpleado.mesa()))
  }

  method fue_un_exito() = self.balance() > 0 and self.todos_asistieron()
  method todos_asistieron() = self.cantidad_de_asistencias() == empresa.cantidad_de_invitados()

  method balance() = self.importe_por_regalos() - self.costo_total()
  method importe_por_regalos() = asistencias.sum({asistencia => asistencia.regalo_en_efectivo()})
  method costo_total() = 200000 + self.costo_por_asistencias()
  method costo_por_asistencias() = self.cantidad_de_asistencias() * 5000
  method cantidad_de_asistencias() = asistencias.size()

  method mesas_con_mas_asistencia() = self.mesas().max({mesa => self.mesas().occurrencesOf(mesa)})
  method mesas() = asistencias.map({asistencia => asistencia.mesa()})
}