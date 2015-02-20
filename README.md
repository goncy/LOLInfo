# LOLInfo

Bienvenidos a LOLInfo! // Welcome to LOLInfo!

LOLInfo es un buscador de partidas activas programado en AS3, incluye tambien busqueda de builds, counters, informacion de invocador, rankeds, etc, todo esto ultimo (actualmente) redireccionado a los motores mas conocidos como LOLKing (mientras sigamos con una api de development, pero la idea es seguir asi un tiempo ya que la gente esta acostumbrada y se siente comoda con esto).

# ¿Por que LOLInfo y no un servicio online?
Bueno, LOLInfo es una aplicacion de escritorio, que a pesar de basar sus llamados a la API de Riot Games, tiene mucha informacion, desde imagenes a informacion estatica integrado en su codigo, por lo que es menos informacion que hay que cargar cada vez que se hace una busqueda, haciendolo asi mas rapido.

# ¿Pero basandose en eso, es lo mismo?
Segun como lo mires, LOLInfo hace un pequeño rejunte de las cosas que a mi punto de vista son importantes, como por ejemplo: El puntaje se basa en estadisticas generales (en ranked) de cada invocador, y no con el campeon con el que este jugando en ese momento, lo que permite tomar mas estrategias a la hora de jugar. No se carga toda la informacion junta, normalmente cuando queremos saber la informacion de la partida activa, tanto de compañeros como de enemigos, miramos las cosas basicas, division, partidas ganadas/perdidas etc. Por lo que mostrar tanta informacion junta lo haria (a mi punto de vista) irrelevante, PERO, se puede ampliar la informacion una vez que se busco la partida, por si acaso de que quieras ver la info completa.

# ¿Y algo que sea exclusivo de LOLInfo?
Si. Hay una comunidad que esta activa en Facebook, por lo que decidi activar un sitema de "Badges", donde se reconoce a distintos invocadores con una especie de medalla para gente que haya, colaborado, estado muy activa, este hace mucho tiempo, etc etc. Los Badges se sortean en facebook como premios para la comunidad por lo que capaz cuando busques una partida encuentre a un compañero o enemigo de la comunidad y puedas entablar una conversacion, tanto dentro como fuera de la partida.

# ¿Como se obtiene la informacion de la API de Riot?
En primero punto se le pide al usuario que ingrese un nombre de invocador y realm a buscar, en base a eso el proceso es:

Usuario (Nombre de invocador, Realm) -> Riot
Riot (ID De invocador) -> Usuario (Informacion)
Usuario (ID De invocador) -> Riot
Riot -> Usuario (Informacion de Liga)

Usuario (Toda la info) -> LOLInfo
LOLInfo (Parseo de datos) -> Usuario

# ¿Donde la puedo descargar?
La aplicación no es descargable para uso cotidiano, pero en caso de que seas un Tester o alguien de Riot se puede extender una beta.

Con todo esto dicho, te espero en:
https://www.facebook.com/LOLInfoGonzaloPozzo?ref=bookmarks
