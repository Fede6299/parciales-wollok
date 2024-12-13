object pepita {
  var energy = 100

  method energy() = energy

  method fly(minutes) {
    energy = energy - minutes * 3
  }
}

// Noticia 2024

class Noticia {
  var property fecha_publicacion
  var property autor
  var property grado_importancia
  var property titulo
  var property desarrollo

  method publicado_hace_poco() = fecha_publicacion - new Date() <= 3
  method es_copada() = grado_importancia >= 8 and self.publicado_hace_poco() and self.caso_particular()
  method caso_particular()

  method palabras_sensacionalistas() = ["espectacular", "increible", "grandioso"]
  method es_sensacionalista() = self.palabras_sensacionalistas().any({p => p.equalsIgnoreCase(titulo)})
  
  method tiene_menos_de_cien_palabras() = desarrollo.split(" ").size() < 100
  method es_vaga() = self.tiene_menos_de_cien_palabras()

  method empiezan_con(letra) = titulo.startsWith(letra)

  method bien_escrita() = self.titulo_con_dos_palabras() and self.tiene_desarrollo()
  method titulo_con_dos_palabras() = titulo.split("").size() >= 2
  method tiene_desarrollo() = !desarrollo.isEmpty()
}

// tres estilos de noticias

class Comun inherits Noticia {
  var property link_noticia

  override method caso_particular() = link_noticia >= 2
}

class Chivo inherits Noticia {
  var property paga

  override method caso_particular() = paga > 200000000
  override method es_vaga() = true
}

class Reportajes inherits Noticia {
  var property entrevistado

  method nombre_impar() = !entrevistado.size().even()
  override method caso_particular() = self.nombre_impar()

  method es_dibu() = entrevistado.equalsIgnoreCase("Dibu Martinez")
  override method es_sensacionalista() = super() and self.es_dibu()
}

class Cobertura inherits Noticia {
  var property noticias = []

  override method caso_particular() = noticias.all{n => n.es_copada()}
}

class Periodista {
  var property fecha_ingreso
  var property preferencia

  var property noticias_no_preferidas = 0
  var property noticias_publicadas = 0

  method prefiere(noticia) = preferencia.publica(noticia)

  method publicar_noticia(noticia) {
    if(self.pude_publicar()){
      noticias_publicadas += 1
    }
    else noticias_no_preferidas += 1
  }
  method pude_publicar() = not(noticias_no_preferidas < 2)

    method validar_noticia_no_interesada(){
    if(!self.pude_publicar()){
      throw new DomainException (message= "no se puede publicar mas noticias debido a que  supero el limite de noticias")
      }
  }
  method validar_noticia_bien_escrita(noticia){
    if(!noticia.bien_escrita()){
      throw new DomainException(message="La noticia esta mal escrita")
    }
  }
}

class Copada {
  method publica(noticia) = noticia.es_copada()
}

class Sensacionalista {
  method publica(noticia) = noticia.es_sensacionalista()
}

class Vago {
  method publica(noticia) = noticia.es_vaga()
}

const jose_de_zer = new Periodista (fecha_ingreso = new Date(day=1, month=1,year=1970), preferencia = preferencia_de_jose)

object preferencia_de_jose {
  method prefiere(noticia) = noticia.empiezan_con("T")
}

