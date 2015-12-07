Erstellen einer Webapplikation mit ASP.NET MVC und DocumentDB
=======================================================================================

**Azure DocumentDB** ist ein vollständig verwalteter und hochskalierbarer NoSQL-Dokumentendatenbankdienst, der von Azure bereitgestellt wird. 
Mit DocumentDB sind Sie in der Lage, moderne und skalierbare mobile Apps und Webanwendungen zu erstellen, die sich durch eine zuverlässige Abfrageleistung und transaktionale Datenverarbeitung auszeichnen.
DocumentDB wurde von Grund auf für eine systemeigene Unterstützung von JSON und JavaScript innerhalb des Datenbankmoduls entwickelt. 
Mehr Informationen über die DocumentDB lassen sich online finden unter: [Microsoft Azure DocumentDB](http://azure.microsoft.com/de/services/documentdb/).

In diesem Lab werden Sie lernen, wie man eine ToDo-Liste als Webapplikation mit Azure DocumentDB erstellt. Die Aufgabenelemente werden als JSON Dokumente in der Azure DocumentDB gespeichert. Bei der Webapplikation handelt es sich um eine C# MVC Applikation, in welcher Sie basis CRUD Operationen mit Methoden verbinden, die DocumentDB benutzen, und werden die Applikation abschließend als Azure Website veröffentlichen.

Das Lab beeinhaltet Instruktionen für die folgenden Aufgaben:

* [Erstellen eines DocumentDB Datenbankaccounts](#creating-a-documentdb-database-account)
* [Erstellen einer neuen ASP.NET MVC Applikation](#creating-a-new-aspnet-mvc-app)
* [Hinzufügen einer DocumentDB zu einem Projekt](#adding-documentdb-to-your-project)
* [Einrichten der ASP.NET MVC Applikation](#setting-up-the-aspnet-mvc-app)
* [Wiring up DocumentDB](#wiring-up-documentdb)
* [Lokales Ausführen der Applikation](#running-the-application-locally)
* [Deployment der Applikation als Azure Website](#deploying-the-app-to-azure)
* [Appendix - Cleanup](#cleanup)

<a name="creating-a-documentdb-database-account"></a>
## Erstellen eines DocumentDB Datenbankaccounts

Um Microsoft Azure DocumentDB zu benutzen, müssen Sie einen DocumentDB Account erstellen. Diese Aufgabenstellung beschreibt, wie man einen DocumentDB Account im Azure-Vorschauportal erstellt.

1. Melden Sie sich im [Azure-Vorschauportal](https://portal.azure.com/) an.

1. Klicken Sie auf **NEU** und wählen **Daten und Speicher**, anschließend  **DocumentDB** um einen neuen DocumentDB Account zu erstellen.  

    ![Creating a DocumentDB account](./images/creating-a-new-documentdb-account2.png)


1. In der **Neues DocumentDB-Konto** Spalte, geben Sie einen Namen zur Identifikation des DocumentDB Accounts in dem **Id** Feld ein (e.g.: documentdb-id) und spezifizieren Sie die geographische Lokation, in welcher Ihr DocumentDB Account gehosted werden soll (e.g.: Westeuropa). Sie können weitere Konfigurationsoptionen vornehmen, basierend auf der Information unter dem Screenshot. Abschließend muss auf **Erstellen** geklickt werden.

	![Konfiguration vom DocumentDB Account](./images/new-documentdb-blade2.png)

	_Konfiguration des DocumentDB Accounts_

	> **Notiz:** In der **Neues DocumentDB-Konto** Spalte können Sie die folgenden Optionen für die Konfiguration eines neuen DocumentDB Accounts finden:

	> - **Id**: Name, der den DocumentDB Account identifiziert. Dieser Wert wird der Hostname in der URI. Die Id kann nur aus Kleinbuchstaben, Zahlen, und dem '-' Zeichen bestehen, und muss zwischen 3 und 50 Zeichen lang sein. Beachten Sie, dass documents.azure.com an den Enpointnamen Ihrer Wahl angehängt wird. 

	> - **Kontostufe**: Standard. Dieses Eingabefeld ist gesperrt, da die DocumentDB Vorschau nur einen Standardtarif unterstützt. Für mehr Informationen, lesen Sie [DocumentDB Preise](https://azure.microsoft.com/de-de/pricing/details/documentdb/).
    
    > - **Abonnement**: Das Azure Abonnement, das Sie für Ihren DocumentDB Account benutzen wollen. Falls Ihr Account nur über ein Abonnemont verfügt, ist dieses automatisch ausgewählt.
	
    > - **Ressourcengruppe**: Die Ressourcengruppe für Ihren DocumentDB Account. Per default wird eine neue Ressourcengruppe erstellt. Sie können den DocumentDB Account auch zu einer bereits existierenden Ressourcengruppe hinzufügen. Mehr Informationen erhalten Sie unter: [Verwenden des Azure-Vorschauportals zum Verwalten Ihrer Azure-Ressourcen](http://azure.microsoft.com/de/documentation/articles/azure-preview-portal-using-resource-groups/).

	> - **Standort**: Die geographische Lokation, wo Ihr DocumentDB Account gehosted wird.

	Der DocumentDB Account wird erstellt. Da dies ein wenig Zeit in Anspruch nehmen kann, können Sie direkt mit der Erstellung des Projekts beginnen und anschließend hierher zurückkommen um die notwendigen Informationen nach der Account Erstellung zu erhalten. Bitte lassen Sie den Browser geöffnet. Sie können den Erstellungsfortschritt im **Dashboard** über die Zeit überwachen.

	![Überprüfen des Erstellungsfortschrittes im Notification Hub](./images/checking-the-creation-status-notification-hub2.png?raw=true)

	_Überprüfen des Fortschritts der DocumentDB Account Erstellung_


Im nächsten Abschnitt werden Sie Schritt für Schritt durch die Erstellung einer ASP.NET MVC Applikation geführt.

<a name="creating-a-new-aspnet-mvc-app"></a>
## Erstellen einer neuen ASP.NET MVC Applikation

In dieser Aufgabe werden Sie ein ASP.NET MVC Projekt und eine Microsoft Azure Website erstellen, wo das Projekt deployed wird.

1. Öffnen Sie Visual Studio und wählen das **Datei** Menü, dann **Neu** und klicken Sie auf **Projekt**.

    ![Erstellen eines neuen Projekts](./images/newProject.png)

    _Erstellen eines neuen Projekts_

	> **Notiz:** Sie können das entstehende Projekt von [end/Todo](end/Todo) öffnen und entsprechend der Instruktionen konfigurieren: [Setting up the end solution](end).

1. In der **Neues Projekt** Dialogbox, wählen Sie **ASP.NET Web Application** unter dem **Visual C# | Web** tab. Versichern Sie sich, dass **.NET Framework 4.5** ausgewählt ist.
Nennen Sie das Projekt Todo, wählen Sie eine **Location** und klicken Sie auf **OK**.

	> **Notiz:** Sie sollten außerdem die Checkbox **Application Insights zum Projekt hinzufügen** deaktivieren, falls Sie diese Funktionalität für Ihr Projekt nicht wünschen.

	![Erstellen einer neuen ASP.Net Webanwendung](images/creating-a-new-aspnet-web-application-project.png?raw=true)

    _Erstellen einer neuen ASP.Net Webanwendung_

1. In der **New ASP.NET Project** Dialogbox, wählen Sie **MVC**. Versichern Sie sich, dass die **In der cloud hosten** Option ebenfalls ausgewählt ist, und ändern Sie die Authentifizierungsmethode auf **Keine Authentifizierung**. Klicken Sie **Ok**.

	![Creating a new MVC project](images/creating-a-new-mvc-project.png?raw=true)

    _Erstellen eines neuen Projekts mit MVC Template_

	> **Notiz 1:** Auswählen der _In der Cloud hosten_ Option wird eine Azure Website für Sie bereitstellen und den Deployment Prozess der finalen Applikation deutlich erleichtern. Falls Sie die Applikation woanders hosten wollen oder Azure nicht im Vorfeld konfigurieren möchten, deaktivieren Sie die Checkbox.

	> **Notiz 2**: Sie werden eventuell zur Anmeldeseite von Visual Studio zur Anmeldung mit Ihrem Microsoft Account weitergeleitet. Bitte geben Sie Ihre Anmeldedaten ein und klicken auf "Anmelden". 

  > **Notiz 3**: Dieses Lab funktioniert mit Visual Studio 2013 und Visual Studio 2015. Falls Sie Visual Studio 2015 verwenden und die *In der Cloud hosten* Option nicht sehen können, müssen Sie das Azure SDK nachinstallieren: [latest release of the Microsoft Azure SDK for Visual Studio 2015](http://go.microsoft.com/fwlink/?linkid=518003&clcid=0x409).

1. Die **Einstellungen der Microsoft Azure-Web-App konfigurieren** Dialogbox erscheint mit einem automatisch generiertem Web-App-Namen. Wählen Sie eine Region (e.g.: _Westeuropa_). Bitte beachten Sie, mit welchem Account Sie angemeldet sind. Vergewissern Sie sich, dass es sich um Ihren Account mit Azure Subscription handelt.

	Dieses Projekt benötigt keine Datenbank, da es einen neuen Azure DocumentDB Account verwendet, der später im Azure-Vorschauportal erstellt wird, also vergewissern Sie sich bitte, dass **Keine Databank** im **Datenbankserver** Feld ausgewählt ist.

	![Configuring Microsoft Azure Website](images/configuring-microsoft-azure-website.png?raw=true)

	_Microsoft Azure-Web-App konfigurieren_

Das Projekt wird erstellt, und die Authentifizierungsoptionen und Azure-Web-App Optionen werden automatisch konfiguriert. Die ASP.NET Applikation kann auch lokal ausgeführt werden.

In der folgenden Aufgabenbeschreibung werden Sie DocumentDB zum Projekt hinzufügen und die Applikation bauen.

<a name="adding-documentdb-to-your-project"></a>
##Hinzufügen einer DocumentDB zu einem Projekt

In dieser Aufgabe werden Sie die Azure DocumentDB SDK zu der Applikation hinzufügen.

Das DocumentDB .NET SDK ist verfügbar als NuGet Paket. Um ein NuGet Paket in Visual Studio zu integrieren, benutzen Sie den NuGet Package Manager in Visual Studio.

1. Rechtsklicken Sie auf das **Todo** Project im Projektmappen-Explorer (Solution Explorer) und wählen **NuGet Pakete verwalten** um den NuGet Package Manager zu öffnen.

	![Opening Manage NuGet Packages](images/opening-manage-nuget-packages.png?raw=true)

	_Öffnen des NuGet Package Managers_

1. In der Suchbox, geben Sie **Azure DocumentDB** ein. Wählen Sie das **Microsoft Azure DocumentDB Client Libraries** Paket mit der Id **Microsoft.Azure.DocumentDB** und klicken Sie auf **Installieren**.

	Das DocumentDB Paket wird heruntergeladen und installiert, ebenso wie alle Abhängigkeiten wie Newtonsoft.Json.


	![Installing the Microsoft Azure DocumentDB Client Libraries](images/installing-microsoft-azure-documentdb.png?raw=true)
	_Installieren der Microsoft Azure DocumentDB_

	> **Notiz:** Alternativ können Sie die Paket-Manager-Konsole verwenden um das Paket zu installieren:

	>  ```PowerShell
	>  Install-Package Microsoft.Azure.DocumentsDB
	>  ```

1. Sie werden zur **Zustimmung zur Lizenz** weitergeleitet. Klicken Sie auf **Ich stimme zu**.

	![Accepting the license for Microsoft Azure Documents Client](images/accepting-the-license-for-ms-azure-documents.png?raw=true)

	_Zustimmen zur Lizenz für Microsoft.Azure.DocumentDB_

1. Wenn das Paket installiert ist, überprüfen Sie das Erscheinen zwei neuer Verweise im **Todo** Projekt:  _Microsoft.Azure.Documents.Client_ and _Newtonsoft.Json_:

	![References added to the solution](images/references-added-to-the-solution.png?raw=true)

	_Verweise, die zur Projektmappe hinzugefügt wurden_

<a name="setting-up-the-aspnet-mvc-app"></a>
##Einrichten der ASP.NET MVC Applikation

In dieser Aufgabenstellung werden Sie die ASP.Net MVC Applikation einrichten, in dem Sie ein Model, einen Controller und einige Views anlegen.

###Hinzufügen eines Models###

1. Im **Projektmappen-Explorer (Solution Explorer)**, rechtsklicken Sie auf den **Models** Ordner im **Todo** Projekt, wählen **Hinzufügen** und klicken auf **Klasse...**.

    ![Adding a Model](images/adding-a-model.png?raw=true)

    _Hinzufügen einer neue Model Klasse_

1. In der **Neues Element hinzufügen** Dialogbox, benennen Sie die Datei als _Item.cs_ und klicken auf **Hinzufügen**.  

	![Creating the Item class](images/creating-the-item-class.png?raw=true)

1. Ersetzen Sie den Inhalt der neuen **Item.cs** Datei durch den Folgenden:

	```C#
	namespace Todo.Models
	{
		 using Newtonsoft.Json;

		 public class Item
		 {
			  [JsonProperty(PropertyName = "id")]
			  public string Id { get; set; }

			  [JsonProperty(PropertyName = "name")]
			  public string Name { get; set; }

			  [JsonProperty(PropertyName = "desc")]
			  public string Description { get; set; }

			  [JsonProperty(PropertyName = "isComplete")]
			  public bool Completed { get; set; }
		 }
	}
	```

	> **Notiz:** Alle Daten in DocumentDB werden als JSON gespeichert. Um die Art zu kontrollieren, wie Objekte von JSON.NET serialisiert/deserialisiert werden, können Sie das JsonProperty Attribut wie in der Item class verwenden. Darüber hinaus können Sie JsonConverter Objekte verwenden um vollständige Kontrolle über Serilisierung zu erlangen.

###Hinzufügen eines Controllers###

1.  Im **Projektmappen-Explorer (Solution Explorer)**, rechtsklicken Sie auf den **Models** Ordner im **Todo** Projekt, wählen **Hinzufügen** und klicken auf **Controller...**.

	![Adding a Controller](images/adding-a-controller.png?raw=true)

	_Hinzufügen eines Controllers_

1. In der **Gerüst hinzufügen** Dialogbox, wählen Sie **MVC 5 Controller - leer** und klicken **Hinzufügen**.

	![Add Scaffold](images/add-scaffold.png?raw=true)


1. Nennen Sie den neuen Controller, **ItemController** und klicken auf **Hinzufügen**.

	![Naming the new Controller](images/naming-the-new-controller.png?raw=true)


1. Nach dem Erstellen der Dateien sollten Sie im Projektmappen-Explorer auftauchen als **Item.cs** und **ItemController.cs** Dateien.

	![Solution after adding model and controller](images/solution-after-adding-model-and-controller.png?raw=true)

	_Projektmappe nach dem Hinzufügen von Model und Controller_

###Hinzufügen von Ansichten (Views) ###
Nun werden sie verschiedene Ansichten (Views) hinzufügen um Details von existierende ToDo items aufzulisten, editieren, löschen, anzuzeigen und Neue zu erstellen.

####Adding an Item Index View####
1. Im **Projektmappen-Explorer (Solution Explorer)**, erweitern Sie den **Views** Ordner. Rechtsklicken Sie den leeren **Item** Ordner, wählen **Hinzufügen**, und anschließend **Anzeigen...**.

	![Adding a new View](images/adding-a-new-view.png?raw=true)

	_Hinzufügen einer neuen Ansicht (View)_

1. In der **Ansicht hinzufügen** Dialogbox, verfollständigen Sie die folgenden Optionen und klicken auf **Hinzufügen**.
	- In der **Ansichtname** Box, tippen Sie **Index**.
	- In der **Vorlage** Box, wählen Sie **List**.
	- In der **Modellklasse** Box, wählen Sie **Item (Todo.Models)**.
	- In der **Layoutseite verwenden** Box, tippen Sie **~/Views/Shared/_Layout.cshtml**.

	![Adding the Index View](images/adding-the-index-view.png?raw=true)

	_Adding the Index View_

	Visual Studio erstellt nun eine Vorlagenansicht mit dem Namen _Index.cshtml_. Wenn die Datei erstellt wurde, wird sich die erstellte cshtml Datei öffnen.

1. Schließen Sie die _Index.cshtml_ Datei Visual Studio; Sie werden später darauf zurückkommen.

####Hinzufügen einer Ansicht zum Erstellen von neuen Items (Create New Item View)####
Sie werden nun eine Ansicht (view) für die Erstellung von neuen Items erstellen, analog zu der Erstellung der Index Ansicht in der vorherigen Sektion.

1. Im **Projektmappen-Explorer (Solution Explorer)**, erweitern Sie den **Views** Ordner. Rechtsklicken Sie den **Item** Ordner, wählen **Hinzufügen**, und anschließend **Anzeigen...**.

1. In der **Ansicht hinzufügen** Dialogbox, verfollständigen Sie die folgenden Optionen und klicken auf **Hinzufügen**.
	- In der **Ansichtname** Box, tippen Sie **Create**.
	- In der **Vorlage** Box, wählen Sie **Create**.
	- In der **Modellklasse** Box, wählen Sie **Item (Todo.Models)**.
	- In der **Layoutseite verwenden** Box, tippen Sie **~/Views/Shared/_Layout.cshtml**.

	![Adding the Create View](images/adding-the-create-view.png?raw=true)

	_Hinzufügen der Index Ansicht_

####Hinzufügen einer Ansicht zum Löschen von Items (Adding a Delete Item View)####
Sie werden nun eine neue Ansicht zum Löschen von Items erstellen.

1. Im **Projektmappen-Explorer (Solution Explorer)**, erweitern Sie den **Views** Ordner. Rechtsklicken Sie den **Item** Ordner, wählen **Hinzufügen**, und anschließend **Anzeigen...**.

1. In der **Ansicht hinzufügen** Dialogbox, verfollständigen Sie die folgenden Optionen und klicken auf **Hinzufügen**.
	- In der **Ansichtname** Box, tippen Sie **Delete**.
	- In der **Vorlage** Box, wählen Sie **Delete**.
	- In der **Modellklasse** Box, wählen Sie **Item (Todo.Models)**.
	- In der **Layoutseite verwenden** Box, tippen Sie **~/Views/Shared/_Layout.cshtml**.

	![Adding the Delete View](images/adding-the-delete-view.png?raw=true)

	_Hinzufügen der Löschen Ansicht_

####Hinzufügen einer neuen Ansicht zum editieren (Edit Item View)####
Nun werden Sie eine neue Ansicht zum editieren von existierenden Items erstellen.

1. Im **Projektmappen-Explorer (Solution Explorer)**, erweitern Sie den **Views** Ordner. Rechtsklicken Sie den **Item** Ordner, wählen **Hinzufügen**, und anschließend **Anzeigen...**.

1. In der **Ansicht hinzufügen** Dialogbox, verfollständigen Sie die folgenden Optionen und klicken auf **Hinzufügen**.
	- In der **Ansichtname** Box, tippen Sie **Edit**.
	- In der **Vorlage** Box, wählen Sie **Edit**.
	- In der **Modellklasse** Box, wählen Sie **Item (Todo.Models)**.
	- Wählen Sie **Als Teilansicht erstellen**

	![Adding the Edit View](images/adding-the-edit-view.png?raw=true)

	_Hinzufügen der Editieren Ansicht_

####Hinzufügen einer Ansicht für Details####
Nun werden Sie eine neue Ansicht für Details von existierenden Items erstellen.

1. Im **Projektmappen-Explorer (Solution Explorer)**, erweitern Sie den **Views** Ordner. Rechtsklicken Sie den **Item** Ordner, wählen **Hinzufügen**, und anschließend **Anzeigen...**.

1. In der **Ansicht hinzufügen** Dialogbox, verfollständigen Sie die folgenden Optionen und klicken auf **Hinzufügen**.
	- In der **Ansichtname** Box, tippen Sie **Details**.
	- In der **Vorlage** Box, wählen Sie **Details**.
	- In der **Modellklasse** Box, wählen Sie **Item (Todo.Models)**.
	- Wählen Sie **Als Teilansicht erstellen**

	![Adding the Details View](images/adding-the-details-view.png?raw=true)

	_Hinzufügen der Detailansicht_

Wenn Sie alle Ansichten erstellt haben, schließen Sie alle cshtml Dokuments in Visual Studio.

<a name="wiring-up-documentdb"></a>
##Wiring up DocumentDB

In dieser Aufgabenstellung werden Sie Code in der **ItemController** Klasse hinzufügen um folgende Funktionalitäten zu erhalten:

* [Auflisten unvollständiger Items](#listing-incomplete-items)
* [Hinzufügen von Items](#adding-items)
* [Editieren von Items](#editing-items)
* [Löschen von Items](#deleting-items)
* [Anzeigen von Details von Items](#details-items)

<a name="listing-incomplete-items"></a>
####Hinzufügen von Code um unvollständige Items aufzulisten####
1. Öffnen Sie die **ItemController.cs** Datei und entfernen jeglichen Code in der Klasse, aber versichern Sie sich die Klasse nicht zu löschen. Sie werden die Klasse nach und nach mit DocumentDB in diesem Abschnitt wiederaufbauen.

	Die Datei sollte nun folgendermaßen aussehen:

	![ItemController class after removing all code](images/itemcontroller-class-after-removing-all-code.png?raw=true)

1. Fügen Sie das folgende Codeschnipsel in die nun leere **ItemController** Klasse ein.

	```C#
	public ActionResult Index()
	{
		var items = DocumentDBRepository.GetIncompleteItems();
		return this.View(items);
	}
	```

	Dieser Code verwendet eine "pseudo repository" Klasse, genannt **DocumentDBRepository**, die noch erstellt werden muss. Hierbei handelt es sich um eine Hilfsklasse, die DocumentDB spezifischen Code enthält. Für die Zwecke dieses Labs, handelt es sich bei dieser Klasse um keine volle Datenzugriffsschicht (full data access layer) mit dependency injection, Fabriken (factories) und repository patterns wie es wahrscheinlich wäre, wenn Sie eine real-world Applikation bauen würden. In diesem Fall wird stattdessen eine einzelne Klasse verwendet, in der jegliche Datenzugriffslogik gebündelt ist um den Fokus auf die DocumentDB zu legen.
1. Rechtsklicken Sie auf das **Todo** Projekt und klicken auf **Hinzufügen (Add)**, **Klasse**.

	![Adding a new class to the project](images/adding-a-new-class-to-the-project.png?raw=true)

	_Hinzufügen einer neuen Klasse_

1. Nennen Sie die neue Klasse **DocumentDBRepository** und klicken auf **Hinzufügen (Add)**.

	![Adding the DocumentDBRepository class](images/adding-the-documentdbrepository-class.png?raw=true)

	_Hinzufügen der DocumentDBRepository Klasse_

1. Ersetzen Sie den Inhalt der **DocumentDBRepository.cs** Datei durch das Folgende:

	```C#
	namespace Todo
	{
		 using System;
		 using System.Collections.Generic;
		 using System.Configuration;
		 using System.Linq;
		 using Microsoft.Azure.Documents;
		 using Microsoft.Azure.Documents.Client;
		 using Microsoft.Azure.Documents.Linq;
		 using Models;

		 public static class DocumentDBRepository
		 {
			  private static string databaseId;
			  private static string collectionId;
			  private static Database database;
			  private static DocumentCollection collection;
			  private static DocumentClient client;

			  private static string DatabaseId
			  {
					get
					{
						 if (string.IsNullOrEmpty(databaseId))
						 {
							  databaseId = ConfigurationManager.AppSettings["database"];
						 }

						 return databaseId;
					}
			  }

			  private static string CollectionId
			  {
					get
					{
						 if (string.IsNullOrEmpty(collectionId))
						 {
							  collectionId = ConfigurationManager.AppSettings["collection"];
						 }

						 return collectionId;
					}
			  }

			  private static Database Database
			  {
					get
					{
						 if (database == null)
						 {
							  database = ReadOrCreateDatabase();
						 }

						 return database;
					}
			  }

			  private static DocumentCollection Collection
			  {
					get
					{
						 if (collection == null)
						 {
							  collection = ReadOrCreateCollection(Database.SelfLink);
						 }

						 return collection;
					}
			  }

			  private static DocumentClient Client
			  {
					get
					{
						 if (client == null)
						 {
							  string endpoint = ConfigurationManager.AppSettings["endpoint"];
							  string authKey = ConfigurationManager.AppSettings["authKey"];
							  Uri endpointUri = new Uri(endpoint);
							  client = new DocumentClient(endpointUri, authKey);
						 }

						 return client;
					}
			  }
		 }
	}
	```

	Die Referenzen zu _ReadOrCreateDatabase_ und _ReadOrCreateCollection_ Methoden werden als _unresolved_ markiert, da diese Methoden erst im nächsten Schritt hinzugefügt werden. Diese beiden Methodenaufrufe werden zum Lesen oder Schreiben von DocumentDB Datenbanken und Dokumentkollektionen verwendet.

1. Fügen Sie den folgenden Code zur **DocumentDBRepository** Klasse hinzu:

	```C#
	private static DocumentCollection ReadOrCreateCollection(string databaseLink)
	{
		 var col = Client.CreateDocumentCollectionQuery(databaseLink)
								 .Where(c => c.Id == CollectionId)
								 .AsEnumerable()
								 .FirstOrDefault();

		 if (col == null)
		 {
			  col = Client.CreateDocumentCollectionAsync(databaseLink, new DocumentCollection { Id = CollectionId }).Result;
		 }

		 return col;
	}

	private static Database ReadOrCreateDatabase()
	{
		 var db = Client.CreateDatabaseQuery()
							  .Where(d => d.Id == DatabaseId)
							  .AsEnumerable()
							  .FirstOrDefault();

		 if (db == null)
		 {
			  db = Client.CreateDatabaseAsync(new Database { Id = DatabaseId }).Result;
		 }

		 return db;
	}
	```

	Dieser Code beeinhaltet Datenbankeinstellungen und verbindet die Applikation mit der DocumentDB durch den DocumentClient.

	Jetzt werden Sie die Projektkonfiguration aktualisieren um den Endpoint und die Authentifizierungskeys zu setzen. Diese erhalten Sie von Ihrem DocumentDB Account, den Sie bereits im ersten Teil des Labs erstellt haben.
1. Öffnen Sie die **Web.config** Datei in der Wurzel des Projekts (nicht die Web.config Datei in dem Views Ordner) und finden Sie den **appSettings** Abschnitt. Fügen Sie die unteren 4 keys vom Schnipsel unterhalb ein:

	```XML
	<appSettings>
		<add key="webpages:Version" value="3.0.0.0"/>
		<add key="webpages:Enabled" value="false"/>
		<add key="ClientValidationEnabled" value="true"/>
		<add key="UnobtrusiveJavaScriptEnabled" value="true"/>
		<add key="endpoint" value="URI" />
		<add key="authKey" value="PRIMARY KEY" />
		<add key="database" value="ToDoList" />
		<add key="collection" value="Items" />
	</appSettings>
	```


1. Wechseln Sie zu Ihrem Browser in dem Sie das Azure-Vorschauportal geöffnet haben. Verifizieren Sie, dass der DocumentDB Account erstellt wurde. Dazu öffnen Sie das Dashboard oder klicken auf das **Notifications** Symbol in der oberen Leiste und prüfen diese auf eine erfolgreiche Benachrichtigung. Falls die Erstellung noch nicht erfolgt ist, warten Sie bis der Account erstellt wurde und die Notification erscheint.

	![creation-succeeded-notification-hub](./images/creation-succeeded-notification-hub.png?raw=true "Creation succeeded in Notification Hub")

	_Bereitstellung erfolgreich_

1. Klicken Sie auf Ihren neuen **DocumentDB** Account im Dashboard.

	![The new DocumentDB account has been created](./images/new-documentdb-account-created.png?raw=true)

	> **Notiz:** Sie können den DocumentDB auch unter Ihrer Ressourcengruppe oder unter **Alle Ressourcen** auffinden.

	> ![Accessing the DocumentDB accounts from the Browse blade](./images/accessing-the-documentdb-accounts-from-browse.png?raw=true)

	> _Zugriff auf die DocumentDB Accounts über die "Alle Ressourcen" Schaltfläche_

1. Klicken Sie auf den **Schlüssel (Keys)** Button. Kopieren Sie den Endpunkt **URI** und fügen den Wert in die **Web.config** Datei in Visual Studio im **URI** Platzhalter ein.

	![Retrieving the keys of the DocumentDB account just created](./images/copying-your-documentdb-keys.png?raw=true)

	_Erhalten der Schlüssel des DocumentDB Accounts_

1. Wechseln Sie zum Browser zurück und kopieren Sie von der **Schlüssel (Keys)** Spalte den **PRIMARY KEY**. Wechseln Sie zu Visual Studio und fügen Sie den Wert in der **Web.config** Datei, im **PRIMARY KEY** Platzhalter ein.

	Der Code ist nun für die Verwendung der Datenbank bereit.

	Das Erste was bei unserer Todo Liste möglich sein soll, ist die Anzeige der unerledigten Items. Sie werden nun eine Methode hinzufügen, die genau das tut.

1. Kopieren Sie den folgenden Code und fügen Ihn irgendwo in der **DocumentDBRepository** Klasse ein.

	```C#
	public static List<Item> GetIncompleteItems()
	{
		 return Client.CreateDocumentQuery<Item>(Collection.DocumentsLink)
					.Where(d => !d.Completed)
					.AsEnumerable()
					.ToList<Item>();
	}
	```

	An diesem Punkt sollte Ihre Applikation ohne jegliche Fehlermeldungen gebaut werden können.

	Falls Sie die Applikation nun starten, sollten Sie zum **HomeController** und der **Index** Ansicht des Controllers geleitet werden. Dies ist das default Verhalten für die MVC Projektvorlage. Sie können dieses Verhalten ändern, indem Sie das routing auf die **Index** Ansicht statt des **ItemController** setzen, sodass unerledigte Items angezeigt werden.

1. Öffnen Sie die **RouteConfig.cs** Datei unter **App_Start** und lokalisieren Sie die Zeile, die mit **defaults:** startet. Verändern Sie diese folgendermaßen:

	<!-- mark:8 -->
	```C#
	public static void RegisterRoutes(RouteCollection routes)
	{
		routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

		routes.MapRoute(
			 name: "Default",
			 url: "{controller}/{action}/{id}",
			 defaults: new { controller = "Item", action = "Index", id = UrlParameter.Optional }
		);
	}
	```

	Dies vermittelt ASP.NET MVC, dass es **Item** als Controller statt **Home** verwendet und **Index** als Ansicht (View) verwendet. Sie können die Applikation nun ausführen, der **ItemController**  wird aufgerufen und gibt die Ergebnisse der **GetIncompleteItems** Methode zur **Item Index** Ansicht zurück.

1. Klicken Sie **F5** um die Anwendung zu bauen und debuggen.

	Die Seite, die sich öffnet sollte wie folgt aussehen: 

	![To Do App running locally](images/application-running-locally.png?raw=true)

	_Lokale Ausführung der To Do Applikation_

1. Stoppen Sie das debugging.

<a name="adding-items"></a>
####Hinzufügen von Items####
Nun haben Sie eine Ansicht um Items aufzulisten und nun werden Sie die Applikation um die Funktionalität erweitern, neue Items zur Datenbank hinzuzufügen.

Sie haben bereits eine **Create** Ansicht in der Applikation und einen Button in der **Index** Ansicht (view), der den User zur **Create** Ansicht (view) weiterleitet. Sie werden nun Code zum Controller und Repository hinzufügen.

1. Öffnen Sie die **ItemController.cs** Datei und fügen Sie den folgenden Codeschnippsel ein, welcher ASP.NET MVC zeigt, was für die **Create** Aktion passieren soll. In diesem Fall, wird die zugehörige Create.cshtml Ansicht wiedergegeben.

	```C#
	public ActionResult Create()
	{
		return this.View();
	}
	```

1. Fügen Sie im **ItemController.cs** den folgenden Codeblock hinzu, das das POST Verhalten des Controller festlegt.

	```C#
	[HttpPost]
	[ValidateAntiForgeryToken]
	public async Task<ActionResult> Create([Bind(Include =  "Id,Name,Description,Completed")] Item item)  
	{
		 if (ModelState.IsValid)  
		 {  
			  await DocumentDBRepository.CreateItemAsync(item);
			  return this.RedirectToAction("Index");  
		 }

		 return this.View(item);
	}
	```

	>**Security Notiz:** Das ValidateAntiForgeryToken Attribut wird verwendet um die Applikation vor cross-site request forgery Attacken zu schützen. Es gehört mehr dazu als nur dieses Attribut hinzuzufügen; Ihre Ansichten müssen mit diesem anti-forgery token ebenso funktionieren. Falls Sie mir zu diesem Thema und korrekte Beispielimplementierungen sehen möchten, lesen Sie hier:  [Preventing Cross-Site Request Forgery](http://www.asp.net/web-api/overview/security/preventing-cross-site-request-forgery-(csrf)-attacks).

	>**Security Notiz:** Wir benutzen das Bind Attribut als Methodenparameter um uns vor over-posting Attacken zu schützen. Für mehr Details, lesen Sie: [Basic CRUD Operations in ASP.NET MVC](http://www.asp.net/mvc/overview/getting-started/getting-started-with-ef-using-mvc/implementing-basic-crud-functionality-with-the-entity-framework-in-asp-net-mvc-application#overpost).

	Nun haben Sie die **Create** Methode erstellt, der **ItemController** wird das **Item** Object von der Form zur **CreateDocument** Method leiten. Sie müssen lediglich die **CreateItemAsync** Method hinzufügen.

1. Öffnen Sie die **DocumentDBRepository** Klasse und fügen die folgende Methode hinzu:

	```C#
	public static async Task<Document> CreateItemAsync(Item item)
	{
		 return await Client.CreateDocumentAsync(Collection.SelfLink, item);
	}
	```

	Diese Methode nimmt ein Objekt und leitet es zur DocumentDB.

Mit diesen Schritten haben Sie allen Code hinzugefügt, der nötig ist um neue Items zur Datenbank hinzuzufügen.

 >Ihnen mag aufgefallen sein, dass manche Methoden oder Klassen noch nicht erkannt werden. Darum kümmern wir uns später.

<a name="editing-items"></a>
####Editieren von Items####
Nun werden Sie die Funktionalität zum editieren von Items in der Datenbank hinzufügen und um Items als erledigt zu markieren. Die **Edit** Ansicht existiert bereits im Projekt, sodass Sie nur etwas Code zum **ItemController** und zum **DocumentDBRepository** hinzufügen müssen.

1. Öffnen Sie **ItemController.cs** und fügen Sie den folgenden Code hinzu:

	```C#
	[HttpPost]
	[ValidateAntiForgeryToken]
	public async Task<ActionResult> Edit([Bind(Include = "Id,Name,Description,Completed")] Item item)
	{
		 if (ModelState.IsValid)
		 {
			  await DocumentDBRepository.UpdateItemAsync(item);
			  return this.RedirectToAction("Index");
		 }

		 return this.View(item);
	}

	public ActionResult Edit(string id)
	{
		 if (id == null)
		 {
			  return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
		 }

		 Item item = (Item)DocumentDBRepository.GetItem(id);
		 if (item == null)
		 {
			  return this.HttpNotFound();
		 }

		 return this.View(item);
	}
	```

	Die erste Edit Methode kümmert sich um Http GET, das auftritt wenn ein User auf den Edit link auf der Index Ansicht klickt. Diese Methode ruft ein Dokument von der DocumentDB ab und leitet es zur Edit Ansicht weiter. Die Edit Ansicht wird ein Http POST an den IndexController ausführen.

	Die zweite Edit Methode leitet das aktualisierte Objekt zur DocumentDB zur Ablage.

1. Fügen Sie die folgenden Direktiven (using directives) zur **ItemController.cs** Datei hinzu:

	```C#
	using Todo.Models;
	using System.Threading.Tasks;
	using System.Net;
	```

1. Fügen Sie folgende Methoden zur **DocumentDBRepository** Klasse hinzu:

	```C#
	public static Item GetItem(string id)
	{
		return Client.CreateDocumentQuery<Item>(Collection.DocumentsLink)
						.Where(d => d.Id == id)
						.AsEnumerable()
						.FirstOrDefault();
	}

	public static Document GetDocument(string id)
	{
		return Client.CreateDocumentQuery(Collection.DocumentsLink)
					  .Where(d => d.Id == id)
					  .AsEnumerable()
					  .FirstOrDefault();
	}

	public static async Task<Document> UpdateItemAsync(Item item)
	{
		Document doc = GetDocument(item.Id);
		return await Client.ReplaceDocumentAsync(doc.SelfLink, item);
	}
	```
	Die erste Methode holt ein Item von der _DocumentDB_ , welches zurück zum **ItemController** und dann zur Edit Ansicht geleitet wird.

	Die zweite Methode erhält ein Dokument von der DocumentDB über die Id. Diese Methode wird von einer Dritten verwendet (UpdateItemAsync) um das Dokument in DocumentDB mit der Version von dem Dokument, das vom **ItemController** kommt, zu ersetzen.

1. Fügen Sie die folgenden Direktiven (using directives) zur **DocumentDBRepository.cs** Datei hinzu. Danach sollten alle Referenzen vollständig sein.

	```C#
	using System.Threading.Tasks;
	```

	Nun sollte die Editieren Funktion funktionieren. Jetzt werden Sie die Funktion zum Löschen von Items implementieren.

<a name="deleting-items"></a>
####Löschen von Items####
Die Veränderungen des Codes um die Funktionalität des Löschen von Items einzufügen, ähnelt dem Code zum Editieren von Items. Wie vorher existiert die **Delete** Ansicht bereits, sodass Sie nur nochmal Code zum **ItemController** und zum **DocumentDBRepository** hinzufügen müssen.

1. Öffnen Sie **ItemController.cs** und fügen Sie den folgenden Code hinzu:

	```C#
	public ActionResult Delete(string id)
	{
		 if (id == null)
		 {
			  return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
		 }

		 Item item = (Item)DocumentDBRepository.GetItem(id);
		 if (item == null)
		 {
			  return this.HttpNotFound();
		 }

		 return this.View(item);
	}

	[HttpPost, ActionName("Delete")]
	//// To protect against Cross-Site Request Forgery, validate that the anti-forgery token was received and is valid
	//// for more details on preventing see http://go.microsoft.com/fwlink/?LinkID=517254
	[ValidateAntiForgeryToken]
	//// To protect from overposting attacks, please enable the specific properties you want to bind to, for
	//// more details see http://go.microsoft.com/fwlink/?LinkId=317598.
	public async Task<ActionResult> DeleteConfirmed([Bind(Include = "Id")] string id)
	{
		 await DocumentDBRepository.DeleteItemAsync(id);
		 return this.RedirectToAction("Index");
	}
	```

1. Fügen Sie folgende Methoden zur **DocumentDBRepository** Klasse hinzu:

	```C#
	public static async Task DeleteItemAsync(string id)
	{
		Document doc = GetDocument(id);
		await Client.DeleteDocumentAsync(doc.SelfLink);
	}
	```

<a name="details-items"></a>
####Anzeigen von Details von Items####
Die **Details**  Ansicht existiert bereits, sodass Sie nur nochmal Code zum **ItemController** hinzufügen müssen.

1. Öffnen Sie **ItemController.cs** und fügen Sie den folgenden Code hinzu:

	```C#
  public ActionResult Details(string id)
  {
		var item = DocumentDBRepository.GetItem(id);
		return this.View(item);
  }
	```

Sie haben nun den nötigen Code für die Funktionalität der Applikation fertiggestellt. Im nächsten Abschnitt werden Sie die Applikation lokal testen.

<a name="running-the-application-locally"></a>
##Lokales Ausführen der Applikation

In dieser Aufgabenstellung werden Sie die richtige Funktionsweise der einzelnen implementierten Funktionen der Applikation verifizieren.

1. Klicken Sie **F5** um die Applikation zu bauen und auszuführen.

	Die Applikation wird in einem Browser ausgeführt.

	![Application running locally](images/application-running-locally.png?raw=true)

	_Lokales Ausführen der Applikation_

1. Klicken Sie auf **Create new** und fügen Werte in die Felder Name und Description ein. Lassen Sie die Checkbox deaktiviert; sonst wird das neue Item in einem erledigtem Zustand hinzugefügt und wir nicht auf der initialen Liste angezeigt.

	![Testing creating an item](images/testing-creating-an-item.png?raw=true)

	_Testing - Erstellen eines Items_

1. Klicken Sie auf **Create**. Sie werden zur **Index** Ansicht zurückgeleitet und Ihr Item erscheint in der Liste.

	![testing the app after creating an item](images/testing-the-app-after-creating-an-item.png?raw=true)

	_Testing - die Index Ansicht nachdem ein Item erstellt wurde_

	Sie können gerne weitere Item zu Ihrere Todo Liste hinzufügen.

1. Klicken Sie auf **Edit**. Sie werden zur Edit Ansicht weitergeleitet, wo Sie jede Eigenschaft eines Objects verändern können, auch das **Completed** flag. Verändern Sie ein Feld Ihrer Wahl und klicken Sie auf **Save**.

	> **Notiz:** (Warnung) Falls Sie die **Completed** Checkbox aktivieren und auf **Save** klicken, wird das Item nicht länger in der Liste der unerledigten Tasks auftauchen. Bitte tun Sie dies also noch nicht. 

	![Testing editing an item](images/testing-editing-an-item.png?raw=true)

	_Testing - Editieren eines Items_

1. Zurück in der Index Ansicht, klicken Sie auf **Details**. ie werden zur Details Ansicht weitergeleitet.

	![Testing view details for an item](images/testing-view-details-for-an-item.png?raw=true)

	_Testing - Ansicht von Details eines Items_

1. Klicken Sie auf **Back to List** und dann **Delete**.  Sie werden zur Löschen Ansicht weitergeleitet, in der Sie das Löschen bestätigen können. 

	![Testing deleting an item](images/testing-deleting-an-item.png?raw=true)

	_Testing - Löschen eines Items_

1. Klicken Sie auf **Delete**. Sie werden zur Index Ansicht weitergeleitet, in der Sie erkennen können, dass das Item gelöscht wurde.

	Sie können verifizieren, dass Items, die als erledigt markiert worden sind, nicht in der **Index** Ansicht erscheinen indem Sie ein Item als erledigt markieren und erneut die **Index** Ansicht betrachten.   

1. Öffnen Sie Visual Studio und drücken Sie die Tastenkombination **Shift+F5** um das Debugging zu stoppen.

<a name="deploying-the-app-to-azure"></a>
## Deploying der Applikation als Azure Web-App

Die folgenden Schritte werden Ihnen zeigen, wie man eine Applikation als Azure Web App deployed. In den vorherigen Schritten, haben Sie Ihr Projekt mit einer Azure Web App verbunden, deshalb ist das Projekt bereits für die Veröffentlichung bereit.

1. In **Visual Studio**, rechtsklicken Sie auf das **Todo** Projekt und wählen **Veröffentlichen (Publish)**.

	![Publishing the application](images/publish-web-application.png?raw=true)

	_Veröffentlichen der Applikation_

	The **Publish Web** dialog box will appear with each setting already configured according to your credentials. In fact, the website has already been created in Azure for you at the Destination URL shown.

	>**Notiz:** Falls Sie das fertige Projekt geöffnet haben anstatt den Lab Anweisungen zu folgen, müssen Sie evtl. zusätzliche Informationen eingeben.

1. Klicken Sie auf **Veröffentlichen (Publish)**.

	![Publish Web Dialog box](images/publish-web-dialog.png?raw=true)


	Nach dem Veröffentlichen öffnet Visual Studio den Browser mit der laufenden Webapplikation. Sie können diese Ansicht benutzen um dieselben Operationen auszuführen, die sie in der lokalen Ausführung getestet haben.

	![Application running in IE from Azure](images/application-running-in-ie-from-azure.png?raw=true)

	_Applikation wird im IE von Azure ausgeführt_

<!--
1. Click on the **Next** button to go to the **Settings** page. You may be prompted to authenticate; make sure you authenticate using your Azure subscription account (typically a Microsoft account) and not the organizational account you created earlier.

    ![Publish Web dialog - Connection tab](./images/publish-web-dialog-connection-tab.png)

    _Publish Web dialog - Connection tab_
-->

<a name="cleanup"></a>
##Appendix - Cleanup

In dieser Aufgabenstellung wird gezeigt, wie man die Ressourcen, die in den vorherigen Abschnitten erstellt wurden löscht:

* eine Webseite
* ein DocumentDB Account

Um die Webseite zu löschen, befolgen Sie diese Schritte:

1. Navigieren Sie im Browser zum [Azure-Vorschauportal](https://portal.azure.com/) und melden Sie sich an.

2. Klicken Sie auf **Durchsuchen**, dann auf **Web Apps**.

	![Browse websites](images/browse-websites.png?raw=true)


1. Wählren Sie Ihre Website und klicken auf **Löschen (DELETE)**.

	![Clicking Delete website](images/clicking-delete-website.png?raw=true)

	_Löschen der Website_

4. Im **Delete Confirmation** Dialog, klicken Sie **Ja**.

	Die Website wird gelöscht. Sie können eine Notification auf dem Dashboard und unter Notifications finden.

Um einen DocumentDB Account zu löschen, gehen Sie wie folgt vor:

2. Klicken Sie auf **Durchsuchen**, dann auf **DocumentDB accounts**.

1. Klicken Sie auf Ihren documentDB Account und klicken auf **Löschen (Delete)**.

1. Geben Sie Ihren documentDB Account Namen ein und klicken Sie auf **Löschen (Delete)**.

	![Confirming deletion of DocumentDB account](images/confirm-deletion-of-documentdb-account.png?raw=true)

	_Löschen des DocumentDB Accounts_

##Summary

Durch die Fertigstellung dieses Labs haben Sie gelernt, wie man eine ASP.Net MVC Applikation erstellt, die eine Azure DocumentDB verwendet um Daten als JSON Objekte zu speichern. Sie haben alle basic CRUD Operationen erstellt, haben die Anwendung lokal getestet und als Azure Website veröffentlicht.
