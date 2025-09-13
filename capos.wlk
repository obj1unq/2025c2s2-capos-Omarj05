object rolando {
    const mochila = #{}
    var property capacidadMochila = 2
    var casa = castilloDePiedra //es bueno tener como una seleccion para ciertas cosas
    const artefactosEncontrados = []
    var property poderBase = 5
    var batallas = 0

    method batallar() {
        batallas += 1
        poderBase += 1
    }

    method poderDePelea() {
        return poderBase + self.poderDeLosArtefactos()
    }

    method poderDeLosArtefactos() {
        return mochila.sum( {artefacto => artefacto.poderDePelea()} )
    }

    method encontrarArtefacto(artefacto) {
        artefactosEncontrados.add(artefacto)
        artefacto.portador(self)

        self.recolectarArtefacto(artefacto)
    }

    method recolectarArtefacto(artefacto) {
        if (self.mochila().size() < self.capacidadMochila()) {
            mochila.add(artefacto)
        }
    }

    method historialDeArtefactosEncontrados() { return artefactosEncontrados }

    method mochila() { return mochila }

    method casa(_casa) { casa = _casa }
    method batallas() { return batallas }

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
    var portador = rolando
    

    method poderDePelea() {
        return if (portador.batallas() == 0 ) { portador.poderBase() } else { portador.poderBase() / 2 }
    }

    method portador(_portador) { portador = _portador }
}

object libroDeHechizos {
    var portador = rolando
    var hechizos = [self.bendicion(), self.invisibilidad(), self.invocacion()]

    method bendicion() { return 4 }

    method invisibilidad() { return portador.poderDePelea() }

    method invocacion() {
        return //filtrar 
    }

    method poderDePelea() {
        return 0
    }

    method portador(_portador) { portador = _portador }
}

object collarDivino {
    var portador = rolando

    method poderDePelea() {
        return if (portador.poderBase() < 6) { 3 } else { 3 + portador.batallas() }
    }

    method portador(_portador) { portador = _portador }
}

object armaduraDeAceroValkyrio {
    var portador = rolando
    const property poderDePelea = 6

    method portador(_portador) { portador = _portador }
}

