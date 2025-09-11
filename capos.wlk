object rolando {
    const mochila = #{}
    var capacidadMochila = 2

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

    method irAlCastillo() {
        castilloDePiedra.guardarObjetos(mochila)
        mochila.clear()
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

