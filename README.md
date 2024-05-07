# Donate_to_artists_ICP

---
#### Deploy de backend en mainnet
#### https://a4gq6-oaaaa-aaaab-qaa4q-cai.raw.icp0.io/?id=vl6n6-3iaaa-aaaak-qigpa-cai

---
## Manifiesto de la Plataforma

El siguiente manifiesto establece las bases filosóficas y conductuales de la comunidad en relación con la plataforma.

La plataforma se erige como un mecanismo revolucionario que promueve la colaboración directa entre artistas y sus seguidores. Se concibe como un espacio donde artistas de diversas disciplinas puedan registrarse para recibir donaciones, propinas e incluso financiamiento para proyectos de producción musical por parte de los usuarios de la plataforma.

La esencia filosófica que fundamenta esta iniciativa radica en la necesidad de descentralizar el poder de decisión en lo concerniente a los incentivos, el destino del financiamiento y la eliminación de intermediarios, como las compañías discográficas. En este contexto, se reconoce que los verdaderos mecenas de la creatividad son los propios admiradores y seguidores, quienes, mediante su apoyo directo, pueden impulsar el crecimiento y la realización de los artistas.

En nuestra plataforma, se fomenta una cultura de apoyo mutuo, donde la comunidad artística y sus seguidores se conectan de manera auténtica y significativa. Se promueve la transparencia, la equidad y el respeto entre todos los miembros, reconociendo el valor único de cada contribución, ya sea grande o pequeña.

Nos comprometemos a cultivar un entorno inclusivo y diverso, donde todos los artistas, independientemente de su género, origen étnico, orientación sexual o posición socioeconómica, tengan la oportunidad de prosperar y compartir su arte con el mundo. Asimismo, nos comprometemos a proteger la integridad creativa y los derechos de autor de nuestros creadores, asegurando que sus obras sean valoradas y respetadas en todo momento.

En resumen, nuestra plataforma es más que un mero sistema de transacciones financieras; es un movimiento cultural que promueve la democratización del arte y la música, empoderando a los artistas y a sus seguidores para forjar un futuro donde la creatividad florezca libremente y sin barreras.

Únete a nosotros en esta emocionante aventura y sé parte del cambio. Juntos, podemos construir un mundo donde el arte sea verdaderamente accesible y sostenible para todos.

---
## Lógica de negocio y fundamentos de la plataforma

Se establecen inicialmente tres tipos de perfil:

* Perfil de Usuario
* Perfil de Artista
* Perfil de Administrador

los cuales se podrán registrar bajo la siguiente lógica:
* Un usuario podrá registrarse en la plataforma identificandose previamente mediante Internet Identity para luego registrar un nombre de usuario, un email, y opcionalmente una imagen de perfil.
###
* La verificacion de un Usuario se concreta mediante un mecanismo de validación de contacto, el cuál consistirá en principio en el email que haya indicado en el registro.
Dicho contacto se validará mediante el envio de un código de verificacion desde la plataforma hacia ese contacto, para luego ser contrastado dicho código de verificación con el código que el usuario indique haber recibido.
### 
* Un artista podrá registrarse bajo el rol de Artista habiendose registrado previamente como Usuario verificado, y completando un formulario de registro, el cual posteriormente será evaluado por la administración.
###
* El primer administador de la plataforma será el deployer del Canister backend, y en calidad de administrador podrá agregar a otros administradores con la sola condición de que éstos estén registrados como usuarios. Los administradores también podrán agregar a otros administradores con la misma condición, pero la exclusividad de eliminar administradores será del deployer del canister y éste no podrá eliminarse a si mismo.

