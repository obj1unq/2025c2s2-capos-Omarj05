object rolando {
    const mochila = #{}
    var property capacidadMochila = 2
    var property casa = castilloDePiedra //es bueno tener como una seleccion para ciertas cosas
    const artefactosEncontrados = []
    var property poderBase = 5
    var batallas = 0

    method batallar() {
        self.verificarContenidoEnMochila() //no se si esta bien 
        batallas += 1
        poderBase += 1
    }

    method verificarContenidoEnMochila() {
        if (mochila.contains(libroDeHechizos)) {
            libroDeHechizos.removerHechizoActual()
        }
    }

    method poderDePelea() {
        return poderBase + self.poderDeLosArtefactos()
    }

    method poderDeLosArtefactos() {
        return mochila.sum( {artefacto => artefacto.poderDePelea()} )
    }

    method recolectarArtefacto(artefacto) {
        artefactosEncontrados.add(artefacto)
        
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

    method poseeArtefacto(artefacto) {
        return self.todasLasPosesiones().contains(artefacto)
    }

    method artefactoMasPoderosoEnPosesion() {
        return casa.artefactoMasPoderoso()
    }

    method enemigosDerrotables() {
        return self.enemigosCombatibles().filter({enemigo => enemigo.puedeSerDerrotadoPorPersonaje(self)})
    }

    method moradasConquistables() {
        return self.enemigosDerrotables().map({ enemigo => enemigo.morada() })
    } 

    method esPoderoso() {
        return self.enemigosDerrotables() == self.enemigosCombatibles()

    }

    method enemigosCombatibles() { return #{caterina, archibaldo, astra} }

    method tieneArtefactoFatalParaEnemigo(enemigo) {
        return mochila.any({ artefacto => artefacto.esFatalParaEnemigo(enemigo) })
    }

    method artefactoFatalParaEnemigo(enemigo) {
        if (self.tieneArtefactoFatalParaEnemigo(enemigo)) {
            
            return mochila.filter({ artefacto => artefacto.esFatalParaEnemigo(enemigo) }).anyOne()
        }
        else {
            return "No posee un artefacto fatal para dicho enemigo."
        }
    }
}

object castilloDePiedra {
    var artefactosAlmacenados = #{}

    method guardarArtefactos(conjunto) {
        artefactosAlmacenados = artefactosAlmacenados + conjunto
    }

    method artefactosAlmacenados() { return artefactosAlmacenados }
 
    method artefactoMasPoderoso() {
        const artefactosOrdenadosPorPoderDePelea = artefactosAlmacenados.asList()
        artefactosOrdenadosPorPoderDePelea.sortBy({ 
            artefacto1, artefacto2 => artefacto1.poderDePelea() > artefacto2.poderDePelea() 
        })
        
        return artefactosOrdenadosPorPoderDePelea.first()
    }
 }

object espadaDelDestino {
    var portador = rolando
    

    method poderDePelea() {
        return if (portador.batallas() == 0 ) { portador.poderBase() } else { portador.poderBase() / 2 }
    }

    method portador(_portador) { portador = _portador }

    method esFatalParaEnemigo(enemigo) {
        return self.poderDePelea() >= enemigo.poderDePelea()
    }
}

object libroDeHechizos {
    var portador = rolando
    var hechizos = [bendicion, invisibilidad, invocacion]

    method poderDePelea() {
        return if (self.tieneHechizos()) { hechizos.first().poderDePelea() } else { 0 }
    }

    method portador(_portador) { 
        portador = _portador 
        hechizos.forEach({ hechizo => hechizo.usuario(_portador) })
    }

    method hechizos(_hechizos) {
        hechizos = _hechizos
    }

    method removerHechizoActual() {
        if (self.tieneHechizos()) {
            hechizos.remove(hechizos.first())
        }
    }

    method esFatalParaEnemigo(enemigo) {
        return self.poderDePelea() >= enemigo.poderDePelea()
    }

    method tieneHechizos() { return not (hechizos == []) }

    method hechizos() { return hechizos }
}

object collarDivino {
    var portador = rolando

    method poderDePelea() {
        return if (portador.poderBase() < 6) { 3 } else { 3 + portador.batallas() }
    }

    method portador(_portador) { portador = _portador }

    method esFatalParaEnemigo(enemigo) {
        return self.poderDePelea() >= enemigo.poderDePelea()
    }
}

object armaduraDeAceroValkyrio {
    var portador = rolando
    const property poderDePelea = 6
    
    method portador(_portador) { portador = _portador }

    method esFatalParaEnemigo(enemigo) {
        return self.poderDePelea() >= enemigo.poderDePelea()
    }
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

//enemigos
object caterina {
    const property poderDePelea = 28
    const property morada = fortalezaDeAcero

    method puedeSerDerrotadoPorPersonaje(personaje) {
        return personaje.poderDePelea() > self.poderDePelea()
    }
}

object archibaldo {
    const property poderDePelea = 16
    const property morada = palacioDeMarmol

    method puedeSerDerrotadoPorPersonaje(personaje) {
        return personaje.poderDePelea() > self.poderDePelea()
    }
}

object astra {
    const property poderDePelea = 14
    const property morada = torreDeMarfil

    method puedeSerDerrotadoPorPersonaje(personaje) {
        return personaje.poderDePelea() > self.poderDePelea()
    }
}

//morada de enemigos
object fortalezaDeAcero {
}

object palacioDeMarmol {
}

object torreDeMarfil {
}