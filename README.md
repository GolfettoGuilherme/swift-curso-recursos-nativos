#  Curso Recursos Nativos Swift

Nesse curso estou estudando:

## Como utilizar a câmera/biblioteca de fotos do iOS

Usando o UIImagePickerController para abrir a camera do app ou a biblioteca de fotos do device e fazer o upload da foto

## Persistir objetos com o Core Data

Usando o tal do Core Data, salvo um objeto na memória do device

Busco da memoria esses objetos para a listagem em tela (inclusive a imagem)


## Menus de Contexto

Aqui usei o UIAlertController para criar um menu no LongPress de cada elemento da agenda para selecionar as opções abaixo

### Envio SMS a partir do app

Criei um componente de Mensagem (usando o MFMessageComposeViewController) para possibilitar o envio de mensagem SMS pelo app

(não é envio de verdade, eu só abro o app de mensagens que faz o envio, mas você entendeu vai)

### Ligação telefônica no app

Esse foi facil, abrir a tela de Telefone do iPhone usando o UIApplication.

Nisso ja deu pra entender um pouquinho de DeepLinks 


### Trabalhar com localização e mapa

Esse foi legal de fazer, aprendi a abrir um endereço tanto no Waze, quanto no próprio mapa dentro do app

No Waze foi a mesma pegada de DeepLink de antes, agora no app, criei um Mapa num Controller.

Dai coloquei o ponto de interesse como um MKPointAnnotation e deixei um local fixo como ponto inicial (ainda vamos ver como colocar mais pontos e customizar o role)

O legal do mapa é que como funcionam com Latitude e Longitude, então foi necessário converter o endereço para os pontos de lat e lng para colocar no mapa

da hora né

### Abrindo um site via Safari

No cadastro de aluno, existe o campo site né? então.

Desenvolvemos uma opção no menu de contexto para abrir o site do aluno no Safari do iOS.

mas não saindo do app, não

usando o SafariServices para mostrar o site do aluno dentro do app.

Top

## Autenticação Local

Usar o FaceId, ou TouchID ou CodigoID para realizar uma ação somente pelo usuario do aparelho.

usando o LocalAuthentication para isso, com closures. bem da hora


## Usando o 3D Touch para fazer atalhos no aplicativo

Setando no Info.plist duas chavinhas para configurar os atalhos via 3D

Depois atribuindo o clique do atalho a uma View do aplicativo


## Icone

Por fim, aprendemos a definir um icone bonito para a aplicação para não ficar naquele genérico da apple.


## Sincronização via Web Services

Adicionei nesse projeto uma pasta de nome `server` onde existe uma aplicação Java para servir de Web Service pro projeto e gerenciar os alunos

### para executar o servidor

basta abrir a pasta `server` e rodar o comando: `java -jar server.jar`

## Alamofire

Aqui aprendemos a instalar o Alamofire para lidar com as requisições HTTP que o aplicativo precisa fazer para o servidor.
Aprendemos os metodos: GET, POST, PUT e DELETE

## Sincronização Offline e Online

Caso durante algum momento o app não consiga se conectar ao servidor (seja por estar longe de um WIFI ou o servidor estar desligado), mantemos os alunos salvos pelo CoreData e sincronizamos com o servidor as mudanças sempre que o app volta a estar em evidencia no dispositivo, método: `applicationDidBecomeActive`



é nois
Fechou Balada
