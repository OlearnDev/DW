
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
Chap.1 : Datawarehouse concepts : 
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

------------------------------------------------------------------

							[Sources externes] 
								  |
							Azure Data Factory
								  |
							Azure Data Lake Storage
								  |
							Azure Databricks/Synapse ETL
								  |
							Azure SQL Database (Data Mart Marketing)
								  |          |            |          
							 FaitsMarketing  DimCampagne  DimClient  DimProduit  DimCanal
								  |
							Power BI (Reporting)
------------------------------------------------------------------

The term "data warehouse architecture data design" encompasses several layers. We can break it down into three main 
categories:

	1.Overall Architectural Styles (How the entire system is structured)
	2.Data Modeling Techniques (How data is structured inside the warehouse)
	3.Data Design Patterns (How data flows and is processed)

1. Overall Architectural Styles

These are high-level blueprints for the entire data ecosystem.

	a. Traditional Monolithic Architecture (Inmon Approach)
	
		Concept: The data warehouse is the central, integrated, subject-oriented, time-variant, and non-volatile core 
		of the corporate information factory. Data is ingested from source systems into a normalized relational model 
		(the "Enterprise Data Warehouse" or EDW). From there, data marts are created as logical or physical subsets 
		for specific business units.

		Key Characteristic: Top-down approach. Focus on a single source of truth and data integration before delivering
				to data marts.

		Pros: Highly consistent, integrated data; minimizes data redundancy.

		Cons: Can be slow and expensive to build and change; requires significant upfront design.

	b. Dimensional Data Mart Bus Architecture (Kimball Approach)
	
		Concept: The data warehouse is the union of all its dimensional data marts. The architecture starts by building 
		conformed, dimensionally modeled data marts directly from source systems. These marts are integrated via 
		conformed dimensions (e.g., a common Date or Customer table used across all marts), which creates the "bus" 
		that ties them together.

		Key Characteristic: Bottom-up approach. Focus on delivering business value quickly through iterative data mart 
		development.

		Pros: Faster delivery of tangible results; highly understandable and performant for queries.

		Cons: Can lead to redundancy and inconsistency if conformed dimensions are not managed strictly.

	c. Hub-and-Spoke Architecture
	
		Concept: This is a hybrid model that often incorporates both Inmon and Kimball ideas. Source data is first 
		landed in a staging area. It is then integrated and transformed into a normalized EDW (the "Hub"). 
		Finally, data is propagated to various dimensional data marts (the "Spokes") for consumption.

		Key Characteristic: Balances the need for a central integrated repository with the need for high-performance, 
		business-specific access layers.

	d. Modern Cloud-Based Architecture (The Data Lakehouse)
	
	  - Concept: This newer architecture leverages low-cost cloud storage (Data Lakes) but adds a management and design 
		layer on top to bring warehouse-like capabilities (ACID transactions, schema enforcement, performance).

		Data Lake: Stores all data—structured, semi-structured, and unstructured—in its raw form.

		Medallion Architecture: A common design pattern within a Lakehouse:

			Bronze Layer: Raw landed data (as-is copy of the source).

			Silver Layer: Cleaned, filtered, and integrated data (a single source of truth).

			Gold Layer: Data aggregated and modeled into business-level schemas (dimensional models for consumption).

	 - Key Characteristic: Decouples storage from compute, allows for advanced use cases (ML, AI on raw data), and is 
		highly scalable and cost-effective.

	 - Pros: Extreme scalability, cost-efficiency for storage, supports all data types.

	 - Cons: Can become a "data swamp" without strong governance; complexity of managing multiple tools.

2. Data Modeling Techniques

This defines how tables and relationships are structured within a layer of the architecture.

	a. Third Normal Form (3NF) / Normalized

		Purpose: To eliminate data redundancy and improve data integrity for transactional systems. This is the 
			classic design for the central EDW in the Inmon approach.

		Structure: Data is broken down into many tables with specific relationships (e.g., one-to-many). For example, 
		   customer data might be split into Customer, Address, Contact_Number tables.

		Best for: The "single source of truth" integration layer where the focus is on efficient storage and capturing 
		   complex relationships, not on query performance.

	b. Dimensional Modeling

		Purpose: To optimize data for querying and analysis in a data mart. This is the heart of the Kimball approach.

		Structure: Uses two types of tables:

		Fact Tables: Contain the measurable, quantitative data about a business process (e.g., sales_amount, 
		             quantity_sold). They are the center of the star schema.

		Dimension Tables: Contain descriptive attributes that provide context to the facts (e.g., Product, Customer, Time, 
		Store). They surround the fact table.

		Best for: The presentation / consumption layer where business intelligence tools and analysts need fast, intuitive 
		query performance.

	c. Data Vault Modeling

		Purpose: To provide a flexible, scalable, and auditable model for the raw data integration layer. It''s designed 
		for agile data warehouse development.

		Structure: Uses three core table types:

		Hubs: Represent a core business key (e.g., Customer_ID).

		Links: Represent a transaction or association between business keys (e.g., a link between a Customer_ID and an 
		Account_ID).

		Satellites: Contain all the descriptive attributes and history for a Hub or Link.

		Best for: The EDW integration layer in agile environments where sources change frequently, and you need to 
		track all history without remodeling.

3. Data Design Patterns (How Data is Processed)

	a. ETL (Extract, Transform, Load)

		Concept: Data is transformed before it is loaded into the target data warehouse.

		Use Case: Traditional data warehousing where the target system requires clean, structured, and ready-to-query 
				data.
				Puts the load on the source or staging server.

	b. ELT (Extract, Load, Transform)

		Concept: Data is extracted and loaded into the target storage (e.g., a Data Lake or cloud DWH) in its raw form. 
		Transformations are then executed inside the powerful target system.

		Use Case: Modern cloud data warehouses (BigQuery, Snowflake, Redshift) and data lakehouses where compute is 
		scalable and separate from storage. Offers greater flexibility.

Summary Table
--------------	
Type				Primary Goal						Best For						Key Architecture
Normalized (3NF)	Data Integrity & Integration		Central EDW (Inmon Style)		Monolithic, Hub-and-Spoke
Dimensional			Query Performance & Usability		Data Marts (Kimball Style)		Data Mart Bus, Hub-and-Spoke
Data Vault			Audibility & Agile Development		Scalable Integration Layer		Modern EDW, Lakehouse (Silver)
Lakehouse			Scalability & Multi-purpose Use		Storing all data types 			Modern Cloud Architecture
														  cost-effectively
														  
In practice, a modern data stack often combines these elements. For example, you might:

	Ingest data into a Data Lake (Lakehouse architecture).	Model the raw data in a Data Vault for integration.

	Transform the integrated data into a Dimensional Model for consumption (ELT pattern).
	Use a Hub-and-Spoke style to manage the flow.

+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
Chap.2 : Azure Data Factory 
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

Azure Data Factory (ADF) est un service cloud de Microsoft Azure qui permet d’orchestrer, automatiser et gérer 
des processus de déplacement et de transformation de données. Il s’agit d’une plateforme ETL/ELT (Extraction, 
Transformation, Chargement) sans serveur (serverless), conçue pour intégrer, transformer et déplacer des données
 entre diverses sources et destinations, que ce soit dans le cloud ou sur site.

Fonctionnalités principales d’Azure Data Factory
------------------------------------------------

* Orchestration de pipelines de données : ADF organise les étapes (activités) nécessaires pour collecter, 
	transformer et déplacer les données au sein d’un workflow (appelé pipeline). Ces activités peuvent s''
	exécuter en séquence ou parallèlement.

* Connectivité étendue : Il permet de se connecter à un grand nombre de sources de données (bases SQL, fichiers, 
	SaaS, cloud, on-premise).

* Transformation des données : ADF supporte des transformations personnalisées via des clusters Spark, HDInsight 
	ou des flux de données visuels intégrés, permettant de nettoyer, enrichir et agréger les données sans gérer 
	l''infrastructure sous-jacente.

* Automatisation et déclencheurs: Il est possible d’automatiser l’exécution des pipelines en fonction d’événements, 
	de calendriers ou de conditions spécifiques.

* Sécurité intégrée : Contrôle d’accès via Azure AD, chiffrement, gestion des rôles pour assurer la protection 
	des données et la conformité.

Concepts clés
----------------

	* Pipelines : Regroupement logique d’activités formant une unité de travail.
	* Activités : Actions individuelles pour déplacer ou transformer les données.
	* Ensembles de données (datasets) : Représentation des données sources ou cibles utilisés dans les activités.
	* Services liés (linked services) : Points de connexion vers les systèmes source et cible.
	* Flux de données : Graphes visuels de transformations des données exécutés sur des clusters Spark.
	* Runtime d’intégration : Environnement d’exécution des tâches, sur cloud ou local.

Utilisation typique
----------------

	* Connexion aux sources de données variées (ex. base SQL, fichiers CSV, APIs).
	* Création de pipelines pour orchestrer l’extraction, le déplacement et la transformation.
	* Automatisation avec déclencheurs horaires, événements ou manuels.
	* Surveillance en temps réel des exécutions et gestion des erreurs.
	* Livraison et préparation de données pour l’analyse, les rapports ou d’autres services cloud.

Azure Data Factory offre ainsi une solution robuste et scalable pour gérer les processus complexes de data 
engineering dans une architecture moderne, facilitant l’intégration hybride de données et leur transformation 
sans gestion complexe d’infrastructure.

Guide de création d''un pipeline dans Azure Data Factory (ADF) :
----------------------------------------------------------------

Étape 1 : Accéder au portail Azure Data Factory

	- Connectez-vous au portail Azure.
	- Créez une fabrique de données (Data Factory) si ce n’est pas déjà fait.
	- Ouvrez Azure Data Factory Studio depuis la ressource créée.

Étape 2 : Créer un nouveau pipeline

	- Dans ADF Studio, allez dans l’onglet Auteur (icône crayon).
	- Cliquez sur le signe + puis sélectionnez Pipeline pour en créer un nouveau.
	- Un canevas de conception s’affiche pour construire visuellement votre pipeline.

Étape 3 : Ajouter des activités au pipeline

	- Sur la gauche, vous avez un volet d’activités (ex : copie de données, exécuter un notebook, traitement, 
	   boucle…).
	- Faites glisser l’activité de copie (Copy Data) sur le canevas.

Étape 4 : Configurer la source de données (source)

	- Cliquez sur l’activité de copie.
	- Dans le panneau de configuration, définissez un service lié (linked service) pour choisir et connecter la 
	  source de vos données (ex. base SQL, Blob storage).
	- Spécifiez l''ensemble de données source (dataset) représentant la table ou les fichiers à copier.
	- Vous pouvez appliquer des filtres ou requêtes pour sélectionner des données précises.

Étape 5 : Configurer la destination (sink)

	- Dans les mêmes paramètres, définissez le service lié et l’ensemble de données cible où les données seront 
	  chargées.

Étape 6 : Mapper les colonnes source et destination

	- Allez à l’onglet Mapping.
	- Vérifiez ou mappez manuellement les colonnes source vers les colonnes de destination.

Étape 7 : Valider et tester le pipeline

	- Cliquez sur Debug pour exécuter une version de test.
	- Vérifiez que les données sont correctement copiées.

Étape 8 : Publier et planifier

	- Cliquez sur Publier (Publish) pour enregistrer les modifications.
	- Configurez un déclencheur (trigger) pour automatiser l’exécution :
		- Déclencheur planifié (horaire, quotidien, mensuel…)
		- Déclencheur basé sur un événement (ex. nouvel arrivage de données)

Étape 9 : Surveiller l’exécution

	- Allez dans l’onglet Surveillance (Monitor).
	- Suivez les exécutions, réussites ou échecs et les logs d’exécution.

Ce processus vous permet de construire un pipeline end-to-end capable de déplacer et transformer les données 
entre différentes sources et destinations, tout en automatisant les workflows via Azure Data Factory.

Pour des cas plus avancés, vous pouvez ajouter des activités de transformation, inclure des flux de données 
(Data Flows), ou orchestrer des calculs avec d’autres services comme Databricks.


