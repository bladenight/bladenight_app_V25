//This is only an example File
//please setup your own data

///Deeplink server
const String defaultDeepLinkServerAddress = 'https://bladenight.app/deeplink/';

///address for standard encrypted wss connection with participation
///set credentials BasicAuth for App
const String defaultWampAdress = 'wss://bnapp:AppSecurit1@test.de:8091';

///address for test of encrypted wss connection with participation
const String defaultTestWampAdress =
    'wss://bnapp:AppSecurit1@10.10.10.20:8081/ws';

///address for standard unencrypted connection / no participation / no authorization
const String defaultWampClientAux = 'wss://bladenight.app:8092';

///address for standard test of unencrypted connection / no participation / no authorization
const String defaultTestWampClientAux = 'wss://bladenight.app:12345';

///address to receive messages for client
String bladenightMessageServerLink = 'https://bladenight.app/messages_ep';

///address to validate and get information about email hash
String bladenightRestApiServerLink = 'https://bladenight.app/rest/api_ep';

const String certificatePassword = 'changeit';

const String certificateTestPassword = 'changeit';

const String defaultTestCertificate = 'Bladenight.p12';
const String defaultCertificate = 'Bladenight.p12';

const String liveMapLink = 'https://sample.domain/test';

const String testServerAddress = 'wss://key:pass@your.server.de:8081/ws';

//Storelinks
const String playStoreLink = '';
const String iOSAppStoreLink = '';

const String specialCode = 'enterHereACode';
//See Onesignal Config
const String oneSignalAppId = '12345678-1234-5678-1234-123456789123';
