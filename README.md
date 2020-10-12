# SolvinityChallenge

Vereisten: 
Voor het uitvoeren van deze challenge is een machine met MacOS of Linux benodigd met daarop Ansible 2.9, Python 3 en VirtualBox geinstalleerd. 

Begin met het controleren van het init.sh script. Dit script controleert een paar zaken en gaat download vervolgens een CentOS 8 minimum iso (ca. 1.6 Gb). De download locatie is: ~/Downloads

Aangezien Ansible nog geen ondersteuning lijkt te hebben voor Virtual Box heb ik het aamaken van de VM buiten Ansible gehouden. Het is m.i. vrij nutteloos om een Ansible script op te bouwen met enkel 'command' modules. Het schrijven van een volledige python-module voor Ansible gaat helaas te veel tijd kosten. Om een machine te deployen kun je gebruik maken van het createvm.sh script. Let hierbij wel op dat je de juiste (bridged) netwerk kaart opgeeft (declaratie in het script) en wanneer je de download locatie in init.sh hebt aangepast, zul je die ook hier aan moeten passen. 

Roep het script aan met de vm-naam en eventueel een omschrijving als parameter(s). De vm zal gebouwd worden met een harddisk en een dvd-drive aan de SATA controller en een virtuele immutable USB-stick voor de kickstart. Standaard heeft de VM 1 Gb geheugen, 1 vCPU en 8 Gb diskspace. 

Nadat de VM is gestart kan ansible.sh worden uitgevoerd. Pas eerst het IP adres in de Ansible hosts file aan, naar het IP adres die de nieuwe VM heeft gekregen. Naast ansible.sh staan er in de ansible directory een aantal playbooks klaar, hun namen spreken voor zich. Let wel op dat je bij het uitvoeren van deze playbooks in de ansible directory staat of de username en private-key als parameters meegeeft aan ansible-playbook.

Ansible zal twee webservers en een loadbalancer uitrollen. Om zo efficient met de resources om te gaan stammen alle drie de containers af van dezelfde httpd container. Het build-proces zal een httpd.conf toevoegen en de webservers krijgen daarnaast een index.html file. De poorten die de containers krijgen zijn te specificeren in de Ansible hosts-file. De containers zijn conform de challenge ook van buiten af te benaderen op hun poort. 

Last not least, het test.sh script zal een vijftal verzoeken doen naar de VM. Geef het IP adres van de VM als parameter mee. 


