class Comensal {
	var property posicion
	const property elementos_cerca = []
	var property criterio

	var property criterio_de_comida
	const property comidas = []

	method primer_elemento() = elementos_cerca.head()
	method quitar_elemento(elemento) {
		self.elementos_cerca().remove(elemento)
	}
	method agregar_elemento(elemento) {
		self.elementos_cerca().add(elemento)
	}
	method quitar_todos_los_elementos() {
		self.elementos_cerca().clear()
	}
	method agregar_todos_los_elementos(amigo) {
		amigo.elementos_cerca().forEach({e => self.agregar_elemento(e)})
	}
	method tiene_el_elemento(elemento) = elementos_cerca.contains(elemento)

	method intentar_pasar_elemento(amigo, elemento) {
		if(not amigo.tiene_el_elemento(elemento)) { throw new DomainException(message = "No tengo cerca el elemento " + elemento) }
		else self.criterio().pasar_elemento(self, elemento, amigo)
	}

	method comer(comida) {
		if(not self.criterio_de_comida().le_gusta(comida)) {
			throw new DomainException(message = "No le gusta " + comida)
		}
		else comidas.add(comida)
	}

	method esta_pipon() = comidas.all({comida => comida.es_pesada()})
	method comio_algo() = not comidas.isEmpty()
	method la_pasa_bien() = self.comio_algo() and self.la_paso_bien_amgio()
	method la_paso_bien_amgio()
}

object sordo {
	method pasar_elemento(comensal, elemento, amigo) {
		comensal.agregar_elemento(amigo.primer_elemento())
		amigo.quitar_elemento(amigo.primer_elemento())
	}
}
object molesto {
	method pasar_elemento(comensal, elemento, amigo) {
		comensal.agregar_todos_los_elementos(amigo)
		amigo.quitar_todos_los_elementos()
	}
}
object incomodo {
	method pasar_elemento(comensal, elemento, amigo) {
		const posicion_comensal = comensal.posicion()
		comensal.posicion(amigo.posicion())
		amigo.posicion(posicion_comensal)
	}
}

object coherente {
	method pasar_elemento(comensal, elemento, amigo) {
		comensal.agregar_elemento(elemento)
		amigo.quitar_elemento(elemento)
	}
}

class Comida {
	var property calorias
	var property es_carne

	method pocas_calorias() = calorias < 500
	method es_pesada() = calorias > 500
}

object vegetariano {
	method le_gusta(comida) = not comida.es_carne()
}

object diabetico {
	method le_gusta(comida) = comida.pocas_calorias()
}

class Alternado {
	var quiero = false
	method le_gusta(comida) { 
		quiero = not quiero
		return not quiero }
}

class Comibinacion {
	const property combinacion_comida = []
	method le_gusta(comida) = combinacion_comida.all({criterio => criterio.le_gusta(comida)})
}

object osky inherits Comensal(posicion = 10, criterio = coherente, criterio_de_comida = vegetariano) {
	override method la_paso_bien_amgio() = true
}

object moni inherits Comensal(posicion = 11, criterio = coherente, criterio_de_comida = vegetariano) {
	override method la_paso_bien_amgio() = self.posicion() == 11
}

object facu inherits Comensal(posicion = 5, criterio = sordo, criterio_de_comida = vegetariano){
	override method la_paso_bien_amgio() = self.comidas().any({comida => comida.es_carne()})
}

object vero inherits Comensal(posicion = 5, criterio = sordo, criterio_de_comida = vegetariano) {
	override method la_paso_bien_amgio() = self.elementos_cerca().size() <= 3
}