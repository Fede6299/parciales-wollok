class Lugar {
	var property nombre

	method nombre_par() = nombre.even()
  method es_divertido() = self.nombre_par() and self.caso_particular()
	method caso_particular()

	method es_tranquilo()
	method es_raro() = self.nombre_largo()
	method nombre_largo() = nombre.size() > 10
}

class Ciudad inherits Lugar {
  var property cant_habitantes
  var property atracciones_turisticas = []
  var property cant_decibles

	override method caso_particular() = self.tiene_muchas_atracciones() and self.tiene_muchos_habitantes()
	method tiene_muchas_atracciones() = atracciones_turisticas.size() > 3
	method tiene_muchos_habitantes() = cant_habitantes > 100000

	override method es_tranquilo() = self.poco_decibeles()
	method poco_decibeles() = cant_decibles < 20
}

class Pueblo inherits Lugar {
  var property extension_km2
  var property fundacion
  var property provincia

	const property provincias_litoral = ["Entre Rios", "Corrientes", "Misiones"]
	override method caso_particular() = self.es_antiguo() or self.es_del_litoral()
	method es_antiguo() = fundacion < 1800
	method es_del_litoral() = provincias_litoral.any({p => p.equalsIgnoreCase(provincia)})

	override method es_tranquilo() = self.esta_en_La_Pampa()
	method esta_en_La_Pampa() = provincia.equalsIgnoreCase("La Pampa")
}

class Balnearios inherits Lugar {
  var property mts_playa_promedio
  var property mar_peligroso
  var property tiene_peatonal

	override method caso_particular() = self.tiene_playa_grande() and mar_peligroso
	method tiene_playa_grande() = mts_playa_promedio > 300

	override method es_tranquilo() = not tiene_peatonal
}

class Persona {
	var property preferencia
	var property presupuesto_maximo
	
	method aceptaVacaciones(lugar) = preferencia.estado(lugar)
	method monto_adecuado(monto) = presupuesto_maximo > monto
}

object tranquilo {
	method estado(lugar) = lugar.es_tranquilo()
}

object divertido {
	method estado(lugar) = lugar.es_divertido()
}

object raro {
	method estado(lugar) = lugar.es_raro()
}
// IMPORTANTE
class Combinado{
	const property criterios = []

	method estado(lugar) = criterios.any({criterio => criterio.estado(lugar)})    
}

class Tour {
	var property fecha_salida
	var property cant_personas_requeridas
	const property lugares_a_recorrer = []
	var property precio_Tour
	var property personas_agregadas = 0

	method agregar_persona(persona) {
		if(not persona.monto_adecuado(precio_Tour))
			throw new DomainException (message = "El monto supera el precio maximo que puede pagar")
		if(not self.lugar_adecuado(persona))
			throw new DomainException (message = "Todos los lugares no son de la preferencia de la persona")
		if(not self.hay_lugar())
			throw new DomainException (message = "No hay más lugar en el Tour")
		else personas_agregadas += 1
	}

	method lugar_adecuado(persona) = lugares_a_recorrer.all({lugar => persona.prefiere(lugar)})
	method hay_lugar() = personas_agregadas < cant_personas_requeridas
	method quitar_persona() {personas_agregadas -= 1}

	method monto_por_tour() = self.personas_agregadas() * self.precio_Tour()
  method este_anio() = fecha_salida.year() == new Date().year()
}

class Reporte {
	const property lista_tours = []

  method tour_pendiente() = lista_tours.filter({tour => tour.hayLugar()})

  method monto_total_anio() = self.tours_actuales().sum({tour => tour.monto_por_tour()})
  method tours_actuales() = lista_tours.filter({tour => tour.este_anio()})

  method anioActual() = new Date().year()
}