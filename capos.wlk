object rolando {
    const mochila = #{}
    var property capacidadMochila = 2
    var property casa = castilloDePiedra //es bueno tener como una seleccion para ciertas cosas
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

        self.recolectarArtefacto(artefacto)
    }

    method recolectarArtefacto(artefacto) {
        if (self.mochila().size() < self.capacidadMochila()) {
            artefacto.portador(self)
            mochila.add(artefacto)
        }
    }

    method historialDeArtefactosEncontrados() { return artefactosEncontrados }

    method mochila() { return mochila }

    method batallas() { return batallas }

    method irACasa() {
        casa.guardarArtefactos(mochila) // evitar referencias globales y dar todo por parametro (sobrediseño)
        mochila.clear()
    }

    method todasLasPosesiones() {
        return mochila + casa.artefactosAlmacenados()
    }

    method tieneArtefacto(artefacto) {
        return self.todasLasPosesiones().contains(artefacto)
    }

    method artefactoMasPoderosoEnPosesion() {
        return casa.artefactoMasPoderoso()
    }
}

object castilloDePiedra {
    var artefactosAlmacenados = #{}

    method guardarArtefactos(conjunto) {
        artefactosAlmacenados = artefactosAlmacenados + conjunto
    }

    method artefactosAlmacenados() { return artefactosAlmacenados }
 
    method artefactoMasPoderoso() {
        return artefactosAlmacenados.filter({ artefacto1, artefacto2 => artefacto1.poderDePelea() > artefacto2.poderDePelea() })
    }
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
    var hechizos = [bendicion, invisibilidad, invocacion]

    method poderDePelea() {
        hechizos.first().usuario(portador)
        
        return hechizos.first().poderDePelea()
        hechizos.remove(hechizos.first())
    }

    method portador(_portador) { portador = _portador }

    method hechizos(_hechizos) {
        hechizos = _hechizos
    }
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

//hechizos
object bendicion {
    var usuario = rolando

    method poderDePelea() { return 4 }

    method usuario(_usuario) { usuario = _usuario }
}

object invisibilidad {
    var usuario = rolando

    method poderDePelea() { return usuario.poderDePelea() }

    method usuario(_usuario) { usuario = _usuario }
}

object invocacion {
    var usuario = rolando

    method poderDePelea() {
        return usuario.artefactoMasPoderosoEnPosesion().poderDePelea()
    }

    method usuario(_usuario) { usuario = _usuario }
}