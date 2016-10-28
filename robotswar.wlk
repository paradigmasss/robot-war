class Robot {
	var peso
	var posicion
	var vida
	var armamento
	
	
	constructor(_peso,_posicion,_vida){
		peso = _peso
		posicion = _posicion
		vida = _vida
	}
	method vida()=vida
	method peso()=peso
	
	method armamento(arma){armamento= arma	}
	method armamento()=armamento
	
	method noEstaLejos(unRobot){return true}
	method avanzar(cantidad){posicion = posicion + cantidad}
	
	method mejorarArma(){
		self.armamento().bonus(5)
		
	}
	
	
	method posicion()=posicion
	method posicion(_posicion){posicion = _posicion}
	method distanciaCon(unRobot){
		if(self.posicion()>unRobot.posicion()){
		return self.posicion() - unRobot.posicion()
	}else{
		return unRobot.posicion() - self.posicion()
	}}
	
	method atacar(unRobot){
		if(!self.armamento().noEstaLejos(self,unRobot)){
			if(self.posicion()<unRobot.posicion())
			{self.avanzar(1)}else{self.retroceder(1)}}
			else{
				self.armamento().daniar(self,unRobot)
			}
	}
	
	method recibirAtaque(danio){
		vida = vida - danio
	}
	method retroceder(cantidad){posicion = posicion - cantidad}
	
}


class Chocador  {
	var bonus = 0
	method noEstaLejos(yo,unRobot)= yo.distanciaCon(unRobot) < 4
	method bonus()= bonus
	method bonus(_bonus){bonus += _bonus}
	
	method daniar(yo,unRobot){
		
			if(yo.posicion()<unRobot.posicion()){
			unRobot.recibirAtaque(2+self.bonus())
			unRobot.avanzar(1)
			yo.avanzar(1)
			}else{
				unRobot.recibirAtaque(2+self.bonus())
				unRobot.retroceder(1)
				yo.retroceder(1)		
				}
			}

}


class Disparador {
	
	var potenciaDisparo
	var bonus = 0
	constructor(_potencia){
		
		potenciaDisparo = _potencia
	}
	method noEstaLejos(yo,unRobot)=true
	
	method bonus()= bonus
	method bonus(_bonus){bonus += _bonus}
	
	method daniar(yo,unRobot){
		unRobot.recibirAtaque(potenciaDisparo/yo.distanciaCon(unRobot)+self.bonus())
		
	}
	
	
}

class Volador{
	var distanciaVuelo
	var bonus = 0
	
	constructor(_distancia){
		distanciaVuelo = _distancia
	}
	
	method noEstaLejos(yo,unRobot)=yo.distanciaCon(unRobot)<= distanciaVuelo
	method bonus()= bonus
	method bonus(_bonus){bonus += _bonus}
	
	method daniar(yo,unRobot){
		unRobot.recibirAtaque((unRobot.peso()/10) + self.bonus())
		yo.posicion(unRobot.posicion())
		
	}
	
	
}

class Tochocientos inherits Robot{
	var armas = []
	var puedenAtacar = []
	
	constructor(_peso,_posicion,_vida)=super(_peso,_posicion,_vida)
	
	override method armamento(arma){
		armas.add(arma)
		}
	override method armamento()=armas
	
	override method mejorarArma(){
		self.armamento().map({arma => arma.bonus(5)})
	}
	
	override method atacar(unRobot){
		
		puedenAtacar = self.armamento().filter({arma => arma.noEstaLejos(self,unRobot)})
		puedenAtacar.map({arma => arma.daniar(self,unRobot)})
		
	}
	
	
}
