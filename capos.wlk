object rolando {
    const mochila = #{}
    var capacidadMochila = 2
    var casa = castilloDePiedra //es bueno tener como una seleccion para ciertas cosas

    method recolectarArtefacto(artefacto) {
        self.validarRecoleccion()
        mochila.add(artefacto)
    }

    method capacidadMochila(tamaño) { capacidadMochila = tamaño }

    method mochila() { return mochila }

    method validarRecoleccion() {
        if (mochila.size() == capacidadMochila) {
            self.error("La mochila está llena.")
        }
    }

    method casa(_casa) { casa = _casa }


    method irACasa() {
        casa.guardarObjetos(mochila) // evitar referencias globales y dar todo por parametro (sobrediseño)
        mochila.clear()
    }

    method todasLasPosesiones() {
        return mochila + casa.artefactosAlmacenados()
    }

    method tieneArtefacto(artefacto) {
        return self.todasLasPosesiones().contains(artefacto)
    }
}

object castilloDePiedra {
    var artefactosAlmacenados = #{}

    method guardarObjetos(conjunto) {
        artefactosAlmacenados = artefactosAlmacenados + conjunto
    }

    method artefactosAlmacenados() { return artefactosAlmacenados }
 
 }

object espadaDelDestino {
}

object libroDeHechizos {
}

object collarDivino {
}

object armaduraDeAceroValkyrio {
}

