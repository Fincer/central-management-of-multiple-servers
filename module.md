# Kurssimoduuli

- Linkki moduuliin: [Fincer-altego - Salt, GIS Workstation](https://github.com/Fincer-altego/salt_gisworkstation)

Tämä kurssimoduuli on tehty osana Haaga-Helian Tietojenkäsittelyn koulutusohjelman kurssia [Palvelinten hallinta (ICT4TN022, kevät 2018)](http://www.haaga-helia.fi/fi/opinto-opas/opintojaksokuvaukset/ICT4TN022).

Kurssimoduuli käsittelee SaltStack:n käyttöä usean tietokoneen työympäristössä. Yksinkertaistettuna periaatteena yksi tietokone toimii Master-roolissa, ja käskyttää kytkennässä olevia, Minion-roolissa olevia tietokoneita ohjelmien konfiguraatioiden, asennusten, käyttäjänhallinnan jne. suhteen.

## SISÄLLYSLUETTELO

- [Järjestelmävaatimukset](https://github.com/Fincer-altego/central-management-of-multiple-servers/blob/master/module.md#j%C3%A4rjestelm%C3%A4vaatimukset)

    - [Moduulin toteutusperiaatteista](https://github.com/Fincer-altego/central-management-of-multiple-servers/blob/master/module.md#moduulin-toteutusperiaatteista)

- [Moduulin shell-skriptivaatimukset](https://github.com/Fincer-altego/central-management-of-multiple-servers/blob/master/module.md#moduulin-shell-skriptivaatimukset)

- [Asennettavat ohjelmat](https://github.com/Fincer-altego/central-management-of-multiple-servers/blob/master/module.md#asennettavat-ohjelmat)

- [Asennettavat binääritiedostot](https://github.com/Fincer-altego/central-management-of-multiple-servers/blob/master/module.md#asennettavat-bin%C3%A4%C3%A4ritiedostot)

- [Asennettavat konfiguraatiot](https://github.com/Fincer-altego/central-management-of-multiple-servers/blob/master/module.md#asennettavat-konfiguraatiot)

- [Moduulin rakenne](https://github.com/Fincer-altego/central-management-of-multiple-servers/blob/master/module.md#moduulin-rakenne)

- [Moduulin ajo](https://github.com/Fincer-altego/central-management-of-multiple-servers/blob/master/module.md#moduulin-ajo)

- [Miltä näyttää minion-koneilla?](https://github.com/Fincer-altego/central-management-of-multiple-servers/blob/master/module.md#milt%C3%A4-n%C3%A4ytt%C3%A4%C3%A4-minion-koneilla)

- [Huomioita moduulin ajosta](https://github.com/Fincer-altego/central-management-of-multiple-servers/blob/master/module.md#huomioita-moduulin-ajosta)

- [Moduulin hyvät puolet](https://github.com/Fincer-altego/central-management-of-multiple-servers/blob/master/module.md#moduulin-hyv%C3%A4t-puolet)

- [Moduulin huonot puolet](https://github.com/Fincer-altego/central-management-of-multiple-servers/blob/master/module.md#moduulin-huonot-puolet)

- [Moduulin kehittämistarpeet](https://github.com/Fincer-altego/central-management-of-multiple-servers/blob/master/module.md#moduulin-kehitt%C3%A4mistarpeet)

-------------------

## Aihe

Moduulin aihekuvaus löytyy [harjoituksen 6 yhteydestä](https://github.com/Fincer-altego/central-management-of-multiple-servers/blob/master/h6.md#c-k%C3%A4ytt%C3%A4j%C3%A4tarina-user-story-ketk%C3%A4-ovat-modulisi-k%C3%A4ytt%C3%A4j%C3%A4t-mit%C3%A4-he-haluavat-saada-aikaan-modulillasi-miss%C3%A4-tilanteessa-he-sit%C3%A4-k%C3%A4ytt%C3%A4v%C3%A4t-mitk%C3%A4-ovat-t%C3%A4rkeimm%C3%A4t-parannukset-k%C3%A4ytt%C3%A4j%C3%A4n-kannalta-joita-moduliin-pit%C3%A4isi-viel%C3%A4-tehd%C3%A4-t%C3%A4h%C3%A4n-c-kohtaan-vain-sanallinen-vastaus-t%C3%A4m%C3%A4-kohta-ei-poikkeuksellisesti-edellyt%C3%A4-testej%C3%A4-tietokoneella)

*"Moduuli on tarkoitettu pieneen käyttöympäristöön (suuruusluokka 7-13 konetta) paikkatiedon prosessointiin. Moduulin käyttäjät koostuvat paikkatietoasiantuntijoista, jotka haluavat saada avoimen lähdekoodin paikkatietotyökaluja."*

*"Käyttötarkoitus rajautuu asennettavien ohjelmien mukaan: LASTools, QGIS, gpsbabel, CloudCompare jne. Näitä ohjelmia käytetään rasteri- ja vektorimuotoisten paikkatietoaineistojen sekä laserkeilausaineistojen prosessointiin sekä analytiikkaan."*

-------------------

## Järjestelmävaatimukset

Moduuli edellyttää tietokoneiden käyttöjärjestelmiltä seuraavia vaatimuksia.

- Salt Master -tietokone: Ubuntu 18.04 LTS tai variantti

- Salt Minions -tietokoneet:
    - Ubuntu 18.04 LTS tai variantti
    - Microsoft Windows (versio 7 testattu)

### Moduulin toteutusperiaatteista

- Salt Masteria ei ole kokeiltu Microsoft Windowsilla, vaan se on toteutettu kohdistuneena asennuksena yksinoikeudella Linux Ubuntu 18.04 LTS -käyttöjärjestelmälle. 

- Tavoitteena on ollut mahdollisimman automatisoitu asennustoimenpide, joka voidaan suorittaa "tyhjille" käyttöjärjestelmille kylmiltään. 

- Moduulin ajaminen on tarkoitettu tapahtuvaksi pääsääntöisesti yhdellä komennolla (pois lukien minion-koneiden esikonfigurointi).

-------------------

## Moduulin shell-skriptivaatimukset

Moduuli tukeutuu vahvasti Unix-ympäristöjen Bash-shelliin, mitä vaaditaan moduulin onnistuneessa ajosuorituksessa.

Moduulin mukana tulevissa shell-skripteissä on lisäksi määritelty lisävaatimuksia ajoympäristön suhteen. Näitä vaatimuksia ovat mm.:

- kriittisten binäärien olemassaolo Salt Master -tietokoneella

- verkkoyhteyden saatavuus

- moduuli ajettava pääkäyttäjän oikeuksin

- Minioneiden käyttöjärjestelmään, yhteyteen ja raportoituun tilaan liittyvät määrittelyt

- jne.

-------------------

## Asennettavat ohjelmat

Moduuli asentaa alla luetellut ohjelmat Microsoft Windows - ja Linux Ubuntu 18.04 LTS -käyttöympäristöihin.

### Microsoft Windows

- [Visual Runtime 2013](https://www.microsoft.com/en-us/download/details.aspx?id=40784)

- [CloudCompare](cloudcompare.org)

- [Merkaartor](merkaartor.be)

    - Kuvaus: *"map editor for OpenStreetMap.org"*

- [QGIS](qgis.org)

    - Kuvaus: *"A Geographic Information System (GIS) manages, analyzes, and displays databases of geographic information."*

- [QuickRoute GPS](http://www.matstroeng.se/quickroute/en/)

    - Kuvaus: *"GPS analysis software for getting your route on the map"*

- Ohjelmaa [GPSd](https://code.google.com/archive/p/gpsd-4-win/) ei onnistuttu asentamaan automaattisesti MS Windows -alustalle. Ohjelmakuvaus löytyy seuraavan otsikon alta.

### Linux Ubuntu 18.04 LTS

- [cloudcompare](cloudcompare.org)

    - Kuvaus: *"3D point cloud and mesh processing software"*

- [gpx2shp](gpx2shp.osdn.jp)

    - Kuvaus: *"convert GPS or GPX file to ESRI Shape file"*

- [rel2gpx](https://directory.fsf.org/wiki/Rel2gpx)

    - Kuvaus: *"create GPX-track from OSM relation"*

- [quickroute-gps](http://www.matstroeng.se/quickroute/en/)

    - Kuvaus: *"GPS analysis software for getting your route on the map"*

- [python-gpxpy](https://github.com/tkrajina/gpxpy)

    - Kuvaus: *"GPX file parser and GPS track manipulation library (Python 2)"*

- [obdgpslogger](https://github.com/oesmith/obdgpslogger)

    - Kuvaus: *"suite of tools to log OBDII and GPS data"*

- [merkaartor](merkaartor.be)

    - Kuvaus: *"map editor for OpenStreetMap.org"*

- [gpsbabel](gpsbabel.org)

    - Kuvaus: *"GPS file conversion plus transfer to/from GPS units"*

- [gpsbabel-gui](gpsbabel.org)

    - Kuvaus: *" GPS file conversion plus transfer to/from GPS units - GUI"*

- [gis-gps]( https://pkg-grass.alioth.debian.org/)

    - Kuvaus: *"GPS related programs"*

- [qgis](qgis.org)

    - Kuvaus: *"A Geographic Information System (GIS) manages, analyzes, and displays databases of geographic information."*

- [qgis-server](qgis.org)

    - Kuvaus: *"QGIS server providing various OGC services"*

- [qgis-providers](qgis.org)

    - Kuvaus: *"collection of data providers to QGIS"*

- [qgis-plugin-grass](qgis.org)

    - Kuvaus: *"GRASS plugin for QGIS"*

- [gpsd](http://www.catb.org/gpsd/)

    - Kuvaus: *"The gpsd service daemon can monitor one or more GPS devices connected to a host computer, making all data on the location and movements of the sensors available to be queried on TCP port 2947."*

## Asennettavat binääritiedostot

Moduuli asentaa seuraavat suoritettavat tiedostot Microsoft Windows - ja Linux Ubuntu 18.04 LTS -käyttöympäristöihin.

### Microsoft Windows

LAStools - yhteensä 49 suoritettavaa tiedostoa. Osa on suljettua lähdekoodia, osa avointa.

Nämä tiedostot asennetaan Salt minion-koneen järjestelmäpolkuun C:\lastools\

- las2las

- las2txt

- lasdiff

- lasindex

- lasinfo

- lasmerge

- lasprecision

- laszip

- txt2las

- blast2dem

- blast2iso

- bytecopy

- bytediff

- e572las

- las2dem

- las2iso

- las2shp

- las2tin

- lasboundary

- lascanopy

- lasclassify

- lasclip

- lascolor

- lascontrol

- lascopy

- lasduplicate

- lasgrid

- lasground

- lasground_new

- lasheight

- laslayers

- lasnoise

- lasoptimize

- lasoverage

- lasoverlap

- lasplanes

- laspublish

- lasreturn

- lassort

- lassplit

- lasthin

- lastile

- lastool

- lastrack

- lasvalidate

- lasview

- lasvoxel

- shp2las

- sonarnoiseblaster

- Lisäksi asennetaan suoritettava tiedosto gpx2shp.exe, myös polkuun C:\lastools\

### Linux Ubuntu 18.04 LTS

LAStools - yhteensä 9 suoritettavaa tiedostoa. Kaikki ovat avointa lähdekoodia.

Nämä tiedostot asennetaan Salt minion -koneen järjestelmäpolkuun /usr/local/bin/

- las2las

- las2txt

- lasdiff

- lasindex

- lasinfo

- lasmerge

- lasprecision

- laszip

- txt2las

-------------------

## Asennettavat konfiguraatiot

Seuraavat muutostoimenpiteet on toteutettu Salt:n _file.managed_ -toiminnolla eli tiedoston korvauksella.

### Microsoft Windows

- QGIS -konfiguraatio, joka kytkee QGIS-ohjelmasta automaattisesti päälle laserkeilausdatan prosessoinnissa tarvittavat LAStools -työkalut, jotka on asennettu järjestelmäkansioon C:\lastools\

    - QGIS käyttää Windowsissa käyttäjäkohtaisia rekisteriavaimia ohjelma-asetusten muutoksiin. Ohjelman kehittäjien maililistoja ja ohjelmarakennetta tutkimalla tulin johtopäätökseen, jossa ainoa ratkaisu konfiguroida LAStools päälle QGIS:stä automaattisesti ilman käyttäjän toimenpiteitä on tehdä muutokset ohjelman käyttämään [LidarToolsAlgorithmProvider.py](https://searchcode.com/file/115836660/python/plugins/processing/algs/lidar/LidarToolsAlgorithmProvider.py) -tiedostoon. Globaalia konfiguraatiotiedostoa (.conf, .ini tms.) ei ohjelmalle näytä olevan Windows-ympäristössä.
    
    ![lastool-pydiffs](https://raw.githubusercontent.com/Fincer-altego/central-management-of-multiple-servers/master/images/saltstack_module/lastool-py_diffs.png)
    
    *LidarToolsAlgorithmProvider.py -tiedostoon toteutetut muutokset oikealla*

### Linux Ubuntu 18.04 LTS

- Sama QGIS-konfiguraatio kuin Windowsissa (kuvailtu ylhäällä)

    - Linux-ympäristössä QGIS kirjoittaa Windows-rekisterin sijaan asetustiedostot oletuksena tiedostoon $HOME/.config/QGIS/QGIS2.conf. Linux:ssa QGIS kirjoittaa myös tiedoston /etc/default/qgis, jota muuttamalla en saanut LAStools-työkaluja kytkettyä päälle. Päädyin yhteneväisyyden ja konfiguraation minimoimisen takia käyttämään samaa muokattua [LidarToolsAlgorithmProvider.py](https://searchcode.com/file/115836660/python/plugins/processing/algs/lidar/LidarToolsAlgorithmProvider.py) -tiedostoa myös Linux-ympäristössä
    
-------------------

## Moduulin rakenne

Moduuli sisältää seuraavat tiedostot saatavilla GitHub-varastosta [Fincer-altego - salt_gisworkstation](https://github.com/Fincer-altego/salt_gisworkstation).

| Data | Kuvaus |
|--------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [saltscripts](https://github.com/Fincer-altego/salt_gisworkstation/tree/master/saltscripts) | Alaskriptien pääkansio |
| [saltscripts/1-setup-salt-env.sh](https://github.com/Fincer-altego/salt_gisworkstation/blob/master/saltscripts/1-setup-salt-env.sh) | Alaskripti - esiasenna Salt Master & Salt Minion nykyiselle tietokoneelle |
| [saltscripts/2-get-programs-on-master.sh](https://github.com/Fincer-altego/salt_gisworkstation/blob/master/saltscripts/2-get-programs-on-master.sh) | Alaskripti - asenna ja lataa vaadittava ympäristö GIS-ohjelmien asentamiseen minion-tietokoneille |
| [sample_images](https://github.com/Fincer-altego/salt_gisworkstation/tree/master/sample_images) | Esimerkkikuvien pääkansio |
| [sample_images/screen_ubuntu-final.png](https://github.com/Fincer-altego/salt_gisworkstation/blob/master/sample_images/screen_ubuntu-final.png) | Esimerkkikuva - Salt:n tilan ajonjälkeinen tilanne Lubuntu 18.04 LTS -minion-tietokoneella |
| [sample_images/screen_ubuntu-master-final.png](https://github.com/Fincer-altego/salt_gisworkstation/blob/master/sample_images/screen_ubuntu-master-final.png) | Esimerkkikuva - Salt:n tilan ajonjälkeinen tilanne Lubuntu 18.04 LTS -master-tietokoneella |
| [sample_images/screen_windows-final.png](https://github.com/Fincer-altego/salt_gisworkstation/blob/master/sample_images/screen_windows-final.png) | Esimerkkikuva - Salt:n tilan ajonjälkeinen tilanne MS Windows 7 -minion-tietokoneella |
| [sample_images/screen_windows-final-2.png](https://github.com/Fincer-altego/salt_gisworkstation/blob/master/sample_images/screen_windows-final-2.png) | Esimerkkikuva - Salt:n tilan ajonjälkeinen tilanne MS Windows 7 -minion-tietokoneella |
| [srv_pillar](https://github.com/Fincer-altego/salt_gisworkstation/tree/master/srv_pillar) | Pääkansio, josta tuotetaan Salt Master -tietokoneen järjestelmäkansio /srv/pillar |
| [srv_pillar/top.sls](https://github.com/Fincer-altego/salt_gisworkstation/blob/master/srv_pillar/top.sls) | Salt Master -tietokoneella sijaitsevan Salt:n pilarirakenteen päällimmäinen tilatiedosto |
| [srv_pillar/stones.sls](https://github.com/Fincer-altego/salt_gisworkstation/blob/master/srv_pillar/stones.sls) | Salt Master -tietokoneella sijaitsevan Salt:n pilarirakenteen sekundaarinen stones-tilatiedosto |
| [srv_salt](https://github.com/Fincer-altego/salt_gisworkstation/tree/master/srv_salt) | Pääkansio, josta tuotetaan Salt Master -tietokoneen järjestelmäkansio /srv/salt |
| [srv_salt/top.sls](https://github.com/Fincer-altego/salt_gisworkstation/blob/master/srv_salt/top.sls) | Salt Master -tietokoneella sijaitsevan Salt:n Master -palvelun päällimmäinen tilatiedosto |
| [srv_salt/stone_file](https://github.com/Fincer-altego/salt_gisworkstation/tree/master/srv_salt/stone_file) | Salt Master -tietokoneelle tuotettava kansiopolku /srv/salt/stone_file (liittyy pilarin stones-tilaan) |
| [srv_salt/stone_file/init.sls](https://github.com/Fincer-altego/salt_gisworkstation/blob/master/srv_salt/stone_file/init.sls) | Salt Master -tietokoneelle tuotettavan tilan /srv/salt/stone_file päällimmäinen tilatiedosto |
| [srv_salt/stone_file/granite.txt](https://github.com/Fincer-altego/salt_gisworkstation/blob/master/srv_salt/stone_file/granite.txt) | Salt Master -tietokoneelle tuotettavan Salt-tilan stone_file muottitiedosto minion-tietokoneille |
| [srv_salt/gis_windows](https://github.com/Fincer-altego/salt_gisworkstation/tree/master/srv_salt/gis_windows) | Salt Master -tietokoneelle osoitettu Salt:n tilakansio gis_windows, jonka sisällä on määritelty MS Windows -Salt-minion -koneille kohdistetut muutokset |
| [srv_salt/gis_windows/init.sls](https://github.com/Fincer-altego/salt_gisworkstation/blob/master/srv_salt/gis_windows/init.sls) | Salt:n kansion gis_windows päällimmäinen Salt-tilatiedosto |
| [srv_salt/gis_ubuntu-1804](https://github.com/Fincer-altego/salt_gisworkstation/tree/master/srv_salt/gis_ubuntu-1804) | Salt Master -tietokoneelle osoitettu Salt:n tilakansio gis_ubuntu-1804, jonka sisällä on määritelty Ubuntu 18.04 LTS -Salt-minion -koneille kohdistetut muutokset |
| [srv_salt/gis_ubuntu-1804/init.sls](https://github.com/Fincer-altego/salt_gisworkstation/blob/master/srv_salt/gis_ubuntu-1804/init.sls) | Salt:n kansion gis_ubuntu-1804 päällimmäinen Salt-tilatiedosto |
| [srv_salt/common/qgis_lastools](https://github.com/Fincer-altego/salt_gisworkstation/tree/master/srv_salt/common/qgis_lastools) | Salt Master -tietokoneelle generoitava kansiopolku /srv/salt/common/qgis_lastools, jonka sisällä on määritelty [QGIS -ohjelmaa](https://qgis.org/) koskevat muutostiedostot minion-tietokoneille |
| [srv_salt/common/qgis_lastools/LidarToolsAlgorithmProvider.py](https://github.com/Fincer-altego/salt_gisworkstation/blob/master/srv_salt/common/qgis_lastools/LidarToolsAlgorithmProvider.py) | Salt Minion -tietokoneille osoitettu, QGIS:n moduulia [LAStools](https://rapidlasso.com/lastools/) koskeva GPL-lisensoitu [Python-kooditiedosto](https://searchcode.com/file/115836660/python/plugins/processing/algs/lidar/LidarToolsAlgorithmProvider.py) |
| [srv_salt_winrepo](https://github.com/Fincer-altego/salt_gisworkstation/tree/master/srv_salt_winrepo) | Salt Master -tietokoneelle luotava kansiopolku /srv/salt/winrepo, johon tuotetaan MS Windows -ohjelmien asennuspakettien vaatimat Salt-tilatiedostot |
| [srv_salt_winrepo/cloudcompare.sls](https://github.com/Fincer-altego/salt_gisworkstation/blob/master/srv_salt_winrepo/cloudcompare.sls) | [CloudCompare -ohjelman](cloudcompare.org) asennusta koskeva Salt-tilatiedosto MS Windows -minion-tietokoneille |
| [srv_salt_winrepo/gpsd.sls](https://github.com/Fincer-altego/salt_gisworkstation/blob/master/srv_salt_winrepo/gpsd.sls) | [GPSd -ohjelman](http://www.catb.org/gpsd/) asennusta koskeva Salt-tilatiedosto MS Windows -minion-tietokoneille |
| [srv_salt_winrepo/merkaartor.sls](https://github.com/Fincer-altego/salt_gisworkstation/blob/master/srv_salt_winrepo/merkaartor.sls) | [Merkaartor -ohjelman](http://merkaartor.be/) asennusta koskeva Salt-tilatiedosto MS Windows -minion-tietokoneille |
| [srv_salt_winrepo/qgis.sls](https://github.com/Fincer-altego/salt_gisworkstation/blob/master/srv_salt_winrepo/qgis.sls) | [QGIS -ohjelman](qgis.org) asennusta koskeva Salt-tilatiedosto MS Windows -minion-tietokoneille |
| [srv_salt_winrepo/quickroute-gps_x86.sls](https://github.com/Fincer-altego/salt_gisworkstation/blob/master/srv_salt_winrepo/quickroute-gps_x86.sls) | [QuickRoute GPS -ohjelman (x86)](http://www.matstroeng.se/quickroute/en/) asennusta koskeva Salt-tilatiedosto MS Windows -minion-tietokoneille |
| [srv_salt_winrepo/vcrun2013.sls](https://github.com/Fincer-altego/salt_gisworkstation/blob/master/srv_salt_winrepo/vcrun2013.sls) | [Visual Studio 2013 -ohjelman](https://www.microsoft.com/en-us/download/details.aspx?id=40784) asennusta koskeva Salt-tilatiedosto MS Windows -minion-tietokoneille |

-------------------

## Moduulin ajo

### Ajoympäristö

**Testikoneet:**

Moduulia testattiin pääsääntöisesti Oracle VirtualBox:ssa seuraavilla asetuksilla:

- 1x Linux Lubuntu 18.04 LTS Salt Master -tietokone

- 1x Microsoft Windows 7 Salt Minion -tietokone

- 1x Linux Lubuntu 18.04 LTS Salt Minion -tietokone

**Verkkoasetukset:**

Kaikki virtuaalitietokoneet oli kytketty julkiseen verkkoon (NAT) sekä keskenään samaan verkkoon (Internal Network, intnet). Julkinen verkko tarvittiin asennuspakettien latausta varten, yksityinen verkko taas Salt Masterin ja minioneiden keskinäiseen kommunikointiin.

**Lähtötilanne:**

![vbox-initial-conf](https://raw.githubusercontent.com/Fincer-altego/central-management-of-multiple-servers/master/images/saltstack_module/0-initial-conf-vbox.png)

**Minionit käsinsäätöä:**

Moduulin huono puoli tällä hetkellä on, että se vaatii Salt Minion -koneiden käsin konfiguroinnin. Salt Minioneiden asennusta ei ole siis automatisoitu, mutta se olisi hyvinkin potentiaalinen kehityskohde.

Ennen moduulin ajoa halusin varmistua, että kaikki _intnet_-verkossa olleet minion-tietokoneet näkevät masterin. Moduuli on tarkoitettu ajettavaksi ilman tätä varmistusta, mutta testin tarkoituksena oli varmistua yhteydestä luotettavasti, jotta GIS-ohjelmien sisäänajon voitiin varmistua onnistuneen "kylmiltään".

Yhteyden testauksen ajaksi Salt Master -koneelle asennettiin Salt Master ja minion-tietokoneet konfiguroitiin myös kuntoon.

![minion-confs](https://raw.githubusercontent.com/Fincer-altego/central-management-of-multiple-servers/master/images/saltstack_module/0-minion-confs.png)

*Moduulin tämän hetken huono puoli on, että Salt Minion -tietokoneet täytyy konfiguroida käsin ottamaan yhteys Salt Master -koneeseen. Salt Masterin IP-osoite sisäisessä verkossa intnet oli kuvassa näkyvä 10.13.13.105. Kuvassa ruutukaappaus Lubuntu- ja Windows -minion-tietokoneista*

![connectiontest](https://raw.githubusercontent.com/Fincer-altego/central-management-of-multiple-servers/master/images/saltstack_module/1-test-config.png)

*Moduulin ajossa haluttiin olla 100% varmoja määriteltyjen Salt minion-tietokoneiden yhteydestä Salt Master -tietokoneeseen. Moduuli on rakennettu siten, että se hyppää sellaisten hyväksyttyjen koneiden (ID) yli, joihin se ei saa yhteyttä yrityksistä huolimatta. Koska koneita oli hyvin vähäinen määrä ja koska GIS-pakettien asennus haluttiin toteuttaa kylmiltään, haluttiin yhteydestä varmistua kuvassa näkyvällä toimenpiteellä. Testin jälkeen Salt Master -daemoni poistettiin Master-koneelta, koska moduulin mukana tuleva shell-skripti asentaa sen automaattisesti Master-koneelle*

### Moduulin ajovaiheet - ruutukaappaukset

![salt-readytogo](https://raw.githubusercontent.com/Fincer-altego/central-management-of-multiple-servers/master/images/saltstack_module/2-execute-script.png)

*Yhteystestailun jälkeen oli aika laittaa moduuli laulamaan. Moduuli suoritetaan ajamalla halutulla Master-koneella kuvassa näkyvä komento 'sudo bash runme.sh' moduulin pääkansiossa*

![screen3](https://raw.githubusercontent.com/Fincer-altego/central-management-of-multiple-servers/master/images/saltstack_module/screen-3.png)

*Heti alussa moduulin shell-skripti tulostaa viestin, jossa käyttäjälle kerrotaan lyhyesti, mitä moduuli tekee. Samalla kysytään käyttäjän varmistusta jatkaa moduulin suoritusta*

![screen4](https://raw.githubusercontent.com/Fincer-altego/central-management-of-multiple-servers/master/images/saltstack_module/screen-4.png)

*Moduuli lataa uusimman Salt Masterin version SaltStackin pakettivarastoista. On ensisijaisen tärkeää varmistua, että Salt minioneiden ja masterin versio täsmäävät keskenään. Moduulin shell-skriptistä voidaan kytkeä SaltStackin varasto pois päältä.*

![screen8](https://raw.githubusercontent.com/Fincer-altego/central-management-of-multiple-servers/master/images/saltstack_module/screen-8.png)

*Moduuli tekee paikalliselle tietokoneelle oletuskonfiguraation Salt Minionille 'defaultMinion', minkä jälkeen moduuli tarkistaa saatavien minion-tietokoneiden olemassaolon ja hyväksyy koneet. Shell-skriptissä voidaan määritellä, että moduuli hyväksyy koneet joko automaattisesti tai käyttäjän erikseen hyväksyminä*

*Koska moduuli joutuu latamaan hyvin paljon Windows-kohtaisia asennustiedostoja (~ 1 gigatavu), on moduuliin implementoitu erillinen tarkistus sille, onko Windows-koneita minion-koneiden joukossa*

![screen12](https://raw.githubusercontent.com/Fincer-altego/central-management-of-multiple-servers/master/images/saltstack_module/screen-12.png)

*Windows-koneiden tarkastuksen jälkeen päivitetään pakettivarastot LASTools:n ja CloudComparen lähdekoodista kasaamista varten. Ohjelmat on pakko kasata lähdekoodista, koska tutkimuksista huolimatta ajantasaisia ja saatavilla olevia pakettivarastoja ohjelmien binääreille ei ole. Ohjelmien kasaaminen lähdekoodista usean koneen tapauksessa on hyvin riskialtista, ja vaatisi ehdottomasti laajempaa testausta.*

![screen-17](https://raw.githubusercontent.com/Fincer-altego/central-management-of-multiple-servers/master/images/saltstack_module/screen-17.png)

*Salt Masterille täytyy asentaa aimo tukku paketteja, jotta minioneille kohdistettujen ohjelmien onnistunut asennus menisi onnistuneesti maaliin. Asennuksessa kestää jonkin aikaa.*

![screen-61](https://raw.githubusercontent.com/Fincer-altego/central-management-of-multiple-servers/master/images/saltstack_module/screen-61.png)

*CloudCompare on pakko kasata lähdekoodista .deb-paketiksi, mikäli se halutaan asentaa Ubuntu salt-minion -tietokoneille. Windowsille moduuli lataa ohjelmakehittäjän tarjoaman binäärin.*

![screen105](https://raw.githubusercontent.com/Fincer-altego/central-management-of-multiple-servers/master/images/saltstack_module/screen-105.png)

*CloudComparen kasaaminen lähdekoodista kestää arviolta noin 10 minuuttia, riippuen kasauksessa käytettävistä optimointiparametreista, saatavien prosessorien lukumäärästä jne. Moduuliin on implementoitu ominaisuus, joka tarkastaa, onko CloudCompare jo kasattu, jolloin ohjelman kasaus voidaan mahdollisesti ohittaa. Moduuli tekee kylläkin vielä lisätarkistuksen, mikäli pakettivarastoista saatavat kehittäjäpaketit on päivitetty ja kasaa ohjelman tarvittaessa uudelleen.*

![screen117](https://raw.githubusercontent.com/Fincer-altego/central-management-of-multiple-servers/master/images/saltstack_module/screen-117.png)

*Moduuli ottaa järjestyksessä yhteyden minion-tietokoneisiin CloudComparen kasauksen jälkeen, testaten yhteyden ja tarkistamalla minionin Salt-version. Tämän jälkeen moduuli käy järjestyksessä läpi kaikki hyväksytyt minion-tietokoneet, ilmoittaen minionilta saadut IP-tiedot, ID-tunnuksen sekä järjestysnumeron. Ajossa minionin grains- ja pillars-tiedot päivitetään sekä ajetaan moduulin määrittelemät Salt-tilat (myös pillar:t) sisään minionille*

![screen178](https://raw.githubusercontent.com/Fincer-altego/central-management-of-multiple-servers/master/images/saltstack_module/screen-178.png)

*Koska moduulin asentamien GIS-pakettien lataus- ja asennuskoko huitelee useissa sadoissa megatavuissa, havaittiin selkeitä ongelmia Salt masterin ja minion -koneen välisissä kutsuissa. Moduuliin on määritelty jo kasvatettu timeout-arvo, jotta Master ei katkaisisi yhteyttä minioneihin. Siitäkin huolimatta kuvassa näkyviä puutteita havaittiin yhteydenpidossa.*

![screen183](https://raw.githubusercontent.com/Fincer-altego/central-management-of-multiple-servers/master/images/saltstack_module/screen-183.png)

*Ratkaisuna yhteysongelmiin moduuliin voisi implementoida tuen seuraaville: 1) Salt Master tarjoaa paketit suoraan minioneille lokaalista varastosta, toimii eritoten lokaaleissa verkoissa (vähentää myös tilojen ajoaikaa, koska nyt ajasta merkittävä osa menee siihen, että minionit lataavat masterin määrittelemät paketit itsekseen) 2) Master ajaa minionien asennustoimenpiteet rinnakkain, ei peräkkäin (onko ongelmatonta?)*

![screen189](https://raw.githubusercontent.com/Fincer-altego/central-management-of-multiple-servers/master/images/saltstack_module/screen-189.png)

*Huolimatta edellä kuvatuista ongelmista, master kykeni ajamaan Salt-tilat sisään minionille*

![screen343](https://raw.githubusercontent.com/Fincer-altego/central-management-of-multiple-servers/master/images/saltstack_module/screen-343.png)

*Minion-tietokoneista Windows tuotti toistuvasti ns. false-positive -tuloksia Salt-tilojen sisäänajosta. Tilassa määritellyt neljä asennusohjelmaa palauttavat samaan aikaan retcode 2:n (virhe) sekä sanallisen viestin 'install_status: success'. Nämä ovat SaltStack:ssa ilmenneitä ongelmia olleet ilmeisesti jo vuosien ajan ja niitä on ajan saatossa korjattu, mutta näköjään kaikkia virhetilanteita ei ole saatu pois. Asiaa tutkittiin (NSIS -asennuspaketeista lähtien), mutta asiaa ei kyetty ratkaisemaan moduulin nykyiseen versioon.*

*Moduuli ilmoittaa ajon lopussa, kuinka moneen Salt-minioniin tilojen sisäänajo onnistui, ja kuinka moneen epäonnistui. Lisäksi epäonnistuneiden minioneiden osalta moduuli ilmoittaa epäonnistuneen minionin ID:n ja saadut IP-osoitteet vikatilanteiden jatkoselvitystä varten.*

-------------------

## Miltä näyttää minion-koneilla?

Moduulin ajon jälkeen tilanne näyttää seuraavalta minion-koneilla:

### Microsoft Windows 7 - 64-bit

![winminion-programs](https://raw.githubusercontent.com/Fincer-altego/salt_gisworkstation/master/sample_images/screen_windows-final.png)

*Salt-moduulissa määritellyt ohjelmat on onnistuneesti asennettu sisään Windows-minion -tietokoneelle. Lisäksi Salt-pillar:ssa määritelty testitiedosto on oikealla sisällöllä ajettu onnistuneesti sisään*

![winminion-lastools](https://raw.githubusercontent.com/Fincer-altego/salt_gisworkstation/master/sample_images/screen_windows-final-2.png)

*Salt-moduulissa QGIS-ohjelmaan määritelty LAStools-työkalujen konfigurointi on onnistuneesti sisällä kaikille käyttäjille*

### Linux Lubuntu 18.04 LTS - 64-bit

![ubuntuminion-programs](https://raw.githubusercontent.com/Fincer-altego/salt_gisworkstation/master/sample_images/screen_ubuntu-final.png)

*Salt-moduulissa määritellyt ohjelmat onnistuneesti asennettuna Linux Lubuntu -minion-tietokoneen sisään. Lisäksi Salt-pillar:ssa määritelty testitiedosto on oikealla sisällöllä ajettu onnistuneesti sisään ja LAStools on onnistuneesti esikonfiguroitu QGIS-ohjelmaan*

![ubuntumaster-programs](https://raw.githubusercontent.com/Fincer-altego/salt_gisworkstation/master/sample_images/screen_ubuntu-master-final.png)

*Salt Masterilla on sama tilanne kuin ylhäällä Ubuntu minion-tietokoneella, koska master-koneelle oli määritelty myös oma minion-asennus, johon moduuli kohdisti toimenpiteitä*

-------------------

## Huomioita moduulin ajosta

### Ajoaika

Moduulin kylmiltä ajo kestää tällä hetkellä huomattavan kauan. Merkittävä osa ajasta menee seuraaviin asioihin:

- asennuspakettien latausaika

    - suurimmat paketit ovat kooltaan useita satoja megatavuja. Esimerkiksi LASTools yli 300 mt. 
    
    - Kaiken kaikkiaan asennettavia paketteja on noin 1,3 gigatavun edestä.
    
    - ratkaisu: lataa paketit Salt Masterille etukäteen, tiputa ne minioneille.
    
        - Tämä on jo osittain implementoitu. Mikäli moduuli on kertaalleen ajettu ja havaitsee asennuspaketit kansiossa compiled, ei moduuli lataa/kasaa paketteja enää uudelleen
        
        - Ongelma edelleen se, että minion-tietokoneet tekevät vaadittavien riippuvuuspakettien suhteen omat latauksensa (esim. QGIS)
    
- asennuspakettien asennusaika

    - Asennuspakettikokonaisuudet ovat isoja ja vievät paljon prosessointiaikaa niin masterilta kuin minionilta. Masteria tämä tosin valtaosin koskee moduulin ensimmäistä ajokertaa. Minioneiden osalta Ubuntu-koneilla moduulin ajaminen toiseen kertaan on nopeampaa kuin Windows-minioneilla. Moduulin testauksen aikana näytti ilmeiseltä, että SaltStack tukee ja kykenee paremmin kontrolloimaan Linux-ympäristössä tapahtuvia asennuksia
    
### Ajon luotettavuus

**Ohjelmien kasaus - CloudCompare** 

Merkittävin luotettavuuteen liittyvä ongelma on erityisesti CloudComparen kasausprosessi. Ohjelman kasaus on riippuvainen monesta kehittäjäpaketista, joten tietokoneympäristön fragmentoituminen on omiaan lisäämään riskiä siitä, että joillakin minioneilla asennus menee ajan saatossa siihen kuntoon, ettei ohjelma enää käynnisty (esimerkiksi puuttuvan kirjastoriippuvuuden takia). Ohjelman kasausta hallituissa ympäristöissä tulisi välttää viimeiseen saakka.

CloudComparen merkittävin ongelma Linux-ympäristöissä on virallisten pakettilähteiden puute tai vanhentuneisuus. Esimerkiksi Ubuntulle löytyy CloudComparen PPA, mutta se on osoitettu Linux Ubuntu:n versiolle 16.04 LTS ja [toimittaa CloudComparesta version 2.6.0 vuodelta 2014](https://launchpad.net/~romain-janvier/+archive/ubuntu/cloudcompare), siinä missä uusin versio on edelleen kehityksessä oleva 2.10 Alpha.

CloudCompare on merkittävä avoimen lähdekoodin ohjelma pistepilvien prosessointiin. Eräs vaihtoehtoinen, joskaan ei niin spesifisesti laserkeilausdatan käsittelyyn tarkoitettu ohjelma, on [MeshLab](http://www.meshlab.net/). MeshLab:sta moduulin kirjoittajalla on kokemusta, ja se ei tuotantoympäristössä ole riittävän vakaa ohjelma raskaiden datamassojen prosessointiin (siinä, missä CloudCompare on).

**Ohjelmien kasaus - LAStools**

LAStoolsia vaivaa sama ongelma kuin CloudComparea, mitä tulee joidenkin Linux-jakeluiden pakettivarastoihin. LAStools tuskin kuitenkaan hajoaa niin helposti kuin CloudCompare, koska vaaditut ulkopuoliset kehittäjäpakettiriippuvuudet on minimissään rajoittuen likipitäen _make_ -binäärin löytyvyyteen.

**Salt-tilojen aikakatkaisu**

Salt-tilojen ajon aikana havaittiin huolestuttavia viestejä yhteysongelmasta Salt Masterin ja minioneiden välillä. Ongelma liittyy isojen asennuspakettien lataukseen ja asennukseen, eikä tule juurikaan ilmi pienien järjestelmämuutoksien toteutuksessa tai pieniä asennuspaketteja asentaessa. *Tämä on ongelma, joka pitää ratkaista, mikäli moduuli otetaan laajemmassa tuotantoympäristössä käyttöön.*

Aikakatkaisuun kehitysehdotuksia on lueteltu ylhäällä otsikon "Ajoaika" alla.

-------------------

## Moduulin hyvät puolet

- Asentaa GIS-ohjelmat Ubuntu- ja Windows -käyttöympäristöihin

- Laajennettavissa helposti

- Potentiaali: vähentää GIS-työasemien asennukseen kuluvaa aikaa

- Jonkin verran kustomoitavissa (shell-skriptit mm.)

## Moduulin huonot puolet

- Ajo kestää kauan

    - Mikäli kaikki paketit ladataan verkosta, kestää 3 minionin kuntoon laittaminen automatiikalla noin 1 tunnin.

    - Rajoittaa mm. moduulin skaalautuvuutta laajempiin ympäristöihin

- Shell-skriptien luotettavuus

    - Edellyttäisi pidempiaikaista ja vaativampaa testausta
    
    - Bugit mahdollisia

- Tuetut minion-ympäristöt hyvin rajoittuneet

    - Laajempi käyttöjärjestelmätuki vaadittaisiin
    
- Testausympäristö oli moduulin ajossa rajoittunut

    - Edelleen, vaatisi ajan kanssa testausta laajemmassa ympäristössä
    
- Koneet, joissa Salt masterin kanssa konfliktissa oleva minion-versio

    - Osittainen tuki tehty, mutta vielä olisi tehtävää
    
-------------------
    
## Moduulin kehittämistarpeet

Moduulissa on paljon kehittämistarpeita, joskin myös potentiaalia. Kriittisiin kohtiin olisi puututtava, mm.

- ajoajan hitauteen

- master- ja minion -tietokoneiden yhteyden luotettavuuteen

- ohjelmien kasauksen minimointiin

jne. Enemmän kehittämistarpeita on lueteltu ylhäällä otsikon "Moduulin huonot puolet" alla sekä shell-skriptissä '[runme.sh](https://github.com/Fincer-altego/salt_gisworkstation/blob/master/runme.sh)' (alussa oleva TODO-lista).

Lisäksi olisi hyvin tärkeää, että Salt Minion -konfiguraatiot tehdään SSH-yhteyden yli kohdekoneille. Tällä erää aika ei riittänyt tämän toiminnallisuuden toteuttamiseen, vaikkakin näkemys tämän toteuttamiseksi on kohtalaisen selkeä.
