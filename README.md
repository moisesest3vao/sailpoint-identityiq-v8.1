# SailPoint IIQ no Docker

## Sobre
Tendo em vista a necessidade de ter uma forma descomplicada de codificar no IdentityIQ criamos uma instalação com uma infraestrutura preparada para está ferramenta.

Essa é uma ótima maneira de desenvolver com o IdentityIQ rapidamente. Caso você utilize o SSB como ferramenta de BUILD a utilização dessa instalação podem ser estendida a seus ambientes produtivos.  

Essa instalação oferece 3 Conectores + Tasks Aggregation prontos
1. Conector DimitedFile (Human Resources)
	- Aplicação dominante
2. Aplicação JDBC
	- Aplicação com toda estrutura de provisionamento de CONTAS e GRUPOS
3. Aplicação OpenLDAP
	- Aplicação com toda estrutura de provisionamento de CONTAS e GRUPOS

## Pré-requisitos
Para o uso dessa instalação devemos seguir os seguintes passos.
1.  Clonar o repositorio na sua estação de trabalho.
2.  Realizar o download aqui https://community.sailpoint.com/ dos seguintes componentes
	- [identityiq-8.1.zip](https://community.sailpoint.com/t5/IdentityIQ-Server-Software/IdentityIQ-8-1/ta-p/158175 "identityiq-8.1.zip")  
	- [identityiq-8.1p2.jar](https://community.sailpoint.com/t5/IdentityIQ-Server-Software/IdentityIQ-8-1p2/ta-p/182114 "identityiq-8.1p2.jar") 
	- [1_ssb-v6.1.zip](https://community.sailpoint.com/t5/Services-Standard-Deployment/Services-Standard-Build-SSB-v6-1/ta-p/76056 "1_ssb-v6.1.zip")  

Observe que o IdentityIQ é um código fechado, portanto, primeiro você precisa obter uma licença para o IdentityIQ.

## Configurando os binários (Obrigatorio)  

Os locais dos arquivos devem ser os seguintes:

 * `identityiq-8.1.zip`: tomcat => file_install => ssb => base => ga
 * `identityiq-8.1p2.jar`: tomcat => file_install => ssb => base => patch
 * `1_ssb-v6.1.zip`: tomcat => file_install 
     * Renomear para `ssb.zip`
 
## Configurando banco de dados (Obrigatorio) 

 * `create_identityiq_tables-8.1.sqlserver`: sqlserver_iiq => scripts 
	 * Renomear para `1-create_identityiq_tables-8.1.sqlserver` 
 * `upgrade_identityiq_tables.sqlserver`: sqlserver_iiq => scripts 
	 * Renomear para `2-upgrade_identityiq_tables.sqlserver` 
 * `upgrade_identityiq_tables-8.1p2.sqlserver`: sqlserver_iiq => scripts 
	 * Renomear para `3-upgrade_identityiq_tables-8.1p2.sqlserver` 	 

**Observação**: 
1. É necessário alterar a senha dos usuario identityiq e identityiqPlugin do script `create_identityiq_tables-8.1.sqlserver.sqlserver` para uma senha forte **`Change@123`**    
2. Para extrair o script `upgrade_identityiq_tables-8.1p2.sqlserver` user o comando **`jar xvf identityiq-8.1p2.jar`**
3. Caso necessite adicionar scripts customizados para criar atributos estendido no IdentityIq, crie um **4-qualquernome.sqlserver**,**5-qualquernome.sqlserver**...**n-qualquernome.sqlserver** e adicione em **sqlserver_iiq => scripts** na montagem do ```docker-compose```

#### Configuração das aplicações fake  
1.  Caso não necessite da instalação customizada (com as 3 aplicações adicionais), inserir no arquivo docker.ignorefiles.properties  
<pre>
Application/Application-HumanResources.xml
Application/Application-Jdbc.xml
Application/Application-Openldap.xml
CorrelationConfig/CorrelationConfig-HumanResourcesEmployee.xml
CorrelationConfig/CorrelationConfig-JdbcEmployee.xml
CorrelationConfig/CorrelationConfig-Openldap.xml
Form/Form-CreateAccountJdbc.xml
Form/Form-CreateAccountOpenldap.xml
Form/Form-CreateGroupJdbc.xml
Form/Form-CreateGroupOpenldap.xml
Form/Form-UpdateAccountJdbc.xml
Form/Form-UpdateGroupJdbc.xml
Form/Form-UpdateGroupOpenldap.xml
ObjectConfig/ObjectConfig-IdentityHumanResources.xml
Rule/Rule-HumanResourcesBuildmapEmployee.xml
Rule/Rule-HumanResourcesCreationEmployee.xml
Rule/Rule-HumanResourcesEmail.xml
Rule/Rule-HumanResourcesFirstName.xml
Rule/Rule-HumanResourcesLastName.xml
Rule/Rule-HumanResourcesManager.xml
Rule/Rule-HumanResourcesName.xml
Rule/Rule-HumanResourcesStatus.xml
Rule/Rule-HumanResourcesType.xml
Rule/Rule-IdentityGetEmployee.xml
Rule/Rule-IdentityGetFirstname.xml
Rule/Rule-IdentityGetFullName.xml
Rule/Rule-IdentityGetLastname.xml
Rule/Rule-JdbcCreateProvision.xml
Rule/Rule-JdbcDeleteProvision.xml
Rule/Rule-JdbcDisableProvision.xml
Rule/Rule-JdbcEnableProvision.xml
Rule/Rule-JdbcSetNameGroup.xml
Rule/Rule-JdbcUpdateProvision.xml
Rule/Rule-OpenldapSetAccountDn.xml
Rule/Rule-OpenldapSetGroupDn.xml
Rule/Rule-RuleLibraryGetAttributesRequest.xml
Rule/Rule-SetGroupRequest.xml
SystemConfiguration/SystemConfiguration-Email.xml
TaskDefinition/TaskDefinition-HumanResourcesAccountAggregation.xml
TaskDefinition/TaskDefinition-JdbcAccountAggregation.xml
TaskDefinition/TaskDefinition-JdbcGroupAggregation.xml
TaskDefinition/TaskDefinition-OpenLdapAccountAggregation.xml
TaskDefinition/TaskDefinition-OpenLdapGroupAggregation.xml
UI/UIConfig-Uiconfig.xml
</pre>

## Executando contêiner
Para executar o conteiner só necessita da linha de comando
```
docker-compose up
```
## Descrição das IMAGENS e CONTÊINERS utilizados na instalação

#### TOMCAT - tomcat:9.0.34-jdk11-openjdk
- Contêiner com o IIQ SailPoint IdentityIQ8.1p2 em execução com OpenJDK e Tomcat 9.
	-  Com um volume para o diretorio /opt/file, onde existe um arquivo txt para aplicação fake.

------------

#### SQL SERVER - server:2019-CU4-ubuntu-16.04
- Contêiner com o Banco de Dados SQL Server  2019
	-  Para hospedar o DataBase IdentityIQ e IdentityIQPlugin.
	-  Dados para acesso
		- Banco de Dados IdentityIQ => Host: **10.5.0.3** User: **IdentityIQ** Password: **Change@123**
		- Banco de Dados IdentityIQ => Host: **10.5.0.3** User: **IdentityIQPlugin** Password: **Change@123**  

	-  Para hospedar o DataBase AppMock para simular um aplicativo fake.
		- Banco de Dados AppMock => Host: **10.5.0.3** User: **AppMock** Password: **Change@123**
------------

#### OPENLDAP -  osixia/openldap:1.5.0
- Contêiner OpenLDAP com contas para simular um aplicativo fake.
	-  Com um volume para o arquivo **/container/service/slapd/assets/config/bootstrap/schema/attributes.schema** onde existe um schema, caso aja necessidade de adicionar novos atributos a conta. 
	-  Com um volume para o arquivo **/container/service/slapd/assets/config/bootstrap/ldif/custom/adata.ldif** onde existe um ldif, com contas e grupos. 
	-  Dados para acesso
		- Host: **10.5.0.4** User: **cn=admin,dc=corp1** Password: **test1234**	

#### EMAIL - mailhog/mailhog
- Contêiner com um server de e-mail configurado para disparar E-mail's.

## Configurando Volumes (Opcional)
Para essa instalação foi inserido 3 volumes, altere somente se houver tal necessidade.

> **É recomendado alterar os volumes somente se o seu sistema operacional for WINDOWS, ir para a seção do *CONFIGURANDO .ENV***

## Configurando .ENV (Opcional)
Existe na raiz deste projeto um .ENV, com alguns parametros, caso queira trocar por outros valores ou mover os diretorios padrões da instalação, somente acessa-lo e editar.

##### Parametros do OpenLDAP
- LDAP_ADMIN_PASSWORD= **Senha para o OpenLDAP criado para simular o aplicativo fake.**
- LDAP_BASE_DN= **Raiz DN do OpenLDAP criado**
- LDAP_ORGANISATION= **Nome da organização**
- LDAP_DOMAIN= **Domain do OpenLDAP**

>***É recomendado alterar as variaveis abaixo, caso seu sistema operacional for WINDOWS***

##### Parametros do Volumes
- LDAP_DATA_SCHEMA= **Schema do OpenLdap caso queira adicionar algum atributo**
- LDAP_DATA= **Contas e Grupos do OpenLdap caso queira adicionar uma nova conta ou  grupo** 
- DIRECTORY_TOMCAT_APPLICATION= **Diretorio para um arquivo com dados de identidades fakes**